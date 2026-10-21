/// @description Update Facing sprites

Dir = DirFaceAngle(Angle);
Enemy_UpdateSprite(State);
		
alarm[1] = irandom_range(UpdateFacingSpriteDelayMin, UpdateFacingSpriteDelayMax);
