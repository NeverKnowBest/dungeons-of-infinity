event_inherited();

if(SpawnWait) exit;

if(PreDestroyed){

	instance_create_layer(StartX, StartY, "Objs_Upper", oEnemy_Wallmaster, {FloorLevel : UPPERLOWER, 
																			ItemHolding : -1, 
																			SectionID: 0,
																			RoomIndex: StartRoomIndex,
																			Dir_Init: Dir_Init});	
	exit;
	
}

if(TemplateCheck(global.TransitionRoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss)){
	instance_destroy(id);
	exit;
}

if(	TemplateCheck(oLink.RoomIndex, RoomTemplateClass.Special, RoomTemplateClass_Special.Fairy) ||
	TemplateCheck(oLink.RoomIndex, RoomTemplateClass.Special, RoomTemplateClass_Special.GemPond)){
	Enemy_UpdateState(EnemyState.Idle);
	exit;
}


if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Idle);
}

PauseCheck


//if passing through these room types, make him invisible, check all 4 corners
var RoomIndexTL = Dungeon_GetRoomIndex(bbox_left, bbox_top);
var RoomIndexTR = Dungeon_GetRoomIndex(bbox_right, bbox_top);
var RoomIndexBL = Dungeon_GetRoomIndex(bbox_left, bbox_bottom);
var RoomIndexBR = Dungeon_GetRoomIndex(bbox_right, bbox_bottom);

var Invisible1 =	TemplateCheck(RoomIndexTL, RoomTemplateClass.Special, RoomTemplateClass_Special.Fairy) ||
					TemplateCheck(RoomIndexTL, RoomTemplateClass.Special, RoomTemplateClass_Special.GemPond) ||
					TemplateCheck(RoomIndexTL, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss);
var Invisible2 =	TemplateCheck(RoomIndexTR, RoomTemplateClass.Special, RoomTemplateClass_Special.Fairy) ||
					TemplateCheck(RoomIndexTR, RoomTemplateClass.Special, RoomTemplateClass_Special.GemPond) ||
					TemplateCheck(RoomIndexTR, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss);
var Invisible3 =	TemplateCheck(RoomIndexBL, RoomTemplateClass.Special, RoomTemplateClass_Special.Fairy) ||
					TemplateCheck(RoomIndexBL, RoomTemplateClass.Special, RoomTemplateClass_Special.GemPond) ||
					TemplateCheck(RoomIndexBL, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss);
var Invisible4 =	TemplateCheck(RoomIndexBR, RoomTemplateClass.Special, RoomTemplateClass_Special.Fairy) ||
					TemplateCheck(RoomIndexBR, RoomTemplateClass.Special, RoomTemplateClass_Special.GemPond) ||
					TemplateCheck(RoomIndexBR, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss);

Invisible = (Invisible1 && Invisible2 && Invisible3 && Invisible4);


switch(State){
	
	case EnemyState.Walking:	
		
		if(Alpha < 1) break;
		
		var _Dir = point_direction(x, y, oLink.x, oLink.y - 6);
		vx = lengthdir_x(Speed + random_range(-SpeedMod, SpeedMod), _Dir);
		vy = lengthdir_y(Speed + random_range(-SpeedMod, SpeedMod), _Dir);	
		
		Dir = (vx < 0 ? 1 : -1);
		
		image_index = (z_frame >= 180 && z_frame <= 270 ? 1 : 0);
		
		if(distance_to_object(oLink) < AttackDist && !Invisible){
			
			if(oLink.InDoor_Full){
				Enemy_UpdateState(EnemyState.Idle);
				break;
			}else{
				Enemy_UpdateState(EnemyState.Shooting);
			}
			
		}
		
		break;
	

}

z = z_base + (dsin(z_frame) * 2);
z_frame = (z_frame + 4) mod 360;

if(Alpha < 1){
	Alpha += 0.025;
	if(Alpha >= 1){
		Alpha = 1;
	}
}

CanHurtLink = (Alpha == 1 && !Invisible);






