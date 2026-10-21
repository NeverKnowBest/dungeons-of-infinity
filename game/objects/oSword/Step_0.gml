
var img_index = floor(oLink.image_index);
var Lx = oLink.x;
var Ly = oLink.y;
//var Ldepth = oLink.depth;
image_xscale = 1;
image_yscale = 1;
image_angle = 0;

switch(oLink.Facing){
	case LEFT:
		//if(img_index >= 10) depth = Ldepth - 1; //draw sword in front of Link
		//if(img_index < 10) depth = Ldepth + 1; //draw sword behind Link
		if(img_index == 0) {image_index = 0; x = Lx -1; y = Ly - 8; image_xscale = -1}; 
		if(img_index == 1) {image_index = 1; x = Lx - 6; y = Ly - 7; image_xscale = -1;}; 
		if(img_index == 2) {image_index = 2; x = Lx - 8; y = Ly - 6; image_xscale = -1;}; 
		if(img_index == 3) {image_index = 3; x = Lx - 13; y = Ly - 6; image_xscale = -1;}; 
		if(img_index == 4) {image_index = 1; x = Lx - 9; y = Ly - 8; image_angle = 90;}; 
		if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx - 14; y = Ly - 5; image_angle = 90;};
		if(img_index == 9) {image_index = 1; x = Lx - 9; y = Ly; image_xscale = -1; image_angle = 90;};
		if(img_index == 10) {image_index = 2; x = Lx - 6; y = Ly + 4; image_xscale = -1; image_angle = 90;};
		if(img_index >= 11) {image_index = 3; x = Lx - 1; y = Ly + 7; image_xscale = -1; image_angle = 90;}; 
			
		break;
		
	case RIGHT:
		//if(img_index >= 10) depth = Ldepth - 1; //draw sword in front of Link
		//if(img_index < 10) depth = Ldepth + 1; //draw sword behind Link
		if(img_index == 0) {image_index = 0; x = Lx + 1; y = Ly - 8;};
		if(img_index == 1) {image_index = 1; x = Lx + 6; y = Ly - 7;}; 
		if(img_index == 2) {image_index = 2; x = Lx + 8; y = Ly - 6;};
		if(img_index == 3) {image_index = 3; x = Lx + 13; y = Ly - 6;};
		if(img_index == 4) {image_index = 1; x = Lx + 10; y = Ly - 7; image_yscale = -1; image_angle = 90;};
		if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx + 14; y = Ly - 5; image_yscale = -1; image_angle = 90;};
		if(img_index == 9) {image_index = 1; x = Lx + 9; y = Ly; image_angle = -90;}; 
		if(img_index == 10) {image_index = 2; x = Lx + 6; y = Ly + 4; image_angle = -90;}; 
		if(img_index >= 11) {image_index = 3; x = Lx + 1; y = Ly + 7; image_angle = -90;}; 

		break;
		
	case UP:
		//depth = Ldepth + 1; //draw sword behind Link
		if(img_index == 0) {image_index = 0; x = Lx + 5; y = Ly - 7; image_xscale = -1; image_angle = -90;}; 
		if(img_index == 1) {image_index = 1; x = Lx + 3; y = Ly - 11; image_xscale = -1; image_angle = -90;}; 
		if(img_index == 2) {image_index = 2; x = Lx + 1; y = Ly - 15; image_xscale = -1; image_angle = -90;}; 
		if(img_index == 3) {image_index = 3; x = Lx; y = Ly - 21; image_xscale = -1; image_angle = -90;};
		if(img_index == 4) {image_index = 1; x = Lx - 1; y = Ly - 17;};
		if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx - 5; y = Ly - 21;};
		if(img_index == 9) {image_index = 1; x = Lx - 9; y = Ly - 15; image_xscale = -1;}; 
		if(img_index == 10) {image_index = 2; x = Lx - 11; y = Ly - 10; image_xscale = -1;}; 
		if(img_index >= 11) {image_index = 3; x = Lx - 14; y = Ly - 6; image_xscale = -1;}; 

		break;
		
	case DOWN:
		//depth = Ldepth - 1 //draw sword in front of Link
		if(img_index == 0) {image_index = 0; x = Lx - 2; y = Ly - 5; image_xscale = -1; image_angle = 90;}; 
		if(img_index == 1) {image_index = 1; x = Lx - 1; y = Ly - 2; image_xscale = -1; image_angle = 90;}; 
		if(img_index == 2) {image_index = 2; x = Lx; y = Ly; image_xscale = -1; image_angle = 90;}; 
		if(img_index == 3) {image_index = 3; x = Lx + 1; y = Ly + 5; image_xscale = -1; image_angle = 90;}; 
		if(img_index == 4) {image_index = 1; x = Lx + 1; y = Ly + 1; image_angle = 180;}; 
		if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx + 4; y = Ly + 5; image_angle = 180;}; 
		if(img_index == 9) {image_index = 1; x = Lx + 8; y = Ly - 1; image_xscale = -1; image_angle = 180;};  
		if(img_index == 10) {image_index = 2; x = Lx + 10; y = Ly - 3; image_xscale = -1; image_angle = 180;}; 
		if(img_index >= 11) {image_index = 3; x = Lx + 14; y = Ly - 5; image_xscale = -1; image_angle = 180;}; 
			
		break;
		
}	
	
if(img_index > 2 && img_index < 10){ //only check collisions if sword is past 0 or before 180 deg
	
	var CrystalInst = ObjCollision(self, oCrystalSwitch);
	if(CrystalInst != noone){
		if(!CrystalInst.HitPause){
			CrystalInst.Hit = true;	
		}
	}

	var PotInst = ObjCollision(self, oPot);
	if(PotInst != noone){
		PotInst.Destroyed = true;
		instance_destroy(PotInst.WallObj);
		if(PotInst.ContentsObj != noone) ItemSpawn(ContainerType.Pot, PotInst.ContentsObj, PotInst.ContentsVal, PotInst.x, PotInst.y, oLink.FloorLevel);	
	}
	
	with(oEnemy){
		var EnemyInst = ObjCollision(self, other);
		if(EnemyInst != noone){
			Hit = true;
			LinkSwordHit = true;
			HitDamage = 1 + oLink.SwordLevel; //temporary, damage will eventually depend on other factors
		}
	}

	with(oEnemy_HitBox){
		var EnemyInst = ObjCollision(other, self);
		if(EnemyInst != noone){
			LinkedInst.Hit = true;
			LinkedInst.LinkSwordHit = true;
			LinkedInst.HitDamage = 1 + oLink.SwordLevel; //temporary, damage will eventually depend on other factors
		}
	}

	var BoneInst = ObjCollision(self, oBone);
	if(BoneInst != noone) BoneInst.Destroyed = true;
	
}