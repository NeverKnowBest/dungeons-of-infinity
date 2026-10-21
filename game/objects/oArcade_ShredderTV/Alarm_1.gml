/// @description animation frame

AnimationIndex = (AnimationIndex + 1) mod 12;
AnimationFrame_Face = AnimationIndex div 2;
AnimationFrame_Mask = AnimationIndex mod 2;
alarm[1] = AnimationDelay;