Wake_HeadFrame++;
image_index = Wake_HeadFrames[Wake_HeadFrame];

if(Wake_HeadFrame < array_length(Wake_HeadFrames) - 1)
	alarm[0] = AniDelay;
else{
	State = NPCState_OldLady.Awake;
	DB_Init = true;
}