DrawNight = true;
with(oLinkDeath){
	if(ShowRed || Falling || FadeToGameOver || GameOver || ShowMenu) other.DrawNight = false;
}

if(!Setup) exit;

if(Cfg.Rain){
	repeat(irandom_range(10,20)){
		instance_create_layer(irandom_range(oCamera.X, oCamera.X2), irandom_range(oCamera.Y, oCamera.Y2), "ObjsHighest", oRainDrop);
	}

	repeat(irandom_range(10,20)){
		instance_create_layer(irandom_range(oCamera.X, oCamera.X2), irandom_range(oCamera.Y, oCamera.Y2), "ObjsHighest", oRainSplash);
	}
}

if(Cfg.Leaves){
	repeat(irandom_range(5,12)){
		instance_create_layer(irandom_range(oCamera.X, oCamera.X2), irandom_range(oCamera.Y, oCamera.Y2), "ObjsHighest", oLeaf_Outside);
	}
}

Setup = false;
