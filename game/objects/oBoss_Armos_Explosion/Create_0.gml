
Speed = 1/3;

xTL = x - 8;
yTL = y - 8;
vxTL = -Speed;
vyTL = -Speed;

xTR = x + 8;
yTR = y - 8;
vxTR = Speed;
vyTR = -Speed;

xBL = x - 8;
yBL = y + 8;
vxBL = -Speed;
vyBL = Speed;

xBR = x + 8;
yBR = y + 8;
vxBR= Speed;
vyBR = Speed;

Colors = array_create(0);
array_insert(Colors, 0, KB_B,KB_B, KB_R,KB_R, KB_In,KB_In, KB_B,KB_B, KB_Br,KB_Br, KB_B,KB_B, KB_R,KB_R, KB_In,KB_In, KB_B,KB_B, KB_Br,KB_Br);
ColorFrame = 0;
