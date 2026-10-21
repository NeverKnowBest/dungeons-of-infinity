if(Destroyed){
	instance_create_layer(x, y, layer, oZerberk_Robot_Destroyed);
	instance_destroy(self);
	exit;
}

HeroDir = point_direction(x, y, oZerberk_Hero.x, oZerberk_Hero.y);

if(!Walk || oZerberk_Hero.Dead){
	sprite_index = sZerberk_Robot_Standing;
	exit;
}

var _FaceDir = DirFaceAngle(HeroDir);
switch(_FaceDir){
	case UP: sprite_index = sZerberk_Robot_Walking_Up; break;
	case DOWN: sprite_index = sZerberk_Robot_Walking_Down; break;
	case LEFT: sprite_index = sZerberk_Robot_Walking_Left; break;
	case RIGHT: sprite_index = sZerberk_Robot_Walking_Right; break;
	
}

vx = lengthdir_x(WalkSpeed, HeroDir);
vy = lengthdir_y(WalkSpeed, HeroDir);

var _OldMask = mask_index;
mask_index = sZerberk_Robot_WallCollisionMask;

x += vx;
if(Zerberk_WallCollisionX(id) || Zerberk_WallCollisionY(id)){
	x -= vx;
}

y += vy;
if(Zerberk_WallCollisionX(id) || Zerberk_WallCollisionY(id)){
	y -= vy;
}

mask_index = _OldMask;