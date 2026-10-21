enum MosaicType{
	Warp,
	Shock,
	Sick	
}

function Mosaic(_MosaicType){

	global.MosaicDo = true;
	global.Paused = true;
	oRender.Mosaic_Type = _MosaicType;
	oRender.Mosaic_SizeIndex = 0;
	
	switch(_MosaicType){
		case MosaicType.Warp:
			oRender.Mosaic_Speed = 0.125;
			oRender.Mosaic_Warp = true;
			with(oLink) UpdateState(LinkState.Warping);
			break;
			
		case MosaicType.Shock:
			oRender.Mosaic_Speed = 0.65;
			with(oLink) UpdateState(LinkState.Shocked);
			break;
			
		case MosaicType.Sick:
		
	}	
	
}