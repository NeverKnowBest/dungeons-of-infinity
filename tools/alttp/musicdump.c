// Renders an ALttP song, or a sound effect, to raw 16-bit stereo PCM (44100 Hz) using zelda3's SPC emulation.
// Song:   musicdump <bank> <song> <seconds> <out.pcm>
// Effect: musicdump sfx <port> <id> <seconds> <out.pcm>   (port 1 = ambient APUI01, 2 = sound_effect_1 APUI02, 3 = sound_effect_2 APUI03)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "src/types.h"
#include "src/variables.h"
#include "src/zelda_rtl.h"
#include "src/assets.h"
#include "src/audio.h"
#include "src/util.h"
#include "snes/snes_regs.h"
#include "src/spc_player.h"

const uint8 *g_asset_ptrs[kNumberOfAssets];
uint32 g_asset_sizes[kNumberOfAssets];
void ZeldaApuLock() {}
void ZeldaApuUnlock() {}
void Die(const char *error) { fprintf(stderr, "Error: %s\n", error); exit(1); }
MemBlk FindInAssetArray(int asset, int idx) {
  return FindIndexInMemblk((MemBlk) { g_asset_ptrs[asset], g_asset_sizes[asset] }, idx);
}
static void LoadAssets() {
  size_t length = 0;
  uint8 *data = ReadWholeFile("zelda3_assets.dat", &length);
  if (!data) Die("no assets");
  uint32 offset = 88 + kNumberOfAssets * 4 + *(uint32 *)(data + 84);
  for (size_t i = 0; i < kNumberOfAssets; i++) {
    uint32 size = *(uint32 *)(data + 88 + i * 4);
    offset = (offset + 3) & ~3;
    g_asset_sizes[i] = size;
    g_asset_ptrs[i] = data + offset;
    offset += size;
  }
}
void zelda_apu_write(uint32_t adr, uint8_t val);
int main(int argc, char **argv) {
  int sfx = argc > 5 && strcmp(argv[1], "sfx") == 0;
  if (sfx) argv++;
  int bank = atoi(argv[1]), song = atoi(argv[2]), seconds = atoi(argv[3]);
  int port = sfx ? bank : 0;  // effects live in the driver, so any song bank works
  if (sfx) bank = 0;
  LoadAssets();
  ZeldaInitialize();
  LoadSongBank(kSoundBank_intro);
  if (bank == 1) LoadSongBank(kSoundBank_indoor);
  else if (bank == 2) LoadSongBank(kSoundBank_ending);
  else LoadSongBank(kSoundBank_intro);
  FILE *f = fopen(argv[4], "wb");
  int per = (534 * 44100) / 32000;
  int16 *buf = malloc(per * 4);
  int frames = seconds * 60;
  for (int i = 0; i < frames; i++) {
    if (sfx) {
      // Written to its port for one frame, as the NMI does (src/nmi.c); an ambient loop (rain is 1) then plays until the end
      zelda_apu_write(APUI00 + port, i == 4 ? song : 0);
    } else {
      zelda_apu_write(APUI00, i < 4 ? song : 0);
    }
    ZeldaPushApuState();
    ZeldaRenderAudio(buf, per, 2);
    fwrite(buf, 4, per, f);
    if (getenv("TRACE")) printf("%d %02x%02x\n", i, g_zenv.player->music_ptr_toplevel >> 8, g_zenv.player->music_ptr_toplevel & 0xff);
  }
  fclose(f);
  return 0;
}
