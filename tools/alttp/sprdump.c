// Dumps OBJ VRAM + palettes for an overworld area, and the OAM flags of a sprite type.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "src/types.h"
#include "src/variables.h"
#include "src/zelda_rtl.h"
#include "src/assets.h"
#include "src/load_gfx.h"
#include "src/overworld.h"
#include "src/sprite.h"
#include "src/util.h"
#include "snes/ppu.h"
const uint8 *g_asset_ptrs[kNumberOfAssets];
uint32 g_asset_sizes[kNumberOfAssets];
void ZeldaApuLock() {}
void ZeldaApuUnlock() {}
void Die(const char *error) { fprintf(stderr, "Error: %s\n", error); exit(1); }
MemBlk FindInAssetArray(int asset, int idx) { return FindIndexInMemblk((MemBlk) { g_asset_ptrs[asset], g_asset_sizes[asset] }, idx); }
static void LoadAssets() {
  size_t length = 0; uint8 *data = ReadWholeFile("zelda3_assets.dat", &length);
  uint32 offset = 88 + kNumberOfAssets * 4 + *(uint32 *)(data + 84);
  for (size_t i = 0; i < kNumberOfAssets; i++) { uint32 size = *(uint32 *)(data + 88 + i * 4); offset = (offset + 3) & ~3; g_asset_sizes[i] = size; g_asset_ptrs[i] = data + offset; offset += size; }
}
void Overworld_LoadPalettes(uint8 bg, uint8 spr);
void Sprite_LoadGraphicsProperties();
void Palette_Load_SpriteMain();
int main(int argc, char **argv) {
  int area = strtol(argv[1], 0, 0), stype = strtol(argv[2], 0, 0);
  LoadAssets(); ZeldaInitialize();
  sram_progress_indicator = 2;
  savegame_is_darkworld = area & 0x40;
  overworld_screen_index = area;
  Sprite_LoadGraphicsProperties();
  sprite_graphics_index = overworld_sprite_gfx[area];
  main_tile_theme_index = area & 0x40 ? 0x21 : 0x20;
  aux_tile_theme_index = 0;
  InitializeTilesets();
  Palette_Load_SpriteMain();
  Overworld_LoadPalettes(GetOverworldBgPalette(area), overworld_sprite_palettes[area]);
  for (int i = 128; i < 256; i++) if (main_palette_buffer[i] == 0) main_palette_buffer[i] = aux_palette_buffer[i];
  sprite_type[0] = stype;
  SpritePrep_LoadProperties(0);
  printf("gfx %d oamflags %02x prio %02x\n", sprite_graphics_index, sprite_oam_flags[0], sprite_obj_prio[0]);
  FILE *f = fopen(argv[3], "wb");
  fwrite(g_zenv.vram, 1, 0x10000, f);
  fwrite(main_palette_buffer, 1, 512, f);
  fclose(f);
  return 0;
}
