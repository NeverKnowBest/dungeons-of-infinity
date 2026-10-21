if(global.LinkDead) exit;

Enemy_PixelRender(true, sEnemy_Soldier_Palette, SoldierInst.ColorIndex);
//PixelRender(true, true, true, sEnemy_Soldier_Palette, SoldierInst.ColorIndex, false, 0);

for(var i = 1; i < 5; i++){
	var ChainDist = i * (SpinDist / 5);
	draw_sprite(sSoldierWeapon_Mace_Chain, 0, StartX + lengthdir_x(ChainDist, SpinAngle), StartY + lengthdir_y(ChainDist, SpinAngle));	
}
draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_white, 0.2);

shader_reset();