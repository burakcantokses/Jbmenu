/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <cstrike>
#include <engine>
#include <hamsandwich>

native jb_get_user_packs(id)
	native jb_set_user_packs(id, ammount) 

#define PLUGIN "IronMan"
#define VERSION "0.1"
#define AUTHOR "burakware"

new bool:ironman_hasar[33],bool:ironman_ziplama[33],bool:dusme_hasari[33]

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("say /ironman","ironmanoluyor")
	register_logevent("Event_RoundStart", 2, "1=Round_Start")
	RegisterHam(Ham_TakeDamage, "player", "OnCBasePlayer_TakeDamage")
}
public Event_RoundStart()
{
	for(new i; i < get_maxplayers(); i++) {
		ironman_hasar[i] = false
		dusme_hasari[i] = false
	}

}
public ironmanoluyor(id) {
	if(get_user_team(id) == 1) {
		if(jb_get_user_packs(id) >= 120) {
			new isimcik[64]
			get_user_name(id,isimcik,63)
			jb_set_user_packs(id,jb_get_user_packs(id) - 120)
			set_user_health(id,500)
			set_user_armor(id,1000)
			set_user_maxspeed(id, 350.0)
			set_user_gravity(id,0.3)
			give_item(id, "weapon_hegrenade")
			ironman_ziplama[id] = true
			dusme_hasari[id] = true
			ironman_hasar[id] = true
			client_printc(0,"!n[ !tShieldsClan !n] !t[ !g%s !t] !nIsimli Oyuncu !gIronMan'a !nDonustu!",isimcik)
			client_printc(id,"!n[ !tShieldsClan !n] !gIronman'a !ndonustun. !t500HP !n, !t1000 Armor !n, !t2X Hasar !nOzellikleri Aldin!")
			client_printc(id,"!n[ !tShieldsClan !n] !n[!tBosluk!n] !g Tusuna Basip Yukari Bakarak Ayagindan Roket Atarak Yukari Cikabilirsin.")
		}
		else {
			client_printc(id,"!n[ !tShieldsClan !n] !gYeterli Paran Yok!")
		}
	}
}

public client_PreThink(id){
		if(ironman_ziplama[id] == true){
			if(!(get_user_button(id) & IN_JUMP)) {
			return PLUGIN_CONTINUE;
			}
			new Float:fAim[3] , Float:fVelocity[3];
			VelocityByAim(id , 700 , fAim);
			
			fVelocity[0] = 0;
			fVelocity[1] = 0;
			fVelocity[2] = fAim[2];
			
			set_user_velocity(id , fVelocity);
			}
		return PLUGIN_CONTINUE
}

public OnCBasePlayer_TakeDamage( id, iInflictor, iAttacker, Float:flDamage, bitsDamageType )
{
	if( bitsDamageType & DMG_FALL && dusme_hasari[id])
	{
		return HAM_SUPERCEDE
	}
	if(ironman_hasar[id])
	{
		SetHamParamFloat(4, flDamage * 2.0)
	}
	
	return HAM_IGNORED
}
stock client_printc(const id, const input[], any:...)
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
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/
