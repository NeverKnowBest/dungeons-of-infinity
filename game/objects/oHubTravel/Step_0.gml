switch(State){
	
	case 0:
		// scroll at the dungeon transition speed (4px per frame on each axis)
		with(oCamera){
			var _X = X + clamp(other.CamTargetX - X, -4, 4);
			var _Y = Y + clamp(other.CamTargetY - Y, -4, 4);
			Cam_SetPos(_X, _Y);
		}
		if(oCamera.X == CamTargetX && oCamera.Y == CamTargetY){
			oCamera.Override = false;
			Dungeon_RoomDeActivate(FromRoom);
			global.Paused = false;
			var _Dir = (DestFacing == RIGHT) ? 1 : -1;
			with(oLink) Link_SetAutoMove(_Dir, 0, WalkSpeed, 14);
			State = 1;
		}
		break;
		
	case 1:
		Frames++;
		if(Frames > 16){
			with(oLink) if(State == LinkState.AutoMove) UpdateState(LinkState.Standing);
			instance_destroy();
		}
		break;
		
}
