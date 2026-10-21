
enum LinkCharacter{
	Link,
	Girl,
	Monkey,
	Frog,
	Fox,
	Penguin,
	Rabbit,	
	Wolf,
	Mouse	
}

#macro LinkCharacters 9



function LinkSprites_Load(){
	
	global.LinkCharacterSpr[LinkCharacter.Link] = (global.Xmas ? sLinkCharacter_Link_Xmas : sLinkCharacter_Link); 
	global.LinkCharacterSpr[LinkCharacter.Girl] = sLinkCharacter_Girl; 
	global.LinkCharacterSpr[LinkCharacter.Monkey] = sLinkCharacter_Monkey;
	global.LinkCharacterSpr[LinkCharacter.Frog] = sLinkCharacter_Frog; 
	global.LinkCharacterSpr[LinkCharacter.Fox] = sLinkCharacter_Fox; 
	global.LinkCharacterSpr[LinkCharacter.Penguin] = sLinkCharacter_Penguin; 
	global.LinkCharacterSpr[LinkCharacter.Rabbit] = sLinkCharacter_Rabbit;
	global.LinkCharacterSpr[LinkCharacter.Wolf] = sLinkCharacter_Wolf; 
	global.LinkCharacterSpr[LinkCharacter.Mouse] = sLinkCharacter_Mouse;

	global.LinkCharacterPal[LinkCharacter.Link] = (global.Xmas ? sPalette_Link_Xmas : sPalette_Link); ;
	global.LinkCharacterPal[LinkCharacter.Girl] = sPalette_Girl;
	global.LinkCharacterPal[LinkCharacter.Monkey] = sPalette_Monkey;
	global.LinkCharacterPal[LinkCharacter.Frog] = sPalette_Frog;
	global.LinkCharacterPal[LinkCharacter.Fox] = sPalette_Fox;
	global.LinkCharacterPal[LinkCharacter.Penguin] = sPalette_Penguin;
	global.LinkCharacterPal[LinkCharacter.Rabbit] = sPalette_Rabbit;
	global.LinkCharacterPal[LinkCharacter.Wolf] = sPalette_Wolf;
	global.LinkCharacterPal[LinkCharacter.Mouse] = sPalette_Mouse;
	
	for(var i = 0; i < 9; i++){
		
		var _ChrDir = GAMEDIR_DATA + "Characters\\" + string(i + 1);
		
		if (directory_exists(_ChrDir)){
			
			var _File = file_find_first(_ChrDir + "\\*.png", fa_none);
		    file_find_close();
			
			if(_File == "<null>" || _File == ""){	
				continue;
			}else{
				global.LinkCharacterSpr[i] = sprite_add(_ChrDir + "\\" + _File, 1, false, false, 0, 0); 
				global.LinkCharacterPal[i] = noone;	
			}
			
			var _PalDir = _ChrDir + "\\Pal";
			
			if (directory_exists(_PalDir)){
				
				var _File = file_find_first(_PalDir + "\\*.png", fa_none);
				file_find_close();
				
				if(_File == "<null>" || _File == ""){
					continue;					
				}else{
					global.LinkCharacterPal[i] = sprite_add(_PalDir + "\\" + _File, 1, false, false, 0, 0);;
				}
				
			}
		}
		
		
	}

}

function LinkSprites_Construct(_CharacterIndex){

	
	var SpriteSheet = global.LinkCharacterSpr[_CharacterIndex];

	
	#region Stand
	
		#region Stand Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Stand_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2 Stand Carrying
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 208,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 0);  //source head	
			sprite_add_from_surface(global.LinkSpr_Stand_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Stand_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Stand_Down, 0, spritespeed_framespersecond);
		
		#endregion

		#region Stand Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 32,    16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,     16, 16,   0, 0);    //source head	
			global.LinkSpr_Stand_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2 Stand Carrying
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 224,     16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 0);  //source head	
			sprite_add_from_surface(global.LinkSpr_Stand_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);		

			sprite_collision_mask(global.LinkSpr_Stand_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);	
			sprite_set_speed(global.LinkSpr_Stand_Up, 0, spritespeed_framespersecond);
		
		#endregion

		#region Stand Right
		
			var SprW = 18;
			var SprH = 24;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 16,    16, 16,   1, 8);     //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,     16, 16,   0, 0);     //source head	
			global.LinkSpr_Stand_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2 Stand Carrying
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 224,     16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   96, 176,    16, 16,   0, 0);  //source head	
			sprite_add_from_surface(global.LinkSpr_Stand_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);
				
			sprite_set_speed(global.LinkSpr_Stand_Right, 0, spritespeed_framespersecond);
			sprite_collision_mask(global.LinkSpr_Stand_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);	
			
		#endregion

		#region Stand Left
		
			var SprW = 18;
			var SprH = 24;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Stand_Right, 0,   9,21,   -1, 1, 0, c_white, 1); //flip Right sprite Hor	
			global.LinkSpr_Stand_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2 Stand Carrying
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Stand_Right, 1,   9,21,   -1, 1, 0, c_white, 1); //flip Right sprite Hor	
			sprite_add_from_surface(global.LinkSpr_Stand_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Stand_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);					
			sprite_set_speed(global.LinkSpr_Stand_Left, 0, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Walk
	
		#region Walk Down

			var SprW = 16;
			var SprH = 26;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   64, 16,   16, 16,   16, 10,   -1, 1,   c_white, 1);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			global.LinkSpr_Walk_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 16,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 288,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 4 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 288,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Down, SprSurface, 0, 0, SprW, SprH, false, false);		

			//frame 5 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 16,   16, 16,   0, 10);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   80, 16,   16, 16,   16, 10,  -1,1,  c_white, 1);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Down, SprSurface, 0, 0, SprW, SprH, false, false);			
			
			//frame 7 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   80, 288,   16, 16,   16, 10,   -1,1,  c_white,1);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 8
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   96, 288,   16, 16,   16, 10,   -1,1,  c_white,1);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Down, SprSurface, 0, 0, SprW, SprH, false, false);				
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Walk_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Walk_Down, 25, spritespeed_framespersecond);
		
		#endregion

		#region Walk Up

			var SprW = 16;
			var SprH = 26;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 16,   16, 16,   0, 10);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
			global.LinkSpr_Walk_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 32,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 288,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 304,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Up, SprSurface, 0, 0, SprW, SprH, false, false);		
			
			//frame 5 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 304,   16, 16,   0, 10);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 304,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Up, SprSurface, 0, 0, SprW, SprH, false, false);			
			
			//frame 7 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 304,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 8
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 304,   16, 16,  0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Up, SprSurface, 0, 0, SprW, SprH, false, false);				
		
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Walk_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);	
			sprite_set_speed(global.LinkSpr_Walk_Up, 25, spritespeed_framespersecond);
		
		#endregion
		
		#region Walk Right

			var SprW = 18;
			var SprH = 25;
			var OrigX = 9;
			var OrigY = 22;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 16,   16, 16,   1, 9);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 1);    //source head	
			global.LinkSpr_Walk_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, OrigX, OrigY);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 16,   16, 16,   1, 9);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Right, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 16,   16, 16,   0, 9);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 160,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 256,   16, 16,   1, 9);  //source body
			draw_sprite_part(SpriteSheet, 0,   64, 160,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Right, SprSurface, 0, 0, SprW, SprH, false, false);				
			
			//frame 5 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 288,   16, 16,   1, 9);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 272,   16, 16,   1,9);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 7 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 272,   16, 16,   0,9);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 160,    16, 16,   0, 0);    //source head
			sprite_add_from_surface(global.LinkSpr_Walk_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 8
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 288,   16, 16,   0,9);  //source body
			draw_sprite_part(SpriteSheet, 0,   64, 160,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_Right, SprSurface, 0, 0, SprW, SprH, false, false);				
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Walk_Right, false, 2,   1, 8, 16, 23,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Walk_Right, 25, spritespeed_framespersecond);
			
		#endregion

		#region Walk Left

			var SprW = 18;
			var SprH = 25;
			var OrigX = 9;
			var OrigY = 22;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);

			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Walk_Right, 0,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
			global.LinkSpr_Walk_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, OrigX, OrigY);
				
			for(var Frame = 1; Frame < 8; Frame++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Walk_Right, Frame,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
				sprite_add_from_surface(global.LinkSpr_Walk_Left, SprSurface, 0, 0, SprW, SprH, false, false);
				
			}
			
			surface_reset_target();		
			surface_free(SprSurface);
			
			sprite_collision_mask(global.LinkSpr_Walk_Left, false, 2,   1, 8, 16, 23,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Walk_Left, 25, spritespeed_framespersecond);
		
		#endregion
	
	#endregion
	
	#region Sword
	
		#region Sword Down
			
			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//frame 1,2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 80,   16, 32,   0,0);    //source body
			global.LinkSpr_Sword_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			sprite_add_from_surface(global.LinkSpr_Sword_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3,4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 32,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			repeat(2) sprite_add_from_surface(global.LinkSpr_Sword_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   64, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Sword_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6,7,8,9
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 432,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   64, 0,    16, 16,   0, 5);    //source head	
			repeat(4) sprite_add_from_surface(global.LinkSpr_Sword_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 10
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   64, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Sword_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 11,12,13,14
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 176,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 0,    16, 16,   0, 1);    //source head	
			repeat(4) sprite_add_from_surface(global.LinkSpr_Sword_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Sword_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Sword_Down, 60, spritespeed_framespersecond);
		
		#endregion

		#region Sword Up
			
			var SprW = 16;
			var SprH = 29;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//frame 1,2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 80,   16, 24,   0,5);    //source body
			global.LinkSpr_Sword_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 26);
			sprite_add_from_surface(global.LinkSpr_Sword_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3,4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 48,   16, 16,   0, 13);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 4);    //source head	
			repeat(2) sprite_add_from_surface(global.LinkSpr_Sword_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 48,   16, 16,   0, 13);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 3);    //source head	
			sprite_add_from_surface(global.LinkSpr_Sword_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6,7,8,9
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 432,   16, 16,   0, 13);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			repeat(4) sprite_add_from_surface(global.LinkSpr_Sword_Up, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 10
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 48,   16, 16,   0, 13);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 3);    //source head	
			sprite_add_from_surface(global.LinkSpr_Sword_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 11,12,13,14
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 176,   16, 16,   0, 13);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 5);    //source head	
			repeat(4) sprite_add_from_surface(global.LinkSpr_Sword_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Sword_Up, false, 2,   0, 12, 15, 27,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Sword_Up, 60, spritespeed_framespersecond);
		
		#endregion
		
		#region Sword Right
			
			var SprW = 23;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//frame 1,2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 32,   16, 16,   1,8);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 1);    //source head
			global.LinkSpr_Sword_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
			sprite_add_from_surface(global.LinkSpr_Sword_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3,4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 32,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 1);    //source head	
			repeat(2) sprite_add_from_surface(global.LinkSpr_Sword_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 32,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   2, 2);    //source head	
			draw_sprite_part(SpriteSheet, 0,   96, 408,   8, 8,   12, 12);    //source arm	
			sprite_add_from_surface(global.LinkSpr_Sword_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6,7,8,9
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 416,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   5, 2);    //source head
			draw_sprite_part(SpriteSheet, 0,   96, 408,   8, 8,   16, 12);    //source arm	
			repeat(4) sprite_add_from_surface(global.LinkSpr_Sword_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 10
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 32,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   2, 2);    //source head	
			draw_sprite_part(SpriteSheet, 0,   96, 408,   8, 8,   12, 12);    //source arm	
			sprite_add_from_surface(global.LinkSpr_Sword_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 11,12,13,14
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 32,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 1);    //source head	
			repeat(4) sprite_add_from_surface(global.LinkSpr_Sword_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Sword_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Sword_Right, 60, spritespeed_framespersecond);
		
		#endregion

		#region Sword Left

			var SprW = 23;
			var SprH = 24;
			var OrigX = 14;
			var OrigY = 21;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);

			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Sword_Right, 0,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
			global.LinkSpr_Sword_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, OrigX, OrigY);
				
			for(var Frame = 1; Frame < 14; Frame++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Sword_Right, Frame,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
				sprite_add_from_surface(global.LinkSpr_Sword_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Sword_Left, false, 2,   6, 7, 21, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Sword_Left, 60, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Sword Poke
		
		#region Sword Poke Down

			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//frame 0
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 208,   16, 16,   0,8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,   16, 16,   0,2);    //source head
			global.LinkSpr_SwordPoke_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			//frame 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 96,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 64,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_SwordPoke_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordPoke_Down, 0, 8, 21); //same as frame 1
			sprite_add_from_surface(global.LinkSpr_SwordPoke_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_SwordPoke_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordPoke_Down, 16, spritespeed_framespersecond);
		
		#endregion

		#region Sword Poke Up

			var SprW = 16;
			var SprH = 26;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//frame 0
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 176,   16, 16,   0,10);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,   16, 16,   0,2);    //source head
			global.LinkSpr_SwordPoke_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 23);
			
			//frame 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 48,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_SwordPoke_Up, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 80,   16, 16,   0, 10);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_SwordPoke_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_SwordPoke_Up, false, 2,   0, 9, 15, 24,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordPoke_Up, 16, spritespeed_framespersecond);
		
		#endregion

		#region Sword Poke Right

			var SprW = 18;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//frame 0
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 208,   16, 16,   1,8);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,   16, 16,   1,1);    //source head
			global.LinkSpr_SwordPoke_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
			
			//frame 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 80,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   2, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_SwordPoke_Right, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 208,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_SwordPoke_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_SwordPoke_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordPoke_Right, 16, spritespeed_framespersecond);
		
		#endregion

		#region Sword Poke Left

			var SprW = 18;
			var SprH = 24;
			var OrigX = 9;
			var OrigY = 21;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);

			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_SwordPoke_Right, 0,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
			global.LinkSpr_SwordPoke_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, OrigX, OrigY);
				
			for(var Frame = 1; Frame < 3; Frame++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_SwordPoke_Right, Frame,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
				sprite_add_from_surface(global.LinkSpr_SwordPoke_Left, SprSurface, 0, 0, SprW, SprH, false, false);
				
			}
			
			surface_reset_target();		
			surface_free(SprSurface);
			
			sprite_collision_mask(global.LinkSpr_SwordPoke_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordPoke_Left, 16, spritespeed_framespersecond);
		
		#endregion		
		
	#endregion
	
	#region Push

		#region Down
			
			var SprW = 18;
			var SprH = 25;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 368,   16, 16,   1, 9);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 320,    16, 16,   1, 3);    //source head	
			global.LinkSpr_Push_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 23);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 368,   16, 16,   1, 9);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 320,    16, 16,   1, 4);    //source head	
			sprite_add_from_surface(global.LinkSpr_Push_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 368,   16, 16,   1, 9);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 320,    16, 16,   1, 5);    //source head	
			sprite_add_from_surface(global.LinkSpr_Push_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Push_Down, false, 2,   1, 9, 16, 24,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Push_Down, 8, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 18;
			var SprH = 25;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 64,    16, 16,   1, 2);    //source head	
			draw_sprite_part(SpriteSheet, 0,   48, 192,   16, 16,   1, 9);    //source body			
			global.LinkSpr_Push_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 64,    16, 16,   1, 3);    //source head	
			draw_sprite_part(SpriteSheet, 0,   64, 192,   16, 16,   1, 9);  //source body
			sprite_add_from_surface(global.LinkSpr_Push_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 64,    16, 16,   1, 4);    //source head	
			draw_sprite_part(SpriteSheet, 0,   80, 192,   16, 16,   1, 9);  //source body
			sprite_add_from_surface(global.LinkSpr_Push_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Push_Up, 0, 9, 21); //same as frame 0
			sprite_add_from_surface(global.LinkSpr_Push_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Push_Up, 1, 9, 21, -1, 1, 0, c_white, 1); //same as frame 1 mirrored
			sprite_add_from_surface(global.LinkSpr_Push_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Push_Up, 2, 9, 21, -1, 1, 0, c_white, 1); //same as frame 2
			sprite_add_from_surface(global.LinkSpr_Push_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Push_Up, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Push_Up, 8, spritespeed_framespersecond);
		
		#endregion

		#region Right
		
			var SprW = 18;
			var SprH = 25;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 368,  16, 16,   1, 8);     //source body
			draw_sprite_part(SpriteSheet, 0,   16, 320,  16, 16,   1, 0);     //source head	
			global.LinkSpr_Push_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 22);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 368,  16, 16,   1, 8);     //source body
			draw_sprite_part(SpriteSheet, 0,   16, 320,  16, 16,   1, 1);     //source head	
			sprite_add_from_surface(global.LinkSpr_Push_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 368,  16, 16,   1, 8);     //source body
			draw_sprite_part(SpriteSheet, 0,   16, 320,  16, 16,   1, 2);     //source head	
			sprite_add_from_surface(global.LinkSpr_Push_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4 (same as frame 0)
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Push_Right, 0, 9, 22);
			sprite_add_from_surface(global.LinkSpr_Push_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5 (same as frame 1)
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Push_Right, 1, 9, 22);
			sprite_add_from_surface(global.LinkSpr_Push_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);
				
			sprite_set_speed(global.LinkSpr_Push_Right, 8, spritespeed_framespersecond);
			sprite_collision_mask(global.LinkSpr_Push_Right, false, 2,   1, 8, 16, 23,   bboxkind_rectangular, 0);	
			
		#endregion

		#region Left
		
			var SprW = 18;
			var SprH = 25;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);

			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Push_Right, 0, 9, 22, -1, 1, 0, c_white, 1);
			global.LinkSpr_Push_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 22);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_Push_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Push_Right, i, 9, 22, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_Push_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);
				
			sprite_set_speed(global.LinkSpr_Push_Left, 8, spritespeed_framespersecond);
			sprite_collision_mask(global.LinkSpr_Push_Left, false, 2,   1, 8, 16, 23,   bboxkind_rectangular, 0);	
		
		#endregion
		
	#endregion

	#region Carrying

		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 208,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Carrying_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);

			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 224,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 224,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Carrying_Down, 0, 8, 21);
			sprite_add_from_surface(global.LinkSpr_Carrying_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 224,   16, 16,   16, 8, -1, 1, c_white, 1);  //source body
			draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 224,   16, 16,   16, 8, -1, 1, c_white, 1);  //source body
			draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Carrying_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Carrying_Down, 12, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 224,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Carrying_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);

			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 224,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 224,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Carrying_Up, 0, 8, 21);
			sprite_add_from_surface(global.LinkSpr_Carrying_Up, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   96, 224,   16, 16,   16, 8, -1, 1, c_white, 1);  //source body
			draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   112, 224,   16, 16,   16, 8, -1, 1, c_white, 1);  //source body
			draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Carrying_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Carrying_Up, 12, spritespeed_framespersecond);
		
		#endregion

		#region Right

			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 224,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   96, 176,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Carrying_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);

			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 224,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   96, 176,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 224,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   96, 176,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Carrying_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Carrying_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Carrying_Right, 12, spritespeed_framespersecond);
			
		#endregion

		#region Left
		
			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Carrying_Right, 0, 9, 21, -1, 1, 0, c_white, 1);
			global.LinkSpr_Carrying_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_Carrying_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Carrying_Right, i, 9, 21, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_Carrying_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Carrying_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Carrying_Left, 12, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Throwing

		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 208,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Throwing_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Throwing_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Throwing_Down, SprSurface, 0, 0, SprW, SprH, false, false);


			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Throwing_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Throwing_Down, 12, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 224,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Throwing_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Throwing_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 32,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Throwing_Up, SprSurface, 0, 0, SprW, SprH, false, false);


			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Throwing_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Throwing_Up, 12, spritespeed_framespersecond);
		
		#endregion

		#region Right

			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 224,   16, 16,   1, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   96, 176,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Throwing_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 192,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Throwing_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 16,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Throwing_Right, SprSurface, 0, 0, SprW, SprH, false, false);


			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Throwing_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Throwing_Right, 12, spritespeed_framespersecond);
			
		#endregion

		#region Left
		
			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Throwing_Right, 0, 9, 21, -1, 1, 0, c_white, 1);
			global.LinkSpr_Throwing_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_Throwing_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Throwing_Right, i, 9, 21, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_Throwing_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Throwing_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Throwing_Left, 12, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Pickup

		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 64,    16, 16,   0, 3);    //source head	
			global.LinkSpr_PickUp_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2-4
			repeat(3){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 8);  //source body
				draw_sprite_part(SpriteSheet, 0,   0, 320,    16, 16,   0, 4);    //source head	
				sprite_add_from_surface(global.LinkSpr_PickUp_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			//frame 5-6
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_part(SpriteSheet, 0,   112, 208,   16, 16,   0, 8);  //source body
				draw_sprite_part(SpriteSheet, 0,   80, 176,    16, 16,   0, 0);    //source head	
				sprite_add_from_surface(global.LinkSpr_PickUp_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_PickUp_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_PickUp_Down, 16, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 320,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 320,    16, 16,   0, 2);    //source head	
			global.LinkSpr_PickUp_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2-4
			repeat(3){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_part(SpriteSheet, 0,   0, 336,   16, 16,   0, 8);  //source body
				draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
				sprite_add_from_surface(global.LinkSpr_PickUp_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			//frame 5-6
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_part(SpriteSheet, 0,   80, 224,   16, 16,   0, 8);  //source body
				draw_sprite_part(SpriteSheet, 0,   112, 176,    16, 16,   0, 0);    //source head	
				sprite_add_from_surface(global.LinkSpr_PickUp_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_PickUp_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_PickUp_Up, 16, spritespeed_framespersecond);
		
		#endregion

		#region Right

			var SprW = 19;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 320,   16, 16,   1, 9);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 64,    16, 16,   2, 3);    //source head	
			global.LinkSpr_PickUp_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2-4
			repeat(3){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_part(SpriteSheet, 0,   96, 320,   16, 16,   1, 9);  //source body
				draw_sprite_part(SpriteSheet, 0,   16, 320,    16, 16,   0, 2);    //source head	
				sprite_add_from_surface(global.LinkSpr_PickUp_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			//frame 5-6
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_part(SpriteSheet, 0,   32, 224,   16, 16,   1, 9);  //source body
				draw_sprite_part(SpriteSheet, 0,   96, 176,    16, 16,   0, 1);    //source head	
				sprite_add_from_surface(global.LinkSpr_PickUp_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_PickUp_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_PickUp_Right, 16, spritespeed_framespersecond);
			
		#endregion

		#region Left
		
			var SprW = 19;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_PickUp_Right, 0, 10, 21, -1, 1, 0, c_white, 1);
			global.LinkSpr_PickUp_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 10, 21);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_PickUp_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_PickUp_Right, i, 10, 21, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_PickUp_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_PickUp_Left, false, 2,   2, 7, 17, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_PickUp_Left, 16, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Boomerang
		
		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 256,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			global.LinkSpr_Boomerang_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Boomerang_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Boomerang_Down, 1, 8, 21);
			sprite_add_from_surface(global.LinkSpr_Boomerang_Down, SprSurface, 0, 0, SprW, SprH, false, false);


			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Boomerang_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Boomerang_Down, 8, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 272,   16, 24,   0, 0);   
			global.LinkSpr_Boomerang_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 256,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Boomerang_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Boomerang_Up, 1, 8, 21);
			sprite_add_from_surface(global.LinkSpr_Boomerang_Up, SprSurface, 0, 0, SprW, SprH, false, false);


			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Boomerang_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Boomerang_Up, 8, spritespeed_framespersecond);
		
		#endregion

		#region Right

			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 296,   16, 24,   0, 0); 
			global.LinkSpr_Boomerang_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 32,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Boomerang_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_Boomerang_Right, 1, 9, 21);
			sprite_add_from_surface(global.LinkSpr_Boomerang_Right, SprSurface, 0, 0, SprW, SprH, false, false);


			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Boomerang_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Boomerang_Right, 8, spritespeed_framespersecond);
			
		#endregion

		#region Left
		
			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Boomerang_Right, 0, 9, 21, -1, 1, 0, c_white, 1);
			global.LinkSpr_Boomerang_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_Boomerang_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Boomerang_Right, i, 9, 21, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_Boomerang_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Boomerang_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Boomerang_Left, 8, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Bow

		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Bow_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 16,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Bow_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 240,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Bow_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4-6
			repeat(3){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Bow_Down, 2, 8, 21);
				sprite_add_from_surface(global.LinkSpr_Bow_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Bow_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Bow_Down, 32, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 32,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Bow_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Bow_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 240,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Bow_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4-6
			repeat(3){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Bow_Up, 2, 8, 21);
				sprite_add_from_surface(global.LinkSpr_Bow_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Bow_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Bow_Up, 32, spritespeed_framespersecond);
		
		#endregion

		#region Right

			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 192,   16, 16,   1, 7);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Bow_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 32,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Bow_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 240,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Bow_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4-6
			repeat(3){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Bow_Right, 2, 9, 21);
				sprite_add_from_surface(global.LinkSpr_Bow_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Bow_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Bow_Right, 32, spritespeed_framespersecond);
			
		#endregion

		#region Left
		
			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Bow_Right, 0, 9, 21, -1, 1, 0, c_white, 1);
			global.LinkSpr_Bow_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_Bow_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Bow_Right, i, 9, 21, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_Bow_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Bow_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Bow_Left, 32, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
		
	#region Hookshot
	
		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 48,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			global.LinkSpr_Hookshot_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Hookshot_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Hookshot_Down, 0, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 256,    16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,     16, 16,   0, 0);    //source head	
			global.LinkSpr_Hookshot_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);

			surface_reset_target();		
			surface_free(SprSurface);		

			sprite_collision_mask(global.LinkSpr_Hookshot_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);	
			sprite_set_speed(global.LinkSpr_Hookshot_Up, 0, spritespeed_framespersecond);
		
		#endregion

		#region Right
		
			var SprW = 18;
			var SprH = 24;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 32,    16, 16,   1, 8);     //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,     16, 16,   0, 1);     //source head	
			global.LinkSpr_Hookshot_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);

			surface_reset_target();		
			surface_free(SprSurface);
				
			sprite_set_speed(global.LinkSpr_Hookshot_Right, 0, spritespeed_framespersecond);
			sprite_collision_mask(global.LinkSpr_Hookshot_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);	
			
		#endregion

		#region Left
		
			var SprW = 18;
			var SprH = 24;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Hookshot_Right, 0,   9,21,   -1, 1, 0, c_white, 1); //flip Right sprite Hor	
			global.LinkSpr_Hookshot_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Hookshot_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);					
			sprite_set_speed(global.LinkSpr_Hookshot_Left, 0, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Rod

		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   24, 104,   16, 24,   0, 0);
			global.LinkSpr_Rod_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 208,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Rod_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Rod_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4-5
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Rod_Down, 2, 8, 21);
				sprite_add_from_surface(global.LinkSpr_Rod_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Rod_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Rod_Down, 16, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   56, 104,   16, 24,   0, 0);
			global.LinkSpr_Rod_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 20);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Rod_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 208,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Rod_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4-5
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Rod_Up, 2, 8, 20);
				sprite_add_from_surface(global.LinkSpr_Rod_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Rod_Up, false, 2,   0, 6, 15, 21,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Rod_Up, 16, spritespeed_framespersecond);
		
		#endregion

		#region Right

			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   40, 104,   16, 24,   0, 0);
			global.LinkSpr_Rod_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 32,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Rod_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 208,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Rod_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4-5
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Rod_Right, 2, 9, 21);
				sprite_add_from_surface(global.LinkSpr_Rod_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Rod_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Rod_Right, 16, spritespeed_framespersecond);
			
		#endregion

		#region Left
		
			var SprW = 18;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Rod_Right, 0, 9, 21, -1, 1, 0, c_white, 1);
			global.LinkSpr_Rod_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_Rod_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Rod_Right, i, 9, 21, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_Rod_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Rod_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Rod_Left, 16, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Powder

		#region Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 80,   16, 24,   0, 0);
			global.LinkSpr_Powder_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 32,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 176,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   48, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5-6
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Powder_Down, 3, 8, 21);
				sprite_add_from_surface(global.LinkSpr_Powder_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Powder_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Powder_Down, 12, spritespeed_framespersecond);
		
		#endregion

		#region Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 80,   16, 24,   0, 0);
			global.LinkSpr_Powder_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 48,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Up, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 176,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5-6
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Powder_Up, 3, 8, 21);
				sprite_add_from_surface(global.LinkSpr_Powder_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Powder_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Powder_Up, 12, spritespeed_framespersecond);
		
		#endregion

		#region Right

			var SprW = 17;
			var SprH = 22;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 32,   16, 16,   1, 6);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, -1);    //source head	
			global.LinkSpr_Powder_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 19);
	
			//frame 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 32,   16, 16,   1, 6);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 32,   16, 16,   1, 6);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Right, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 32,   16, 16,   1, 6);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Powder_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5-6
			repeat(2){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite(global.LinkSpr_Powder_Right, 3, 9, 19);
				sprite_add_from_surface(global.LinkSpr_Powder_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			}
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Powder_Right, false, 2,   1, 5, 16, 20,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Powder_Right, 12, spritespeed_framespersecond);
			
		#endregion

		#region Left
		
			var SprW = 17;
			var SprH = 22;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Powder_Right, 0, 8, 19, -1, 1, 0, c_white, 1);
			global.LinkSpr_Powder_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 19);
				
			for(var i = 1; i < sprite_get_number(global.LinkSpr_Powder_Right); i++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Powder_Right, i, 8, 19, -1, 1, 0, c_white, 1);
				sprite_add_from_surface(global.LinkSpr_Powder_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			}

			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Powder_Left, false, 2,   0, 5, 15, 20,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Powder_Left, 12, spritespeed_framespersecond);
		
		#endregion
		
	#endregion
	
	#region Hurt
		
		#region Down

			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 80,   SprW, SprH,   0,0);  
			global.LinkSpr_Hurt_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);
			
			sprite_collision_mask(global.LinkSpr_Hurt_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Hurt_Down, 0, spritespeed_framespersecond);
		
		#endregion
		
		#region Up

			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 80,   SprW, SprH,   0,0);   
			global.LinkSpr_Hurt_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);
			
			sprite_collision_mask(global.LinkSpr_Hurt_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Hurt_Up, 0, spritespeed_framespersecond);
			
		#endregion
		
		#region Right

			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 80,   SprW, SprH,   0,0);  
			global.LinkSpr_Hurt_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);
			
			sprite_collision_mask(global.LinkSpr_Hurt_Right, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Hurt_Right, 0, spritespeed_framespersecond);
			
		#endregion
		
		#region Left

			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Hurt_Right, 0,   8,21,   -1, 1, 0, c_white, 1); //flip Right sprite Hor	
			global.LinkSpr_Hurt_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);
			
			sprite_collision_mask(global.LinkSpr_Hurt_Left, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Hurt_Left, 0, spritespeed_framespersecond);
			
		#endregion
		
	#endregion
	
	#region Dead

		var SprW = 24;
		var SprH = 32;
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
		
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   88, 144,    16, 16,   0, 8);  //body
		draw_sprite_part(SpriteSheet, 0,   32, 64,    16, 16,   2, 0);  //head
		global.LinkSpr_Dead = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 22);
		
		//15,22
		
		//frame 2 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite(sLinkDeadFallHit, 0,   15, 22);  //fall hit effect
		draw_sprite_part(SpriteSheet, 0,   104, 144,    24, 16,   0, 7);  
		sprite_add_from_surface(global.LinkSpr_Dead, SprSurface, 0, 0, SprW, SprH, false, false);
			
		//frame 3 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   104, 144,    24, 16,   0, 7);  
		sprite_add_from_surface(global.LinkSpr_Dead, SprSurface, 0, 0, SprW, SprH, false, false);			
			
		surface_reset_target();		
		surface_free(SprSurface);
		
		sprite_set_speed(global.LinkSpr_Dead, 12, spritespeed_framespersecond);
		
	#endregion
	
	#region Falling

		var SprW = 24;
		var SprH = 24;
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
		
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   0, 104,    24, 24,   0, 0); 
		global.LinkSpr_Falling = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 12, 12);
			
		//frame 2 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   80, 64,    16, 16,   4, 4);  
		sprite_add_from_surface(global.LinkSpr_Falling, SprSurface, 0, 0, SprW, SprH, false, false);

		//frame 3 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   96, 64,    16, 16,   4, 4);
		sprite_add_from_surface(global.LinkSpr_Falling, SprSurface, 0, 0, SprW, SprH, false, false);
			
		//frame 4 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   72, 112,    8, 8,   8, 8);
		sprite_add_from_surface(global.LinkSpr_Falling, SprSurface, 0, 0, SprW, SprH, false, false);
			
		//frame 5 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   72, 120,    8, 8,   8, 8);
		sprite_add_from_surface(global.LinkSpr_Falling, SprSurface, 0, 0, SprW, SprH, false, false);
			
		//frame 6 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   72, 104,    8, 8,   8, 8);
		sprite_add_from_surface(global.LinkSpr_Falling, SprSurface, 0, 0, SprW, SprH, false, false);
			
		surface_reset_target();		
		surface_free(SprSurface);
			
		sprite_set_speed(global.LinkSpr_Falling, 6, spritespeed_framespersecond);
		
	#endregion
	
	#region Shock

		var SprW = 16;
		var SprH = 24;
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
		
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   0, 296,    SprW, SprH,   0, 0); 
		global.LinkSpr_Shock = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
		//frame 2 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   0, 272,    SprW, SprH,   0, 0);  
		sprite_add_from_surface(global.LinkSpr_Shock, SprSurface, 0, 0, SprW, SprH, false, false);
			
		//frame 3 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   0, 296,    SprW, SprH,   0, 0);  
		sprite_add_from_surface(global.LinkSpr_Shock, SprSurface, 0, 0, SprW, SprH, false, false);

		//frame 4 
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   0, 272,    SprW, SprH,   0, 0);  
		sprite_add_from_surface(global.LinkSpr_Shock, SprSurface, 0, 0, SprW, SprH, false, false);
			
			
		surface_reset_target();		
		surface_free(SprSurface);
		
		sprite_collision_mask(global.LinkSpr_Shock, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)	
		sprite_set_speed(global.LinkSpr_Shock, 12, spritespeed_framespersecond);
		
	#endregion
	
	#region Star 

		var SprW = 18;
		var SprH = 24;
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
		
		//Frame 1 Down 1
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   48, 240,    16, 16,   1, 8); //body
		draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   1, 0);   //head
		global.LinkSpr_Star = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21); 
			
		//frame 2 Down 2
		draw_clear_alpha(c_black, 0.0);
		draw_sprite(global.LinkSpr_Star, 0, 9, 21);
		sprite_add_from_surface(global.LinkSpr_Star, SprSurface, 0, 0, SprW, SprH, false, false);
			
		//frame 3 Left 1
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part_ext(SpriteSheet, 0,   0, 16,    16, 16,   17, 8, -1, 1, c_white, 1); //body
		draw_sprite_part_ext(SpriteSheet, 0,   0, 0,    16, 16,   18, 0, -1, 1, c_white, 1); //Head
		sprite_add_from_surface(global.LinkSpr_Star, SprSurface, 0, 0, SprW, SprH, false, false);
		
		//frame 4 Left 2
		draw_clear_alpha(c_black, 0.0);
		draw_sprite(global.LinkSpr_Star, 2, 9, 21);
		sprite_add_from_surface(global.LinkSpr_Star, SprSurface, 0, 0, SprW, SprH, false, false);
			
		//frame 5 Up 1
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   32, 240,    16, 16,   1, 8); //body
		draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   1, 0); //Head
		sprite_add_from_surface(global.LinkSpr_Star, SprSurface, 0, 0, SprW, SprH, false, false);
		
		//frame 6 Up 2
		draw_clear_alpha(c_black, 0.0);
		draw_sprite(global.LinkSpr_Star, 4, 9, 21);
		sprite_add_from_surface(global.LinkSpr_Star, SprSurface, 0, 0, SprW, SprH, false, false);
		
		//frame 7 Right 1
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_ext(global.LinkSpr_Star, 2, 9, 21, -1, 1, 0, c_white, 1); //Head
		sprite_add_from_surface(global.LinkSpr_Star, SprSurface, 0, 0, SprW, SprH, false, false);
		
		//frame 8 Right 2
		draw_clear_alpha(c_black, 0.0);
		draw_sprite(global.LinkSpr_Star, 6, 9, 21);
		sprite_add_from_surface(global.LinkSpr_Star, SprSurface, 0, 0, SprW, SprH, false, false);
		
		surface_reset_target();		
		surface_free(SprSurface);
		
		sprite_collision_mask(global.LinkSpr_Star, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
		sprite_set_speed(global.LinkSpr_Star, 32, spritespeed_framespersecond);
		
	#endregion

	#region Stand Sword Spin Charge
	
		#region Stand Sword Spin Charge Down
			
			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 192,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			global.LinkSpr_Stand_SwordCharge_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Stand_SwordCharge_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
			sprite_set_speed(global.LinkSpr_Stand_SwordCharge_Down, 0, spritespeed_framespersecond);
		
		#endregion

		#region Stand Sword Spin Charge Up

			var SprW = 16;
			var SprH = 24;	
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 192,    16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,     16, 16,   0, 0);    //source head	
			global.LinkSpr_Stand_SwordCharge_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);		

			sprite_collision_mask(global.LinkSpr_Stand_SwordCharge_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);	
			sprite_set_speed(global.LinkSpr_Stand_SwordCharge_Up, 0, spritespeed_framespersecond);
		
		#endregion

		#region Stand Sword Spin Charge Right
		
			var SprW = 18;
			var SprH = 24;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 192,    16, 16,   1, 8);     //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,     16, 16,   0, 0);     //source head	
			global.LinkSpr_Stand_SwordCharge_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);
				
			sprite_set_speed(global.LinkSpr_Stand_SwordCharge_Right, 0, spritespeed_framespersecond);
			sprite_collision_mask(global.LinkSpr_Stand_SwordCharge_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);	
			
		#endregion

		#region Stand Sword Spin Charge Left
		
			var SprW = 18;
			var SprH = 24;		
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Stand_SwordCharge_Right, 0,   9,21,   -1, 1, 0, c_white, 1); //flip Right sprite Hor	
			global.LinkSpr_Stand_SwordCharge_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Stand_SwordCharge_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);					
			sprite_set_speed(global.LinkSpr_Stand_SwordCharge_Left, 0, spritespeed_framespersecond);
		
		#endregion
		
	#endregion

	#region Walk Spin Charge
	
		#region Walk Spin Charge Down

			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 192,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			global.LinkSpr_Walk_SwordCharge_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Down, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 4 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 432,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Down, SprSurface, 0, 0, SprW, SprH, false, false);		

			//frame 5 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 432,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Down, SprSurface, 0, 0, SprW, SprH, false, false);			
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Walk_SwordCharge_Down, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Walk_SwordCharge_Down, 12, spritespeed_framespersecond);
		
		#endregion

		#region Walk Spin Charge Up

			var SprW = 16;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 192,   16, 16,   0, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 1);    //source head	
			global.LinkSpr_Walk_SwordCharge_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 192,   16, 16,   0, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 4 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   64, 192,   16, 16,   16, 8,   -1,1,  c_white,1);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Up, SprSurface, 0, 0, SprW, SprH, false, false);		
			
			//frame 5 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   80, 192,   16, 16,   16, 8,   -1,1,  c_white,1);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   48, 192,   16, 16,   16, 8,   -1,1,  c_white,1);  //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Up, SprSurface, 0, 0, SprW, SprH, false, false);			
		
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Walk_SwordCharge_Up, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);	
			sprite_set_speed(global.LinkSpr_Walk_SwordCharge_Up, 12, spritespeed_framespersecond);
		
		#endregion
		
		#region Walk Spin Charge Right

			var SprW = 18;
			var SprH = 24;
			var OrigX = 9;
			var OrigY = 21;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 336,   16, 16,   1, 8);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 1);    //source head	
			global.LinkSpr_Walk_SwordCharge_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, OrigX, OrigY);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   112, 192,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Right, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 192,   16, 16,   1, 8);  //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Right, SprSurface, 0, 0, SprW, SprH, false, false);		
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Walk_SwordCharge_Right, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Walk_SwordCharge_Right, 12, spritespeed_framespersecond);
			
		#endregion

		#region Walk Spin Charge Left

			var SprW = 18;
			var SprH = 24;
			var OrigX = 9;
			var OrigY = 21;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);

			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_Walk_SwordCharge_Right, 0,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
			global.LinkSpr_Walk_SwordCharge_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, OrigX, OrigY);
				
			for(var Frame = 1; Frame < 3; Frame++){
				draw_clear_alpha(c_black, 0.0);
				draw_sprite_ext(global.LinkSpr_Walk_SwordCharge_Right, Frame,   OrigX, OrigY,   -1,1, 0,c_white,1);    //flip right sprite hor
				sprite_add_from_surface(global.LinkSpr_Walk_SwordCharge_Left, SprSurface, 0, 0, SprW, SprH, false, false);
				
			}
			
			surface_reset_target();		
			surface_free(SprSurface);
			
			sprite_collision_mask(global.LinkSpr_Walk_SwordCharge_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_Walk_SwordCharge_Left, 12, spritespeed_framespersecond);
		
		#endregion
	
	#endregion
	
	#region Sword Spin
		
		#region Down
			
			var SprW = 18;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//Frame 0 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   96, 32,    16, 16,   17, 8, -1, 1, c_white, 1); //body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   1, 1);   //head
			global.LinkSpr_SwordSpin_Down = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21); 
			
			//frame 1 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 80,    16, 24,   17, 0, -1, 1, c_white, 1); //body
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 2 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Down, 1, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 3 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Down, 0, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 4 Down 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 240,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   1, 0);   //head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 5 Down 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Down, 4, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6 Left 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 16,    16, 16,   17, 8, -1, 1, c_white, 1); //body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,    16, 16,   18, 0, -1, 1, c_white, 1); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 7 Left 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Down, 6, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 8 Up 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 240,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   1, 0); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 9 Up 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Down, 8, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 10 Right 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_SwordSpin_Down, 6, 9, 21, -1, 1, 0, c_white, 1);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 11 Right 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Down, 10, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 12 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Down, 0, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Down, SprSurface, 0, 0, SprW, SprH, false, false);
		
			surface_reset_target();		
			surface_free(SprSurface);
		
			sprite_collision_mask(global.LinkSpr_SwordSpin_Down, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordSpin_Down, 32, spritespeed_framespersecond);			
		
		#endregion

		#region Up
			
			var SprW = 18;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//Frame 0 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 48,    16, 16,   17, 8, -1, 1, c_white, 1); //body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   1, 0);   //head
			global.LinkSpr_SwordSpin_Up = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21); 
			
			//frame 1 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 80,    16, 24,   17, 0, -1, 1, c_white, 1); //body
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 2 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Up, 1, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 3 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Up, 0, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 4 Up 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 240,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   1, 0); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 5 Up 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Up, 4, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6 Right 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 16,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 7 Right 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Up, 6, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 8 Down 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 240,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   1, 0);   //head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 9 Down 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Up, 8, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 10 Left 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 16,    16, 16,   17, 8, -1, 1, c_white, 1); //body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,    16, 16,   18, 0, -1, 1, c_white, 1); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 11 Left 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Up, 10, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 12 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Up, 0, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Up, SprSurface, 0, 0, SprW, SprH, false, false);
		
			surface_reset_target();		
			surface_free(SprSurface);
		
			sprite_collision_mask(global.LinkSpr_SwordSpin_Up, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordSpin_Up, 32, spritespeed_framespersecond);			
		
		#endregion
		
		#region Right
			
			var SprW = 19;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//Frame 0 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 128,    16, 16,   2, 8); //body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 0);   //head
			global.LinkSpr_SwordSpin_Right = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 10, 21); 
			
			//frame 1 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 240,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   0, 0);   //head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 2 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Right, 1, 10, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 3 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Right, 0, 10, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 4 Right 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 16,    16, 16,   2, 8); //body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   1, 0); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 5 Right 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Right, 4, 10, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 6 Down 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 240,    16, 16,   2, 8); //body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   2, 0);   //head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 7 Down 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Right, 6, 10, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 8 Left 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_SwordSpin_Right, 4, 10, 21, -1, 1, 0, c_white, 1);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 9 Left 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Right, 8, 10, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 10 Up 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 240,    16, 16,   2, 8); //body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   2, 0); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 11 Up 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Right, 10, 10, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 12
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Right, 0, 10, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Right, SprSurface, 0, 0, SprW, SprH, false, false);
		
			surface_reset_target();		
			surface_free(SprSurface);
		
			sprite_collision_mask(global.LinkSpr_SwordSpin_Right, false, 2,   2, 7, 17, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordSpin_Right, 32, spritespeed_framespersecond);			
		
		#endregion

		#region Left

			var SprW = 19;
			var SprH = 24;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//Frame 0 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 128,    16, 16,   1, 8); //body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,    16, 16,   18, 0, -1, 1, c_white, 1);   //head
			global.LinkSpr_SwordSpin_Left = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 9, 21); 
			
			//frame 1 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 128,    16, 16,   2, 8); //body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,    16, 16,   19, 0, -1, 1, c_white, 1);   //head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 2 Wind 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Left, 1, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 3 Wind 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Left, 0, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 4 Left 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 16,    16, 16,   17, 8, -1, 1, c_white, 1); //body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,    16, 16,   18, 0, -1, 1, c_white, 1); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 5 Left 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Left, 4, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6 Up 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 240,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   1, 0); //Head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 7 Up 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Left, 6, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 8 Right 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_ext(global.LinkSpr_SwordSpin_Left, 4, 9, 21, -1, 1, 0, c_white, 1);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 9 Right 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Left, 8, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);

			//Frame 10 Down 1
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 240,    16, 16,   1, 8); //body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   1, 0);   //head
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 11 Down 2
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Left, 10, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			//frame 12
			draw_clear_alpha(c_black, 0.0);
			draw_sprite(global.LinkSpr_SwordSpin_Left, 0, 9, 21);
			sprite_add_from_surface(global.LinkSpr_SwordSpin_Left, SprSurface, 0, 0, SprW, SprH, false, false);
		
			surface_reset_target();		
			surface_free(SprSurface);
		
			sprite_collision_mask(global.LinkSpr_SwordSpin_Left, false, 2,   1, 7, 16, 22,   bboxkind_rectangular, 0);
			sprite_set_speed(global.LinkSpr_SwordSpin_Left, 32, spritespeed_framespersecond);	
		
		#endregion
		
	#endregion
	
	#region Holding Item
			
		var SprW = 16;
		var SprH = 24;
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
			
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   32, 176,   16, 16,   0,8);    //source body
		draw_sprite_part(SpriteSheet, 0,   16, 176,   16, 16,   0,0);    //source head
		global.LinkSpr_HoldingItem = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
		surface_reset_target();		
		surface_free(SprSurface);

		sprite_collision_mask(global.LinkSpr_HoldingItem, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);			
		sprite_set_speed(global.LinkSpr_HoldingItem, 0, spritespeed_framespersecond);
		
	#endregion
		
	#region Holding Item 2 (Ending triforce)
			
		var SprW = 16;
		var SprH = 24;
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
			
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   64, 432,   16, 16,   0,8);    //source body
		draw_sprite_part(SpriteSheet, 0,   32, 400,   16, 16,   0,0);    //source head
		global.LinkSpr_HoldingItem2 = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
		surface_reset_target();		
		surface_free(SprSurface);

		sprite_collision_mask(global.LinkSpr_HoldingItem2, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);			
		sprite_set_speed(global.LinkSpr_HoldingItem2, 0, spritespeed_framespersecond);
		
	#endregion
		
	#region Descending Top
	
		#region 1

			var SprW = 16;
			var SprH = 16;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 32,   16, 16,   0, 2);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -6);    //source head	
			global.LinkSpr_Descending_Top1 = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 15);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 336,   16, 16,   0, 0);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -7);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);		

			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 336,   16, 16,   0, -1);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -7);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 4 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 32,   16, 16,   0, 0);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -8);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 5 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 48,   16, 16,   0, -1);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -8);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 6 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   80, 192,   16, 16,   0+16, -3,  -1,1, c_white,1);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,    16, 16,   0, -9);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 7 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   64, 384,   16, 16,   -2+16, -2,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   16, 368,   16, 16,  -2+16, -10,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 8 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   48, 384,   16, 16,   -2+16, -2,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   16, 368,   16, 16,  -2+16, -11,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 9 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   80, 384,   16, 16,   -3+16, -4,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   16, 368,   16, 16,  -3+16, -11,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 10 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   48, 384,   16, 16,   -4+16, -1,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   16, 368,   16, 16,  -4+16, -10,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 11
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   64, 384,   16, 16,   -4+16, -3,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   16, 368,   16, 16,  -4+16, -11,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 12 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   48, 384,   16, 16,   -5+16, -2,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   16, 368,   16, 16,  -5+16, -11,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 13 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   80, 384,   16, 16,   -7+16, -4,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   16, 368,   16, 16,  -7+16, -11,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 14 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 16,   16, 16,   -7+16, -2,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,   16, 16,  -6+16, -10,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 15 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 336,   16, 16,   -8+16, -3,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,      16, 16,  -7+16, -10,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 16 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   32, 336,   16, 16,   -9+16, -3,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,      16, 16,  -8+16, -9,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 17 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 336,   16, 16,   -10+16, -3,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,     16, 16,    -9+16, -10,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 18 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 16,   16, 16,   -10+16, -1,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,    16, 16,   -9+16, -9,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 19 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 336,   16, 16,   -11+16, -2,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,      16, 16,  -10+16, -9,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 20 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   32, 336,   16, 16,   -13+16, -2,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,      16, 16,  -12+16, -8,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 21-22 (blank frames since last frame visible during loading)
			draw_clear_alpha(c_black, 0.0);
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);
			draw_clear_alpha(c_black, 0.0);
			sprite_add_from_surface(global.LinkSpr_Descending_Top1, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Descending_Top1, false, 0,   0, 0, 15, 14,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Descending_Top1, 12, spritespeed_framespersecond);
		
		#endregion

		#region 2

			var SprW = 16;
			var SprH = 16;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//Frame 1-4
			draw_clear_alpha(c_black, 0.0);
			global.LinkSpr_Descending_Top2 = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 15);
			repeat(3) sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 336,   16, 16,   8+16, -11,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,      16, 16,   7+16, -18,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);
			
			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   32, 336,   16, 16,   7+16, -10,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   0, 0,      16, 16,  8+16, -16,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 7
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 384,   16, 16,   5+16, -8,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   212, 16,    16, 16,  5+16, -16,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 8
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 384,    16, 16,   4+16, -7,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   212, 16,    16, 16,  4+16, -16,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 9
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   32, 384,    16, 16,   3+16, -7,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   112, 16,    16, 16,  3+16, -14,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 10
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   16, 384,    16, 16,   2+16, -5,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   112, 16,    16, 16,  2+16, -13,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 11
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   0, 384,    16, 16,   1+16, -3,  -1,1, c_white,1);    //source body
			draw_sprite_part_ext(SpriteSheet, 0,   112, 16,    16, 16,  1+16, -12,  -1,1, c_white,1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 12
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 336,    16, 16,   0, -2);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,     16, 16,   0, -9);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 13
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 336,    16, 16,   0, -2);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,     16, 16,   0, -8);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Top2, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Descending_Top2, false, 0,   0, 0, 15, 13,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Descending_Top2, 12, spritespeed_framespersecond);
		
		#endregion
		
	#endregion

	#region Descending Bottom
	
		#region 1

			var SprW = 16;
			var SprH = 32;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
		
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 7);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, -1);    //source head	
			global.LinkSpr_Descending_Bottom1 = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 19);
			
			//frame 2 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 336,   16, 16,   0, 7);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);		

			//frame 3 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 336,   16, 16,   0, 7);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 11);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 3);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   48, 336,   16, 16,   0+16, 11,  -1,1,  c_white,1);    //source body
			draw_sprite_part(SpriteSheet, 0,        16, 0,    16, 16,   0, 4);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 6 
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part_ext(SpriteSheet, 0,   64, 336,   16, 16,   0+16, 11,  -1,1,  c_white,1);    //source body
			draw_sprite_part(SpriteSheet, 0,        16, 0,    16, 16,   0, 5);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 7
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 384,   16, 16,   0, 15);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 16,    16, 16,   0, 6);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 8
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 384,   16, 16,   1, 16);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 16,    16, 16,   1, 8);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 9
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 384,   16, 16,   1, 18);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 16,    16, 16,   1, 9);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 10
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 384,   16, 16,   2, 18);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 16,    16, 16,   2, 11);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 11
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 384,   16, 16,   3, 21);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 16,    16, 16,   3, 12);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 12
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 384,   16, 16,   4, 22);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 16,    16, 16,   4, 14);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 13
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 384,   16, 16,   6, 23);    //source body
			draw_sprite_part(SpriteSheet, 0,   112, 16,    16, 16,   6, 14);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 14
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 336,   16, 16,   7, 22);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   6, 16);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 15
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 16,   16, 16,   8, 25);    //source body
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   7, 17);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 16
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   8, 18);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 17
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   9, 18);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 18
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   10, 19);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 19
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   11, 20);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 20
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   0, 0,    16, 16,   13, 20);    //source head
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);	

			//frame 21-22 (blank frames since last frame visible during loading)
			draw_clear_alpha(c_black, 0.0);
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);
			draw_clear_alpha(c_black, 0.0);
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom1, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Descending_Bottom1, false, 0,   0, 0, 15, 14,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Descending_Bottom1, 12, spritespeed_framespersecond);
		
		#endregion

		#region 2

			var SprW = 16;
			var SprH = 21;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			//Frame 1-3
			draw_clear_alpha(c_black, 0.0);
			global.LinkSpr_Descending_Bottom2 = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 20);
			repeat(2) sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);	
			
			//frame 4
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -12, 4);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 5
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   48, 384,      16, 16,   -11, 13);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -11, 4);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 6
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 384,      16, 16,   -10, 10);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -10, 3);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 7
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 384,      16, 16,   -8, 11);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -8, 3);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 8
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 384,      16, 16,   -8, 11);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -8, 3);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 9
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 384,      16, 16,   -5, 9);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -5, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 10
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 384,      16, 16,   -3, 10);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -3, 2);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 11
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   64, 384,      16, 16,   -1, 9);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 368,      16, 16,   -1, 3);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 12
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   80, 336,      16, 16,   0, 7);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,       16, 16,   0, 0);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);

			//frame 13
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   96, 336,      16, 16,   0, 5);    //source body
			draw_sprite_part(SpriteSheet, 0,   32, 0,       16, 16,   0, -1);    //source head	
			sprite_add_from_surface(global.LinkSpr_Descending_Bottom2, SprSurface, 0, 0, SprW, SprH, false, false);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_Descending_Bottom2, false, 0,   0, 0, 15, 13,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_Descending_Bottom2, 12, spritespeed_framespersecond);
		
		#endregion
		
	#endregion

	#region Dungeon Icon
			
		var SprW = 16;
		var SprH = 16;	
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
		
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   112, 160,   16, 16,   0, 0);
		global.LinkSpr_DungeonIcon = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
		surface_reset_target();		
		surface_free(SprSurface);

		sprite_collision_mask(global.LinkSpr_DungeonIcon, false, 0,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
		
	#endregion

	#region Map Icon
			
		var SprW = 16;
		var SprH = 16;	
		var SprSurface = surface_create(SprW, SprH);
		surface_set_target(SprSurface);
		
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(SpriteSheet, 0,   16, 0,   16, 16,   0, 0);
		global.LinkSpr_MapIcon = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 8, 21);
			
		surface_reset_target();		
		surface_free(SprSurface);

		sprite_collision_mask(global.LinkSpr_MapIcon, false, 0,   0, 7, 15, 22,   bboxkind_rectangular, 0)			
		
	#endregion

	
}

function LinkSprites_Destroy(){
	
	sprite_delete(global.LinkSpr_Stand_Down);
	sprite_delete(global.LinkSpr_Stand_Up);
	sprite_delete(global.LinkSpr_Stand_Right);
	sprite_delete(global.LinkSpr_Stand_Left);

	sprite_delete(global.LinkSpr_Walk_Down);
	sprite_delete(global.LinkSpr_Walk_Up);
	sprite_delete(global.LinkSpr_Walk_Right);
	sprite_delete(global.LinkSpr_Walk_Left);
	
	sprite_delete(global.LinkSpr_Push_Down);
	sprite_delete(global.LinkSpr_Push_Up);
	sprite_delete(global.LinkSpr_Push_Right);
	sprite_delete(global.LinkSpr_Push_Left);
	
	sprite_delete(global.LinkSpr_Carrying_Down);
	sprite_delete(global.LinkSpr_Carrying_Up);
	sprite_delete(global.LinkSpr_Carrying_Right);
	sprite_delete(global.LinkSpr_Carrying_Left);
	
	sprite_delete(global.LinkSpr_Throwing_Down);
	sprite_delete(global.LinkSpr_Throwing_Up);
	sprite_delete(global.LinkSpr_Throwing_Right);
	sprite_delete(global.LinkSpr_Throwing_Left);
	
	sprite_delete(global.LinkSpr_PickUp_Down);
	sprite_delete(global.LinkSpr_PickUp_Up);
	sprite_delete(global.LinkSpr_PickUp_Right);
	sprite_delete(global.LinkSpr_PickUp_Left);
	
	sprite_delete(global.LinkSpr_Sword_Down);
	sprite_delete(global.LinkSpr_Sword_Up);
	sprite_delete(global.LinkSpr_Sword_Right);
	sprite_delete(global.LinkSpr_Sword_Left);
	
	sprite_delete(global.LinkSpr_SwordPoke_Down);
	sprite_delete(global.LinkSpr_SwordPoke_Up);
	sprite_delete(global.LinkSpr_SwordPoke_Right);
	sprite_delete(global.LinkSpr_SwordPoke_Left);
	
	sprite_delete(global.LinkSpr_Boomerang_Down);
	sprite_delete(global.LinkSpr_Boomerang_Up);
	sprite_delete(global.LinkSpr_Boomerang_Right);
	sprite_delete(global.LinkSpr_Boomerang_Left);
	
	sprite_delete(global.LinkSpr_Hookshot_Down);
	sprite_delete(global.LinkSpr_Hookshot_Up);
	sprite_delete(global.LinkSpr_Hookshot_Right);
	sprite_delete(global.LinkSpr_Hookshot_Left);
	
	sprite_delete(global.LinkSpr_Bow_Down);
	sprite_delete(global.LinkSpr_Bow_Up);
	sprite_delete(global.LinkSpr_Bow_Right);
	sprite_delete(global.LinkSpr_Bow_Left);
	
	sprite_delete(global.LinkSpr_Rod_Down);
	sprite_delete(global.LinkSpr_Rod_Up);
	sprite_delete(global.LinkSpr_Rod_Right);
	sprite_delete(global.LinkSpr_Rod_Left);
	
	sprite_delete(global.LinkSpr_Powder_Down);
	sprite_delete(global.LinkSpr_Powder_Up);
	sprite_delete(global.LinkSpr_Powder_Right);
	sprite_delete(global.LinkSpr_Powder_Left);
	
	sprite_delete(global.LinkSpr_Hurt_Down);
	sprite_delete(global.LinkSpr_Hurt_Up);
	sprite_delete(global.LinkSpr_Hurt_Right);
	sprite_delete(global.LinkSpr_Hurt_Left);
	
	sprite_delete(global.LinkSpr_HoldingItem);
	sprite_delete(global.LinkSpr_HoldingItem2);
	
	sprite_delete(global.LinkSpr_Dead);
	
	sprite_delete(global.LinkSpr_Falling);
	
	sprite_delete(global.LinkSpr_Shock);
	
	sprite_delete(global.LinkSpr_Star);

	sprite_delete(global.LinkSpr_Stand_SwordCharge_Down);
	sprite_delete(global.LinkSpr_Stand_SwordCharge_Up);
	sprite_delete(global.LinkSpr_Stand_SwordCharge_Right);
	sprite_delete(global.LinkSpr_Stand_SwordCharge_Left);
	
	sprite_delete(global.LinkSpr_Walk_SwordCharge_Down);
	sprite_delete(global.LinkSpr_Walk_SwordCharge_Up);
	sprite_delete(global.LinkSpr_Walk_SwordCharge_Right);
	sprite_delete(global.LinkSpr_Walk_SwordCharge_Left);
	
	sprite_delete(global.LinkSpr_SwordSpin_Down);
	sprite_delete(global.LinkSpr_SwordSpin_Up);
	sprite_delete(global.LinkSpr_SwordSpin_Right);
	sprite_delete(global.LinkSpr_SwordSpin_Left);	
	
	sprite_delete(global.LinkSpr_Descending_Top1);
	sprite_delete(global.LinkSpr_Descending_Top2);
	sprite_delete(global.LinkSpr_Descending_Bottom1);
	sprite_delete(global.LinkSpr_Descending_Bottom2);
	
	sprite_delete(global.LinkSpr_DungeonIcon);
	sprite_delete(global.LinkSpr_MapIcon);
	
}