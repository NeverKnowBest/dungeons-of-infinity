if(!PickedUp) draw_sprite(sShadow_Large, 0, x, y_base);

Enemy_PixelRender();

draw_sprite_ext(sprite_index, image_index, x, y, Dir, 1, 0, c_white, 1);

if(Scared && State != EnemyState.Frozen && State != EnemyState.Stone) draw_sprite(sEnemy_Chicken_Sweat, image_index, x, y - 18);

shader_reset()
