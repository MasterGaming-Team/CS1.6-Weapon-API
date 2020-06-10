#if defined _mg_weapon_api_const_included
	#endinput
#endif

#define _mg_weapon_api_const_included

#define MGW_INVALID					-1
#define MGW_NONE					0
#define MGW_P228					1
#define MGW_GLOCK					2 // Unused by game, see MGW_CLOCK18
#define MGW_SCOUT					3
#define MGW_HEGRENADE				4
#define MGW_XM1014					5
#define MGW_C4						6
#define MGW_MAC10					7
#define MGW_AUG						8
#define MGW_SMOKEGRENADE			9
#define MGW_ELITE					10
#define MGW_FIVESEVEN				11
#define MGW_UMP45					12
#define MGW_SG550					13
#define MGW_GALI					14
#define MGW_GALIL					14
#define MGW_FAMAS					15
#define MGW_USP						16
#define MGW_GLOCK18					17
#define MGW_AWP						18
#define MGW_MP5NAVY					19
#define MGW_M249					20
#define MGW_M3						21
#define MGW_M4A1					22
#define MGW_TMP						23
#define MGW_G3SG1					24
#define MGW_FLASHBANG				25
#define MGW_DEAGLE					26
#define MGW_SG552					27
#define MGW_AK47					28
#define MGW_KNIFE					29
#define MGW_P90						30
#define MGW_VEST					31
#define MGW_VESTHELM				32
#define MGW_LAST_WEAPON_DEFAULT		MGW_P90
#define MGW_MAVERICKCROWBAR			35 // Maverick pack starts with this
#define MGW_MAVERICKK1A				36
#define MGW_MAVERICKM1887			37
#define MGW_MAVERICKGALIL			38
#define MGW_MAVERICKM60				39
#define MGW_MAVERICKSPAS12			40 // Maverick pack end with this
#define MGW_CROW1					41 // Crow pack start with this
#define MGW_CROW3					42
#define MGW_CROW5					43
#define MGW_CROW7					44
#define MGW_CROW9					45
#define MGW_CROW11					46 // Crow pack ends with this
#define MGW_SKULL1					47 // Skull pack starts with this
#define MGW_SKULL2					48
#define MGW_SKULL3					49
#define MGW_SKULL4					50
#define MGW_SKULL5					51
#define MGW_SKULL6					52
#define MGW_SKULL7					53
#define MGW_SKULL8					54
#define MGW_SKULL9					55
#define MGW_SKULL11					56 // Skull pack ends with this
#define MGW_BALROG1					57 // Balrog pack starts with this
#define MGW_BALROG3					58
#define MGW_BALROG5					59
#define MGW_BALROG7					60
#define MGW_BALROG9					61
#define MGW_BALROG11				62 // Balrog pack ends with this
#define MGW_JANUS1					63 // Janus pack starts with this
#define MGW_JANUS3					64
#define MGW_JANUS5					65
#define MGW_JANUS7					66
#define MGW_JANUS9					67
#define MGW_JANUS11					68 // Janus pack ends with this
#define MGW_VULCANUS1				69 // Vulcanus pack starts with this
#define MGW_VULCANUS3				70
#define MGW_VULCANUS5				71
#define MGW_VULCANUS7				72
#define MGW_VULCANUS9				73
#define MGW_VULCANUS11				74 // Vulcanus pack ends with this
#define MGW_GOLDM3					75 // Gold pack starts with this
#define MGW_GOLDAK47				76
#define MGW_GOLDM4A1				77
#define MGW_GOLDGALIL				78
#define MGW_GOLDSG550				79
#define MGW_GOLDAWP					80
#define MGW_GOLDMP5NAVY				81
#define MGW_GOLDM249				82
#define MGW_GOLDG3SG1				83
#define MGW_GOLDSG552				84
#define MGW_GOLDP90					85
#define MGW_GOLDDEAGLE				86
#define MGW_GOLDUSP					87 // Gold pack ends with this
#define MGW_DUALINFINITY			88 // Single weapons(part 1) start with this
#define MGW_DUALINFINITYFINAL		89
#define MGW_LUGER					90
#define MGW_KINGCOBRA				91
#define MGW_ANACONDA				92
#define MGW_TACTICAL_KNIFE			93
#define MGW_M79SAWOFF				94
#define MGW_WINCHESTERM1887			95
#define MGW_KSG12					96
#define MGW_SPAS12					97
#define MGW_UTS15					98 // Single weapons(part 1) end with this
#define MGW_SHIELDGUN				99 // Must be this, by cstrike_const.inc
#define MGW_USAS12					100 // Single weapons(part 2) start with this
#define MGW_DOUBLEBARREL			101
#define MGW_TRIPLEBARREL			102
#define MGW_QBS09					103
#define MGW_K1A						104
#define MGW_THOMPSHON				105
#define MGW_UZI						106
#define MGW_KRISS					107
#define MGW_BIZON					108
#define MGW_M14EBR					109
#define MGW_TAR21					110
#define MGW_QBZ95B					111
#define MGW_SCARL					112
#define MGW_AKM						113
#define MGW_XM8						114
#define MGW_SVD						115
#define MGW_AS50					116
#define MGW_M24						117
#define MGW_HECATE					118
#define MGW_XM2010					119
#define MGW_M82						120
#define MGW_AWPZ					121
#define MGW_M95						122
#define MGW_MOSIN					123
#define MGW_TRG						124
#define MGW_FALCON					125
#define MGW_SCAROZD					126
#define MGW_INFINITYSILVER			127
#define MGW_INFINITYBLACK			128
#define MGW_INFINITYRED				129
#define MGW_LAST_WEAPON				MGW_INFINITYRED
#define MGW_BITFIELDCOUNT			(MGW_LAST_WEAPON/32)+1

#define MGW_FLAG_SELECTONEMPTY		(1<<0)
#define MGW_FLAG_NOAUTORELOAD 		(1<<1)
#define MGW_FLAG_NOAUTOSWITCHEMPTY	(1<<2)
#define MGW_FLAG_LIMITINWORLD		(1<<3)
#define MGW_FLAG_EXHAUSTIBLE		(1<<4)
// Continue with machine guns, CSO weapons(https://cso.fandom.com/wiki/Weapons)

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1066\\ f0\\ fs16 \n\\ par }
*/
