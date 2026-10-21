FloorLevel = oLink.FloorLevel;
layer = (FloorLevel == LOWER ? global.LayerID_Objs_Lower : global.LayerID_Objs_Upper);
DepthBehindLink = oLink.depth + 5;
DepthInFrontOfLink = oLink.depth - 5;

var img_index = floor(oLink.image_index);
var Lx = oLink.x;
var Ly = oLink.y-1;
image_xscale = 1;
image_yscale = 1;
image_angle = 0;
var CheckCollision = false;

switch(oLink.State){
	
	case LinkState.Sword:
	
		switch(oLink.Facing){
			case LEFT:
				depth = oLink.depth + 5;
				if(img_index == 0) {image_index = 0; x = Lx - 1; y = Ly - 8; image_xscale = -1 depth = DepthBehindLink;}; 
				if(img_index == 1) {image_index = 1; x = Lx - 6; y = Ly - 7; image_xscale = -1; depth = DepthBehindLink;}; 
				if(img_index == 2) {image_index = 2; x = Lx - 8; y = Ly - 6; image_xscale = -1; depth = DepthBehindLink;}; 
				if(img_index == 3) {image_index = 3; x = Lx - 13; y = Ly - 6; image_xscale = -1; depth = DepthBehindLink;}; 
				if(img_index == 4) {image_index = 1; x = Lx - 9; y = Ly - 8; image_angle = 90; depth = DepthBehindLink;}; 
				if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx - 14; y = Ly - 4; image_angle = 90;depth = DepthInFrontOfLink;};
				if(img_index == 9) {image_index = 1; x = Lx - 9; y = Ly; image_xscale = -1; image_angle = 90;depth = DepthInFrontOfLink;};
				if(img_index == 10) {image_index = 2; x = Lx - 6; y = Ly + 4; image_xscale = -1; image_angle = 90;depth = DepthInFrontOfLink;};
				if(img_index >= 11) {image_index = 3; x = Lx - 1; y = Ly + 7; image_xscale = -1; image_angle = 90;depth = DepthInFrontOfLink;}; 
				HitPosX = Lx - 22;
				HitPosY = Ly - 5;
			
				break;
		
			case RIGHT:
				if(img_index == 0) {image_index = 0; x = Lx + 1; y = Ly - 8; depth = DepthBehindLink;};
				if(img_index == 1) {image_index = 1; x = Lx + 6; y = Ly - 7; depth = DepthBehindLink;}; 
				if(img_index == 2) {image_index = 2; x = Lx + 8; y = Ly - 6; depth = DepthBehindLink;};
				if(img_index == 3) {image_index = 3; x = Lx + 13; y = Ly - 6; depth = DepthBehindLink;};
				if(img_index == 4) {image_index = 1; x = Lx + 10; y = Ly - 7; image_yscale = -1; image_angle = 90; depth = DepthBehindLink;};
				if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx + 14; y = Ly - 4; image_yscale = -1; image_angle = 90;depth = DepthInFrontOfLink;};
				if(img_index == 9) {image_index = 1; x = Lx + 9; y = Ly; image_angle = -90;depth = DepthInFrontOfLink;}; 
				if(img_index == 10) {image_index = 2; x = Lx + 6; y = Ly + 4; image_angle = -90;depth = DepthInFrontOfLink;}; 
				if(img_index >= 11) {image_index = 3; x = Lx + 1; y = Ly + 7; image_angle = -90;depth = DepthInFrontOfLink;}; 
				HitPosX = Lx + 22;
				HitPosY = Ly - 5;
				break;
		
			case UP:
				depth = DepthBehindLink;
				if(img_index == 0) {image_index = 0; x = Lx + 5; y = Ly - 7; image_xscale = -1; image_angle = -90;}; 
				if(img_index == 1) {image_index = 1; x = Lx + 3; y = Ly - 11; image_xscale = -1; image_angle = -90;}; 
				if(img_index == 2) {image_index = 2; x = Lx + 1; y = Ly - 15; image_xscale = -1; image_angle = -90;}; 
				if(img_index == 3) {image_index = 3; x = Lx; y = Ly - 21; image_xscale = -1; image_angle = -90;};
				if(img_index == 4) {image_index = 1; x = Lx - 1; y = Ly - 17;};
				if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx - 5; y = Ly - 21;};
				if(img_index == 9) {image_index = 1; x = Lx - 9; y = Ly - 15; image_xscale = -1;}; 
				if(img_index == 10) {image_index = 2; x = Lx - 11; y = Ly - 10; image_xscale = -1;}; 
				if(img_index >= 11) {image_index = 3; x = Lx - 14; y = Ly - 6; image_xscale = -1;}; 
				HitPosX = Lx - 4;
				HitPosY = Ly - 28;
				break;
		
			case DOWN:
				depth = DepthInFrontOfLink;
				if(img_index == 0) {image_index = 0; x = Lx - 2; y = Ly - 5; image_xscale = -1; image_angle = 90;}; 
				if(img_index == 1) {image_index = 1; x = Lx - 1; y = Ly - 2; image_xscale = -1; image_angle = 90;}; 
				if(img_index == 2) {image_index = 2; x = Lx; y = Ly + 1; image_xscale = -1; image_angle = 90;}; 
				if(img_index == 3) {image_index = 3; x = Lx + 1; y = Ly + 5; image_xscale = -1; image_angle = 90;}; 
				if(img_index == 4) {image_index = 1; x = Lx + 1; y = Ly + 1; image_angle = 180;}; 
				if(img_index >= 5 && img_index <= 8) {image_index = 0; x = Lx + 4; y = Ly + 5; image_angle = 180;}; 
				if(img_index == 9) {image_index = 1; x = Lx + 8; y = Ly - 1; image_xscale = -1; image_angle = 180;};  
				if(img_index == 10) {image_index = 2; x = Lx + 10; y = Ly - 3; image_xscale = -1; image_angle = 180;}; 
				if(img_index >= 11) {image_index = 3; x = Lx + 14; y = Ly - 5; image_xscale = -1; image_angle = 180;}; 
				HitPosX = Lx + 4;
				HitPosY = Ly + 12;			
				break;
		
		}
		
		//only check collisions if sword is past 0 or before 180 deg
		CheckCollision = img_index >= 2 && img_index <= 9;
		break;
	
	case LinkState.SwordPoke:
		
		CheckCollision = false;
		
		switch(oLink.Facing){
			
			case DOWN:
				switch(img_index){
			
					case 0:
						x = Lx + 7; 
						y = Ly - 5; 
						image_index = 0;
						image_angle = 180; 
						break;
						
					case 1:
						x = Lx + 2; 
						y = Ly + 1; 
						image_index = 1;
						image_angle = 180; 							
						break;
						
					case 2:
						x = Lx + 6; 
						y = Ly - 1; 
						image_index = 0;
						image_angle = 180; 
						break;

				}	
				break;

			case UP:
				
				depth = DepthBehindLink;
				
				switch(img_index){
			
					case 0:
						x = Lx - 7; 
						y = Ly - 9; 
						image_index = 0;
						break;

					case 1:
						x = Lx - 3; 
						y = Ly - 12;
						image_index = 1;					
						break;

					case 2:
						x = Lx - 7; 
						y = Ly - 4; 
						image_index = 0;
						break;
						
				}	
				break;
				
			case RIGHT:
				
				depth = DepthInFrontOfLink;
				image_index = 0;
				image_xscale = -1; 
				image_angle = -90; 
				switch(img_index){
			
					case 0:
						x = Lx + 4; 
						y = Ly - 2; 					
						break;
					case 1:
						x = Lx + 9; 
						y = Ly - 5; 
						break;
						
					case 2:
						x = Lx; 
						y = Ly - 5; 
						break;

				}				
				break;

			case LEFT:

				depth = DepthInFrontOfLink;
				image_index = 0;
				image_angle = 90;
				image_xscale = -1; 
				switch(img_index){
			
					case 0:
						x = Lx - 4; 
						y = Ly - 2; 					
						break;
						
					case 1:
						x = Lx - 9; 
						y = Ly - 5; 					
						break;
						
					case 2:
						x = Lx; 
						y = Ly - 5; 		
						break;


				}				
				break;
				
		}
		
		break;
		
	case LinkState.Star:

		image_index = 1;
		CheckCollision = true;
		depth = DepthInFrontOfLink;
		
		switch(img_index){
			
			case 0: //down 1
				x = Lx + 8; 
				y = Ly - 7; 
				image_xscale = -1; 
				image_angle = -90; 
				break;
			
			case 1: //down 2
				x = Lx + 8; 
				y = Ly - 2; 
				image_angle = -90; 				
				break;
			case 2: //left 1
				x = Lx + 3; 
				y = Ly + 1; 
				image_xscale = -1; 
				image_angle = 180; 				
				break;
			case 3: //left 2
				x = Lx - 4; 
				y = Ly + 1; 
				image_angle = 180; 				
				break;
			case 4: //up 1
				x = Lx - 8; 
				y = Ly - 2; 
				image_xscale = -1; 
				image_angle = 90; 					
				break;
			case 5: //up 2
				x = Lx - 8; 
				y = Ly - 9; 
				image_angle = 90; 					
				break;
			case 6: //right 1
				x = Lx - 5; 
				y = Ly - 12; 
				image_xscale = -1; 
				depth = DepthBehindLink;
				break;
				
			case 7: //right 2
				x = Lx + 3; 
				y = Ly - 12;
				depth = DepthBehindLink;
				break;
			
		}

		break;
	
	case LinkState.SwordSpin:
	
		image_index = 1;
		CheckCollision = true;
		depth = DepthInFrontOfLink;
		
		SwordSpinSparkle_Dir -= SwordSpinSparkle_Speed;
		if(SwordSpinSparkle_Dir < 0) SwordSpinSparkle_Dir += 360;
		
		switch(oLink.Facing){
			
			case DOWN:
				switch(img_index){
			
					case 0:
						CheckCollision = false;
					case 3:
					case 12:
						x = Lx + 10; 
						y = Ly - 10; 
						depth = DepthBehindLink;
						break;
				
					case 1:
					case 2:
						x = Lx + 1; 
						y = Ly - 14; 
						image_xscale = -1; 
						depth = DepthBehindLink;
						CheckCollision = false;
						break;
				
					case 4: //down 1
						x = Lx + 8; 
						y = Ly - 7; 
						image_xscale = -1; 
						image_angle = -90; 
						break;
			
					case 5: //down 2
						x = Lx + 8; 
						y = Ly - 2; 
						image_angle = -90; 				
						break;
					case 6: //left 1
						x = Lx + 3; 
						y = Ly + 1; 
						image_xscale = -1; 
						image_angle = 180; 				
						break;
					case 7: //left 2
						x = Lx - 4; 
						y = Ly + 1; 
						image_angle = 180; 				
						break;
					case 8: //up 1
						x = Lx - 8; 
						y = Ly - 2; 
						image_xscale = -1; 
						image_angle = 90; 					
						break;
					case 9: //up 2
						x = Lx - 8; 
						y = Ly - 9; 
						image_angle = 90; 					
						break;
					case 10: //right 1
						x = Lx - 5; 
						y = Ly - 12; 
						image_xscale = -1;
						depth = DepthBehindLink;
						break;
				
					case 11: //right 2
						x = Lx + 3; 
						y = Ly - 12; 
						depth = DepthBehindLink;
						break;

				
				}	
				break;

			case UP:
				switch(img_index){
			
					case 0:
						CheckCollision = false;
					case 3:
					case 12:
						x = Lx - 10; 
						y = Ly - 4; 
						image_angle = 180; 
						depth = DepthInFrontOfLink;
						break;
				
					case 1:
					case 2:
						x = Lx; 
						y = Ly - 1; 
						image_xscale = -1; 
						image_angle = 180; 	
						depth = DepthInFrontOfLink;
						CheckCollision = false;
						break;
					case 4: //up 1
						x = Lx - 8; 
						y = Ly - 2; 
						image_xscale = -1; 
						image_angle = 90; 	
						break;
					case 5: //up 2
						x = Lx - 8; 
						y = Ly - 9; 
						image_angle = 90; 					
						break;
					case 6: //right 1
						x = Lx - 5; 
						y = Ly - 12; 
						image_xscale = -1;
						depth = DepthBehindLink;
						break;
				
					case 7: //right 2
						x = Lx + 3; 
						y = Ly - 12; 
						depth = DepthBehindLink;
						break;				
					case 8: //down 1
						x = Lx + 8; 
						y = Ly - 7; 
						image_xscale = -1; 
						image_angle = -90; 
						break;
			
					case 9: //down 2
						x = Lx + 8; 
						y = Ly - 2; 
						image_angle = -90; 				
						break;
					case 10: //left 1
						x = Lx + 3; 
						y = Ly + 1; 
						image_xscale = -1; 
						image_angle = 180; 				
						break;
					case 11: //left 2
						x = Lx - 4; 
						y = Ly + 1; 
						image_angle = 180; 				
						break;


				
				}	
				break;
				
			case RIGHT:
			
				switch(img_index){
			
					case 0:
						CheckCollision = false;
					case 3:
					case 12:
						x = Lx - 5; 
						y = Ly - 12; 
						image_angle = 90; 	
						depth = DepthBehindLink;
						break;
				
					case 1:
					case 2:
						x = Lx - 7; 
						y = Ly - 3; 
						image_xscale = -1; 
						image_angle = 90; 
						depth = DepthBehindLink;
						CheckCollision = false;
						break;

					case 4: //right 1
						x = Lx - 5; 
						y = Ly - 12; 
						image_xscale = -1;
						depth = DepthBehindLink;
						break;
				
					case 5: //right 2
						x = Lx + 3; 
						y = Ly - 12; 
						depth = DepthBehindLink;
						break;
						
					case 6: //down 1
						x = Lx + 8; 
						y = Ly - 7; 
						image_xscale = -1; 
						image_angle = -90; 
						break;
			
					case 7: //down 2
						x = Lx + 8; 
						y = Ly - 2; 
						image_angle = -90; 				
						break;
					case 8: //left 1
						x = Lx + 3; 
						y = Ly + 1; 
						image_xscale = -1; 
						image_angle = 180; 				
						break;
					case 9: //left 2
						x = Lx - 4; 
						y = Ly + 1; 
						image_angle = 180; 				
						break;
					case 10: //up 1
						x = Lx - 8; 
						y = Ly - 2; 
						image_xscale = -1; 
						image_angle = 90; 					
						break;
					case 11: //up 2
						x = Lx - 8; 
						y = Ly - 9; 
						image_angle = 90; 					
						break;

				
				}				
				break;

			case LEFT:
			
				switch(img_index){
			
					case 0:
						CheckCollision = false;
					case 3:
					case 12:
						x = Lx + 4; 
						y = Ly + 1; 
						image_angle = -90; 	
						depth = DepthBehindLink;
						break;
				
					case 1:
					case 2:
						x = Lx + 8; 
						y = Ly - 9; 
						image_xscale = -1; 
						image_angle = -90; 
						depth = DepthBehindLink;
						CheckCollision = false;
						break;

					case 4: //left 1
						x = Lx + 3; 
						y = Ly + 1; 
						image_xscale = -1; 
						image_angle = 180; 
						break;
					case 5: //left 2
						x = Lx - 4; 
						y = Ly + 1; 
						image_angle = 180; 				
						break;
					case 6: //up 1
						x = Lx - 8; 
						y = Ly - 2; 
						image_xscale = -1; 
						image_angle = 90; 					
						break;
					case 7: //up 2
						x = Lx - 8; 
						y = Ly - 9; 
						image_angle = 90; 					
						break;						
					case 8: //right 1
						x = Lx - 5; 
						y = Ly - 12; 
						image_xscale = -1;
						depth = DepthBehindLink;
						break;
				
					case 9: //right 2
						x = Lx + 3; 
						y = Ly - 12; 
						depth = DepthBehindLink;
						break;
						
					case 10: //down 1
						x = Lx + 8; 
						y = Ly - 7; 
						image_xscale = -1; 
						image_angle = -90; 
						break;
			
					case 11: //down 2
						x = Lx + 8; 
						y = Ly - 2; 
						image_angle = -90; 				
						break;



				
				}				
				break;
				
		}
		
		switch(img_index){ //events that happen at certain frames
			case 1:
				if(!instance_exists(oSwordSpinSpark)) instance_create_depth(oLink.x + 22, oLink.y - 14, DepthInFrontOfLink, oSwordSpinSpark);
				break;
			case 4:
				alarm[1] = 1;
				if(!audio_is_playing(Sound_SwordSpin)) audio_play_sound(Sound_SwordSpin, 1, false);
				break;
				
		}
		break;
		
	default:
		
		if(oLink.SwordCharge == 0) break;
		
		CheckCollision = true;
		
		switch(oLink.Facing){
			case LEFT:
				depth = DepthInFrontOfLink;
				image_index = 0; 
				x = Lx - 4; 
				y = Ly - 3;
				if(oLink.State == LinkState.Walking) y += ((img_index + 1) mod 3); //adjust sword based on link's moving frame
				image_angle = 90;
				if(CreateSparkle){
					var _SparkleX = oLink.x - 2 - lerp(0, 15 + global.Inventory.ItemData[ItemClass.Sword].Index, oLink.SwordCharge);
					var _SparkleY = y - 1 + irandom_range(-3, 3);
					var _SparkleDepth = DepthInFrontOfLink;
				}
				break;
		
			case RIGHT:
				depth = DepthInFrontOfLink;
				image_index = 0; 
				x = Lx + 4; 
				y = Ly - 3; 
				if(oLink.State == LinkState.Walking) y += ((img_index + 1) mod 3); //adjust sword based on link's moving frame
				image_yscale = -1; 
				image_angle = 90;
				if(CreateSparkle){
					var _SparkleX = oLink.x + 2 + lerp(0, 15 + global.Inventory.ItemData[ItemClass.Sword].Index, oLink.SwordCharge);
					var _SparkleY = y - 1 + irandom_range(-3, 3);
					var _SparkleDepth = DepthInFrontOfLink;
				}
				break;
		
			case UP:
				depth = DepthBehindLink;
				image_index = 1;
				x = Lx - 3; 
				y = Ly - 10; 
				if(oLink.State == LinkState.Walking) y += ((img_index + 1) mod 3); //adjust sword based on link's moving frame
				if(CreateSparkle){
					var _SparkleX = oLink.x - 1 - lerp(7, 0, oLink.SwordCharge) + irandom_range(-3, 3);
					var _SparkleY = oLink.y - 8 - lerp(0, 15 + global.Inventory.ItemData[ItemClass.Sword].Index, oLink.SwordCharge);	
					var _SparkleDepth = DepthInFrontOfLink;
				}
				break;
		
			case DOWN:
				depth = DepthInFrontOfLink;
				image_index = 1;
				x = Lx + 3; 
				y = Ly - 2;
				if(oLink.State == LinkState.Walking) y += ((img_index + 1) mod 3); //adjust sword based on link's moving frame
				image_angle = 180; 
				if(CreateSparkle){
					var _SparkleX = oLink.x + lerp(6, 0, oLink.SwordCharge) + irandom_range(-3, 3);
					var _SparkleY = oLink.y - 6 + lerp(0, 15 + global.Inventory.ItemData[ItemClass.Sword].Index, oLink.SwordCharge);					
					var _SparkleDepth = DepthInFrontOfLink;
				}
				break;			
			
		}
		

		if(CreateSparkle){
			if(ReadySpark && oLink.SwordCharge >= SwordChargeReady){
				instance_create_depth(_SparkleX, _SparkleY, _SparkleDepth, oSparkle2);
				ReadySpark = false;
			}else{
				instance_create_depth(_SparkleX, _SparkleY, _SparkleDepth, oSparkle);
			}
			CreateSparkle = false;
		}
		
		break;
		
}

if(CheckCollision){ 
	
	StarCollisionX = oLink.x - 1;
	StarCollisionY = oLink.y - 8;	
	
	SwordCollision(oEnemy, global.SwordCollisionList);

	for(var i = 0; i < ds_list_size(global.SwordCollisionList); i++){
		
		var EnemyInst = global.SwordCollisionList[| i];
		
		var _Hit = false;
		
		with(EnemyInst){
			if(State != EnemyState.KnockBack && State != EnemyState.PushBack){
				switch(oLink.State){
					default:
						if(oLink.SwordCharge == 0) break;
					case LinkState.Sword:
						if(InFrontOfLink(x, y)){
							_Hit = Enemy_LinkWeaponHit(LinkWeaponClass.Sword, 0, self, other.HitPosX, other.HitPosY, point_direction(oLink.x, oLink.y, x, y));
						}
						break;
					case LinkState.Star:
					case LinkState.SwordSpin:
						var _Hit = Enemy_LinkWeaponHit(LinkWeaponClass.Sword, 0, self, oLink.x, oLink.y, point_direction(oLink.x, oLink.y, x, y));
						break;
				}
				if(_Hit){
					if(instance_exists(oSwordBeam)) instance_destroy(oSwordBeam);
				}

			}
		}
		
		if(_Hit){
			oLink.SwordChargeAllowed = false;
			if(Sword_DoSwordPoke()) exit;
			break;
		}
	}


	var SoldierWeaponInst = ObjCollision(x, y, oSoldierWeapon, FloorLevel);
	if(SoldierWeaponInst != noone){
		
		if(SoldierWeaponInst.object_index != oSoldierWeapon_Mace){
			
			if(EnemyCanHurtLink(SoldierWeaponInst.SoldierInst)){
					
				instance_create_layer(SoldierWeaponInst.x, SoldierWeaponInst.y, "ObjsHigher_Upper", oWallHit, {PlaySound: true});
		
				with(SoldierWeaponInst.SoldierInst){
						
					Pushback = true;
						
					if(InFrontOfLink(x, y)){
						var _Hit = Enemy_LinkWeaponHit(LinkWeaponClass.Sword, 0, self, other.HitPosX, other.HitPosY, point_direction(oLink.x, oLink.y, x, y));
						if(_Hit){
							oLink.SwordChargeAllowed = false;
							if(Sword_DoSwordPoke()) exit;
							exit;
						}

					}
				}
			}
		}
		
	}

	
	var BoneInst = SwordCollision(oBone);
	if(BoneInst != noone){
		BoneInst.Destroyed = true;	
		if(Sword_DoSwordPoke()) exit;
	}

	
	
	var CrystalInst = SwordCollision(oCrystalSwitch);
	if(CrystalInst != noone){
		if(!CrystalInst.HitPause){
			with(oSwordBeam){
				instance_destroy(id);
			}
			CrystalInst.Hit = true;	
			if(Sword_DoSwordPoke()) exit;
		}
	}
	
	var CurtainInst = SwordCollision(oCurtain);
	if(CurtainInst != noone){
		Curtain_Reveal(CurtainInst);
		if(!CurtainInst.Revealed){
			if(Sword_DoSwordPoke()) exit;
		}
	}

	
	var PickupObjInst = SwordCollision(oPickupObj);
	if(PickupObjInst != noone){
		
		var DestroyObj = PickupObjInst.DestroyedBySword;
		var IgnoreObj = false;
		switch(PickupObjInst.object_index){
			case oPot:
				if(!SwordLevel(Swords.Steel) && oLink.State != LinkState.Star){
					DestroyObj = false;
				}
				break;
		}

		if(DestroyObj){
			PickupObjInst.State = PickupObjState.Destroyed;
		}else if(!IgnoreObj){
			if(!instance_exists(oWallHit)) instance_create_layer(PickupObjInst.x, PickupObjInst.y - 4, "ObjsHigher_" + PickupObjInst.FloorLevelStr, oWallHit, {PlaySound: true});		
		}	
		
		if(Sword_DoSwordPoke()) exit;
		
	}

	
}