// What zelda3's src/*.c need from the files the harnesses leave out (main.c, config.c, opengl.c, glsl_shader.c)
// and from the opus library (only used for MSU audio, which the harnesses never play).
#include <stddef.h>
#include <stdbool.h>
#include "src/types.h"
#include "src/config.h"
#include "third_party/opus-1.3.1-stripped/opus.h"

Config g_config;
bool ParseBool(const char *value, bool *result) { return false; }
OpusDecoder *opus_decoder_create(opus_int32 fs, int channels, int *error) { if (error) *error = -1; return NULL; }
void opus_decoder_destroy(OpusDecoder *st) {}
int opus_decoder_ctl(OpusDecoder *st, int request, ...) { return -1; }
int opus_decode(OpusDecoder *st, const unsigned char *data, opus_int32 len, opus_int16 *pcm, int frame_size, int decode_fec) { return -1; }
