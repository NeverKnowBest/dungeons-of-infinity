if(BossDestroyed){
	PixelRender(true, true, false, noone, 0, false, []);
	draw_sprite(sBoss_Aghanim_Dead, 0, x, y);
	shader_reset();
	exit;
}

PixelRender(true, true, false, noone, 0, false, []);
draw_sprite(sShadow_Large, 0, x, y);
shader_reset();

if(GravityBall){
	
	PixelRender(true, true, true, sPalette_Aghanim_EnergyBall, EnergyBall_PalIndex, false, 0);
	draw_sprite(sEnergyBall, 2, x - 12, y - 28);
	draw_sprite(sEnergyBall, 2, x + 12, y - 28);
	shader_reset();
	
}

switch(State){
	
	default:
		Enemy_PixelRender();

		draw_self();

		shader_reset();			
		
		break;
	
	case EnemyState.Sleep:
	case EnemyState.Wake:
		
		PixelRender(true, true, false, noone, 0, false, []);
		
		draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, make_color_rgb(BlackballMorph, BlackballMorph, BlackballMorph), 1);
		
		shader_reset();	
		break;
	
	case EnemyState.Idle:
		
		break;
	
	case EnemyState.Killed:
		PixelRender(false, false, false, noone, 0, true, global.KnockBackColors[KnockBackColorFrame]);
		draw_self();
		shader_reset();	
		break;
		
}

if(TakeItems_ShowBag){
	
	PixelRender(true, true, false, noone, 0, false, []);
	draw_sprite(sBoss_Aghanim_LinkItems, 0, TakeItems_BagPosX, TakeItems_BagPosY);
	shader_reset();	
	
	if(TakeItems_ShowShield){
		
		var _Index = (alarm[8] >= 96 ? 0 : (alarm[8] >= 92 ? 1 : 2 + EnergyBall_PalIndex))
		draw_sprite_ext(sAghanim_GravityBall, _Index, x, y + 4, 1, -1, 0, c_white, 1);

		PixelRender(false, false, true, sPalette_Aghanim_EnergyBall, EnergyBall_PalIndex, false, 0);
		draw_sprite(sEnergyBall, 2, x - 12, y - 24);
		draw_sprite(sEnergyBall, 2, x + 12, y - 24);
		shader_reset();
	
	}


	
}
//draw_set_font(global.Font_Blue)
//var _x = x + 16;
//var _y = y - 24;
//var _d = 14;
//draw_text(_x, _y, "E: " + string(Energy)); //_y+= _d;
//draw_text(_x, _y, "Scr " + string(Script[ScriptIndex][0])); _y+= _d;
//draw_text(_x, _y, "ImgInd " + string(image_index)); _y+= _d;