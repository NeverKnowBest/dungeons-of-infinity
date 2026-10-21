if(Toggle){
					
	if((Color == global.Level.SwitchBlock_ActiveColor && Raised) || (Color != global.Level.SwitchBlock_ActiveColor && !Raised)){
		
		AniDelayCounter--;
		if(AniDelayCounter == 0){
			AniDelayCounter = AniDelayFrames;
			ImgIndex = ImgIndex + (Color == global.Level.SwitchBlock_ActiveColor && Raised ? -1 : 1);
			if(ImgIndex == 0 || ImgIndex == 4){
				Raised = !Raised;
				SwitchBlock_SetWalls(self);
				Toggle = false;
			}

		}
		
	}else{
		Toggle = false;
	}	
		
}