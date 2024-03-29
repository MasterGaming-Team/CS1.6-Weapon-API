/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <engine>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include <mg_weapon_api_const>

#define PLUGIN "[MG] Weapon API"
#define VERSION "1.0"
#define AUTHOR "Vieni"

new const gWeaponAmmoIdList[] = 
{
	0, 9, 0, 2, 12, 5, 14, 6, 4, 13, 10, 7, 6, 4, 4, 4, 6,
	10, 1, 10, 3, 5, 4, 10, 2, 11, 8, 4, 2, -1, 7
}

new const gWeaponMaxAmmoList[] = 
{
	0, 52, 0, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100,
	120, 30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100
}

new const gWeaponSlotId[] = 
{
	-1, 1, -1, 0, 3, 0, 4, 0, 0, 3, 1, 1, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 2, 0
}

new const gWeaponNumberInSlot[] = 
{
	0, 3, 0, 9, 1, 12, 3, 13, 14, 3, 5, 6, 15, 16, 17, 18, 4,
	2, 2, 7, 4, 5, 6, 11, 3, 2, 1, 10, 1, 1, 8
}

new const gWeaponFlags[] = 
{
	0, 0, 0, 0, (MGW_FLAG_EXHAUSTIBLE|MGW_FLAG_LIMITINWORLD), 0, (MGW_FLAG_EXHAUSTIBLE|MGW_FLAG_LIMITINWORLD), 0, 0, (MGW_FLAG_EXHAUSTIBLE|MGW_FLAG_LIMITINWORLD), 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, (MGW_FLAG_EXHAUSTIBLE|MGW_FLAG_LIMITINWORLD), 0, 0, 0, 0, 0
}

new Array:arrayWeaponId							// MGW_* see mg_weapon_api_const.inc
new Array:arrayWeaponViewModel					// The view model of the weapon
new Array:arrayWeaponPlayerModel				// The outer model of the weapon
new Array:arrayWeaponWorldModel					// The world model of the weapon
new Array:arrayWeaponViewBody					// The body of the view model
new Array:arrayWeaponPlayerBody					// The body of the outer model
new Array:arrayWeaponWorldBody					// The body of the world model
new Array:arrayWeaponLangnameFull				// Full name[lang file], mostly used in menus
new Array:arrayWeaponLangname					// Name[lang file], chat etc.
new Array:arrayWeaponSprite						// Weapon name, used for weapon sprite file *.txt
new Array:arrayWeaponBaseWeapon					// Weapon type this weapon's based on, see cstrike_const.inc(CSW_*)
new Array:arrayWeaponAnimShift					// How many times shift the animations
new Array:arrayWeaponFlags						// Weapon flags, see mg_weapon_api_const.inc(MGW_FLAG_*)

new Array:arrayWeaponExPrimSpeed				// The time delay between primary attacks
new Array:arrayWeaponExSecSpeed					// The time delay between secondary attacks
new Array:arrayWeaponExDamage					// The regular done by the weapon
new Array:arrayWeaponExRecoil					// The recoil rate of the weapon
new Array:arrayWeaponExReloadTime				// The time needed to reload with this weapon
new Array:arrayWeaponExPrimaryAmmoType			// Primary ammo type, see MGW_AMNMO_* in mg_weapon_api_const.inc
new Array:arrayWeaponExPrimaryAmmoBPMax			// Maximum carriable primary ammo
new Array:arrayWeaponExPrimaryAmmoClip			// Max primary clip ammo
new Array:arrayWeaponExSecondaryAmmoType		// Secondary ammo type, see MGW_AMNMO_* in mg_weapon_api_const.inc
new Array:arrayWeaponExSecondaryAmmoBPMax		// Maximum carriable secondary ammo

new Array:arrayWeaponSfxPrimAttack				// Primary attack sfx list[This contains array ids!!!]
new Array:arrayWeaponSfxSecAttack				// Secondary attack sfx list[This contains array ids!!!]

new Array:arrayUserWeaponList[33]

new Trie:trieDefaultWeaponModelList				// Using trie for faster string search(get the classname by model)
new Trie:trieDefaultWeaponIdList				// Using trie for faster string search(get the class id by classname)
new Trie:trieWeaponSpriteList					// Using trie for faster string search(get the defweapon name by sprite name)

new gUserWeapons[33][MGW_BITFIELDCOUNT]

new gMsgWeaponList

new gForwardWeaponUserWeaponGet, gForwardWeaponUserWeaponLost

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_forward(FM_SetModel, "fwFmSetModel")

	gMsgWeaponList = get_user_msgid("WeaponList")

	gForwardWeaponUserWeaponGet = CreateMultiForward("mg_fw_weapon_user_weapon_get", ET_CONTINUE, FP_CELL, FP_CELL)
	gForwardWeaponUserWeaponLost = CreateMultiForward("mg_fw_weapon_user_weapon_lost", ET_CONTINUE, FP_CELL, FP_CELL)
}

public plugin_precache()
{
	arrayWeaponId = ArrayCreate(1)
	arrayWeaponViewModel = ArrayCreate(96)
	arrayWeaponPlayerModel = ArrayCreate(96)
	arrayWeaponWorldModel = ArrayCreate(96)
	arrayWeaponViewBody = ArrayCreate(1)
	arrayWeaponPlayerBody = ArrayCreate(1)
	arrayWeaponWorldBody = ArrayCreate(1)
	arrayWeaponLangnameFull = ArrayCreate(64)
	arrayWeaponLangname = ArrayCreate(64)
	arrayWeaponSprite = ArrayCreate(64)
	arrayWeaponBaseWeapon = ArrayCreate(1)
	arrayWeaponAnimShift = ArrayCreate(1)
	arrayWeaponFlags = ArrayCreate(1)

	arrayWeaponExPrimSpeed = ArrayCreate(1)
	arrayWeaponExSecSpeed = ArrayCreate(1)
	arrayWeaponExDamage = ArrayCreate(1)
	arrayWeaponExRecoil = ArrayCreate(1)
	arrayWeaponExReloadTime = ArrayCreate(1)
	arrayWeaponExPrimaryAmmoType = ArrayCreate(1)
	arrayWeaponExPrimaryAmmoBPMax = ArrayCreate(1)
	arrayWeaponExPrimaryAmmoClip = ArrayCreate(1)
	arrayWeaponExSecondaryAmmoType = ArrayCreate(1)
	arrayWeaponExSecondaryAmmoBPMax = ArrayCreate(1)

	arrayWeaponSfxPrimAttack = ArrayCreate(1)
	arrayWeaponSfxSecAttack = ArrayCreate(1)

	trieDefaultWeaponModelList = TrieCreate()
	trieDefaultWeaponIdList = TrieCreate()

	TrieSetString(trieDefaultWeaponModelList, "models/w_ak47.mdl", "weapon_ak47")
	TrieSetString(trieDefaultWeaponModelList, "models/w_aug.mdl", "weapon_aug")
	TrieSetString(trieDefaultWeaponModelList, "models/w_awp.mdl", "weapon_awp")
	TrieSetString(trieDefaultWeaponModelList, "models/w_deagle.mdl", "weapon_deagle")
	TrieSetString(trieDefaultWeaponModelList, "models/w_elite.mdl", "weapon_elite")
	TrieSetString(trieDefaultWeaponModelList, "models/w_famas.mdl", "weapon_famas")
	TrieSetString(trieDefaultWeaponModelList, "models/w_fiveseven.mdl", "weapon_fiveseven")
	TrieSetString(trieDefaultWeaponModelList, "models/w_flashbang.mdl", "weapon_flashbang")
	TrieSetString(trieDefaultWeaponModelList, "models/w_g3sg1.mdl", "weapon_g3sg1")
	TrieSetString(trieDefaultWeaponModelList, "models/w_galil.mdl", "weapon_galil")
	TrieSetString(trieDefaultWeaponModelList, "models/w_glock18.mdl", "weapon_glock18")
	TrieSetString(trieDefaultWeaponModelList, "models/w_hegrenade.mdl", "weapon_hegrenade")
	TrieSetString(trieDefaultWeaponModelList, "models/w_knife.mdl", "weapon_knife")
	TrieSetString(trieDefaultWeaponModelList, "models/w_m3.mdl", "weapon_m3")
	TrieSetString(trieDefaultWeaponModelList, "models/w_m4a1.mdl", "weapon_m4a1")
	TrieSetString(trieDefaultWeaponModelList, "models/w_m249.mdl", "weapon_m249")
	TrieSetString(trieDefaultWeaponModelList, "models/w_mac10.mdl", "weapon_mac10")
	TrieSetString(trieDefaultWeaponModelList, "models/w_mp5.mdl", "weapon_mp5navy")
	TrieSetString(trieDefaultWeaponModelList, "models/w_p90.mdl", "weapon_p90")
	TrieSetString(trieDefaultWeaponModelList, "models/w_p228.mdl", "weapon_p228")
	TrieSetString(trieDefaultWeaponModelList, "models/w_scout.mdl", "weapon_scout")
	TrieSetString(trieDefaultWeaponModelList, "models/w_sg550.mdl", "weapon_sg550")
	TrieSetString(trieDefaultWeaponModelList, "models/w_sg552.mdl", "weapon_sg552")
	TrieSetString(trieDefaultWeaponModelList, "models/w_smokegrenade.mdl", "weapon_smokegrenade")
	TrieSetString(trieDefaultWeaponModelList, "models/w_tmp.mdl", "weapon_tmp")
	TrieSetString(trieDefaultWeaponModelList, "models/w_ump45.mdl", "weapon_ump45")
	TrieSetString(trieDefaultWeaponModelList, "models/w_usp.mdl", "weapon_usp")
	TrieSetString(trieDefaultWeaponModelList, "models/w_xm1014.mdl", "weapon_xm1014")

	TrieSetCell(trieDefaultWeaponIdList, "weapon_ak47", CSW_AK47)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_aug", CSW_AUG)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_awp", CSW_AWP)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_deagle", CSW_DEAGLE)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_elite", CSW_ELITE)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_famas", CSW_FAMAS)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_fiveseven", CSW_FIVESEVEN)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_flashbang", CSW_FLASHBANG)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_g3sg1", CSW_G3SG1)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_galil", CSW_GALIL)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_glock18", CSW_GLOCK18)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_hegrenade", CSW_HEGRENADE)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_knife", CSW_KNIFE)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_m3", CSW_M3)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_m4a1", CSW_M4A1)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_m249", CSW_M249)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_mac10", CSW_MAC10)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_mp5navy", CSW_MP5NAVY)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_p90", CSW_P90)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_p228", CSW_P228)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_scout", CSW_SCOUT)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_sg550", CSW_SG550)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_sg552", CSW_SG552)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_smokegrenade", CSW_SMOKEGRENADE)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_tmp", CSW_TMP)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_ump45", CSW_UMP45)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_usp", CSW_USP)
	TrieSetCell(trieDefaultWeaponIdList, "weapon_xm1014", CSW_XM1014)
}

public plugin_natives()
{
	register_native("mg_weapon_register", "native_weapon_register")
	register_native("mg_weapon_registerex", "native_weapon_registerex")
	register_native("mg_weapon_registersfx", "native_weapon_registersfx")
	register_native("mg_weapon_user_has", "native_weapon_user_has")
	register_native("mg_weapon_user_get", "native_weapon_user_get")
	register_native("mg_weapon_user_get_all", "native_weapon_user_get_all")
	register_native("mg_weapon_user_get_arrayhandler", "native_weapon_user_get_arrayhandler")
	register_native("mg_weapon_user_give", "native_weapon_user_give")
	register_native("mg_weapon_user_strip", "native_weapon_user_strip")
	register_native("mg_weapon_user_strip_all", "native_weapon_user_strip_all")
}

public native_weapon_register(plugin_id, param_num)
{
	new lWeaponId, lWeaponViewModel[96], lWeaponPlayerModel[96], lWeaponWorldModel[96], lWeaponViewBody, lWeaponPlayerBody, lWeaponWorldBody
	new lWeaponLangnameFull[64], lWeaponLangname[64], lWeaponSprite[64], lWeaponBaseWeapon, lWeaponAnimShift, lWeaponFlags
	
	lWeaponId = get_param(1)

	if(ArrayFindValue(arrayWeaponId, lWeaponId) != -1)
	{
		log_amx("[REGISTER] Weapon already registered! (%d)", lWeaponId)
		return false
	}

	get_string(2, lWeaponViewModel, charsmax(lWeaponViewModel))
	get_string(3, lWeaponPlayerModel, charsmax(lWeaponPlayerModel))
	get_string(4, lWeaponWorldModel, charsmax(lWeaponWorldModel))
	lWeaponViewBody = get_param(5)
	lWeaponPlayerBody = get_param(6)
	lWeaponWorldBody = get_param(7)
	get_string(8, lWeaponLangnameFull, charsmax(lWeaponLangnameFull))
	get_string(9, lWeaponLangname, charsmax(lWeaponLangname))
	get_string(10, lWeaponSprite, charsmax(lWeaponSprite))
	lWeaponBaseWeapon = get_param(11)
	lWeaponAnimShift = get_param(12)
	lWeaponFlags = get_param(13)

	if(equal(lWeaponSprite, "none"))
		get_weaponname(lWeaponBaseWeapon, lWeaponSprite, charsmax(lWeaponSprite))
	
	if(lWeaponFlags == -1)
		lWeaponFlags = gWeaponFlags[lWeaponBaseWeapon]

	ArrayPushCell(arrayWeaponId, lWeaponId)
	ArrayPushString(arrayWeaponViewModel, lWeaponViewModel)
	ArrayPushString(arrayWeaponPlayerModel, lWeaponPlayerModel)
	ArrayPushString(arrayWeaponWorldModel, lWeaponWorldModel)
	ArrayPushCell(arrayWeaponViewBody, lWeaponViewBody)
	ArrayPushCell(arrayWeaponPlayerBody, lWeaponPlayerBody)
	ArrayPushCell(arrayWeaponWorldBody, lWeaponWorldBody)
	ArrayPushString(arrayWeaponLangnameFull, lWeaponLangnameFull)
	ArrayPushString(arrayWeaponLangname, lWeaponLangname)
	ArrayPushString(arrayWeaponSprite, lWeaponSprite)
	ArrayPushCell(arrayWeaponBaseWeapon, lWeaponBaseWeapon)
	ArrayPushCell(arrayWeaponAnimShift, lWeaponAnimShift)
	ArrayPushCell(arrayWeaponFlags, lWeaponFlags)
	// For safety we set all the other arrays to null
	ArrayPushCell(arrayWeaponExPrimSpeed, -1.0)
	ArrayPushCell(arrayWeaponExSecSpeed, -1.0)
	ArrayPushCell(arrayWeaponExDamage, -1.0)
	ArrayPushCell(arrayWeaponExRecoil, -1.0)
	ArrayPushCell(arrayWeaponExReloadTime, -1.0)
	ArrayPushCell(arrayWeaponExPrimaryAmmoType, gWeaponAmmoIdList[lWeaponBaseWeapon])
	ArrayPushCell(arrayWeaponExPrimaryAmmoBPMax, gWeaponMaxAmmoList[lWeaponBaseWeapon])
	ArrayPushCell(arrayWeaponExPrimaryAmmoClip, -1)
	ArrayPushCell(arrayWeaponExSecondaryAmmoType, -1)
	ArrayPushCell(arrayWeaponExSecondaryAmmoBPMax, -1)
	ArrayPushCell(arrayWeaponSfxPrimAttack, -1)
	ArrayPushCell(arrayWeaponSfxSecAttack, -1)

	new lBaseWeaponName[32]
	get_weaponname(lBaseWeaponId, lBaseWeaponName, charsmax(lBaseWeaponName))

	TrieSetString(trieWeaponSpriteList, lWeaponSprite, lBaseWeaponName)

	return true
}

public native_weapon_registerex(plugin_id, param_num)
{
	new lWeaponId = get_param(1)
	new lArrayId = ArrayFindValue(arrayWeaponId, lWeaponId)

	if(lArrayId == -1)
	{
		log_amx("[REGISTEREXTRA] Weapon was not found! (%d)", lWeaponId)
		return false
	}

	new Float:lWeaponExPrimSpeed, Float:lWeaponExSecSpeed, Float:lWeaponExDamage, Float:lWeaponExRecoil, Float:lWeaponExReloadTime
	new lWeaponExPrimaryAmmoType, lWeaponExPrimaryAmmoBPMax, lWeaponExPrimaryAmmoClip
	new lWeaponExSecondaryAmmoType, lWeaponExSecondaryAmmoBPMax

	lWeaponExPrimSpeed = get_param_f(2)
	lWeaponExSecSpeed = get_param_f(3)
	lWeaponExDamage = get_param_f(4)
	lWeaponExRecoil = get_param_f(5)
	lWeaponExReloadTime = get_param_f(6)
	lWeaponExPrimaryAmmoType = get_param(7)
	lWeaponExPrimaryAmmoBPMax = get_param(8)
	lWeaponExPrimaryAmmoClip = get_param(9)
	lWeaponExSecondaryAmmoType = get_param(10)
	lWeaponExSecondaryAmmoBPMax = get_param(11)

	new lBaseWeaponId = ArrayGetCell(arrayWeaponBaseWeapon, lArrayId)

	if(lWeaponExPrimaryAmmoType == -1)
		lWeaponExPrimaryAmmoType = gWeaponAmmoIdList[lBaseWeaponId]
	
	if(lWeaponExPrimaryAmmoBPMax == -1)
		lWeaponExPrimaryAmmoBPMax = gWeaponMaxAmmoList[lBaseWeaponId]

	ArraySetCell(arrayWeaponExPrimSpeed, lArrayId, lWeaponExPrimSpeed)
	ArraySetCell(arrayWeaponExSecSpeed, lArrayId, lWeaponExSecSpeed)
	ArraySetCell(arrayWeaponExDamage, lArrayId, lWeaponExDamage)
	ArraySetCell(arrayWeaponExRecoil, lArrayId, lWeaponExRecoil)
	ArraySetCell(arrayWeaponExReloadTime, lArrayId, lWeaponExReloadTime)
	ArraySetCell(arrayWeaponExPrimaryAmmoType, lArrayId, lWeaponExPrimaryAmmoType)
	ArraySetCell(arrayWeaponExPrimaryAmmoBPMax, lArrayId, lWeaponExPrimaryAmmoBPMax)
	ArraySetCell(arrayWeaponExPrimaryAmmoClip, lArrayId, lWeaponExPrimaryAmmoClip)
	ArraySetCell(arrayWeaponExSecondaryAmmoType, lArrayId, lWeaponExSecondaryAmmoType)
	ArraySetCell(arrayWeaponExSecondaryAmmoBPMax, lArrayId, lWeaponExSecondaryAmmoBPMax)

	return true
}

public native_weapon_registersfx(plugin_id, param_num)
{
	new lWeaponId = get_param(1)
	new lArrayId = ArrayFindValue(arrayWeaponId, lWeaponId)

	if(lArrayId == -1)
	{
		log_amx("[REGISTERSFX] Weapon was not found! (%d)", lWeaponId)
		return false
	}

	new lWeaponSfxPrimAttack, lWeaponSfxSecAttack

	lWeaponSfxPrimAttack = get_param(2)
	lWeaponSfxSecAttack = get_param(3)

	ArraySetCell(arrayWeaponSfxPrimAttack, lArrayId, lWeaponSfxPrimAttack)
	ArraySetCell(arrayWeaponSfxSecAttack, lArrayId, lWeaponSfxSecAttack)

	return true
}

public native_weapon_user_has(plugin_id, param_num)
{
	new id = get_param(1)

	if(!is_user_alive(id))
		return false
	
	new lWeaponId = get_param(2)

	if(ArrayFindValue(arrayWeaponId, lWeaponId) == -1)
	{
		log_amx("[HAS] Weapon is not registered! (%d)", lWeaponId)
		return false
	}

	if(userHasWeapon(id, lWeaponId))
		return true
	
	return false
}

public native_weapon_user_get(plugin_id, param_num)
{
	new id = get_param(1)

	if(!is_user_alive(id))
		return MGW_INVALID
	
	return getUserCurrentWeapon(id)
}

public native_weapon_user_get_all(plugin_id, param_num)
{
	new id = get_param(1)
	
	set_array(2, gUserWeapons[id], MGW_BITFIELDCOUNT)

	return true
}

public native_weapon_user_give(plugin_id, param_num)
{
	new id = get_param(1)

	if(!is_user_alive(id))
		return false
	
	new lWeaponId = get_param(2)

	return giveUserWeapon(id, lWeaponId)
}

public native_weapon_user_strip(plugin_id, param_num)
{
	new id = get_param(1)

	if(!is_user_alive(id))
		return false

	new lWeaponId = get_param(2)

	stripUserWeapon(id, lWeaponId)
	
	return true
}

public native_weapon_user_strip_all(plugin_id, param_num)
{
	new id = get_param(id)

	if(!is_user_alive(id))
		return false

	new lArraySize = ArraySize(arrayUserWeaponList[id])

	for(new i; i < lArraySize; i++)
	{
		stripUserWeapon(id, i)
	}

	return true
}

public fwFmSetModel(ent, model[])
{
	static lClassName[32]
	lClassName[0] = EOS

	entity_get_string(ent, EV_SZ_classname, lClassName, charsmax(lClassName))

	if(!equal(lClassName, "weaponbox"))
		return FMRES_IGNORED

	static lWeaponEnt

	TrieGetString(trieDefaultWeaponModelList, model, lClassName, charsmax(lClassName))

	lWeaponEnt = find_ent_by_owner(-1, lClassName, ent)

	if(!is_valid_ent(lWeaponEnt))
		return FMRES_IGNORED
	
	static lOwner
	lOwner = entity_get_edict(ent, EV_ENT_owner)

	if(!is_user_connected(lOwner))
		return FMRES_IGNORED

	static lBaseWeaponId, lWeaponId, lWeaponWorldModel[96]
	lWeaponWorldModel[0] = EOS
	
	TrieGetCell(trieDefaultWeaponIdList, lClassName, lBaseWeaponId)
	lWeaponId = getUserWeaponByDefaultId(lOwner, lBaseWeaponId)

	if(lWeaponId == MGW_INVALID)
		return FMRES_IGNORED

	static lArrayId
	lArrayId = ArrayFindValue(arrayWeaponId, lWeaponId)

	if(lArrayId == -1)
	{
		log_amx("[SETMODEL] Invalid Weapon ID! (This message should not appear!!!) [%d]", lWeaponId)
		return FMRES_IGNORED
	}

	ArrayGetString(arrayWeaponWorldModel, lArrayId, lWeaponWorldModel, charsmax(lWeaponWorldModel))

	entity_set_int(lWeaponEnt, EV_INT_impulse, lWeaponId)
	entity_set_model(ent, lWeaponWorldModel)
	entity_set_int(ent, EV_INT_body, ArrayGetCell(arrayWeaponWorldBody, lArrayId))

	removeUserWeaponData(lOwner, lWeaponId)

	return FMRES_SUPERCEDE
}

public client_putinserver(id)
{
	ArrayDestroy(arrayUserWeaponList[id])

	arrayUserWeaponList[id] = ArrayCreate(1)
}

public client_disconnected(id)
{
	ArrayDestroy(arrayUserWeaponList[id])
}

public client_command(id)
{
	if(!is_user_alive(id))
		return PLUGIN_CONTINUE
	
	static lCommand[64], lBaseWeaponName[32]
	read_argv(0, lCommand, charsmax(lCommand))
	remove_quotes(lCommand)
	
	if(TrieGetString(trieWeaponSpriteList, lCommand, lBaseWeaponName, charsmax(lBaseWeaponName)))
	{
		engclient_cmd(id, lBaseWeaponName)
		return PLUGIN_HANDLED
	}

	return PLUGIN_CONTINUE
}

getUserCurrentWeapon(id)
{
	new lCurrentBaseWeapon = get_user_weapon(id)
	new lArraySize = ArraySize(arrayUserWeaponList[id])

	for(new i; i < lArraySize; i++)
	{
		if(ArrayGetCell(arrayWeaponBaseWeapon, ArrayGetCell(arrayUserWeaponList[id], i)) == lCurrentBaseWeapon)
			return ArrayGetCell(arrayWeaponId, i)
	}

	return MGW_INVALID
}

userHasWeapon(id, weaponId)
{
	return gUserWeapons[id][weaponId/32] & (1<<(weaponId % 32))
}

getUserWeaponByDefaultId(id, baseWeaponId)
{
	new lArraySize = ArraySize(arrayUserWeaponList[id])

	new lWeaponId

	for(new i; i < lArraySize; i++)
	{
		lWeaponId = ArrayGetCell(arrayUserWeaponList[id], i)

		if(ArrayGetCell(arrayWeaponBaseWeapon, lWeaponId) == baseWeaponId)
			return ArrayGetCell(arrayWeaponId, lWeaponId)
	}

	return MGW_INVALID
}

removeUserWeaponData(id, weaponId)
{
	if(!is_user_connected(id))
		return false
	
	static lArrayId, retValue

	lArrayId = ArrayFindValue(arrayWeaponId, weaponId)

	if(lArrayId == -1 && gUserWeapons[id][weaponId/32] & (1<<(weaponId % 32)))
		log_amx("[REMOVEWEAPONDATA] !!WARNING!! Weapon dynamic array and weapon list are not synchronized!! (%d)", weaponId)
	
	ExecuteForward(gForwardWeaponUserWeaponLost, retValue, id, weaponId)

	gUserWeapons[id][weaponId/32] &= ~(1<<(weaponId % 32))

	if(lArrayId == -1)
		return true

	ArrayDeleteItem(arrayUserWeaponList[id], lArrayId)

	return true
}

stripUserWeapon(id, weaponId, baseWeaponId = CSW_NONE)
{
	new lArrayId = ArrayFindValue(arrayWeaponId, weaponId)

	if(lArrayId == -1)
	{
		log_amx("[REMOVEWEAPON] This weapon is not registered! (%d)", weaponId)
		
		if(baseWeaponId == CSW_NONE)
			return false
		else
		{
			ham_strip_user_weapon(id, baseWeaponId)
			return true
		}
	}

	if(baseWeaponId == CSW_NONE)
		baseWeaponId = ArrayGetCell(arrayWeaponBaseWeapon, weaponId)
	
	ham_strip_user_weapon(id, baseWeaponId)
	removeUserWeaponData(id, weaponId)

	return true
}

setUserWeaponData(id, weaponId)
{
	if(!is_user_connected(id))
		return false

	static lArrayId, retValue

	lArrayId = ArrayFindValue(arrayWeaponId, weaponId)

	if(lArrayId != -1 && !(gUserWeapons[id][weaponId/32] & (1<<(weaponId % 32))))
	{
		log_amx("[GIVEWEAPONDATA] !!WARNING!! Weapon dynamic array and weapon list are not synchronized!! (%d)", weaponId)
	}

	ExecuteForward(gForwardWeaponUserWeaponGet, retValue, id, weaponId)

	gUserWeapons[id][weaponId/32] |= (1<<(weaponId % 32))

	if(lArrayId != -1)
		return true

	ArrayPushCell(arrayUserWeaponList[id], lArrayId)

	return true
}

giveUserWeapon(id, weaponId)
{
	if(!is_user_alive(id))
		return false
	
	if(userHasWeapon(id, weaponId))
		return false
	
	new lArrayId = ArrayGetCell(arrayWeaponId, weaponId)

	if(lArrayId == -1)
	{
		log_amx("[GIVEUSERWEAPON] Weapon is not registered! (%d)", weaponId)
		return false
	}

	new lBaseWeaponId, lWeaponId, lBaseWeaponName[32]
	lBaseWeaponId = ArrayGetCell(arrayWeaponBaseWeapon, lArrayId)

	while((lWeaponId = getUserWeaponByDefaultId(id, lBaseWeaponId)))
	{
		stripUserWeapon(id, lWeaponId, lBaseWeaponId)
	}

	get_weaponname(lBaseWeaponId, lBaseWeaponName, charsmax(lBaseWeaponName))

	if(give_item(id, lBaseWeaponName))
	{
		setUserWeaponData(id, weaponId)
		setUserWeaponSprite(id, weaponId)
		return true
	}
	else
	{
		log_amx("[GIVEUSERWEAPON] Could not give weapon with command: ^"give_item(%d, %s)^"", id, lBaseWeaponName)
		return false
	}
}

setUserWeaponSprite(id, weaponId)
{
	new lArrayId = ArrayFindValue(arrayWeaponId, weaponId)

	if(lArrayId == -1)
	{
		log_amx("[SETWEAPONSPRITE] Weapon's not registered! (%d)", weaponId)
		return false
	}

	new lWeaponSprite[64], lBaseWeaponId

	ArrayGetString(arrayWeaponSprite, lArrayId, lWeaponSprite, charsmax(lWeaponSprite))
	lBaseWeaponId = ArrayGetCell(arrayWeaponBaseWeapon, lArrayId)

	message_begin(MSG_ONE, gMsgWeaponList, {0, 0, 0}, id)
	{
		write_string(lWeaponSprite)											// WeaponName
		write_byte(ArrayGetCell(arrayWeaponExPrimaryAmmoType, lArrayId))	// PrimaryAmmoID
		write_byte(ArrayGetCell(arrayWeaponExPrimaryAmmoBPMax, lArrayId))	// PrimaryAmmoMaxAmount
		write_byte(ArrayGetCell(arrayWeaponExSecondaryAmmoType, lArrayId))	// SecondaryAmmoID
		write_byte(ArrayGetCell(arrayWeaponExSecondaryAmmoBPMax, lArrayId))	// SecondaryAmmoMaxAmount
		write_byte(gWeaponSlotId[lBaseWeaponId])							// SlotID (0...N)
		write_byte(gWeaponNumberInSlot[lBaseWeaponId])						// NumberInSlot (1...N)
		write_byte(lBaseWeaponId)											// WeaponID
		write_byte(ArrayGetCell(arrayWeaponFlags, lArrayId))				// Flags
	}
	message_end()

	return true
}

/* From stripweapons.inc, by ConnorMcLeod
 * http://forums.alliedmods.net/showpost.php?p=1109747&postcount=42
 *
 * Strips a player's weapon based on weapon index.
 *
 * @param id:				Player id
 * @param iCswId:			Weapon CSW_* index
 * @param iSlot:			Inventory slot (Leave 0 if not sure)
 * @param bSwitchIfActive:	Switch weapon if currently deployed
 * @return:	1 on success, otherwise 0
 *
 * Ex: 	ham_strip_user_weapon(id, CSW_M4A1); 	// Strips m4a1 if user has one.
 * 		ham_strip_user_weapon(id, CSW_HEGRENADE, _, false);		// Strips HE grenade if user has one 
 *																// without switching weapons.
*/
stock ham_strip_user_weapon(id, iCswId, iSlot = 0, bool:bSwitchIfActive = true)
{
	new iWeapon
	if( !iSlot )
	{
		static const iWeaponsSlots[] = {
			-1,
			2, //CSW_P228
			-1,
			1, //CSW_SCOUT
			4, //CSW_HEGRENADE
			1, //CSW_XM1014
			5, //CSW_C4
			1, //CSW_MAC10
			1, //CSW_AUG
			4, //CSW_SMOKEGRENADE
			2, //CSW_ELITE
			2, //CSW_FIVESEVEN
			1, //CSW_UMP45
			1, //CSW_SG550
			1, //CSW_GALIL
			1, //CSW_FAMAS
			2, //CSW_USP
			2, //CSW_GLOCK18
			1, //CSW_AWP
			1, //CSW_MP5NAVY
			1, //CSW_M249
			1, //CSW_M3
			1, //CSW_M4A1
			1, //CSW_TMP
			1, //CSW_G3SG1
			4, //CSW_FLASHBANG
			2, //CSW_DEAGLE
			1, //CSW_SG552
			1, //CSW_AK47
			3, //CSW_KNIFE
			1 //CSW_P90
		}
		iSlot = iWeaponsSlots[iCswId]
	}

	const XTRA_OFS_PLAYER = 5
	const m_rgpPlayerItems_Slot0 = 367

	iWeapon = get_pdata_cbase(id, m_rgpPlayerItems_Slot0 + iSlot, XTRA_OFS_PLAYER)

	const XTRA_OFS_WEAPON = 4
	const m_pNext = 42
	const m_iId = 43

	while( iWeapon > 0 )
	{
		if( get_pdata_int(iWeapon, m_iId, XTRA_OFS_WEAPON) == iCswId )
		{
			break
		}
		iWeapon = get_pdata_cbase(iWeapon, m_pNext, XTRA_OFS_WEAPON)
	}

	if( iWeapon > 0 )
	{
		const m_pActiveItem = 373
		if( bSwitchIfActive && get_pdata_cbase(id, m_pActiveItem, XTRA_OFS_PLAYER) == iWeapon )
		{
			ExecuteHamB(Ham_Weapon_RetireWeapon, iWeapon)
		}

		if( ExecuteHamB(Ham_RemovePlayerItem, id, iWeapon) )
		{
			user_has_weapon(id, iCswId, 0)
			ExecuteHamB(Ham_Item_Kill, iWeapon)
			return 1
		}
	}

	return 0
}

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1066\\ f0\\ fs16 \n\\ par }
*/

/*
SecAmmoIcon
Supported Mods:	Team Fortress Classic • Half-Life Deathmatch • Counter-Strike • Counter-Strike: Condition Zero

This message creates an icon at the bottom right corner of the screen. TFC uses it to display carried grenade icon. It is not registered in other mods, but it is still useable though.

Note: icon is any sprite name from hud.txt.
Note: this message will have effect only when sent in conjuction with SecAmmoVal message.
Name:	SecAmmoIcon
Structure:	
string	icon

SecAmmoVal
Supported Mods:	Team Fortress Classic • Half-Life Deathmatch • Counter-Strike • Counter-Strike: Condition Zero

It is used to show carried grenade amount in TFC; it is disabled on all other mods, but it is still useable though.

Note: Slots range from 1 to 4.
Note: Sending 0 as amount for all slots will remove the effect of this message.

Name:	SecAmmoVal
Structure:	
byte	slot
byte	amount
 */