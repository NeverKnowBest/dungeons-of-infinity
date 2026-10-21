application_surface_draw_enable(true);

audio_group_set_gain(audiogroup_Music, global.MusicVol, 0);
audio_group_set_gain(audiogroup_SFX, global.SFXVol, 0);	


FX_Contrast = fx_create("_filter_contrast");
_Contrast = 1.5;
_Brightness = 0.0;
fx_set_parameter(FX_Contrast, "g_ContrastIntensity", _Contrast);
fx_set_parameter(FX_Contrast, "g_ContrastBrightness", _Brightness);
layer_set_fx("Effect_Contrast", FX_Contrast);

ShowBG = false;

AllowStart = false;

var _StartFrame = 45;
var _IntroMusicFrame = _StartFrame + 150;
var _MainMusicFrame = _IntroMusicFrame + 370;
var _ShowBGFrame = _MainMusicFrame + 40;
var _SwordFrame = _ShowBGFrame + 68;


alarm[0] = _StartFrame; //intro music
alarm[1] = _IntroMusicFrame; //intro music
alarm[2] = _MainMusicFrame; //main music
alarm[3] = _ShowBGFrame; //sword
alarm[4] = _SwordFrame; //sword

var i = 0;

_SparklePosX[i] = 126; _SparklePosY[i++] = 67;
_SparklePosX[i] = 265; _SparklePosY[i++] = 104;
_SparklePosX[i] = 225; _SparklePosY[i++] = 65;
_SparklePosX[i] = 184; _SparklePosY[i++] = 104;

SparkleIndex = 0;
SparkleDelay = 30;
alarm[5] = _ShowBGFrame + 30;

Music = noone;

CreditStart = 1500;
alarm[6] = CreditStart;
//layer_sequence_headpos(seqTitle, 200);