event_inherited();

if(Destroyed){
	
	repeat(choose(0,0,0,irandom_range(1, 2))){
		var inst = instance_create_layer(x + random_range(-4,4), y + random_range(-4,4), "Arcade_Objs", oSporkInvader_Gem);
		inst.sprite_index = sSporkInvader_GemM;
	}
	repeat(choose(0,0,0,irandom_range(1, 4))){
		var inst = instance_create_layer(x + random_range(-4,4), y + random_range(-4,4), "Arcade_Objs", oSporkInvader_Gem);
		inst.sprite_index = sSporkInvader_GemS;
	}

	global.Arcade_ActiveInst.Score += 100;
	instance_create_layer(x, y - 2, "Arcade_Objs", ExplosionObj);
	
	instance_destroy(self);
	
}

