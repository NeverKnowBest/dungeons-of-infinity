// Post Draw: application_surface holds the finished frame (the HUD is drawn later, in Draw GUI)
if(Sheet != undefined){
	Test_SheetCapture();
}else if(ShotName != ""){
	Test_SaveShot(ShotName);
	ShotName = "";
}
