LightFrame++;

if(LightFrame < LightFrames){
	LightUpdate = true;
}else{
	instance_destroy(id);
}