if(State == EnemyState.Idle || !Visible) exit;

Enemy_PixelRender(true, sEnemy_Delevant_Pal, Index);

draw_sprite(sprite_index, image_index, x, y);

shader_reset();

Enemy_PixelRender();

if(State == EnemyState.Wake || State == EnemyState.Sleep) draw_sprite(sInSand, global.InWaterImgIndex, x, y + 4);

shader_reset();