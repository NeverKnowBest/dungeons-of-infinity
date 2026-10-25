// "Achievement unlocked" banner at the top of the screen. Created by Achievement_ShowToast with Title and Reward.
Timer = 0;
Duration = 240;
SlideFrames = 12;
Slot = instance_number(oAchievementToast) - 1; // stack under any banner already showing
depth = -1100;
W = 200;
H = (Reward == "") ? 34 : 44;
audio_play_sound(Sound_ItemGet, 1, false);
