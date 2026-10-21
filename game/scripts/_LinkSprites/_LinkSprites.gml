function LinkSprites_Construct(Character){
	
	
	var SpriteSheet = sprite_add("Characters\\Character - " + Character + ".png", 1, false, false, 0, 0);

	
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
	
	#region Hold Item
			
			var SprW = 16;
			var SprH = 24;
			var OriX = 8;
			var OriY = 21;
			var SprSurface = surface_create(SprW, SprH);
			surface_set_target(SprSurface);
			
			draw_clear_alpha(c_black, 0.0);
			draw_sprite_part(SpriteSheet, 0,   32, 176,   16, 16,   0,8);    //source body
			draw_sprite_part(SpriteSheet, 0,   16, 176,   16, 16,   0,0);    //source head
			global.LinkSpr_HoldingItem = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, OriX, OriY);
			
			surface_reset_target();		
			surface_free(SprSurface);

			sprite_collision_mask(global.LinkSpr_HoldingItem, false, 2,   0, 7, 15, 22,   bboxkind_rectangular, 0);			
			sprite_set_speed(global.LinkSpr_HoldingItem, 0, spritespeed_framespersecond);
		
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
	
	surface_free(SpriteSheet);
	
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
	
	sprite_delete(global.LinkSpr_Sword_Down);
	sprite_delete(global.LinkSpr_Sword_Up);
	sprite_delete(global.LinkSpr_Sword_Right);
	sprite_delete(global.LinkSpr_Sword_Left);
	
	sprite_delete(global.LinkSpr_HoldingItem);
	
	sprite_delete(global.LinkSpr_Descending_Top1);
	sprite_delete(global.LinkSpr_Descending_Top2);
	sprite_delete(global.LinkSpr_Descending_Bottom1);
	sprite_delete(global.LinkSpr_Descending_Bottom2);
	
	sprite_delete(global.LinkSpr_DungeonIcon);
	
}