
#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fun>
#if defined engine
#include <engine>
#else
#include <fakemeta>
#endif

#define ADMIN_LEVEL_Q	ADMIN_LEVEL_C 

new bool:hook[33]
new hook_to[33][3]
new hook_speed_cvar
new hook_enabled_cvar
new bool:has_hook[33]

new beamsprite

public plugin_init() 
{
	register_plugin("Spiderman Ag Atma","1.0","burakware")
	register_concmd("+spidermanpowerknknerdenanladin","hook_aktif",ADMIN_USER," - Kullanim : C tusuna bas")
	register_concmd("-spidermanpowerknknerdenanladin","hook_off")
	register_concmd("hook_toggle","hook_toggle",ADMIN_LEVEL_Q,"Toggles your hook on and off")
	
	
	hook_speed_cvar = register_cvar("hook_speed","5")
	hook_enabled_cvar = register_cvar("hook_enabled","1")
	
}

public plugin_precache()
{
	beamsprite = precache_model("sprites/olympos.spr")
	precache_sound("hook/oly.wav")
}

public client_putinserver(id)
{
	has_hook[id]=false
}

public hook_toggle(id,level,cid)
{
	if(hook[id]) hook_off(id)
	else hook_aktif(id,level,cid)
	return PLUGIN_HANDLED
}

public hook_aktif(id,level,cid)
{
	if(!has_hook[id] && !get_pcvar_num(hook_enabled_cvar) && !get_user_team(id) == 2)
	{
		return PLUGIN_HANDLED
	}
	if(hook[id])
	{
		return PLUGIN_HANDLED
	}
	 if (cs_get_user_team(id) == CS_TEAM_T ){
		set_user_gravity(id,0.0)
		set_task(0.1,"hook_prethink",id+10000,"",0,"b")
		hook[id]=true
		hook_to[id][0]=999999
		hook_prethink(id+10000)
		emit_sound(id,CHAN_VOICE,"hook/oly.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		return PLUGIN_CONTINUE
	}
return PLUGIN_CONTINUE
}

public hook_off(id)
{
	if(is_user_alive(id)) set_user_gravity(id)
	hook[id]=false
	return PLUGIN_HANDLED
}

public hook_prethink(id)
{
	id -= 10000
	if(!is_user_alive(id))
	{
		hook[id]=false
	}
	if(!hook[id])
	{
		remove_task(id+10000)
		return PLUGIN_HANDLED
	}
	
	//Get Id's origin
	static origin1[3]
	get_user_origin(id,origin1)
	
	if(hook_to[id][0]==999999)
	{
		static origin2[3]
		get_user_origin(id,origin2,3)
		hook_to[id][0]=origin2[0]
		hook_to[id][1]=origin2[1]
		hook_to[id][2]=origin2[2]
	}
	
	//ct icin renk olustur
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(1)		// baslatalim
	write_short(id)		// start entity
	write_coord(hook_to[id][0])
	write_coord(hook_to[id][1])
	write_coord(hook_to[id][2])
	write_short(beamsprite)
	write_byte(1)		// framestart
	write_byte(1)		// framerate
	write_byte(2)		// life in 0.1's
	write_byte(5)		// width
	write_byte(0)		// noise
	write_byte(225)		// red
	write_byte(225)		// green
	write_byte(225)		// blue
	write_byte(100)		// brightness
	write_byte(0)		// speed
	message_end()
	
	
	static Float:velocity[3]
	velocity[0] = (float(hook_to[id][0]) - float(origin1[0])) * 3.0
	velocity[1] = (float(hook_to[id][1]) - float(origin1[1])) * 3.0
	velocity[2] = (float(hook_to[id][2]) - float(origin1[2])) * 3.0
	
	static Float:y
	y = velocity[0]*velocity[0] + velocity[1]*velocity[1] + velocity[2]*velocity[2]
	
	static Float:x
	x = (get_pcvar_float(hook_speed_cvar) * 120.0) / floatsqroot(y)
	
	velocity[0] *= x
	velocity[1] *= x
	velocity[2] *= x
	
	set_velo(id,velocity)
	
	return PLUGIN_CONTINUE
}



public set_velo(id,Float:velocity[3])
{
	#if defined engine
	return set_user_velocity(id,velocity)
	#else
	return set_pev(id,pev_velocity,velocity)
	#endif
}







