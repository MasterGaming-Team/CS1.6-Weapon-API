#if defined _mg_weapon_api_included
	#endinput
#endif

#define _mg_weapon_api_included

#include <mg_weapon_api_const>

/*
 * Registers a new weapon.
 *
 * @param weaponId                  MGW_*, see mg_weapon_api_const.inc.
 * @param viewModel                 The view model of the weapon.
 * @param playerModel               The outer model of the weapon.
 * @param worldModel                The world model of the weapon.
 * @param viewBody                  The body of the view model.
 * @param playerBody                The body of the outer model.
 * @param worldBody                 The body of the world model.
 * @param langnameFull              Lang destination of the full name of the weapon.(Mostly used in menus)
 * @param langname                  Lang destination of the regular name of the weapon.
 * @param spr                       The name of the weapon sprite file(.txt). Also the command name of the weapon.
 * @param baseWeapon                CSW_*, see cstrike_const.inc. Which default the weapon is based on.
 * @param animShift                 How many times the animations should be shifted.
 * @param flags                     MGW_FLAG_*, see mg_weapon_api_const.inc.
 *
 * @return			False if the weapon's already registered.
 */
native mg_weapon_register(weaponId, const viewModel[], const playerModel[], const worldModel[], viewBody, playerBody, worldBody, const langnameFull[],
            const langname[], const spr[] = "none", baseWeapon, animShift = 0, flags = -1);

/*
 * Registers extra attributions for a weapon.
 * @note The weapon must be registered before this!!
 * @note Which variables are not registered will be set to the default!
 *
 * @param weaponId                  MGW_*, see mg_weapon_api_const.inc.
 * @param primSpeed                 Delay between primary attacks.
 * @param secSpeed                  Delay between secondary attacks.
 * @param damage                    Regular damage.
 * @param recoil                    The amount of recoil the weapon gets.
 * @param reloadTime                How much time it takes to reload this weapon.
 * @param priAmType                 MGW_AMMO_*, see mg_weapon_api_const.inc.
 * @param priAmBPMax                Max primary backpack ammo.
 * @param priAmClip                 Max primary clip ammo.
 * @param SecAmType                 MGW_AMMO_*, see mg_weapon_api_const.inc.
 * @param SecAmBPMax                Max secondary backpack ammo.
 *
 * @return                          False if weapon was not registered before.
 */
native mg_weapon_registerex(weaponId, Float:primSpeed = -1.0, Float:secSpeed = -1.0, Float:damage = -1.0, Float:recoil = -1.0, Float:reloadTime = -1.0,
            priAmType = -1, PriAmBPMax = -1, priAmClip = -1, secAmType = -1, secAmBPMax = -1);

/*
 * Registers world sounds for a weapon.
 * @note The weapon must be registered before this!!
 * @note These will be randomly picked from the array.
 * @note Only send the handler!! You can create the dynamic array like this
 * new lArrayHandler = ArrayCreate(64)
 * and set file paths into it like this:
 * ArrayPushString(lArrayHandler, "sound/weapons/fire-1.wav")
 * and you must register the command like this:
 * mg_weapon_registersfx(lArrayHandlerPrimary, lArrayHandlerSecondary)
 *
 * @param primAttackArrayHandler    The handler of the array which contains the primary attack sounds.
 * @param secAttackArrayHandler     The handler of the array which contains the secondary attack sounds.
 *
 * @return                          False if weapon was not registered before.
 */
native mg_weapon_registersfx(primAttackArrayHandler, secAttackArrayHandler);

/*
 * Returns whether the user has a specific weapon.
 *
 * @param id                        Player id.
 * @param weaponId                  MGW_*, see mg_weapon_api_const.inc
 *
 * @return                          True if the player has the weapon.
 */
native mg_weapon_user_has(id, weaponId);

/*
 * Returns the MSG_* id of the players weapon in hands(See mg_weapon_api_const.inc)
 *
 * @param id                        Player id.
 * 
 * @return                          The weapon id.
 */
native mg_weapon_user_get(id);

/*
 * Sets the players weapon bitfield into our variables.
 * @note Our bitfield should be registered like this:
 * bitField[MGW_BITFIELDCOUNT]
 * And the command must be sent like this:
 * mg_weapon_user_get_all(id, bitField)
 *
 * If the player has a specific weapon can be checked like this:
 * if(bitField[MGW_* / 32] & (1<<(MGW_* % 32)))
 * If the player has that specific weapon it'll return true!
 * 
 *
 * @param id                        Player id.
 * @param bitField                  The bitfield to copy to.
 *
 * @return                          True.
 */
 native mg_weapon_user_get_all(id, bitField[MGW_BITFIELDCOUNT])