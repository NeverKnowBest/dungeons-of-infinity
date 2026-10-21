if(IsCornerWall && !global.EditMode) MouseOver = false;

if(MouseOver) SetBrightness(0.3);

draw_self();

shader_reset();

MouseOver = false;
