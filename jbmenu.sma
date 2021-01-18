#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <cstrike>
#include <hlsdk_const>
#include <fakemeta>
#include <fakemeta_util>
#include <fun>
#include <engine>
#include <xs>

#define PLUGIN "ShieldsClan JBMenu"
#define VERSION "v0.2"
#define AUTHOR "burakware"

#define TAG "ShieldsClan"
#define charsmax(%1) (sizeof(%1)-1)
#define is_valid_player(%1) (1 <= %1 <= 32)
#define OFFSET_CLIPAMMO        51
#define OFFSET_LINUX_WEAPONS    4
#define fm_cs_set_weapon_ammo(%1,%2)    set_pdata_int(%1, OFFSET_CLIPAMMO, %2, OFFSET_LINUX_WEAPONS)
#define m_pActiveItem 373
#define CELL_RADIUS	Float:200.0
#define MAX_DOOR 1000


#if defined _jail_included
#endinput
#endif
#define _jail_included
native jb_get_user_packs(id)
	native jb_set_user_packs(id, ammount)  
	
/*============================================================
Variables
============================================================*/
const NOCLIP_WPN_BS    = ((1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FLASHBANG)|(1<<CSW_KNIFE)|(1<<CSW_C4))
new const g_MaxClipAmmo[] = {
	0,
	13, //csW_P228
	0,
	10, //csW_SCOUT
	0,  //csW_HEGRENADE
	7,  //csW_XM1014
	0,  //csW_C4
	30, //csW_MAC10
	30, //csW_AUG
	0,  //csW_SMOKEGRENADE
	15, //csW_ELITE
	20, //csW_FIVESEVEN
	25, //csW_UMP45
	30, //csW_SG550
	35, //csW_GALIL
	25, //csW_FAMAS
	12, //csW_USP
	20, //csW_GLOCK18
	10, //csW_AWP
	30, //csW_MP5NAVY
	100, //csW_M249
	8,  //csW_M3
	30, //csW_M4A1
	30, //csW_TMP
	20, //csW_G3SG1
	0,  //csW_FLASHBANG
	7,  //csW_DEAGLE
	30, //csW_SG552
	30, //csW_AK47
	0,  //csW_KNIFE
	50 //csW_P90
}


new 	
OnOff, 
precio1, 
precio2, 
precioC1, 
precioC2, 
precioC3,
precioC4,
precio5, 
precio6, 
precio7, 
hp,
hasar,
g_glock,
kacziplasin,
syncObj,
hasar_miktar,
gorev_odul1,
gorev_odul2,
gorev_odul3,
gorev_odul4,
gorev_odul5,
gorev_odul6,
godmode,
gorunmezlik,
kiyafet,
noclip,
dolar,
g_bomberman[33],
CTDefaultDano, 
TDefaultDano, 
PaloDano, 
HachaDano, 
MacheteDano, 
MotocierraDano,
hTDefaultDano, 
hCTDefaultDano, 
hPaloDano, 
hHachaDano, 
hMacheteDano,
isyanteam,
g_killjp, 
g_killhsjp, 
g_startjp,
g_maxjp,
g_unammo[33],
jumpnum[33],
g_bonus[33],
engel[33],
g_yuksek[33],
hasar_azalt[33],
g_frozen[33],
Ronda[33],
g_zipla[33],
g_kanverdim[33],
Speed[33],
Speed2[33],
g_round[33],
g_slot[33],
g_vip[33],
g_elit[33],
g_market[33],
g_bombaa[33],
TCuchillo[33],
CTCuchillo[33],
Destapador[33],
Hacha[33],
Machete[33],
Motocierra[33],
g_jbpacks[33],
quitar[33],
ananzaaxd[33],
regalar[33],
gidPlayer[33]


/*============================================================
Weapon Model's
============================================================*/

new VIEW_MODELT[]    	= "models/ShieldsClan/v_yumrukA.mdl"
new PLAYER_MODELT[] 	= "models/w_knife.mdl"

new VIEW_MODELCT[]    	= "models/[Shop]JailBreak/Electro/Electro.mdl" 
new PLAYER_MODELCT[]   	= "models/[Shop]JailBreak/Electro/Electro2.mdl" 

new VIEW_Hacha[]    	= "models/ShieldsClan/v_tahtaKilic.mdl" 
new PLAYER_Hacha[]   	= "models/w_knife.mdl" 

new VIEW_Machete[]    	= "models/ShieldsClan/v_razor.mdl" 
new PLAYER_Machete[]    = "models/w_knife.mdl"

new VIEW_Palo[]    	= "models/ShieldsClan/v_yeniyil.mdl" 
new PLAYER_Palo[]    	= "models/w_knife.mdl" 

new VIEW_Moto[]    	= "models/ShieldsClan/keserim.mdl" 
new PLAYER_Moto[]    	= "models/w_knife.mdl" 

new WORLD_MODEL[]    	= "models/w_knife.mdl"
new OLDWORLD_MODEL[]    = "models/w_knife.mdl"

/*============================================================
Shop Sounds!
============================================================*/
new const Si[] 		= { "[Shop]JailBreak/Yes.wav" }
new const el_sonu[]      = { "misc/elsonumuzik1" }
new const el_sonu2[]       = { "misc/elsonumuzik2" }
new const el_sonu3[]      = { "misc/elsonumuzik3" }
/*============================================================
Weapon Sound's
============================================================*/

new const palo_deploy[] 		= { "weapons/knife_deploy1.wav" }
new const palo_slash1[] 		= { "weapons/knife_slash1.wav" }
new const palo_slash2[] 		= { "weapons/knife_slash2.wav" }
new const palo_wall[] 		= { "[Shop]JailBreak/Palo/PHitWall.wav" } 
new const palo_hit1[] 		= { "[Shop]JailBreak/Palo/PHit1.wav" } 
new const palo_hit2[] 		= { "[Shop]JailBreak/Palo/PHit2.wav" } 
new const palo_hit3[] 		= { "[Shop]JailBreak/Palo/PHit3.wav" } 
new const palo_hit4[] 		= { "[Shop]JailBreak/Palo/PHit4.wav" } 
new const palo_stab[] 		= { "[Shop]JailBreak/Palo/PStab.wav" }

new const hacha_deploy[] 	= { "weapons/knife_deploy1.wav" }
new const hacha_slash1[] 	= { "weapons/knife_slash1.wav" }
new const hacha_slash2[] 	= { "weapons/knife_slash2.wav" }
new const hacha_wall[] 		= { "[Shop]JailBreak/Palo/PHitWall.wav" } 
new const hacha_hit1[] 		= { "[Shop]JailBreak/palo/PHit1.wav" }
new const hacha_hit2[] 		= { "[Shop]JailBreak/palo/PHit2.wav" }
new const hacha_hit3[] 		= { "[Shop]JailBreak/palo/PHit3.wav" }
new const hacha_stab[] 		= { "[Shop]JailBreak/palo/PHit4.wav" }

new const machete_deploy[] 	= { "weapons/knife_deploy1.wav" }
new const machete_slash1[] 	= { "weapons/knife_slash1.wav" }
new const machete_slash2[] 	= { "weapons/knife_slash2.wav" }
new const machete_wall[] 	= { "[Shop]JailBreak/Palo/PHitWall.wav" } 
new const machete_hit1[] 	= { "[Shop]JailBreak/palo/PHit1.wav" }
new const machete_hit2[] 	= { "[Shop]JailBreak/palo/PHit2.wav" }
new const machete_hit3[] 	= { "[Shop]JailBreak/palo/PHit3.wav" }
new const machete_hit4[] 	= { "[Shop]JailBreak/palo/PHit4.wav" }
new const machete_stab[] 	= { "[Shop]JailBreak/Machete/MStab.wav" }

new const motocierra_deploy[] 	= { "[Shop]JailBreak/Moto/MTConvoca.wav", }
new const motocierra_slash[] 	= { "[Shop]JailBreak/Moto/MTSlash.wav", }
new const motocierra_wall[] 	= { "[Shop]JailBreak/Moto/MTHitWall.wav" }
new const motocierra_hit1[] 	= { "[Shop]JailBreak/Moto/MTHit1.wav",  }
new const motocierra_hit2[] 	= { "[Shop]JailBreak/Moto/MTHit2.wav",  }
new const motocierra_stab[] 	= { "[Shop]JailBreak/Moto/MTStab.wav"  }

new const t_deploy[] 		= { "[Shop]JailBreak/T/TConvoca.wav", }
new const t_slash1[] 		= { "[Shop]JailBreak/T/Slash1.wav", }
new const t_slash2[] 		= { "[Shop]JailBreak/T/Slash2.wav", }
new const t_wall[] 		= { "[Shop]JailBreak/T/THitWall.wav" }
new const t_hit1[] 		= { "[Shop]JailBreak/T/THit1.wav",  }
new const t_hit2[] 		= { "[Shop]JailBreak/T/THit2.wav",  }
new const t_hit3[] 		= { "[Shop]JailBreak/T/THit3.wav",  }
new const t_hit4[] 		= { "[Shop]JailBreak/T/THit4.wav",  }
new const t_stab[] 		= { "[Shop]JailBreak/T/TStab.wav"  }

new const ct_deploy[] 		= { "[Shop]JailBreak/CT/CTConvoca.wav", }
new const ct_slash1[] 		= { "[Shop]JailBreak/CT/Slash1.wav", }
new const ct_slash2[] 		= { "[Shop]JailBreak/CT/Slash2.wav", }
new const ct_wall[] 		= { "[Shop]JailBreak/CT/CTHitWall.wav" }
new const ct_hit1[] 		= { "[Shop]JailBreak/CT/CTHit1.wav",  }
new const ct_hit2[] 		= { "[Shop]JailBreak/CT/CTHit2.wav",  }
new const ct_hit3[] 		= { "[Shop]JailBreak/CT/CTHit3.wav",  }
new const ct_hit4[] 		= { "[Shop]JailBreak/CT/CTHit4.wav",  }
new const ct_stab[] 		= { "[Shop]JailBreak/CT/CTStab.wav"  }


new bool:g_hasar[33]
new bool:check[33]
new bool:check2[33]
new bool:check3[33]
new bool:check4[33]
new bool:check5[33]
new bool:dojump[33] 
new bool:reklamCheck[33]
new bool:kahramanGirdi[33]
new bool:reklamAtti[33]
new bool:yetkiliMenu[33]
new bool:round_sonu;


//Gorevler
new
gorev1[33],
gorev2[33],
gorev3[33],
gorev4[33],
gorev5[33],
gorev6[33],
gardiyan_oldur[33],
jb_harca[33],
mahkum_oldur[33],
esya_al[33],
g_gardiyan[33],
g_cek[33],
g_reklam[33],
g_survive[33];

//Meslekler
new
select_meslek[33],
meslek[33];



/*============================================================
Config
============================================================*/
public plugin_natives()
{	
	register_native("jb_get_user_packs","native_jb_get_user_packs", 1)
	register_native("jb_set_user_packs","native_jb_set_user_packs")
	
}

public plugin_init() 
{
	register_clcmd("say /jbmenu","anamenu")
	register_clcmd("say_team /jbmenu","anamenu")
	register_clcmd("say /shop", "Tienda")
	register_clcmd("say !shop", "Tienda")
	register_clcmd("say_team /shop", "Tienda")
	register_clcmd("say_team !shop", "Tienda")
	register_clcmd("say /reset","reset")
	register_clcmd("say /rs","reset")
	
	register_clcmd("say /mg", 	"kontrol")
	register_clcmd("say !mg", 	"kontrol")
	register_clcmd("say_team /mg", 	"kontrol")
	register_clcmd("say_team !mg", 	"kontrol")
	register_logevent("logevent_round_end", 2, "1=Round_End")
	register_clcmd("JbPacks", 	"player")
	
	RegisterHam(Ham_Spawn, 		"player", "Fwd_PlayerSpawn_Post",	1)
	RegisterHam(Ham_TakeDamage, 	"player", "FwdTakeDamage", 		0)
	RegisterHam(Ham_TakeDamage, "player", "OnCBasePlayer_TakeDamage")
	RegisterHam(Ham_Killed,		"player", "fw_player_killed")
	RegisterHam( Ham_Player_Jump , "player" , "Player_Jump" , false )
	RegisterHam(Ham_Killed,"player","Ham_CBasePlayer_Killed_Post",1);
	
	register_event( "DeathMsg" , "olunce" , "a" )
	register_event("HLTV", "elbasi", "a", "1=0", "2=0")
	register_event("CurWeapon", 	"Event_Change_Weapon", "be", "1=1")
	
	register_forward(FM_SetModel, 	"fw_SetModel")
	register_forward(FM_EmitSound,	"Fwd_EmitSound")
	
	
	/*============================================================
	Cvar's 
	============================================================*/
	
	g_killjp 	= register_cvar("jb_killJP", 		"3"); 
	g_killhsjp 	= register_cvar("jb_bonushsJP", 	"2");
	g_startjp 	= register_cvar("jb_startJP",		"7");  
	g_maxjp 	= register_cvar("jb_maxgiveJP",		"100"); 
	
	OnOff 		= register_cvar("jb_Shop", 		"1")//1(ON) 0(OFF) 
	
	kacziplasin     = register_cvar("amx_maxjumps","1")
	
	/*============================================================
	Cephane Menu Fiyat Cvar :
	============================================================*/
	
	precio1 	= register_cvar("jb_pFlash", 		"8")
	precio2		= register_cvar("jb_pHe", 		"11")
	precio5		= register_cvar("jb_pFast", 		"35")
	precio6		= register_cvar("jb_pYuksek", 		"40")
	precio7		= register_cvar("jb_pUnammo", 		"50")
	g_glock          = register_cvar("jb_glock",                "100")
	
	
	/*============================================================
	Market Fiyat & Hasar Cvar :
	============================================================*/
	
	precioC1	= register_cvar("jb_pKnife1", 		"-1")
	precioC2 	= register_cvar("jb_pKnife2", 		"-1")
	precioC3 	= register_cvar("jb_pKnife3", 		"-1")
	precioC4 	= register_cvar("jb_pKnife4", 		"50")
	TDefaultDano 	= register_cvar("jb_dKnifeT", 		"5")
	CTDefaultDano 	= register_cvar("jb_dKnifeCT", 		"50")
	PaloDano 	= register_cvar("jb_dKnife1", 		"30")
	HachaDano 	= register_cvar("jb_dKnife2", 		"20")
	MacheteDano 	= register_cvar("jb_dKnife3", 		"25")
	MotocierraDano 	= register_cvar("jb_dKnife4", 		"200")
	
	hTDefaultDano 	= register_cvar("jb_dHsKnifeT", 	"15")
	hCTDefaultDano 	= register_cvar("jb_dHsKnifeCT",	"80")
	hPaloDano 	= register_cvar("jb_dhsKnife1", 	"45")
	hHachaDano 	= register_cvar("jb_dhsKnife2", 	"35")
	hMacheteDano 	= register_cvar("jb_dhsKnife3", 	"30")
	
	
	/*============================================================
	Isyan Menu Fiyat Cvar :
	============================================================*/
	
	
	hp                = register_cvar("jb_hp",                   "10")
	hasar             = register_cvar("jb_hasar",               "30")
	godmode          = register_cvar("jb_godmode",              "80")
	gorunmezlik      = register_cvar("jb_gorunmezlik",         "60")
	kiyafet           = register_cvar("jb_kiyafet",              "65")
	noclip            = register_cvar("jb_noclip",               "80")
	
	/*============================================================
	Isyan-Team Cvar :
	============================================================*/
	
	isyanteam       = register_cvar("jb_isyanteam",            "1")
	
	
	/*============================================================
	Gorev Odul Cvar :
	============================================================*/
	
	gorev_odul1     = register_cvar("gorev_odul1",              "10")
	gorev_odul2     = register_cvar("gorev_odul2",              "10")
	gorev_odul3     = register_cvar("gorev_odul3",              "10")
	gorev_odul4     = register_cvar("gorev_odul4",              "10")
	gorev_odul5     = register_cvar("gorev_odul5",              "10")
	gorev_odul6     = register_cvar("gorev_odul6",              "20")
	
	hasar_miktar    = register_cvar("jb_hasarkatla",           "2.0")
	
	syncObj 	= CreateHudSyncObj()
	
}

/*============================================================
Precaches 
============================================================*/
public plugin_precache() 
{
	precache_sound(Si)
	precache_sound(el_sonu)
	precache_sound(el_sonu2)
	precache_sound(el_sonu3)
	precache_sound(t_deploy)
	precache_sound(t_slash1)
	precache_sound(t_slash2)
	precache_sound(t_stab)
	precache_sound(t_wall)
	precache_sound(t_hit1)
	precache_sound(t_hit2)
	precache_sound(t_hit3)
	precache_sound(t_hit4)
	
	precache_sound(ct_deploy)
	precache_sound(ct_slash1)
	precache_sound(ct_slash2)
	precache_sound(ct_stab)
	precache_sound(ct_wall)
	precache_sound(ct_hit1)
	precache_sound(ct_hit2)
	precache_sound(ct_hit3)
	precache_sound(ct_hit4)
	
	precache_sound(palo_deploy)
	precache_sound(palo_slash1)
	precache_sound(palo_slash2)
	precache_sound(palo_stab)
	precache_sound(palo_wall)
	precache_sound(palo_hit1)
	precache_sound(palo_hit2)
	precache_sound(palo_hit3)
	precache_sound(palo_hit4)
	
	precache_sound(machete_deploy)
	precache_sound(machete_slash1)
	precache_sound(machete_slash2)
	precache_sound(machete_stab)
	precache_sound(machete_wall)
	precache_sound(palo_hit1)
	precache_sound(palo_hit2)
	precache_sound(palo_hit3)
	precache_sound(palo_hit4)
	
	precache_sound(hacha_deploy)
	precache_sound(hacha_slash1)
	precache_sound(hacha_slash2)
	precache_sound(hacha_stab)
	precache_sound(hacha_wall)
	precache_sound(palo_hit1)
	precache_sound(palo_hit2)
	precache_sound(palo_hit3)
	
	precache_sound(motocierra_deploy)
	precache_sound(motocierra_slash)
	precache_sound(motocierra_stab)
	precache_sound(motocierra_wall)
	precache_sound(motocierra_hit1)
	precache_sound(motocierra_hit2)
	
	precache_model(VIEW_MODELT)     
	precache_model(PLAYER_MODELT)
	precache_model(VIEW_MODELCT)     
	precache_model(PLAYER_MODELCT)
	precache_model(VIEW_Palo)     
	precache_model(PLAYER_Palo) 
	precache_model(VIEW_Hacha)     
	precache_model(PLAYER_Hacha)	
	precache_model(VIEW_Machete)     
	precache_model(PLAYER_Machete)	
	precache_model(VIEW_Moto)     
	precache_model(PLAYER_Moto)		
	precache_model(WORLD_MODEL)
	
	
	return PLUGIN_CONTINUE
}

/*============================================================
KNIFE SHOP
============================================================*/
public Tienda1(id)
{
	if (get_user_team(id) == 1 )
	{
		if(g_market[id])
		{
			static Item[64]
			formatex(Item, charsmax(Item),"\d< \rShieldsClan \d> \y~ \wEnvanter \dMenu")
			new Menu = menu_create(Item, "CuchilleroHandler")
			
			formatex(Item, charsmax(Item),"\wUcretsiz\r Bicaklar")
			menu_additem(Menu, Item, "1")
			
			formatex(Item, charsmax(Item),"\wTestere \r+ \dBOMBA \r: \w[\d%d \rTL\w]", get_pcvar_num(precioC4))
			menu_additem(Menu, Item, "2")

			menu_addblank(Menu,3)

		//	formatex(Item, charsmax(Item), "\rReklam \wAt \d[ \w%s \d]", reklamCheck[id] ? "KULLANDINIZ" : "2 TL")
		//	menu_additem(Menu, Item, "3") 

			formatex(Item, charsmax(Item), "\rKan \wBagisla -99 HP \d[ \w%s \d]", g_kanverdim[id] ? "2 TL" : "KULLANDINIZ")
			menu_additem(Menu, Item, "4")

			menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
			menu_display(id, Menu)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gHer dogusunda bir kere markete girebilirsin.",TAG)
		}	
	}
	return PLUGIN_HANDLED
}
public ucretsizbicak(id)
{
	if (get_user_team(id) == 1 )
	{
		if(g_market[id])
		{
			static Item[64]
			formatex(Item, charsmax(Item),"\d< \rShieldsClan \d> \y~ \wEnvanter \dMenu")
			new Menu = menu_create(Item, "ucretsizbicaklar")
			
			formatex(Item, charsmax(Item),"\wYilbasi Agaci \r: \w[\d%d \rTL\w]", get_pcvar_num(precioC1))
			menu_additem(Menu, Item, "1")

                        formatex(Item, charsmax(Item),"\wTahta Kilic \r: \w[\d%d \rTL\w]", get_pcvar_num(precioC2))
			menu_additem(Menu, Item, "2")

                        formatex(Item, charsmax(Item),"\wSuikast Bicagi \r: \w[\d%d \rTL\w]", get_pcvar_num(precioC3))
			menu_additem(Menu, Item, "3")
			
			
			menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
			menu_display(id, Menu)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gHer dogusunda bir kere markete girebilirsin.",TAG)
		}	
	}
	return PLUGIN_HANDLED
}

public ucretsizbicaklar(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], iName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	
	new vivo 	= is_user_alive(id)
	new Obtener1 	= get_pcvar_num(precioC1)
	new Obtener2 	= get_pcvar_num(precioC2)
	new Obtener3 	= get_pcvar_num(precioC3)
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1:
		{
			if (g_jbpacks[id]>= Obtener1 && vivo)
			{
				g_jbpacks[id] -= Obtener1
				jb_harca[id] += Obtener1
				CTCuchillo[id] 	= 0
				TCuchillo[id] 	= 0
				Destapador[id] 	= 1
				Hacha[id] 	= 0
				Machete[id] 	= 0
				Motocierra[id] 	= 0
				engel[id]        = 1
				g_market[id] = false
				esya_al[id] += 1
				
				ham_strip_weapon(id, "weapon_knife")
				give_item(id, "weapon_knife")
				
				renkli_yazi(id,"!n[!t%s!n] !gMarketten !n[!tYilbasi Agaci!n] !gsatin aldin",TAG)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				anamenu(id)
			}
			else
			{
				anamenu(id)
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener1) 
			}
		}
		
		case 2:
		{
			if (g_jbpacks[id] >= Obtener2 && vivo)
			{
				
				g_jbpacks[id] -= Obtener2
				jb_harca[id] += Obtener2
				CTCuchillo[id] 	= 0
				TCuchillo[id] 	= 0
				Destapador[id] 	= 0
				Hacha[id] 	= 1
				Machete[id] 	= 0
				Motocierra[id] 	= 0
				engel[id]        = 1
				g_market[id] = false
				esya_al[id] += 1
				g_market[id] = 0
				
				ham_strip_weapon(id, "weapon_knife")
				give_item(id, "weapon_knife")
				
				renkli_yazi(id,"!n[!t%s!n] !gMarketten !n[!tTahta Kilic!n] !gsatin aldin",TAG)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				anamenu(id)
			}
			else
			{
				anamenu(id)
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener2)
			}
		}
		
		case 3:
		{
			if (g_jbpacks[id] >= Obtener3 && vivo)
			{
				g_jbpacks[id] -= Obtener3
				jb_harca[id] += Obtener3
				g_market[id] = false
				CTCuchillo[id] 	= 0
				TCuchillo[id] 	= 0
				Destapador[id] 	= 0
				Hacha[id] 	= 0
				Machete[id] 	= 1
				Motocierra[id] 	= 0
				engel[id]        = 1
				esya_al[id] += 1
				
				ham_strip_weapon(id, "weapon_knife")
				give_item(id, "weapon_knife")
				
				renkli_yazi(id,"!n[!t%s!n] !gMarketten !n[!Suikast Bicagi!n] !gsatin aldin",TAG)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				anamenu(id)
			}
			else
			{
				anamenu(id)
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener3)
			}
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public CuchilleroHandler(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], iName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	
	new vivo 	= is_user_alive(id)
	new Obtener4 	= get_pcvar_num(precioC4)	
	
	new key = str_to_num(data);
	
	switch(key)
	{
		case 1:
		{
			ucretsizbicak(id)
		}
		case 2:
		{
			if (g_jbpacks[id] >= Obtener4 && vivo)
			{
				
				g_jbpacks[id] -= Obtener4
				jb_harca[id] += Obtener4
				g_market[id] = false
				CTCuchillo[id] 	= 0
				TCuchillo[id] 	= 0
				Destapador[id]	= 0
				Hacha[id] 	= 0
				Machete[id] 	= 0
				Motocierra[id] 	= 1
				engel[id]        = 1
				esya_al[id] += 1
				
				ham_strip_weapon(id, "weapon_knife")
				give_item(id, "weapon_knife")
				give_item(id, "weapon_hegrenade")
				anamenu(id)
				renkli_yazi(id,"!n[!t%s!n] !gMarketten !n[!tTestere + BOMBA!n] !gsatin aldin",TAG)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
			}
			else
			{
				anamenu(id)
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener4)
			}
		}
		case 3:
		{
        	if (reklamCheck[id] == false) {
            	renkli_yazi(0,"!n[ !tShieldsClan !n] !n[ !tF1 !n] !g Tusuna Basarak Yada !n[ !t/ts3 !n] !gYazarak Ailemize Katilabilirsin.")
            	renkli_yazi(0,"!n[ !tShieldsClan !n] !tSlotluk !nVeya !tKomutculuk !nAlarak Avantajlardan Faydalanabilirsiniz.")
            	renkli_yazi(id,"!n[ !tShieldsClan !n] !gReklam Attigin Icin !t2 TL !gKazandin.")
            	jb_set_user_packs(id, jb_get_user_packs(id) + 2)
        	}else {
            	renkli_yazi(0,"!n[ !tShieldsClan !n] !nHer El Sadece !t1 !nDefa Reklam Atabilirsin")
        	}
		}
		case 4: 
		{
			kizilay_menu(id)
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}

public client_PreThink(id)
{
	if(!is_user_alive(id)) return PLUGIN_CONTINUE
	new nbut = get_user_button(id)
	new obut = get_user_oldbutton(id)
	if((nbut & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(obut & IN_JUMP) && g_zipla[id])
	{
		if(jumpnum[id] < get_pcvar_num(kacziplasin))
		{
			dojump[id] = true
			jumpnum[id]++
			return PLUGIN_CONTINUE
		}
	}
	if((nbut & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND))
	{
		jumpnum[id] = 0
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
}
public elbasi()
{
	round_sonu = false
	new players[32],inum,id
	get_players(players,inum)
	for(new i;i<inum;i++)
	{
		remove_task(1337)
		set_task(1.0,"kapa")
		id = players[i]
		select_meslek[id] = true
		g_slot[id] = true
		reklamAtti[id] = false
		kahramanGirdi[id] = false
		g_bonus[id] += 1
		g_cek[id] += 1
		g_vip[id] = true
		g_elit[id] = true
		g_kanverdim[id] = true
		check[id] = false
		check2[id] = false
		check3[id] = false
		check4[id] = false
		check5[id] = false
		g_reklam[id] = true
		g_bomberman[id] = true
		g_gardiyan[id] = true
		reklamAtti[id] = false
	}
}

public client_PostThink(id)
{
	if(!is_user_alive(id)) return PLUGIN_CONTINUE
	if(dojump[id] == true)
	{
		new Float:velocity[3]	
		entity_get_vector(id,EV_VEC_velocity,velocity)
		velocity[2] = random_float(265.0,285.0)
		entity_set_vector(id,EV_VEC_velocity,velocity)
		dojump[id] = false
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
	
}	
/*============================================================
ITEM'S MENU
============================================================*/
public JailbreakPacks(id)
{

	set_hudmessage(124, 252, 0, 5.0, 0.75, 0, 1.0, 1.0)
	ShowSyncHudMsg(id, syncObj,"Cebinizdeki TL : [%i] | ", g_jbpacks[id])

}
public Tienda(id)
{
	if(get_pcvar_num(OnOff))
	{
		if(get_pcvar_num(OnOff) && Ronda[id])
		{
			if(is_user_alive(id))
			{
				if (cs_get_user_team(id) == CS_TEAM_T )
				{
					new contador=0;
					new players[32], num, tempid;
					
					get_players(players, num)
					
					for (new i=0; i<num; i++)
					{
						tempid = players[i]
						
						if (get_user_team(tempid)==1 && is_user_alive(tempid))
						{
							contador++;
						}
					}
					if (contador == 1 )
					{
						renkli_yazi(id,"!n[!t%s!n] !gSon Mahkum Bu Menuden yararlanamaz",TAG)
					}
					else if ( contador >= 2 )
					{
						static Item[64]
						
						formatex(Item, charsmax(Item),"\d< \rShieldsClan \d> \y~ \wCephane Menu")
						new Menu = menu_create(Item, "TiendaHandler")
						
						formatex(Item, charsmax(Item),"\wFlash Bombasi \r[%d TL]", get_pcvar_num(precio1))
						menu_additem(Menu, Item, "1")
						
						formatex(Item, charsmax(Item),"\wEl Bombasi \r[%d TL]", get_pcvar_num(precio2))
						menu_additem(Menu, Item, "2")
						
						formatex(Item, charsmax(Item),"\wHizli Yurume \r[%d TL]", get_pcvar_num(precio5))
						menu_additem(Menu, Item, "5")
						
						formatex(Item, charsmax(Item),"\wYuksek Atlama \r[%d TL] \d(Yuksekten Dusunce Can Gitmez)", get_pcvar_num(precio6))
						menu_additem(Menu, Item, "6")
						
						formatex(Item, charsmax(Item),"\wSinirsiz Mermi \r[%d TL]", get_pcvar_num(precio7))
						menu_additem(Menu, Item, "7")

						formatex(Item, charsmax(Item),"\w20 Mermili Glock \r[%d TL]", get_pcvar_num(g_glock))
						menu_additem(Menu, Item, "8")
						
						menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
						menu_display(id, Menu)
					}
				}
				
			}
			
		}
		
	}
	
	return PLUGIN_HANDLED
}
public client_connect(id)
{
	select_meslek[id] = true
	meslek[id] = 0
	jumpnum[id] = 0
	gorev1[id] = 0
	gorev2[id] = 0
	gorev3[id] = 0
	gorev4[id] = 0
	gorev5[id] = 0
	gorev6[id] = 0
	gardiyan_oldur[id] = 0
	jb_harca[id] = 0
	mahkum_oldur[id] = 
	g_bomberman[id] = true
	esya_al[id] = 0
	g_survive[id ] = 0
	dojump[id] = false
	g_zipla[id] = false
	g_slot[id] = true
	g_vip[id] = true
	g_elit[id] = true
	g_bonus[id] = 3
	g_cek[id] = 3
	remove_task(id+600)
}

public client_disconnected(id)
{
	select_meslek[id] = true
	meslek[id] = 0
	jumpnum[id] = 0
	gorev1[id] = 0
	gorev2[id] = 0
	gorev3[id] = 0
	gorev4[id] = 0
	gorev5[id] = 0
	gorev6[id] = 0
	gardiyan_oldur[id] = 0
	jb_harca[id] = 0
	mahkum_oldur[id] = 0
	esya_al[id] = 0
	g_survive[id ] = 0
	dojump[id] = false
	g_zipla[id] = false
	g_slot[id] = true
	g_bomberman[id] = true
	g_vip[id] = true
	g_elit[id] = true
	g_bonus[id] = 3
	g_cek[id] = 3
	remove_task(id+600)
}
public OnCBasePlayer_TakeDamage( id, iInflictor, iAttacker, Float:flDamage, bitsDamageType )
{
	if( bitsDamageType & DMG_FALL && g_yuksek[id])
	{
		return HAM_SUPERCEDE
	}
	if(meslek[id] == 1)
	{
		SetHamParamFloat(4, flDamage * 0.8)
	}
	if(hasar_azalt[id])
	{
		SetHamParamFloat(4, flDamage * 0.7)
	}
	
	return HAM_IGNORED
}

public olunce()
{
	new olduren = read_data(1)
	new olen = read_data(2)
	
	
	
	if(olduren == olen)
	{
		return PLUGIN_HANDLED
	}
	if(get_user_team(olduren) == 1 && get_user_team(olen) == 1)
		mahkum_oldur[olduren] += 1
	if(get_user_team(olduren) == 1 && get_user_team(olen) == 2)
		gardiyan_oldur[olduren] += 1
	if(meslek[olen] == 5)
	{
		set_task(2.0,"rev_sansi",olen+413)
	}
	
	return PLUGIN_CONTINUE;
	
}
public Ham_CBasePlayer_Killed_Post(id)
{
	new iPlayers[32],iNum;
	get_players(iPlayers,iNum,"aeh","TERRORIST");
	
	if((iNum == 1) && (id != iNum))
	{
		g_unammo[id] = false
	}
}
public rev_sansi(taskid)
{
	new id = taskid - 413
	if(!is_user_alive(id))
	{
		switch(random_num(1,3))
		{
			case 1 :
			{
				renkli_yazi(id,"!n[!t%s!n] !gTekrar Dogamadin",TAG)
			}
			case 2 :
			{
				ExecuteHamB(Ham_CS_RoundRespawn,id)
				renkli_yazi(id,"!n[!t%s!n] !gRevlendin",TAG)
			}
			case 3 :
			{
				renkli_yazi(id,"!n[!t%s!n] !gTekrar Dogamadin",TAG)
			}
		}
	}
}				
public TiendaHandler(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], iName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	new vivo 		= is_user_alive(id)
	new Obtener1 		= get_pcvar_num(precio1)
	new Obtener2 		= get_pcvar_num(precio2)
	new Obtener5 		= get_pcvar_num(precio5)
	new Obtener6 		= get_pcvar_num(precio6)
	new Obtener7		= get_pcvar_num(precio7)
	new esya7                 =  get_pcvar_num(g_glock)
	
	
	new key = str_to_num(data);
	switch(key)
	{
		case 1:
		{
			if (g_jbpacks[id] >= Obtener1 && vivo)
			{
				g_jbpacks[id] -= Obtener1
				jb_harca[id] += Obtener1
				esya_al[id] += 1
				renkli_yazi(id,"!n[!t%s!n] !gCephane Menuden !n[!gFlash Bombasi!n] !gsatin aldin",TAG)
				give_item(id, "weapon_flashbang")
				give_item(id, "weapon_flashbang")
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				Ronda[id] = 0
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener1) 
			}
		}
		case 2:
		{
			
			if (g_jbpacks[id] >= Obtener2 && vivo)
			{
				g_jbpacks[id] -= Obtener2
				jb_harca[id] += Obtener2
				esya_al[id] += 1
				renkli_yazi(id,"!n[!t%s!n] !gCephane Menuden !n[!gEl Bombasi!n] !gsatin aldin",TAG)
				give_item(id, "weapon_hegrenade")
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				Ronda[id] = 0
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener2)
			}
		}
		case 5:
		{		
			if (g_jbpacks[id] >= Obtener5 && vivo)
			{
				g_jbpacks[id] -= Obtener5
				jb_harca[id] += Obtener5
				esya_al[id] += 1
				set_user_maxspeed(id, 500.0)
				Speed[id] = 1
				renkli_yazi(id,"!n[!t%s!n] !gCephane Menuden !n[!gHizli Yurume!n] !gsatin aldin",TAG)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				Ronda[id] = 0
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener5)  
			}
		}
		case 6:
		{	
			if (g_jbpacks[id] >= Obtener6 && vivo)
			{
				g_jbpacks[id] -= Obtener6
				jb_harca[id] += Obtener6
				esya_al[id] += 1
				renkli_yazi(id,"!n[!t%s!n] !gCephane Menuden !n[!gYuksek Atlama!n] !gsatin aldin",TAG)
				g_yuksek[id] = true
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				Ronda[id] = 0
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener6) 
			}
		}
		case 7:
		{
			if (g_jbpacks[id] >= Obtener7 && vivo)
			{
				g_jbpacks[id] -= Obtener7
				jb_harca[id] += Obtener7
				g_unammo[id] = true
				esya_al[id] += 1
				renkli_yazi(id,"!n[!t%s!n] !gCephane Menuden !n[!gSinirsiz Mermi!n] !gsatin aldin",TAG)
				emit_sound(id, CHAN_AUTO, Si, VOL_NORM, ATTN_NORM , 0, PITCH_NORM) 
				Ronda[id] = 0
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener7)
			}
		}
		case 8:
		{
			if(g_jbpacks[id] >= esya7 && vivo)
			{
				g_jbpacks[id] -= esya7
				jb_harca[id] += esya7
				esya_al[id] += 1
				give_item(id,"weapon_glock18")
				renkli_yazi(id,"!n[!t%s!n] !gT Shopdan !n[!t20 Mermili Glock!n] !gsatin aldin",TAG)
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.Gereken  !n[!t%d!n] !gTL",TAG,Obtener7)
			}
		}
		case 9 :
		{
			dolar_menu(id)
		}
	}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
public sans1(id)
{
	switch(random_num(1,2))
	{
		case 1 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 2 :
		{
			renkli_yazi(0,"!n[!t%s!n] !gMahkumlardan birine Sansli Kutudan !tAWP !gcikti.",TAG)
			renkli_yazi(id,"!n[!t%s!n] !gSansli Kutudan !tAWP !ncikti.",TAG)
			give_item(id,"weapon_awp") 
		}
	}
	
}
public sans2(id)
{
	switch(random_num(1,4))
	{
		case 1 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 2 :
		{
			renkli_yazi(0,"!n[!t%s] !gMahkumlardan birine Sansli Kutudan !tAWP !gcikti.",TAG)
			renkli_yazi(id,"!n[!t%s] !gSansli Kutudan !tAWP !ncikti.",TAG)
			give_item(id,"weapon_awp") 
		}
		case 3 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 4:
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
	}
}
public sans3(id)
{
	switch(random_num(1,8))
	{
		case 1 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 2 :
		{
			renkli_yazi(0,"!n[!t%s] !gMahkumlardan birine Sansli Kutudan !tAWP !gcikti.",TAG)
			renkli_yazi(id,"!n[!t%s] !gSansli Kutudan !tAWP !ncikti.",TAG)
			give_item(id,"weapon_awp")
		}
		case 3 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 4 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 5 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 6 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 7 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)
		}
		case 8 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gMalesef Kutudan bir sey kazanamadiniz.",TAG)	
		}				
	}
}
public sans_menu(id)
{
	if(get_user_team(id) == 1 && is_user_alive(id))
	{
		new Menu = menu_create("\d< \rShieldsClan \d> \y~ \wSans Menuleri ","sans_handler")
		menu_additem(Menu,"\wAwp Sansi \d(\r1\w/\y2\d) \w[\r60 TL\w]","1")
		menu_additem(Menu,"\wAwp Sansi \d(\r1\w/\y4\d) \w[\r40 TL\w]","2")
		menu_additem(Menu,"\wAwp Sansi \d(\r1\w/\y8\d) \w[\r30 TL\w]","3")
		menu_additem(Menu,"\wKutu Ac   \d(\wCLASSIC\d) \w[\r20 TL\w]","4")
		
		menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED
}

public sans_handler(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1 :
		{
			if(g_jbpacks[id] >= 60 && is_user_alive(id))
			{
				g_jbpacks[id] -= 60
				jb_harca[id] += 60
				esya_al[id] += 1
				set_task(2.0,"sans1",id)
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			} 
		}
		case 2:
		{
			if(g_jbpacks[id] >= 40 && is_user_alive(id))
			{
				g_jbpacks[id] -= 40
				jb_harca[id] += 40
				esya_al[id] += 1
				set_task(2.0,"sans2",id)
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			} 
		}
		case 3:
		{
			if(g_jbpacks[id] >= 30 && is_user_alive(id))
			{
				g_jbpacks[id] -= 30
				jb_harca[id] += 30
				esya_al[id] += 1
				set_task(2.0,"sans3",id)
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			} 	
		}
		case 4:
		{
			if(g_jbpacks[id] >= 20 && is_user_alive(id))
			{
				g_jbpacks[id] -= 20
				jb_harca[id] += 20	
				esya_al[id] += 1
				set_task(2.0,"kutu",id)
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			}
		}
		
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public kutu(id)
{
	new name[32]
	get_user_name(id,name,31)
	switch(random_num(1,6))
	{
		case 1 :
		{
			renkli_yazi(0,"!n[!t%s!n] !n[!g%s!n] !tadli mahkumun kutusundan iflas cikti.!nCenabet A:FS:AFSF:AS",TAG,name)
			g_jbpacks[id] = 0
		}
		case 2 :
		{
			renkli_yazi(id,"!n[!t%s!n] !gKutundan 10 TL ve +50 HP cikti.",TAG)
			g_jbpacks[id] += 10
			set_user_health(id,get_user_health(id) + 50)
		}
		case 3 :
		{
			renkli_yazi(0,"!n[!t%s!n] !n[!g%s!n] !tadli mahkumun kutusundan infaz cikti.!nCunup AS:DSA:D:SAD",TAG,name)
			user_kill(id,1)
		}
		case 4 :
		{
			renkli_yazi(0,"!n[!t%s!n] !gMahkumlardan birine 7 mermili deagle cikti",TAG)
			renkli_yazi(id,"!n[!t%s!n] !gKutudan 7 mermili deagle cikti.",TAG)
			give_item(id,"weapon_deagle")
		}
		case 5 :
		{
			g_jbpacks[id] += 15
			give_item(id,"weapon_hegrenade")
			give_item(id,"weapon_flashbang")
			give_item(id,"weapon_smokegrenade")
			renkli_yazi(id,"!n[!t%s!n] !gKutudan +15 TL ve Bomba paketi cikti.",TAG)
		}
		case 6 :
		{
			g_jbpacks[id] += 1
			renkli_yazi(id,"!n[!t%s!n] !gKutudan +1 TL cikti.Cok bile verdim.",TAG)
		}
		
	}
}
public logevent_round_end()
{
	round_sonu = true
	client_cmd(0,"stopsound")
	set_task(0.1,"round_sound")
	new players[32],inum,id
	get_players(players,inum)
	for(new i;i<inum;i++)
	{
		id = players[i]
		if(is_user_alive(id) && get_user_team(id) == 1)
		{
			set_task(0.5,"renk",1337,"",0,"b")
			CTCuchillo[id] 	= 0
			TCuchillo[id] 	= 0
			g_round[id] = 1
			strip_user_weapons(id)
			give_item(id,"weapon_knife")
			g_survive[id] += 1
			
		}
	}
}

public renk() 
{
	new players[ 32 ], pnum;
	get_players( players, pnum, "ae", "TERRORIST" );
	
	for( new i; i < pnum; i++ )
	{
		new lastmans = players[ i ];	         new num1 = random_num(0,255) ; new num2 = random_num(0,255);
		new num3 = random_num(0,255)
		new alpha = random_num(70,200)
		message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},lastmans)
		write_short(~0)
		write_short(~0)
		write_short(1<<12)
		write_byte(num1)
		write_byte(num2)
		write_byte(num3)
		write_byte(alpha)
		message_end()
		set_user_rendering(lastmans,kRenderFxGlowShell,num1,num2,num3,kRenderTransAlpha,255)	
	}
}
public kapa()
{
	new players[32], num
	get_players(players,num,"h")
	for(new i=0;i<num;i++)
	{
		message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},players[i])
		write_short(~0)
		write_short(~0)
		write_short(1<<12)
		write_byte(0)
		write_byte(0)
		write_byte(0)
		write_byte(0)
		message_end()
		set_user_rendering(players[i])
	}	
}

	public round_sound()
	{
		if(round_sonu)
		{
			switch(random_num(1,3))
			{
				case 1 :
				{
					emit_sound(0, CHAN_AUTO,el_sonu, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
					round_sonu = false	
				}
				case 2 :
				{
					emit_sound(0, CHAN_AUTO,el_sonu3, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
					round_sonu = false
				}
				case 3 :
				{
					emit_sound(0, CHAN_AUTO,el_sonu2, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
					round_sonu = false
				}	
			}
		}
	}			

public client_putinserver(id) {
	g_jbpacks[id] = get_pcvar_num(g_startjp) 
	set_task(1.0, "JailbreakPacks", id, _, _, "b")
	jumpnum[id] = 0
	dojump[id] = false
	g_zipla[id] = false
}

public kontrol(id)
{
	if(get_user_team(id) == 2)
	{
		duel_menu(id)
	}
	else if(is_user_admin(id))
	{
		duel_menu(id)
	}
	return PLUGIN_HANDLED
}
public duel_menu(id)
{		
	if(get_user_team(id) == 1)
{
renkli_yazi(id,"!t[!t%s] !gBu Komutu Sadece !n[!tCT!n]' !gler Kullanabilir.",TAG)
return PLUGIN_HANDLED;

	}
	static opcion[64]
	
	formatex(opcion, charsmax(opcion),"\d- \rShieldsClan \d- \y| \wTL Ver")
	new iMenu = menu_create(opcion, "menu")
	
	formatex(opcion, charsmax(opcion),"\d- \rSG \d- \y| \wTL Ver")
	menu_additem(iMenu, opcion, "1")	
	
	formatex(opcion, charsmax(opcion),"\d- \rSG \d- \y| \rTL AL")
	menu_additem(iMenu, opcion, "2")	
	
	formatex(opcion, charsmax(opcion),"\d- \rSG \d- \y| \rToplu TL Ver")
	menu_additem(iMenu, opcion, "3")
	
	menu_setprop(iMenu, MPROP_EXIT, MEXIT_ALL)
	menu_display(id, iMenu, 0)
	
	return PLUGIN_HANDLED
}

public menu(id, menu, item)
{
	
	if (item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new Data[6], Name[64]
	new Access, Callback
	
	menu_item_getinfo(menu, item, Access, Data,5, Name, 63, Callback)
	
	new Key = str_to_num(Data)
	
	switch (Key)
	{
		case 1:
		{	
			regalar[id] = 1
			quitar[id] = 0	
			escojer(id)
		}
		case 2: 
		{	
			quitar[id] = 1
			regalar[id] = 0
			escojer(id)
		}
		case 3: 
		{	
			quitar[id] = 1
			regalar[id] = 1
			client_cmd(id, "messagemode JbPacks")
		}
	}
	
	menu_destroy(menu)	
	return PLUGIN_HANDLED
}


public escojer(id)
{
	static opcion[64]
	
	formatex(opcion, charsmax(opcion),"\rOyuncu Secin", LANG_PLAYER, "CHOOSE")
	new iMenu = menu_create(opcion, "choose")
	
	new players[32], pnum, tempid
	new szName[32], szTempid[10]
	
	get_players(players, pnum, "a")
	
	for( new i; i<pnum; i++ )
	{
		tempid = players[i]
		
		get_user_name(tempid, szName, 31)
		num_to_str(tempid, szTempid, 9)
		
		formatex(opcion, charsmax(opcion), "\w%s \r[%d \yTL\r]", szName, g_jbpacks[tempid])
		menu_additem(iMenu, opcion, szTempid, 0)
	}
	
	menu_display(id, iMenu)
	return PLUGIN_HANDLED
}

public choose(id, menu, item)
{
	if( item == MENU_EXIT )
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new Data[6], Name[64]
	new Access, Callback
	menu_item_getinfo(menu, item, Access, Data,5, Name, 63, Callback)
	
	new tempid = str_to_num(Data)
	
	gidPlayer[id] = tempid
	client_cmd(id, "messagemode JbPacks")
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

public player(id)
{
	new say[300]
	read_args(say, charsmax(say))
	
	remove_quotes(say)
	
	if(!is_str_num(say) || equal(say, ""))
		return PLUGIN_HANDLED
	
	jbpacks(id, say)    
	
	return PLUGIN_CONTINUE
}

jbpacks(id, say[]) {
	new amount = str_to_num(say)
	if(amount == 0){
		amount = 1;
	}
	new adminname[32]
	
	
	if(quitar[id] && regalar[id]){
		get_user_name(id, adminname, 31)
		if(amount > get_pcvar_num(g_maxjp))
		{
			
			renkli_yazi(0,"!n[!t%s!n] !g%s adli admin !n[!t%d TL!n]' !gden fazla vermeye calisti.",TAG,adminname,get_pcvar_num(g_maxjp))
		}
		else
		{
			new players[32], pnum, tempid
			get_players(players,pnum,"ae","TERRORIST");
			for( new i; i<pnum; i++ ){
				tempid = players[i]			
				g_jbpacks[tempid] = g_jbpacks[tempid] + amount
			}	
			renkli_yazi(0,"!n[!t%s!n] !g%s adli admin !n[!tMahkum!n] !gtakimina !n[!t%d TL!n] !gverdi.",TAG,adminname,amount)
		}		
	}
	else{
		new vname[32]
		new victim = gidPlayer[id]
		if(victim > 0)
		{
			get_user_name(victim, vname, 31)
			get_user_name(id, adminname, 31)
			
			if(regalar[id])
			{
				if(amount > get_pcvar_num(g_maxjp))
				{
					renkli_yazi(0,"!n[!t%s!n] !g%s adli admin !n[!t%d TL!n]' !gden fazla vermeye calisti.",TAG,adminname,get_pcvar_num(g_maxjp))
				}
				else
				{
					g_jbpacks[victim] = g_jbpacks[victim] + amount
					renkli_yazi(0,"!n[!t%s!n] !g%s adli admin !n[!t%s!n] !gadli mahkuma !n[!t%d TL!n] !gverdi.",TAG,adminname,vname,amount)
				}
			}
			if(quitar[id])
			{
				if(amount > g_jbpacks[victim])
				{
					g_jbpacks[victim] = 0
					renkli_yazi(0,"!n[!t%s!n] !g%s adli admin !n[!t%s!n] !gadli mahkumun tum TL' !gsini aldi",TAG,adminname,vname)
				}
				else 
				{
					g_jbpacks[victim] = g_jbpacks[victim] - amount
					renkli_yazi(0,"!n[!t%s!n] !g%s adli admin !n[!t%s!n] !gadli mahkumdan !n[!t%d TL!n] !galdi.",TAG,adminname,vname,amount)
				}
				
			}		
		}
	}
	return PLUGIN_HANDLED
}


public Fwd_PlayerSpawn_Post(id)
{
	if(get_pcvar_num(isyanteam) && get_user_team(id) == 2)
	{
		set_user_health(id, 250)
	}
	if (is_user_alive(id))
	{
		if(get_user_team(id) == 1) strip_user_weapons(id); give_item(id, "weapon_knife")
		
		set_user_footsteps(id, 0)
		set_user_maxspeed(id,250.0)
		Speed[id] 	= 0
		Speed2[id] 	= 0
		Ronda[id] 	= 1
		CTCuchillo[id] 	= 1
		TCuchillo[id] 	= 1
		Destapador[id] 	= 0
		Hacha[id] 	= 0
		Machete[id] 	= 0
		Motocierra[id] 	= 0
		engel[id]        = 0
		jumpnum[id]      = 0
		g_round[id] = 0
		dojump[id]       = false
		g_unammo[id]    = false
		g_hasar[id]     = false
		g_zipla[id]     = false
		g_yuksek[id]    = false
		g_market[id] = true
		g_bombaa[id] = true
		Tienda1(id)
	}
	if(get_user_team(id) == 2)
	{
		CTCuchillo[id] 	= 1
		g_unammo[id]    = false
		give_item(id,"weapon_ak47")
		give_item(id,"weapon_m4a1")
		give_item(id,"weapon_awp")
		give_item(id,"weapon_deagle")
		cs_set_user_bpammo(id,CSW_AK47,90)
		cs_set_user_bpammo(id,CSW_M4A1,90)
		cs_set_user_bpammo(id,CSW_DEAGLE,35)
		cs_set_user_bpammo(id,CSW_AWP,20)
		if(g_frozen[id])
		{
			ctcoz(id)
		}
	}
	if(meslek[id] == 2)
	{
		set_user_gravity(id,0.65)
	}
	
}
public FwdTakeDamage(victim, inflictor, attacker, Float:damage, damage_bits)
{
	if(!is_valid_player(attacker) || !is_valid_player(victim)) return HAM_IGNORED
	
	if (is_valid_player(attacker) && get_user_weapon(attacker) == CSW_KNIFE)	
	{
		switch(get_user_team(attacker))
		{
			case 1:
			{
				if(TCuchillo[attacker])
				{    
					
					SetHamParamFloat(4, get_pcvar_float(TDefaultDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hTDefaultDano))
					}
				}
				
				if(Destapador[attacker])
				{ 
					SetHamParamFloat(4, get_pcvar_float(PaloDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hPaloDano))
					}
				}
				
				if(Hacha[attacker])
				{    	
					SetHamParamFloat(4, get_pcvar_float(HachaDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hHachaDano))
					}
				}
				
				if(Machete[attacker])
				{    	
					SetHamParamFloat(4, get_pcvar_float(MacheteDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hMacheteDano))
					}
				}
				
				if(Motocierra[attacker])
				{    
					SetHamParamFloat(4, get_pcvar_float(MotocierraDano))
				}
			}
			case 2:
			{
				if(CTCuchillo[attacker])
				{    
					SetHamParamFloat(4, get_pcvar_float(CTDefaultDano))
					
					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hCTDefaultDano))
					}
				}
			}
		}
	}
	if((damage_bits & DMG_FALL) && g_yuksek[victim])
	{
		return HAM_SUPERCEDE
	}
	if(is_valid_player(attacker) && g_hasar[attacker])
	{
		damage *= get_pcvar_float(hasar_miktar)
		SetHamParamFloat(4,damage)
	}
	
	return HAM_HANDLED
}  

public fw_player_killed(victim, attacker, shouldgib)
{
	if(get_user_team(attacker) == 1)
	{
		g_jbpacks[attacker] += get_pcvar_num(g_killjp) 
		
		if(get_pdata_int(victim, 75) == HIT_HEAD)
		{
			g_jbpacks[attacker] += get_pcvar_num(g_killhsjp)
		}
	}
	
}
	public native_jb_get_user_packs(id)
	{
		return g_jbpacks[id];
	}

	public native_jb_set_user_packs(id, ammount)
	{
		new id = get_param(1);
		new ammount = get_param(2);
		g_jbpacks[id] = ammount
		return 1;
	}

public Event_Change_Weapon(id)
{
	new weaponID = read_data(2) 
	
	switch (get_user_team(id))
	{
		case 1:
		{
			if(Speed[id])
			{
				set_user_maxspeed(id, 500.0)
			}
			
			if(Speed2[id])
			{
				set_user_maxspeed(id, 380.0)
				
			}
			
			if(weaponID == CSW_KNIFE)
				
		{
			if(TCuchillo[id])
			{
				set_pev(id, pev_viewmodel2, VIEW_MODELT)
				set_pev(id, pev_weaponmodel2, PLAYER_MODELT)
			}
			
			if(Destapador[id])
			{
				set_pev(id, pev_viewmodel2, VIEW_Palo)
				set_pev(id, pev_weaponmodel2, PLAYER_Palo)
			}
			
			if(Hacha[id])
			{
				set_pev(id, pev_viewmodel2, VIEW_Hacha)
				set_pev(id, pev_weaponmodel2, PLAYER_Hacha)
			}
			
			if(Machete[id])
			{
				set_pev(id, pev_viewmodel2, VIEW_Machete)
				set_pev(id, pev_weaponmodel2, PLAYER_Machete)
			}
			
			if(Motocierra[id])
			{
				set_pev(id, pev_viewmodel2, VIEW_Moto)
				set_pev(id, pev_weaponmodel2, PLAYER_Moto)
			}
			
			
		}
	}
	case 2:
	{
		if(CTCuchillo[id] && weaponID == CSW_KNIFE)
		{
			set_pev(id, pev_viewmodel2, VIEW_MODELCT)
			set_pev(id, pev_weaponmodel2, PLAYER_MODELCT)
		}
	}
	}
	if(meslek[id] == 2)
	{
		set_user_gravity(id,0.7)
	}

	if(g_frozen[id])
	{
		engclient_cmd(id,"weapon_knife")
	}
	if(g_unammo[id]){
		new iWeapon = read_data(2)
		if( !( NOCLIP_WPN_BS & (1<<iWeapon) ) )
		{
			fm_cs_set_weapon_ammo( get_pdata_cbase(id, m_pActiveItem) , g_MaxClipAmmo[ iWeapon ] )
		}
	}
	return PLUGIN_CONTINUE 
}

public fw_SetModel(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	if(!equali(model, OLDWORLD_MODEL)) 
		return FMRES_IGNORED
	new className[33]
	pev(entity, pev_classname, className, 32)
	if(equal(className, "weaponbox") || equal(className, "armoury_entity") || equal(className, "grenade"))
	{
		engfunc(EngFunc_SetModel, entity, WORLD_MODEL)
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED
}

public Fwd_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{
	
	if (!is_user_connected(id))
		return FMRES_IGNORED;
	
	if(CTCuchillo[id])
	{
		if(get_user_team(id) == 2)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3)) 
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, ct_slash1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, ct_slash2, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w')
					{
						engfunc(EngFunc_EmitSound, id, channel, ct_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else 
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, ct_hit1, volume, attn, flags, pitch)
								case 2: engfunc(EngFunc_EmitSound, id, channel, ct_hit2, volume, attn, flags, pitch)
								case 3: engfunc(EngFunc_EmitSound, id, channel, ct_hit3, volume, attn, flags, pitch)
								case 4: engfunc(EngFunc_EmitSound, id, channel, ct_hit4, volume, attn, flags, pitch)
							}
						
						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3)) 
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}	
	}
	
	if(TCuchillo[id])
	{
		if(get_user_team(id) == 1)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3)) 
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, t_slash1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, t_slash2, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w') 
					{
						engfunc(EngFunc_EmitSound, id, channel, t_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else 
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, t_hit1, volume, attn, flags, pitch)
								case 2: engfunc(EngFunc_EmitSound, id, channel, t_hit2, volume, attn, flags, pitch)
								case 3: engfunc(EngFunc_EmitSound, id, channel, t_hit3, volume, attn, flags, pitch)
								case 4: engfunc(EngFunc_EmitSound, id, channel, t_hit4, volume, attn, flags, pitch)
							}
						
						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	
	if(Destapador[id])
	{
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3)) 
			{
				switch (random_num(1, 2))
				{
					case 1: engfunc(EngFunc_EmitSound, id, channel, palo_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, palo_slash2, volume, attn, flags, pitch)
						
				}
				
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, palo_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w') 
				{
					engfunc(EngFunc_EmitSound, id, channel, palo_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else 
				{
					switch (random_num(1, 4))
					{
						case 1:engfunc(EngFunc_EmitSound, id, channel, palo_hit1, volume, attn, flags, pitch)
							case 2:engfunc(EngFunc_EmitSound, id, channel, palo_hit2, volume, attn, flags, pitch)
							case 3:engfunc(EngFunc_EmitSound, id, channel, palo_hit3, volume, attn, flags, pitch)
							case 4:engfunc(EngFunc_EmitSound, id, channel, palo_hit4, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3))
			{
				engfunc(EngFunc_EmitSound, id, channel, palo_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(Hacha[id])
	{
		
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3))
			{
				switch (random_num(1, 2))
				{
					case 1: engfunc(EngFunc_EmitSound, id, channel, hacha_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, hacha_slash2, volume, attn, flags, pitch)
					}
				
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, hacha_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w')
				{
					engfunc(EngFunc_EmitSound, id, channel, hacha_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else 
				{
					switch (random_num(1, 3))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, hacha_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, hacha_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, hacha_hit3, volume, attn, flags, pitch)
						}
					
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3)) 
			{
				engfunc(EngFunc_EmitSound, id, channel, hacha_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(Machete[id])
	{
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3)) 
			{
				switch (random_num(1, 2))
				{
					case 1: engfunc(EngFunc_EmitSound, id, channel, machete_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, machete_slash2, volume, attn, flags, pitch)
					}
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, machete_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w') 
				{
					engfunc(EngFunc_EmitSound, id, channel, machete_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else // hit
				{
					switch (random_num(1, 4))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, machete_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, machete_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, machete_hit3, volume, attn, flags, pitch)
							case 4: engfunc(EngFunc_EmitSound, id, channel, machete_hit4, volume, attn, flags, pitch)
						}
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3)) 
			{
				engfunc(EngFunc_EmitSound, id, channel, machete_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}
	
	if(Motocierra[id])
	{
		
		if (equal(sample[8], "kni", 3))
		{
			if (equal(sample[14], "sla", 3))
			{
				engfunc(EngFunc_EmitSound, id, channel, motocierra_slash, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if(equal(sample,"weapons/knife_deploy1.wav"))
			{
				engfunc(EngFunc_EmitSound, id, channel, motocierra_deploy, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
			if (equal(sample[14], "hit", 3))
			{
				if (sample[17] == 'w') 
				{
					engfunc(EngFunc_EmitSound, id, channel, motocierra_wall, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				else 
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, motocierra_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, motocierra_hit2, volume, attn, flags, pitch)
							
					}
					return FMRES_SUPERCEDE;
				}
			}
			if (equal(sample[14], "sta", 3)) 
			{
				engfunc(EngFunc_EmitSound, id, channel, motocierra_stab, volume, attn, flags, pitch)
				return FMRES_SUPERCEDE;
			}
		}
	}	
	return FMRES_IGNORED;
}
public anamenu(id)
{
	if(is_user_alive(id))
	{
		if (cs_get_user_team(id) == CS_TEAM_T )
		{
			new contador=0;
			new players[32], num, tempid;
			
			get_players(players, num)
			
			for (new i=0; i<num; i++)
			{
				tempid = players[i]
				
				if (get_user_team(tempid)==1 && is_user_alive(tempid))
				{
					contador++;
				}
			}
			if ( contador == 1 )
			{
				renkli_yazi(id,"!n[!t%s!n] !gSon Mahkum Bu Menuden yararlanamaz",TAG)
			}
			else if ( contador >= 2 )
			{
				
				new menuz;
				static amenu[512];
				
				formatex(amenu,charsmax(amenu),"\d- \rShieldsClan  \d-^n\w95.173.173.106")
				menuz = menu_create(amenu,"anamenu_devam")
				
				if(engel[id] == 0)
				{
					
					formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wEmanetler")
					menu_additem(menuz,amenu,"1")
				}
				else if(!g_market[id])
				{
					formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wEmanetler \d[\rKullandiniz\d]")
					menu_additem(menuz,amenu,"1")
				}
				
				
				formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wShieldsClan Menu")
				menu_additem(menuz,amenu,"2")
				
				formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wMeslek Menu")
				menu_additem(menuz,amenu,"5")
				
				formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wSuper Kahramanlar")
				menu_additem(menuz,amenu,"10")
				
				if (yetkiliMenu[id] == true) {
					formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wYetkili Menu \d[\wUser Dahil\d]")
					menu_additem(menuz,amenu,"7")
				}else {
					formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wYetkili Menu \d[\rKullandiniz\d]")
					menu_additem(menuz,amenu,"7")
				}
				formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wIsyan Team Menu")
				menu_additem(menuz,amenu,"20")
				
				formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y| \wGorev Menu")
				menu_additem(menuz,amenu,"4")
				
				menu_setprop(menuz,MPROP_EXITNAME,"\rCikis")
				menu_setprop(menuz,MPROP_NUMBER_COLOR, "\d~ \r" )
				menu_setprop(menuz,MPROP_EXIT,MEXIT_ALL)
				menu_display(id,menuz,0)
			}
		}	
	}
	return PLUGIN_HANDLED
}
public anamenu_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new key = str_to_num(data)
	
	if(key == 1)
	{
		Tienda1(id)
		//Market
	}
	else if(key == 2)
	{
		envanter(id)
		//Envanter Menu
	}
	else if(key == 3)
	{
		
		client_cmd(id,"say /sapka")
	}
	else if(key == 4)
	{
		gorev_menu(id)
		//Gorev Menu
	}
	else if(key == 5)
	{
		meslek_menu(id)
		//Meslek Menu
	}
	else if(key == 6)
	{
		Tienda1(id)
	}
	else if(key == 20)
	{
		isyan_team_menu(id)
		//�syanteam Menu
	}
	else if(key == 7)
	{
		arac_gerec2(id)
		//Yetkili Menu
	}
	else if(key == 10)
	{
		if (kahramanGirdi[id] == false) {		
			super_kahraman(id)
		}else {
			renkli_yazi(id,"!n[!t%s!n] !gHer el 1 kere girebilirsin.",TAG)
		}
		//Kisisel Ayar Menu
	}
	else if(key == 11)
	{
		client_cmd(id,"say /ts3")
		
	}
	else if(key == 12)
	{
		client_cmd(id,"say /sapka")
		
	}
	else if(key == 23)
	{
		client_cmd(id,"say /ts3")
		
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public ayarla(id)
{
	if(get_user_team(id) == 1)
	{
		new Menu = menu_create("\d< \rShieldsClan \d> \y~ \wBilgi \r& \wDetay Menu","ayarcek")
		
		menu_additem(Menu,"\wFPS Ayarlari Uygula","1")
		menu_additem(Menu,"\wMapin Adini Ogren","2")
		menu_additem(Menu,"\wKill Cek","3")
		menu_additem(Menu,"\wSkorunu Sifirla","4")
		
		menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
		menu_display(id, Menu, 0);
	}
	return PLUGIN_HANDLED
}
public ayarcek(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],aname[32]
	
	menu_item_getinfo(menu,item,access,data,5,aname,31,callback)
	new name [32]
	get_user_name(id,name,31)
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1 :
		{
			fps(id)
		}
		case 2 :
		{
			console_cmd(id,"say currentmap")
		}
		case 3 :
		{
			user_kill(id)
		}
		case 4 :
		{
			reset(id)
		}
		case 5:
		{
			if(g_reklam[id])
			{
				g_jbpacks[id] += 3
				g_reklam[id] = false	
				renkli_yazi(id,"!t%s !n: !gYetkili Slotluk Ve Komutculuk icin say'a !t[/ts3] !nYaziniz.",name)
				anamenu(id)
			}
			
		}	
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public fps(id)
{
	console_cmd(id,"fps_max 9999")
	console_cmd(id,"fps_modem 9999")
	console_cmd(id,"cl_cmdrate 151")
	console_cmd(id,"cl_showfps 1")
	console_cmd(id,"rate 25000")
	console_cmd(id,"cl_updaterate 151")
}

public arac_gerec2(id)
{
	new Menu = menu_create("\d< \rShieldsClan \d> \y~ \wYetkili Menu","arac_devam2")
	
	menu_additem(Menu,"\d[ \rSlot\d ] \wMenu","3")
	menu_additem(Menu,"\d[ \rAdmin\d ] \wMenu","4")
	menu_additem(Menu,"\d[ \rYonetici\d ] \wMenu","5")
	
	menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, Menu, 0);
	
	return PLUGIN_HANDLED
}
public arac_devam2(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 3 :
		{
			if(get_user_flags(id) & ADMIN_RESERVATION)
			{
				slot_menu(id)
				//slot menu
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gSLOT Degilsin.Slotluk icin /ts3 yaziniz",TAG)
			}	
		}
		case 4 :
		{
			if(get_user_flags(id) & ADMIN_CHAT)
			{
				vip_menu(id)
				//Admin menu
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gAdmin Degilsin. Adminlik Fiyat ve Ayrintilari icin /ts3 yaziniz.",TAG)
			}
		}
		case 5 :
		{
			if(get_user_flags(id) & ADMIN_RCON)
			{
				elit_menu(id)
				//Yonetici Menu
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gYonetici Degilsin.. Adminlik Fiyat Ve Ayrintilari icin /ts3 yaziniz.",TAG)
			}	
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public vip_menu(id)
{
	if(g_vip[id])
	{ 
		new menu = menu_create("\d< \rShieldsClan \d> \y~ \wAdmin Menusu", "vipmenu_devam")
		menu_additem(menu, "\wHasar Katlayici \d(\r2x\d)","4")
		menu_additem(menu, "\wSaglik Paketi \y: \d(\r50 HP\d)","1")
		menu_additem(menu, "\wSppedy \y: \d(\r450 Km/h Hiz\d)","3")
		menu_additem(menu, "\wUcan Tom \y: \d(\r500 Gravity\d)","2")
		menu_additem(menu, "\w2x Bomba \y: \d(\rHe+Flashbang\d) ","5")
		menu_additem(menu, "\wYetkili Bahisi \y: \d(\r5 TL\d)","6")
		menu_additem(menu, "\wYetkili Bahisi \y: \d(\r4000$\d)","7")
		
		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
		menu_display(id, menu, 0);
		
	}
	else
	{
		renkli_yazi(id,"!n[!t%s!n] !gVIP MENUSU her elde 1 kere acilabilir.",TAG)
	}
	return PLUGIN_HANDLED
}
public vipmenu_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1:{
			set_user_health(id,get_user_health(id) + 50)
			g_slot[id] = false
			g_elit[id] = false
			g_vip[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gAdmin Menusunden 50 Hp aldiniz",TAG)
		}
		case 2:{
			set_user_gravity(id, 0.5)
			g_vip[id] = false
			g_slot[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gAdmin Menusunden 500 gravity aldiniz",TAG)
			
		}
		case 3:{
			
			set_user_maxspeed(id,450.0)
			g_vip[id] = false
			g_elit[id] = false
			g_slot[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gAdmin Menusunden Hiz Aldiniz ",TAG)
			
			
		}
		case 4:{
			g_hasar[id] = true
			g_vip[id] = false
			g_slot[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gAdmin Menusunden 2x Hasar Aldiniz ",TAG)
			
			
		}
		case 5:{
			give_item(id, "weapon_flashbang")
			give_item(id, "weapon_hegrenade")
			g_slot[id] = false
			g_elit[id] = false
			g_vip[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gAdmin Menusunden !n[!tHe+Flashbang!n] Bombasi Aldiniz ",TAG)
		}
		case 6:{
			g_jbpacks[id] += 5
			g_slot[id] = false
			g_vip[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !nAdmin Menusunden !g5 TL !nAldiniz.",TAG)
		}
		case 7:
		{
			dolar = cs_get_user_money(id);
			cs_set_user_money(id, dolar + 4000);
			g_slot[id] = false
			g_vip[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !nAdmin Menusunden !g4000$ !nAldiniz.",TAG)		
		}
	}
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public elit_menu(id)
{
	if(g_elit[id])
	{ 
		new menu = menu_create("\d< \rShieldsClan \d> \y~ \wYonetici Menusu", "elitmenu_devam");
		
		menu_additem(menu, "\wHasar Katlayici \d(\r4x\d)","4")
		menu_additem(menu, "\wBomba Seti \r: \d(\rHe+Flash+Smoke\d) ","5")
		menu_additem(menu, "\wSaglik Paketi \r: \d(\r100 HP\d)","1")
		menu_additem(menu, "\wSppedy \r: \d(\r550 Km/h Hiz\d)","3")
		menu_additem(menu, "\wUcan Tom \r: \d(\r450 Gravity\d)","2")
		menu_additem(menu, "\wYetkili Bahisi \r: \d(\r10 TL\d)","6")
		menu_additem(menu, "\wYetkili Bahisi \r: \d(\r8000$\d)","7")
		
		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
		menu_display(id, menu, 0);
	}
	else
	{
		renkli_yazi(id,"!n[!t%s!n] !gYonetici Menusu her elde 1 kere acilabilir.",TAG)
	}
	return PLUGIN_HANDLED
}
public elitmenu_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1:{
			set_user_armor(id, 200)
			g_vip[id] = false
			g_slot[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gYonetici Menusunden 100 Hp aldiniz",TAG)
		}
		case 2:{
			set_user_gravity(id, 0.450)
			g_slot[id] = false
			g_vip[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gYonetici Menusunden 450 gravity aldiniz",TAG)
			
		}
		case 3:{
			
			set_user_maxspeed(id,400.0)
			g_vip[id] = false
			g_slot[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gYonetici Menusunden Hiz Aldiniz ",TAG)
			
			
		}
		case 4:{
			g_hasar[id] = true
			g_slot[id] = false
			g_vip[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gYonetici  Menusunden 4x Hasar Aldiniz ",TAG)
			
			
		}
		case 5:{
			g_zipla[id] = true
			g_slot[id] = false 
			g_vip[id] = false 
			g_elit[id] = false 
			give_item(id, "weapon_flashbang")
			give_item(id, "weapon_hegrenade")
			give_item(id, "weapon_smokegrenade")
			renkli_yazi(id,"!n[!t%s!n] !gYonetici Menusunden Bomba Seti Aldiniz ",TAG)
		}
		case 7:{
			dolar = cs_get_user_money(id);
			cs_set_user_money(id, dolar + 8000);
			g_slot[id] = false
			g_vip[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gYonetici Menusunden 4000$ Aldiniz.",TAG)	
		}
		case 6:{
			g_jbpacks[id] += 10
			g_vip[id] = false
			g_slot[id] = false
			g_elit[id] = false
			renkli_yazi(id,"!n[!t%s!n] !gYonetici Menusunden 10 Tl Aldiniz ",TAG)
		}
	}
	
	menu_destroy(menu)
	return PLUGIN_HANDLED	
}	
public transfer_menu(id)
{
	if( !is_user_alive(id) ) return PLUGIN_HANDLED
	new menu = menu_create("\d< \rShieldsClan \d> \y~ \wTL Transfer Menusu", "transfer_case")
	
	menu_additem(menu, "\d[ \r10\d ] \wTL", "1", 0);
	menu_additem(menu, "\d[ \r20\d ] \wTL", "2", 0);
	menu_additem(menu, "\d[ \r30\d ] \wTL", "3", 0);
	menu_additem(menu, "\d[ \r40\d ] \wTL", "4", 0);
	menu_additem(menu, "\d[ \r50\d ] \wTL", "5", 0);
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, menu, 0);
	return PLUGIN_HANDLED
}

public transfer_case(id, menu, item)
{
	if( item == MENU_EXIT )		
	{
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	new data[6], iName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
	new key = str_to_num(data);
	new adminismi[32]
	get_user_name(id,adminismi,31)
	
	switch(key)
		
{
	case 1:
	{
		ananzaaxd[id] = 10;
		OyuncuSec(id)
		
	}
	case 2:
	{
		
		ananzaaxd[id] = 20;
		OyuncuSec(id)
		
	}
	case 3:
	{
		
		ananzaaxd[id] = 30;
		OyuncuSec(id)
		
	}
	case 4:
	{
		ananzaaxd[id] = 40;
		OyuncuSec(id)
		
	}
	case 5:
	{
		ananzaaxd[id] = 50;
		OyuncuSec(id)
		
	}
	
}
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}



public OyuncuSec(id)
{
new ad[32],sznum[6]
new menu = menu_create("\y|\d ShieldsClan \y| \r- \wOyuncu \wSecin","OyuncuHand")
for(new i = 1;i<=get_maxplayers();i++)
	if(is_user_connected(i))
		
{
	num_to_str(i,sznum,5)
	get_user_name(i,ad,31)
	menu_additem(menu,ad,sznum)
	
}
menu_display(id,menu)
return PLUGIN_HANDLED
}
public OyuncuHand(id,menu,item)
{
if(item == MENU_EXIT)
	
{
	menu_destroy(menu)
	return PLUGIN_HANDLED
	
}
new ad[32],callback,access,data[6]
menu_item_getinfo(menu,item,access,data,5,ad,31,callback)
new name[32];
get_user_name(id,name,31)
new tid = str_to_num(data)
get_user_name(tid,ad,31)

if(ananzaaxd[id] == 10)
	
{
	if(jb_get_user_packs(id) >= 10)
	{
		jb_set_user_packs(id, jb_get_user_packs(id) - 10)
		jb_set_user_packs(tid, jb_get_user_packs(tid) + 10)
		
		renkli_yazi(id,"!!n[!t%s!n] !t%s !gKisiye !n[!t 10 !n] !gTL Transfer Ettiniz.",ad)
		renkli_yazi(tid,"!n[!t%s!n] !t%s !gKisi Size !n[!t 10 !n] !gTL Transfer Etti.",name)
		ananzaaxd[id] = 0
		
	}
	else
	{
		
		renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[ !tTL !n] !g' Niz !gBulunmamaktadir.")
		ananzaaxd[id] = 0
		
	}
	
}
if(ananzaaxd[id] ==  20)
	
{
	if(jb_get_user_packs(id) >= 20)
	{
		jb_set_user_packs(id, jb_get_user_packs(id) -  20 )
		jb_set_user_packs(tid, jb_get_user_packs(tid) +  20 )
		renkli_yazi(id,"!n[!t%s!n] !t%s !gKisiye !n[!t 20 !n] !gTLTransfer Ettiniz.",ad)
		renkli_yazi(tid,"!n[!t%s!n] !t%s !gKisi Size !n[!t 20 !n] !gTL Transfer Etti.",name)
		ananzaaxd[id] = 0
		
	}
	else
	{
		
		renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[ !tTL !n] !g' Niz !gBulunmamaktadir.")
		ananzaaxd[id] = 0
		
	}
	
}
///
if(ananzaaxd[id] == 30)
	
{
	if(jb_get_user_packs(id) >= 30)
	{
		jb_set_user_packs(id, jb_get_user_packs(id) - 30)
		jb_set_user_packs(tid, jb_get_user_packs(tid) + 30)
		renkli_yazi(id,"!n[!t%s!n] !t%s !gKisiye !n[!t 30 !n] !gTLTransfer Ettiniz.",ad)
		renkli_yazi(tid,"!n[!t%s!n] !t%s !gKisi Size !n[!t 30 !n] !gTL Transfer Etti.",name)
		ananzaaxd[id] = 0
		
	}
	else
	{
		renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[ !tTL !n] !g' Niz !gBulunmamaktadir.")
		ananzaaxd[id] = 0
		
	}
	
}
if(ananzaaxd[id] == 40 )
	
{
	if(jb_get_user_packs(id) >= 40)
	{
		jb_set_user_packs(id, jb_get_user_packs(id) - 40)
		jb_set_user_packs(tid, jb_get_user_packs(tid) + 40)
		renkli_yazi(id,"!n[!t%s!n] !t%s !gKisiye !n[!t 40 !n] !gTLTransfer Ettiniz.",ad)
		renkli_yazi(tid,"!n[!t%s!n] !t%s !gKisi Size !n[!t 40 !n] !gTL Transfer Etti.",name)
		ananzaaxd[id] = 0
		
	}
	else
	{
		
		renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[ !tTL !n] !g' Niz !gBulunmamaktadir.")
		ananzaaxd[id] = 0
		
	}
	
}
if(ananzaaxd[id] == 50)
	
{
	if(jb_get_user_packs(id) >= 50)
	{
		jb_set_user_packs(id, jb_get_user_packs(id) - 50)
		jb_set_user_packs(tid, jb_get_user_packs(tid) + 50)
		renkli_yazi(id,"!n[!t%s!n] !t%s !gKisiye !n[!t 50 !n] !gTLTransfer Ettiniz.",ad)
		renkli_yazi(tid,"!n[!t%s!n] !t%s !gKisi Size !n[!t 50 !n] !gTL Transfer Etti.",name)
		ananzaaxd[id] = 0
		
		
	}
	else
	{
		
		renkli_yazi(id,"!!n[!t%s!n] !gYeterli !n[ !tTL !n] !g' Niz !gBulunmamaktadir.")
		ananzaaxd[id] = 0
		
		
	}
	
}

return PLUGIN_HANDLED
}
public envanter(id)
{
new menuz;
static amenu[512];
formatex(amenu,charsmax(amenu),"\d< \rShieldsClan \d> \y~ \wShieldsClan Menu")
menuz = menu_create(amenu,"arac_devam")

formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wDolar Menu")
menu_additem(menuz,amenu,"7")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wIsyan Menu")
menu_additem(menuz,amenu,"2")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wSaldir Menu")
menu_additem(menuz,amenu,"6")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wCephane Menu")
menu_additem(menuz,amenu,"1")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wSans Menuleri")
menu_additem(menuz,amenu,"4")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wAyarlar Menusu")
menu_additem(menuz,amenu,"5")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wTL Transfer Menu")
menu_additem(menuz,amenu,"3")

menu_setprop(menuz,MPROP_EXIT,MEXIT_ALL)
menu_display(id,menuz,0)

}
public arac_devam(id,menu,item)
{
if(item == MENU_EXIT)
{
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
new access,callback,data[6],iname[64]

menu_item_getinfo(menu,item,access,data,5,iname,63,callback)

new key = str_to_num(data)

if(key == 1)
{
	Tienda(id)
}
else if(key == 2) 
{
	isyan_menu(id)
}
else if(key == 3) 
{
	transfer_menu(id)
}
else if(key == 4) 
{
	sans_menu(id)	
}
else if(key == 5) 
{
	ayarla(id)
}
else if(key == 6) 
{
	saldir_menu(id)	
}
else if(key == 7) 
{
	dolar_menu(id)
}
else if(key == 12)
{
	client_cmd(id,"say /sapka")
	
}
else if(key == 19)
{
	client_cmd(id,"say /sapka")
	
}
menu_destroy(menu)
return PLUGIN_HANDLED;
}

public kizilay_menu(id)
{
if(!g_kanverdim[id] && !is_user_alive(id)) return PLUGIN_HANDLED;

if( get_user_health( id ) < 100 )
{
	renkli_yazi(id,"!n[!t%s!n] Malesef yeterli !tKaniniz !nyok.",TAG)
	return PLUGIN_HANDLED;
}
else
{
	g_kanverdim[id] = false
	jb_set_user_packs(id,jb_get_user_packs(id) + 2)
	set_user_maxspeed( id, 220.0 );
	set_user_health(id, 1)
	renkli_yazi(id,"!n[!t%s!n] Kizilaya !t99 Hp !nBagislayarak [!g2 TL] !nKazandiniz",TAG)
}
return PLUGIN_HANDLED
}

	public super_kahraman(id)
	{
		if(is_user_alive(id))
		{
			static Item[64]
	
			formatex(Item, charsmax(Item),"\d< \rShieldsClan \d> \y~ \wSuper Kahraman Menu")
			new Menu = menu_create(Item, "super_kahraman_gir")
	
			formatex(Item, charsmax(Item),"\dSpiderman \r[YAKINDA]")
			menu_additem(Menu, Item, "1")
	
			formatex(Item, charsmax(Item),"\dBatman \r[120 TL]")
			menu_additem(Menu, Item, "2")
	
			formatex(Item, charsmax(Item),"\dHulk \r[120 TL]")
			menu_additem(Menu, Item, "3")
			
			formatex(Item, charsmax(Item),"\dIronman \r[120 TL]")
			menu_additem(Menu, Item, "4")

			formatex(Item, charsmax(Item),"\dFlash \r[100 TL]")
			menu_additem(Menu, Item, "5")

			formatex(Item, charsmax(Item),"\dSuperman \r[YAKINDA]")
			menu_additem(Menu, Item, "6")

			menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
			menu_display(id, Menu,0)
		}	
	}

	public super_kahraman_gir(id,menu,item)
	{
		if(item == MENU_EXIT){
			menu_destroy(menu)
			return PLUGIN_HANDLED
		}
		new access,callback,data[6],iname[64]
		menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
		new key = str_to_num(data)

		if (key == 1) {
			renkli_yazi(id,"!n[!t%s!n] !ySuanda boyle bir kahraman !tbulunmuyor.",TAG)
		}else if (key == 2) {
			client_cmd(id, "say /batman")
		}else if (key == 3) {
			client_cmd(id, "say /hulk")
		}else if (key== 4) {
			client_cmd(id, "say /ironman")
		}else if (key==5) {
			client_cmd(id, "say /flash")
		}else if (key==6) {	
			renkli_yazi(id,"!n[!t%s!n] !ySuanda boyle bir kahraman !tbulunmuyor.",TAG)
		}else {
			renkli_yazi(id,"!n[!t%s!n] !ySuanda boyle bir kahraman !tbulunmuyor.",TAG)
		}

		menu_destroy(menu)
		return PLUGIN_HANDLED;	
	}

public dolar_menu(id)
{
new menuz;
dolar = cs_get_user_money(id); 
static amenu[512];
formatex(amenu,charsmax(amenu),"\d< \rShieldsClan \d> \y~ \wDolar Menu^n\dParan : \r%d",dolar)
menuz = menu_create(amenu,"dolar_devam")

formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wSaglik Paketi \d(+20 Health) \r[2000$]  ")
menu_additem(menuz,amenu,"1")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wZirh Paketi \d(+40 Armor) \r[2500$]")
menu_additem(menuz,amenu,"2")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wSis Bombasi \d(SmokeGrenade) \r[3000$]")
menu_additem(menuz,amenu,"3")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wFlash Bombasi \d(FlashBang) \r[3500$]")
menu_additem(menuz,amenu,"4")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wHelyum Bombasi \d(HeGrenade) \r[4000$]")
menu_additem(menuz,amenu,"5")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wSinirsiz Mermi \d(Unlimited) \r[8000$]")
menu_additem(menuz,amenu,"6")
formatex(amenu,charsmax(amenu),"\d< \rSG \d> \y~ \wTL Bozdur \d(-20 TL) \r[16000$]")
menu_additem(menuz,amenu,"7")

menu_setprop(menuz,MPROP_EXIT,MEXIT_ALL)
menu_display(id,menuz,0)

}
public dolar_devam(id,menu,item)
{
if(item == MENU_EXIT)
{
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
new access,callback,data[6],iname[64]

menu_item_getinfo(menu,item,access,data,5,iname,63,callback)

new key = str_to_num(data)

if(key == 1)
{
	if(cs_get_user_money(id) >= 2000)
	{
		cs_set_user_money(id, cs_get_user_money(id) - 2000)
		set_user_health(id,get_user_health(id) + 20)
		renkli_yazi(id,"!n[!t%s!n] Dolar Menuden !gSaglik Paketi (!t+20 Hp!g) !nAldin.",TAG)
		anamenu(id)
	}
	else 
	{
		renkli_yazi(id,"!n[!t%s!n] !g%s !gMaalesef Yeterli Paraniz Yok!.",TAG)
		anamenu(id)
	}
}
else if(key == 2)
{
	if(cs_get_user_money(id) >= 2500)
	{
		cs_set_user_money(id, cs_get_user_money(id) - 2500)
		set_user_armor(id,get_user_armor(id) + 40)
		renkli_yazi(id,"!n[!t%s!n] Dolar Menuden !gZirh Paketi (!t+40 Armor!g) !nAldin.",TAG)
		anamenu(id)
	}
	else 
	{
		renkli_yazi(id,"!n[!t%s!n] !g%s !gMaalesef Yeterli Paraniz Yok!.",TAG)
		anamenu(id)
	}
}
else if(key == 3)
{
	if(cs_get_user_money(id) >= 3000)
	{
		cs_set_user_money(id, cs_get_user_money(id) - 3000)
		renkli_yazi(id,"!n[!t%s!n] Dolar Menuden !gSis Bombasi !nAldin.",TAG)
		anamenu(id)
		give_item(id,"weapon_smokegrenade")
	}
	else 
	{
		renkli_yazi(id,"!n[!t%s!n] !g%s !gMaalesef Yeterli Paraniz Yok!.",TAG)
		anamenu(id)
	}
}
else if(key == 4)
{
	if(cs_get_user_money(id) >= 3500)
	{
		cs_set_user_money(id, cs_get_user_money(id) - 3500)
		renkli_yazi(id,"!n[!t%s!n] Dolar Menuden !gFlash Bombasi !nAldin.",TAG)
		anamenu(id)
		give_item(id,"weapon_flashbang")
	}
	else 
	{
		renkli_yazi(id,"!n[!t%s!n] !g%s !gMaalesef Yeterli Paraniz Yok!.",TAG)
		anamenu(id)
	}
}
else if(key == 5)
{
	if(cs_get_user_money(id) >= 4000)
	{
		cs_set_user_money(id, cs_get_user_money(id) - 4000)
		renkli_yazi(id,"!n[!t%s!n] Dolar Menuden !gHelyum Bombasi !nAldin.",TAG)
		anamenu(id)
		give_item(id,"weapon_hegrenade")
	}
	else 
	{
		renkli_yazi(id,"!n[!t%s!n] !g%s !gMaalesef Yeterli Paraniz Yok!.",TAG)
		anamenu(id)
	}
}
else if(key == 6)
{
	if(cs_get_user_money(id) >= 8000)
	{
		cs_set_user_money(id, cs_get_user_money(id) - 8000)
		renkli_yazi(id,"!n[!t%s!n] Dolar Menuden !gSinirsiz Mermi !nAldin.",TAG)
		anamenu(id)
		g_unammo[id] = true
	}
	else 
	{
		renkli_yazi(id,"!n[!t%s!n] !g%s !gMaalesef Yeterli Paraniz Yok!.",TAG)
		anamenu(id)
	}
}
else if(key == 7)
{
	if(g_jbpacks[id] >= 20)
	{
		g_jbpacks[id] -= 20 
		cs_set_user_money(id, cs_get_user_money(id) + 16000)
		renkli_yazi(id,"!n[!t%s!n] Dolar Menuden !g20 TL Bozdurarak 16.000 $ !nAldin.",TAG)
		anamenu(id)
	}
	else 
	{
		renkli_yazi(id,"!n[!t%s!n] !g%s !gMaalesef Yeterli Paraniz Yok!.",TAG)
		anamenu(id)
	}
}
menu_destroy(menu)
return PLUGIN_HANDLED;	

}
public reset(id)
{
cs_set_user_deaths(id, 0)
set_user_frags(id, 0)
cs_set_user_deaths(id, 0)
set_user_frags(id, 0)
renkli_yazi(id,"!n[!t%s!n] !g%s !gSkorunu Sifirladin",TAG)
}
public isyan_menu(id)
{
static Item[64];
new Menu;
formatex(Item,charsmax(Item),"\d< \rShieldsClan \d> \y~ \wIsyan Menu")
Menu = menu_create(Item,"isyan_zamani")

formatex(Item,charsmax(Item),"\w100 HP \r[%d TL]",get_pcvar_num(hp))
menu_additem(Menu,Item,"1")
formatex(Item,charsmax(Item),"\wHasari 2ye Katla \r[%d TL]",get_pcvar_num(hasar))
menu_additem(Menu,Item,"2")
formatex(Item,charsmax(Item),"\wGodmode \d(\r5 Sn\d) \r[%d TL]",get_pcvar_num(godmode))
menu_additem(Menu,Item,"9")
formatex(Item,charsmax(Item),"\wGorunmezlik \d(\r10 Sn\d) \r[%d TL]",get_pcvar_num(gorunmezlik))
menu_additem(Menu,Item,"8")
formatex(Item,charsmax(Item),"\wCT Kiyafeti \d(\r10 Sn\d) \r[%d TL]",get_pcvar_num(kiyafet))
menu_additem(Menu,Item,"12")
formatex(Item,charsmax(Item),"\wNoclip \d(\r3 Sn\d) \r[%d TL]",get_pcvar_num(noclip))
menu_additem(Menu,Item,"3")
//formatex(Item,charsmax(Item),"\ySaldir Menu \d[\rSayfa 1\d]")
//menu_additem(Menu,Item, "5")

menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
menu_display(id,Menu,0)

}
public isyan_zamani(id,menu,item)
{
if(item == MENU_EXIT)
{
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
new access,callback,data[6],iname[64]

menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
new canli = is_user_alive(id)
new esya1 = get_pcvar_num(hp)
new esya2 = get_pcvar_num(hasar)
new isyan3 = get_pcvar_num(godmode)
new isyan4 = get_pcvar_num(gorunmezlik)
new isyan5 = get_pcvar_num(kiyafet)
new isyan6 = get_pcvar_num(noclip)

new key = str_to_num(data)

switch(key)
{
	case 1 :
	{
		if(g_jbpacks[id] >= esya1 && canli)
		{
			g_jbpacks[id] -= esya1
			jb_harca[id] += esya1
			esya_al[id] += 1
			set_user_health(id,get_user_health(id) +100)
			renkli_yazi(id,"!n[!t%s!n] !gIsyan Menuden !n[!t100 HP!n] !gsatin aldin",TAG)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			
		}
	}
	case 2 :
	{
		if(g_jbpacks[id] >= esya2 && canli)
		{
			g_jbpacks[id] -= esya2
			jb_harca[id] += esya2
			g_hasar[id] = true
			esya_al[id] += 1
			renkli_yazi(id,"!n[!t%s!n] !gIsyan Menuden !n[!tHasari 2ye Katla!n] !gsatin aldin",TAG)
			
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)	
		}
	}
	case 3 :
	{
		if(g_jbpacks[id] >= isyan6 && canli)
		{
			g_jbpacks[id] -= isyan6
			jb_harca[id] += isyan6
			esya_al[id] += 1
			set_user_noclip(id,1)
			set_task(3.0,"kapat1",id)
			renkli_yazi(id,"!n[!t%s!n] !gIsyan Menuden !n[!tNoclip!n] !gsatin aldin",TAG)
			renkli_yazi(id,"!n[!t%s!n] !g3 Saniye Sonra Normale Doneceksin.",TAG)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)	
		}
	}
	case 8 :
	{
		if(g_jbpacks[id] >= isyan4 && canli)
		{
			g_jbpacks[id] -= isyan4
			jb_harca[id] += isyan4
			esya_al[id] += 1
			set_user_rendering(id, kRenderFxGlowShell, 255, 255, 0, kRenderTransAlpha, 0)
			set_task(10.0,"gorunmezkapat",id)
			renkli_yazi(id,"!n[!t%s] !gIsyan Menuden !n[!tGorunmezlik!n] !gsatin aldin",TAG)
			renkli_yazi(id,"!n[!t%s] !g10 Saniye Sonra Normale Doneceksin.",TAG)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
		}
	}
	case 9 :
	{
		if(g_jbpacks[id] >= isyan3 && canli)
		{
			g_jbpacks[id] -= isyan3			
			jb_harca[id] += isyan3
			esya_al[id] += 1
			set_user_godmode(id,1)
			set_task(5.0,"kapat2",id) 
			renkli_yazi(id,"!n[!t%s!n] !gIsyan Menuden !n[!tGodmode!n] !gsatin aldin",TAG)
			renkli_yazi(id,"!n[!t%s!n] !g5 Saniye Sonra Normale Doneceksin.",TAG)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
		}
	}
	
	case 12 :
	{
		if(g_jbpacks[id] >= isyan5 && canli)
		{
			g_jbpacks[id] -= isyan5
			jb_harca[id] += isyan5
			esya_al[id] += 1
			cs_set_user_model(id, "gign")
			set_task(10.0,"modelreset",id) 
		}
		else
		{
			renkli_yazi(id,"!n[!t%s!n] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)	
		}
	}
	case 5:
	{
		saldir_menu(id)
	}
}
menu_destroy(menu)
return PLUGIN_HANDLED
}

public saldir_menu(id)
{
if(is_user_alive(id))
{
	static Item[64]
	
	formatex(Item, charsmax(Item),"\d< \rShieldsClan \d> \y~ \wSaldir Menu")
	new Menu = menu_create(Item, "saldir_menu_gir")
	
	formatex(Item, charsmax(Item),"\dCT Disrmla \r[80 TL] \d(Sadece 1 CT )")
	menu_additem(Menu, Item, "1")
	
	formatex(Item, charsmax(Item),"\dT Unammo Ver \r[30 TL] \d(Tum Terorist Takimi)")
	menu_additem(Menu, Item, "2")
	
	formatex(Item, charsmax(Item),"\dCT Gom \r[100 TL] \d(Sadece 1 CT)")
	menu_additem(Menu, Item, "3")
	
	formatex(Item, charsmax(Item),"\dT +50 HP Ver \r[50 TL] \d(Tum Terorist Takimi)")
	menu_additem(Menu, Item, "4")
	
	formatex(Item, charsmax(Item),"\yCephane Menu \d[\rSayfa 1\d]")
	menu_additem(Menu, Item, "5")
	
	menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
	menu_display(id, Menu,0)
}
}

public saldir_menu_gir(id, menu, item) 
{
if( item == MENU_EXIT )
{
	menu_destroy(menu);
	return PLUGIN_HANDLED;
}
new data[6], name[32];
new access, callback;
menu_item_getinfo(menu, item, access, data,5, name, 31, callback);
new key = str_to_num(data);
switch(key)
{
	case 1:
	{
		if (g_jbpacks[id] > 80)
		{
			jb_set_user_packs(id,jb_get_user_packs (id) - 80)
			ctdisarm(id)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)	
			anamenu(id)
			
		}
	}
	case 2:
	{
		
		if (g_jbpacks[id] > 100)
		{
			jb_set_user_packs(id,jb_get_user_packs (id) - 100)
			tunammo(id)
			renkli_yazi(0,"!n[!t%s!n] !g%s !nadli mahkum tum T'ye !tUnammo !nverdi.",TAG,name) 
		}
		else
		{
			renkli_yazi(id,"!n[!t%s] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			anamenu(id)
		}
	}
	case 3:
	{
		
		if (g_jbpacks[id] > 30)
		{
			jb_set_user_packs(id,jb_get_user_packs (id) - 30)
			ctgom(id)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			anamenu(id)
		}
	}
	case 4:
	{
		
		if (g_jbpacks[id] > 50)
		{
			jb_set_user_packs(id,jb_get_user_packs (id) - 50)
			theal(id)
			renkli_yazi(0,"!n[!t%s!n] !g%s !nadli mahkum tum T'ye !t+50 Hp !nverdi.",TAG,name) 
		}
		else
		{
			renkli_yazi(id,"!n[!t%s] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			anamenu(id)
		}
	}
	case 6:
	{
		if (g_jbpacks[id] > 30)
		{
			isinla(id)
			jb_set_user_packs(id,jb_get_user_packs (id) - 30)
		}
		else
		{
			renkli_yazi(id,"!n[!t%s] !gYeterli !n[!tTL!n]' !gniz yok.",TAG)
			anamenu(id)
		}	
	}
	case 5:
	{
		Tienda(id)
	}
}
menu_destroy(menu);
return PLUGIN_HANDLED;
}
public ctdisarm(id)
{
	new ad[32],sznum[6]
	new menu = menu_create("\rSecdigin Gardiyani Disarmla","ctdisarm_devam")
	for(new i = 1;i<=get_maxplayers();i++)
		if(is_user_connected(i) && get_user_team(i) == 2 && is_user_alive(i))
		{
			num_to_str(i,sznum,5)
			get_user_name(i,ad,31)
			menu_additem(menu,ad,sznum)
		}
	menu_display(id,menu, 0)
	return PLUGIN_HANDLED
}

public ctdisarm_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new ad[32],callback,access,data[6]
	menu_item_getinfo(menu,item,access,data,5,ad,31,callback)
	new name[32];
	get_user_name(id,name,31)
	new tid = str_to_num(data)
	get_user_name(tid,ad,31)
	strip_user_weapons(tid)
	give_item(tid,"weapon_knife")
	renkli_yazi(0,"!n[!t%s!n] !g%s !nAdli Mahkum !tJB !nile !g%s !nadli gadriyani disarmladi.",TAG,name,ad)
	
	
	return PLUGIN_HANDLED
	
}

public ctgom(id)
{
	
	new ad[32],sznum[6]
	new menu = menu_create("\rSecdigin Gardiyani Gom","ctgom_devam")
	for(new i = 1;i<=get_maxplayers();i++)
		if(is_user_connected(i) && get_user_team(i) == 2 && is_user_alive(i))
	{
		num_to_str(i,sznum,5)
		get_user_name(i,ad,31)
		menu_additem(menu,ad,sznum)
	}
	menu_display(id,menu, 0)
	return PLUGIN_HANDLED
}

public ctgom_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new ad[32],callback,access,data[6]
	menu_item_getinfo(menu,item,access,data,5,ad,31,callback)
	new name[32];
	get_user_name(id,name,31)
	new tid = str_to_num(data)
	get_user_name(tid,ad,31)
	new Float: iforigin[3]
	pev(tid,pev_origin,iforigin)
	iforigin[2] -= 30
	set_pev(tid,pev_origin,iforigin)
	renkli_yazi(0,"!n[!t%s!n] !g%s !nAdli Mahkum !tJB !nile !g%s !nadli gadriyani gomdu.",TAG,name,ad) 
	
	
	return PLUGIN_HANDLED	
}
public tunammo(id)
{
	new players[32],inum;
	static tempid;
	get_players(players,inum)
	for(new i; i<inum; i++)
	{
		tempid = players[i]
		if(get_user_team(tempid) == 1)
		{
			g_unammo[tempid] = 1
		}
	}
}
public theal(id)
{
	new players[32],inum;
	static tempid;
	get_players(players,inum)
	for(new i; i<inum; i++)
	{
		tempid = players[i]
		if(get_user_team(tempid) == 1)
		{
			set_user_health(tempid,get_user_health(tempid) +50)
		}
	}		
}

public modelreset(id)
{
	cs_set_user_model(id, "arctic")
}
public isinla(id)
{
	new name[32],inum[6]
	if(get_user_team(id) == 1)
	{
		new menu = menu_create("\rSecdigin Gardiyani Yanina Isinla","isinla_devam")
		for(new i = 1;i<=get_maxplayers();i++)
			if(is_user_connected(i) && get_user_team(i) == 2 && is_user_alive(i))
		{
			num_to_str(i,inum,5)
			get_user_name(i,name,31)
			menu_additem(menu,name,inum)
		}
		menu_display(id,menu, 0)	
	}
	return PLUGIN_HANDLED
}		
public isinla_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[32]
	menu_item_getinfo(menu,item,access,data,5,iname,31,callback)
	
	new isim[32]
	new tid = str_to_num(data)
	get_user_name(id,iname,31)
	get_user_name(tid,isim,31)
	new Float:szOrigin[3]
	pev(id,pev_origin,szOrigin)
	szOrigin[0] += 40
	set_pev(tid,pev_origin,szOrigin)
	renkli_yazi(0,"!n[!g%s!n] !tadli mahkum !n[!g%s!n] !tadli kisiyi JB ile yanina isinladi.",iname,isim)
	return PLUGIN_HANDLED;
}
public kapat1(id)
{
	set_user_noclip(id,0)
	renkli_yazi(id,"!n[!t%s!n] !g5 Sn'lik Noclip Hakkin Doldu.",TAG)
}
public kapat2(id)
{
	set_user_godmode(id,0)
	renkli_yazi(id,"!n[!t%s!n] !g5 Sn'lik Godmode Hakkin Doldu.",TAG)
	
}
public gorunmezkapat(id)
{
	set_user_rendering(id, kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 255)
	renkli_yazi(id,"!n[!t%s!n] !g10 Sn'lik Gorunmezlik Hakkin Doldu.",TAG)
	
}
public ctdondur()
{
	//
}
public ctcoz(id)
{
	//
}	
public slot_menu(id)
{
	if(g_slot[id])
	{
		new Menu = menu_create("\y|\d ShieldsClan \y| \r- \wSlot Menusu","slot_devam")
		
		menu_additem(Menu,"\wHiz","1")
		menu_additem(Menu,"\wBonus Al \d[\r3 Elde 1\d] ","2")
		menu_additem(Menu,"\wDaha Az Hasar Al","3")
		menu_additem(Menu,"\w100 Zirh","4")
		
		menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
		menu_display(id,Menu,0)
	}
	else
	{
		renkli_yazi(id,"!n[!t%s!n] !gSlot menusu her elde 1 kere acilabilir.",TAG)
	}
	return PLUGIN_HANDLED
}
public slot_devam(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[64]
	menu_item_getinfo(menu,item,access,data,5,iname,63,callback)
	
	new name [32]
	get_user_name(id,name,31)
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1 :
		{
			set_user_maxspeed(id,300.0)
			g_slot[id] = false
			g_elit[id] = false
			g_vip[id] = false
			Ronda[id] = 1
			renkli_yazi(id,"!n[!t%s!n] !gSlotmenusunden !n[!tHIZ!n] !galdin.",TAG)
		}
		case 2 :
		{
			if(g_bonus[id] >= 3)
			{
				g_slot[id] = false
				g_vip[id] = false
				g_elit[id] = false
				g_bonus[id] = 0
				bonus_al(id)
			}
			else
			{
				renkli_yazi(id,"!n[!t%s!n] !gBonusu 3 elde 1 alabilirsin",TAG)
			}	
		}
		case 3 :
		{
			g_slot[id] = false
			g_vip[id] = false
			g_elit[id] = false
			hasar_azalt[id] = true
			renkli_yazi(id,"!n[!t%s!n] !gSlotmenusunden !n[!tHasar Azalt!n] !galdin.",TAG)
		}
		case 4 :
		{
			g_slot[id] = false
			g_elit[id] = false
			g_vip[id] = false
			set_user_armor(id,get_user_armor(id) + 100)
			renkli_yazi(id,"!n[!t%s!n] !gSlotmenusunden !n[!t+ 100 Armor!n] !galdin.",TAG)
		}
		case 5:
		{
			g_slot[id] = false
			g_elit[id] = false
			g_vip[id] = false
			g_jbpacks[id] += 5
			renkli_yazi(0,"!t%s!n : !gBol Yetkili Slotluk Ve Komutculuk ucretsizdir.",name)	
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public bonus_al(id)
{
	switch(random_num(1,4))
	{
		case 1 :
		{
			g_jbpacks[id] += 5
			renkli_yazi(id,"!n[!t%s!n] !g5 TL Kazandin",TAG)
		}
		case 2 :
		{
			g_jbpacks[id] += 10
			renkli_yazi(id,"!n[!t%s!n] !g10 TL Kazandin",TAG)
		}
		case 3 :
		{
			g_jbpacks[id] += 1
			renkli_yazi(id,"!n[!t%s!n] !g1 TL Kazandin",TAG)
		}
		case 4 :
		{
			g_jbpacks[id] += 20
			renkli_yazi(id,"!n[!t%s!n] !g20 TL Kazandin",TAG)
		}
	}
}

stock in_array(needle, data[], size)
{
	for(new i = 0; i < size; i++)
	{
		if(data[i] == needle)
			return i
	}
	return -1
}
public gorev_menu(id)
{
	static Item[64],sure;
	new Menu;
	formatex(Item,charsmax(Item),"\d< \rShieldsClan \d> \y~ \wGorev Menu")
	Menu = menu_create(Item,"odul_al")
	
	sure = get_user_time(id,1) / 60
	
	if(gardiyan_oldur[id] < 5)
	{
		formatex(Item,charsmax(Item),"\d[\r5\d] \wGardiyan Oldur \d[\r%d/5\d] \w[\y%d TL\w]",gardiyan_oldur[id],get_pcvar_num(gorev_odul1))
		menu_additem(Menu,Item,"1")
	}
	if(gardiyan_oldur[id] >= 5 && gorev1[id] == 0)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.\rOdulunu Almak icin \d[\y1'e\d] \wbas.")
		menu_additem(Menu,Item,"1")
	}
	if(gorev1[id] == 1)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.")
		menu_additem(Menu,Item,"1")
	}
	if(jb_harca[id] < 80)
	{
		formatex(Item,charsmax(Item),"\d[\r80\d] \wTL Harca.\d[\r%d/80\d] \w[\y%d TL\w]",jb_harca[id],get_pcvar_num(gorev_odul2))
		menu_additem(Menu,Item,"2")
	}
	if(jb_harca[id] >= 80 && gorev2[id] == 0)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.\rOdulunu Almak icin \d[\y2'e\d] \wbas.")
		menu_additem(Menu,Item,"2")
	}
	if(gorev2[id] == 1)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.")
		menu_additem(Menu,Item,"2")
	}
	if(mahkum_oldur[id] < 10)
	{
		formatex(Item,charsmax(Item),"\d[\r10\d] \warkadasini oldur. \d[\r%d/10\d] \w[\y%d TL\w]",mahkum_oldur[id],get_pcvar_num(gorev_odul3))
		menu_additem(Menu,Item,"3")
	}
	if(mahkum_oldur[id] >= 10 && gorev3[id] == 0)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.\rOdulunu Almak icin \d[\y3'e\d] \rbas.")
		menu_additem(Menu,Item,"3")
	}
	if(gorev3[id] == 1)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.")
		menu_additem(Menu,Item,"3")
	}
	if(esya_al[id] < 12)
	{
		formatex(Item,charsmax(Item),"\yToplam \w[\r12\w] \yEsya Satin Al \d[\r%d/12\d] \w[\y%d TL\w]",esya_al[id],get_pcvar_num(gorev_odul4))
		menu_additem(Menu,Item,"4")
	}
	if(esya_al[id] >= 12 && gorev4[id] == 0)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.\rOdulunu Almak icin \d[\y4'e\d] \wbas.")
		menu_additem(Menu,Item,"4")
	}
	if(gorev4[id] == 1)
	{
		formatex(Item,charsmax(Item),"\ywGorev Tamamlandi")
		menu_additem(Menu,Item,"4")
	}
	if(g_survive[id] < 8 )
	{
		formatex(Item,charsmax(Item),"\d[\r8\d] \wKez Hayatta Kal \d[\r%d/8\d] \w[\y%d TL\w]",g_survive[id],get_pcvar_num(gorev_odul5))
		menu_additem(Menu,Item,"5")
	}
	if(g_survive[id] >= 8 && gorev5[id] == 0)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.\rOdulunu Almak icin \d[\y5'e\d] \wbas.")
		menu_additem(Menu,Item,"5")
	}
	if(gorev5[id] == 1)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi")
		menu_additem(Menu,Item,"5")
	}
	if(sure < 30 )
	{
		formatex(Item,charsmax(Item),"\d[\r30\d] \wDakika Swde Takil.\d[\r%d/30\d] \w[\y%d TL\w]",sure,get_pcvar_num(gorev_odul6))
		menu_additem(Menu,Item,"6")
	}
	if(sure >= 30 && gorev6[id] == 0)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi.\rOdulunu Almak icin \d[\y6'e\d] \wbas.")
		menu_additem(Menu,Item,"6")
	}
	if(gorev6[id] == 1)
	{
		formatex(Item,charsmax(Item),"\wGorev Tamamlandi")
		menu_additem(Menu,Item,"6")
	}
	
	menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
	menu_display(id,Menu,0)
	
	return PLUGIN_HANDLED
}
public odul_al(id,menu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new access,callback,data[6],iname[32];
	menu_item_getinfo(menu,item,access,data,5,iname,31,callback)	
	
	get_user_name(id,iname,31)
	
	new odul1 = get_pcvar_num(gorev_odul1)
	new odul2 = get_pcvar_num(gorev_odul2)
	new odul3 = get_pcvar_num(gorev_odul3)
	new odul4 = get_pcvar_num(gorev_odul4)
	new odul5 = get_pcvar_num(gorev_odul5)
	new odul6 = get_pcvar_num(gorev_odul6)
	
	switch(str_to_num(data))
	{
		case 1 :
		{
			if(gardiyan_oldur[id] < 5)
			{
				gorev_menu(id)
			}
			if(gardiyan_oldur[id] >= 5 && gorev1[id] == 0)
			{
				g_jbpacks[id] += odul1
				renkli_yazi(id,"!n[!t%s!n] !g5 Gardiyan oldurdugun icin !n[!t%d TL!n] !gkazandin",TAG,odul1)
				gorev1[id] = 1
			}
			if(gorev1[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 2 :
		{
			if(jb_harca[id] < 80)
			{
				gorev_menu(id)
			}
			if(jb_harca[id] >= 80 && gorev2[id] == 0)
			{
				g_jbpacks[id] += odul2
				renkli_yazi(id,"!n[!t%s!n] !g80 TL harcadigin icin !n[!t%d TL!n] !gkazandin",TAG,odul2)
				gorev2[id] = 1
			}
			if(gorev2[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 3 :
		{
			if(mahkum_oldur[id] < 10)
			{
				gorev_menu(id)
			}
			if(mahkum_oldur[id] >= 10 && gorev3[id] == 0)
			{
				g_jbpacks[id] += odul3
				renkli_yazi(id,"!n[!t%s!n] !gFF'de 10 Arkadasini vurdugun icin !n[!t%d TL!n] !gkazandin",TAG,odul3)
				gorev3[id] = 1
			}
			if(gorev3[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 4 :
		{
			if(esya_al[id] < 12)
			{
				gorev_menu(id)
			}
			if(esya_al[id] >= 12 && gorev4[id] == 0)
			{
				g_jbpacks[id] += odul4
				renkli_yazi(id,"!n[!t%s!n] !gToplam 12 Esya aldigin icin !n[!t%d TL!n] !gkazandin",TAG,odul4)
				gorev4[id] = 1
			}
			if(gorev4[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 5 :
		{
			if(g_survive[id] < 8 )
			{
				gorev_menu(id)
			}
			if(g_survive[id] >= 8 && gorev5[id] == 0)
			{
				g_jbpacks[id] += odul5
				renkli_yazi(id,"!n[!t%s!n] !gToplam 8 kez hayatta kaldigin icin !n[!t%d TL!n] !gkazandin",TAG,odul5)
				gorev5[id] = 1
			}
			if(gorev5[id] == 1)
			{
				gorev_menu(id)
			}
		}
		case 6 :
		{
			static sure;
			sure = get_user_time(id,1) / 60
			if(sure < 30 )
			{
				gorev_menu(id)
			}
			if(sure >= 30 && gorev6[id] == 0)
			{
				g_jbpacks[id] += odul6
				renkli_yazi(id,"!n[!t%s!n] !gToplam 30 dakika swde durdugun icin !n[!t%d TL!n] !gkazandin",TAG,odul6)
				gorev6[id] = 1
			}
			if(gorev6[id] == 1)
			{
				gorev_menu(id)
			}
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
public meslek_menu(id)
{
	if(select_meslek[id])
	{
		static Item[64];
		new Menu;
		formatex(Item,charsmax(Item),"\d< \rShieldsClan \d> \y~ \wMeslek Menusu")
		Menu = menu_create(Item,"meslek_sec")
		
		
		
		
		
		formatex(Item,charsmax(Item),"\d[ \rRambo \d] \y: \r[\wAz Hasar Alir\r]")
		menu_additem(Menu,Item,"1")
		
		formatex(Item,charsmax(Item),"\d[ \rAstronot \d] \y: \r[\wYuksek Ziplar\r]")
		menu_additem(Menu,Item,"2")
		
		formatex(Item,charsmax(Item),"\d[ \rHirsiz \d] \y: \r[\w10dk'da 10 TL Calar\r]")
		menu_additem(Menu,Item,"4")
		
		formatex(Item,charsmax(Item),"\d[ \rAvci \d] \y: \r[\wCT Oldurdugunde \y10 \wTL Kazanirsin\r]")
		menu_additem(Menu,Item,"6")
		
		formatex(Item,charsmax(Item),"\d[ \rBombaci \d] \y: \r[\wBomba Sahibi Olursun\r]")
		menu_additem(Menu,Item,"8")
		
		formatex(Item,charsmax(Item),"\d[ \rTerminator \d] \y: \r[\wHer El \y150 \dHP \w+ \y150 \dArmor\r]")
		menu_additem(Menu,Item,"7")
		
		formatex(Item,charsmax(Item),"\d[ \rSansli Adam \d] \y: \r[\w3/1 Rev Sansi\r]")
		menu_additem(Menu,Item,"5")
		menu_display(id,Menu,0)

		menu_setprop(Menu, MPROP_EXIT, MEXIT_ALL)
	}
	else
		
	{
		renkli_yazi(id,"!n[!t%s!n] !gHer Elde 1 Kere Meslek Deyisme Hakkin Vardir",TAG)
		renkli_yazi(id,"!n[!t%s!n] !gHer Elde 1 Kere Meslek Deyisme Hakkin Vardir",TAG)
		renkli_yazi(id,"!n[!t%s!n] !gHer Elde 1 Kere Meslek Deyisme Hakkin Vardir",TAG)
		renkli_yazi(id,"!n[!t%s!n] !gHer Elde 1 Kere Meslek Deyisme Hakkin Vardir",TAG)
		anamenu(id)
		
		
	}
	return PLUGIN_HANDLED
}

public meslek_sec(id,menu,item)
{
if(item == MENU_EXIT)
{
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
new access,callback,data[6],iname[64];
menu_item_getinfo(menu,item,access,data,5,iname,63,callback)

switch(str_to_num(data))
{
	case 1 :
	{
		
		if(meslek[id] == 1)
		{
			renkli_yazi(id,"!n[!t%s!n] !gZaten mesleginiz !n[!tRambo!n]",TAG)
			return PLUGIN_HANDLED
		}
		if(meslek[id] == 4) remove_task(id+600)
		if(meslek[id] == 3) remove_task(id+513)
		select_meslek[id] = false
		meslek[id] = 1
		set_user_gravity(id,0.8)
		renkli_yazi(id,"!n[!t%s!n] !gRambo meslegini sectin",TAG)
		
	}
	case 2 :
	{
		if(meslek[id] == 2)
		{
			renkli_yazi(id,"!n[!t%s!n] !gZaten mesleginiz !n[!tAstronot.!n]",TAG)
			return PLUGIN_HANDLED
		}
		if(meslek[id] == 4) remove_task(id+600)
		if(meslek[id] == 3) remove_task(id+513)
		select_meslek[id] = false
		meslek[id] = 2
		set_user_gravity(id,0.5)
		renkli_yazi(id,"!n[!t%s!n] !gAstronot meslegini sectin",TAG)
	}
	case 4 :
	{
		if(meslek[id] == 4)
		{
			renkli_yazi(id,"!n[!t%s!n] !gZaten mesleginiz !n[!tTL Hirsizi.!n]",TAG)
			return PLUGIN_HANDLED
		}
		if(meslek[id] == 3) remove_task(id+513)
		select_meslek[id] = false
		meslek[id] = 4
		set_task(600.0,"GiveJB2",id+600,_,_,"b")
		set_user_gravity(id,0.8)
		renkli_yazi(id,"!n[!t%s!n] !gTL Hirsizi meslegini sectin",TAG)
	}
	case 5 :
	{
		
		if(meslek[id] == 5)
			
		{
			renkli_yazi(id,"!n[!t%s!n] !gZaten mesleginiz !n[!tSansli Adam.!n]",TAG)
			return PLUGIN_HANDLED
		}
		if(meslek[id] == 3) remove_task(id+513)
		if(meslek[id] == 4) remove_task(id+600)
		select_meslek[id] = false
		meslek[id] = 5
		set_user_gravity(id,0.8)
		renkli_yazi(id,"!n[!t%s!n] !gSansli Adam meslegini sectin",TAG)
		
	}
	case 6 :
	{
		
		if(meslek[id] == 6)
			
		{
			renkli_yazi(id,"!n[!t%s!n] !gZaten mesleginiz !n[!t Avci. !n]",TAG)
			return PLUGIN_HANDLED
		}
		if(meslek[id] == 3) remove_task(id+513)
		if(meslek[id] == 4) remove_task(id+600)
		select_meslek[id] = false
		meslek[id] = 6;
		renkli_yazi(id,"!n[!t%s!n] ^1Mesleginizi ^3[ ^4Avci ^3] ^1Olarak Sectiniz !",TAG)
	}
	case 7 :
	{
		if(meslek[id] == 7)
			
		{
			renkli_yazi(id,"!n[!t%s!n] !gZaten mesleginiz !n[!t Terminator !n]",TAG)
			return PLUGIN_HANDLED
		}
		if(meslek[id] == 3) remove_task(id+513)
		if(meslek[id] == 4) remove_task(id+600)
		select_meslek[id] = false
		meslek[id] = 7;
		renkli_yazi(id,"!n[!t%s!n] ^1Mesleginizi !n[!t Terminator !n] ^1Olarak Sectiniz !",TAG)
		set_user_health(id, 150)
		set_user_armor(id, 150)
	}
	
	case 8 :
	{         
		if(meslek[id] == 8) {       
			renkli_yazi(id,"!n[!t%s!n] ^1Mesleginiz Zaten ^3[ ^4Bombaci ^3] !")  
			return PLUGIN_HANDLED           
		}           
		if(meslek[id] == 3) remove_task(id+513)
		if(meslek[id] == 4) remove_task(id+600)      
		select_meslek[id] = false
		meslek[id] = 8;         
		renkli_yazi(id,"!n[!t%s!n] ^1Mesleginizi ^3[ ^4Bombaci ^3] ^1Olarak Sectiniz !",TAG) 
		switch(random_num(0,2)){
			case 0: {
				give_item(id, "weapon_hegrenade")
			}
			case 1: {
				give_item(id, "weapon_flashbang")
			}
			case 2: {
				give_item(id, "weapon_smokegrenade") 
			}
			case 3: {
				give_item(id, "weapon_smokegrenade") 
			}
			case 4: {
				give_item(id, "weapon_flashgrenade") 
			}
			case 5: {
				give_item(id, "weapon_smokegrenade") 
			}
		}
	} 
}

menu_destroy(menu)
return PLUGIN_HANDLED
}
public GiveJB2(taskid)
{
new id = taskid - 600;
g_jbpacks[id] += 10
renkli_yazi(id,"!n[!t%s!n] !g10 Daikadir swde oldugun icin 10 TL kazandin",TAG)
}
public hpver(taskid)
{
new id = taskid - 513
if(is_user_alive(id))
{
	set_user_health(id,get_user_health(id) + 5)
}
}
public eDeath2() {
new killer = read_data(1);
new victim = read_data(2);

if(get_user_team(killer) == 1 && get_user_team(victim) == 2 && meslek[killer] == 6) {
	jb_set_user_packs(killer,jb_get_user_packs(killer) + 10)
}

}
public OyuncuDogunca2(id) {
if(meslek[id] == 8) {
	set_task(0.3,"GiveMeGrenade",id)
}
if(meslek[id] == 7) {
	set_user_health(id, 150);
	set_user_armor(id, 150);   
}
}

public GiveMeGrenade(id) {
switch(random_num(0,5)){
	case 0: {
		give_item(id, "weapon_hegrenade")
	}
	case 1: {
		give_item(id, "weapon_flashbang")
	}
	case 2: {
		give_item(id, "weapon_smokegrenade") 
	}
	case 3: {
		give_item(id, "weapon_smokegrenade") 
	}
	case 4: {
		give_item(id, "weapon_flashgrenade") 
	}
	case 5: {
		give_item(id, "weapon_smokegrenade") 
	}
}
}
public isyan_team_menu(id)
{
if(get_user_flags(id) & ADMIN_LEVEL_H)
{
	static Item[64];
	new Menu;
	formatex(Item,charsmax(Item),"\d< \rShieldsClan \d> \y~ \wIsyanTeam\d[\rISYANTEAM \rBASKANI\d]")
	Menu = menu_create(Item,"bombermancim")
	
	formatex(Item,charsmax(Item),"\wTakimina Armor Ver \d[\r +100 \d]")
	menu_additem(Menu,Item,"4")
	
	formatex(Item,charsmax(Item),"\wTakimina HP Ver \d[ \r+75 \d]")
	menu_additem(Menu,Item,"3") 
	
	formatex(Item,charsmax(Item),"\wTakimina Bomba Ver \d[ \rFlash+HE\d]")
	menu_additem(Menu,Item,"6") 
	
	formatex(Item,charsmax(Item),"\wTakimina Bomba Ver \d[ \rHe \d]")
	menu_additem(Menu,Item,"2") 
	
	formatex(Item,charsmax(Item),"\wTakimina JB Ver \d[ \r+5 TL\d ]")
	menu_additem(Menu,Item,"1")  
	
	
	menu_setprop(Menu,MPROP_EXIT,MEXIT_ALL)
	menu_display(id,Menu,0)
}
else
{
	renkli_yazi(id,"!n[!t%s!n] !gBu Menuye Sadece !tISYANTEAM !gBaskanlari girebilir.",TAG)
	anamenu(id)	
}
return PLUGIN_HANDLED;
}
public bombermancim(id,menu,item)
{
if(item == MENU_EXIT)
{
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
new access,callback,data[6],iname[64]
menu_item_getinfo(menu,item,access,data,5,iname,63,callback)


new key = str_to_num(data)

switch(key)
{
	case 1 :
	{	
		if (check[id]==false) {
		renkli_yazi(0,"!n[!t%s!n] !gTum isyancilara !n[!t+5 JB!n] !gverildi",TAG)
		g_bomberman[id] = false
		jb_ver(id)
		check[id] = true
		}else {
		renkli_yazi(id,"!n[!t%s!n] !gHer el sadece !t1 !gkere verebilirsin.",TAG)
		}
		anamenu(id)	
	}
	case 2 :
	{
		if (check2[id]==false) {
		renkli_yazi(0,"!n[!t%s!n] !gTum isyancilara !n[!Bomba!n] !gverildi",TAG)
		g_bomberman[id] = false
		bombaver(id)
		check2[id] = true
		}else {
			renkli_yazi(id,"!n[!t%s!n] !gHer el sadece !t1 !gkere verebilirsin.",TAG)
		}
		anamenu(id)
	}
	case 6 :
	{
		if (check3[id] == false) {
		renkli_yazi(0,"!n[!t%s!n] !gTum isyancilara !n[!tFlash Bombasi!n] !gverildi",TAG)
		g_bomberman[id] = false
		bombaver2(id)
		check3[id] = true
		}else {
			renkli_yazi(id,"!n[!t%s!n] !gHer el sadece !t1 !gkere verebilirsin.",TAG)
		}
		anamenu(id)	
	}
	case 3 :
	{
		if (check4[id]==false) {
		renkli_yazi(0,"!n[!t%s!n] !gTum isyancilara !n[!t+50 HP!n] !gverildi",TAG)
		g_bomberman[id] = false
		hp_ver(id)
		check4[id] = true
		}else {
			renkli_yazi(id,"!n[!t%s!n] !gHer el sadece !t1 !gkere verebilirsin.",TAG)
		}
		anamenu(id)
	}
	case 4 : 
	{
		if (check5[id]==false) {
		renkli_yazi(0,"!n[!t%s!n] !gTum isyancilara !n[!t+100 ARMOR!n] !gverildi",TAG)
		g_bomberman[id] = false
		armor_ver(id)
		check5[id] = true
		}else{
				renkli_yazi(id,"!n[!t%s!n] !gHer el sadece !t1 !gkere verebilirsin.",TAG)
		}
		anamenu(id)
	}
}	
menu_destroy(menu)
return PLUGIN_HANDLED
}
public jb_ver(id)
{
new players[32],inum;
static tempid;
get_players(players,inum)
for(new i; i<inum; i++)
{
	tempid = players[i]
	if(get_user_team(tempid) == 1 && get_user_flags(tempid) & ADMIN_RESERVATION)
	{
		g_jbpacks[tempid] += 5	
	}
}
}
public bombaver(id)
{
new players[32],inum;
static tempid;
get_players(players,inum)
for(new i; i<inum; i++)
{
	tempid = players[i]
	if(get_user_team(tempid) == 1 && get_user_flags(tempid) & ADMIN_RESERVATION)
	{
		give_item(tempid,"weapon_hegrenade")
                give_item(tempid,"weapon_flashbang")
	}
}
}

public bombaver2(id)
{
new players[32],inum;
static tempid;
get_players(players,inum)
for(new i; i<inum; i++)
{
	tempid = players[i]
	if(get_user_team(tempid) == 1 && get_user_flags(tempid) & ADMIN_RESERVATION)
	{
		give_item(tempid,"weapon_flashbang")
                give_item(tempid,"weapon_hegrenade")
	}
}
}
public hp_ver(id)
{
new players[32],inum;
static tempid;
get_players(players,inum)
for(new i; i<inum; i++)
{
	tempid = players[i]
	if(get_user_team(tempid) == 1 && get_user_flags(tempid) & ADMIN_RESERVATION)
	{
		set_user_health(tempid,get_user_health(tempid) +75)	
	}
}
}
public armor_ver(id)
{
new players[32],inum;
static tempid;
get_players(players,inum)
for(new i; i<inum; i++)
{
	tempid = players[i]
	if(get_user_team(tempid) == 1 && get_user_flags(tempid) & ADMIN_RESERVATION)
	{
		set_user_armor(tempid,get_user_armor(tempid) + 100)
	}
}	
}
public ucretsiz_al(id)
{
switch(random_num(1,1)){
	case 1 :
	{
		g_jbpacks[id] += 5
	}
}		
}

/*============================================================
Stocks!
============================================================*/
stock renkli_yazi(const id, const input[], any:...)
{
new count = 1, players[32];
static msg[191];
vformat(msg, 190, input, 3);

replace_all(msg, 190, "!n", "^x01"); // Default Renk(Sar�)
replace_all(msg, 190, "!g", "^x04"); // Ye�il Renk
replace_all(msg, 190, "!t", "^x03"); // Tak�m Renk( CT mavi , T k�rm�z� )

if (id) players[0] = id; else get_players(players, count, "ch");
{
for (new i = 0; i < count; i++)
{
	if (is_user_connected(players[i]))
	{
		
		message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i]);
		write_byte(players[i]);
		write_string(msg);
		message_end();
	}
	
}
}
}
stock ham_strip_weapon(id,weapon[])
{
if(!equal(weapon,"weapon_",7)) return 0;

new wId = get_weaponid(weapon);
if(!wId) return 0;

new wEnt;
while((wEnt = engfunc(EngFunc_FindEntityByString,wEnt,"classname",weapon)) && pev(wEnt,pev_owner) != id) {}
if(!wEnt) return 0;

if(get_user_weapon(id) == wId) ExecuteHamB(Ham_Weapon_RetireWeapon,wEnt);

if(!ExecuteHamB(Ham_RemovePlayerItem,id,wEnt)) return 0;
ExecuteHamB(Ham_Item_Kill,wEnt);

set_pev(id,pev_weapons,pev(id,pev_weapons) & ~(1<<wId));

return 1;
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
