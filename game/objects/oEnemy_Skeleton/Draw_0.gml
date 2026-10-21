Enemy_DrawShadow();

Enemy_PixelRender(true, sPalette_Skeleton, Type);
draw_self();
draw_sprite(sEnemy_SkeletonHead, HeadDir - 1, x, y - 10);
shader_reset();

//draw_text(x + 16, y + 8, string(Energy))