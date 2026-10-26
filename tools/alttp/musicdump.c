// Renders an ALttP song to raw 16-bit stereo PCM (44100 Hz) using zelda3's SPC emulation.
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
  int bank = atoi(argv[1]), song = atoi(argv[2]), seconds = atoi(argv[3]);
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
    zelda_apu_write(APUI00, i < 4 ? song : 0);
    ZeldaPushApuState();
    ZeldaRenderAudio(buf, per, 2);
    fwrite(buf, 4, per, f);
    if (getenv("TRACE")) printf("%d %02x%02x\n", i, g_zenv.player->music_ptr_toplevel >> 8, g_zenv.player->music_ptr_toplevel & 0xff);
  }
  fclose(f);
  return 0;
}
