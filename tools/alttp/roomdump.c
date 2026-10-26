// Dumps every ALttP dungeon room using zelda3's own room loader/drawer.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "src/types.h"
#include "src/variables.h"
#include "src/zelda_rtl.h"
#include "src/dungeon.h"
#include "src/load_gfx.h"
#include "src/assets.h"
#include "src/util.h"
#include "src/misc.h"
#include "snes/ppu.h"
void Init_LoadDefaultTileAttr();

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

static void W(FILE *f, const void *p, size_t n) { fwrite(p, 1, n, f); }


// Build a copy of room r's data with a custom door list.
static uint8 g_custom[8192];
static const uint8 *BuildRoom(int r, int ndoors, const uint16 *doors, int door_layer) {
  const uint8 *src = kDungeonRoom + kDungeonRoomOffs[r];
  int i = 0, o = 0;
  g_custom[o++] = src[i++];  // floor
  g_custom[o++] = src[i++];  // layout
  int orig_door_layer = -1;
  for (int L = 0; L < 3; L++) {
    for (;;) {
      uint16 w = src[i] | src[i+1] << 8;
      if (w == 0xffff) { i += 2; break; }
      if (w == 0xfff0) {
        orig_door_layer = L;
        i += 2;
        for (;;) { uint16 d = src[i] | src[i+1] << 8; i += 2; if (d == 0xffff) break; }
        break;
      }
      memcpy(g_custom + o, src + i, 3); o += 3; i += 3;
    }
    int dl = door_layer >= 0 ? door_layer : (orig_door_layer >= 0 ? orig_door_layer : 0);
    if (L == dl && ndoors > 0) {
      g_custom[o++] = 0xf0; g_custom[o++] = 0xff;
      for (int k = 0; k < ndoors; k++) { g_custom[o++] = doors[k] & 0xff; g_custom[o++] = doors[k] >> 8; }
    }
    g_custom[o++] = 0xff; g_custom[o++] = 0xff;
  }
  return src;
}

static int g_pal = -1, g_bs = -1, g_main = -1;
static void DumpRoom(const char *name, int r, int ndoors, const uint16 *doors, int door_layer) {
  const uint8 *src = BuildRoom(r, ndoors, doors, door_layer);
  static uint8 *bigbuf = NULL;
  static uint32 cust_off = 0;
  if (!bigbuf) {
    printf("room asset size %u\n", g_asset_sizes[3]);
    bigbuf = malloc(g_asset_sizes[3] + 8192);
    memcpy(bigbuf, g_asset_ptrs[3], g_asset_sizes[3]);
    cust_off = g_asset_sizes[3];
    g_asset_ptrs[3] = bigbuf;
  }
  uint16 saved_off = kDungeonRoomOffs[r];
  if (ndoors >= 0) {
    memcpy(bigbuf + cust_off, g_custom, sizeof(g_custom));
    kDungeonRoomOffs[r] = cust_off;
  }
  submodule_index = 0;
  main_module_index = 7;
  BG2HOFS_copy2 = BG2VOFS_copy2 = 0;
  dungeon_room_index = r;
  memset(dung_bg1, 0, 0x2000);
  memset(dung_bg2, 0, 0x2000);
  uint8 *hp = (uint8*)GetRoomHeaderPtr(r);
  uint8 save1 = hp[1], save2 = hp[2];
  if (g_pal >= 0) hp[1] = g_pal;
  if (g_bs >= 0) hp[2] = g_bs;
  Dungeon_LoadRoom();
  main_tile_theme_index = g_main >= 0 ? g_main : aux_tile_theme_index;
  hp[1] = save1; hp[2] = save2;
  Dungeon_LoadCustomTileAttr();
  DecompressAnimatedDungeonTiles(kDungAnimatedTiles[main_tile_theme_index]);
  Dungeon_LoadAttributeTable();
  misc_sprites_graphics_index = 10;
  InitializeTilesets();
  palette_sp6r_indoors = 10;
  Dungeon_LoadPalettes();
  kDungeonRoomOffs[r] = saved_off;
  {
    const char *af = getenv("ANIMFRAME");
    if (af) memcpy(&g_zenv.vram[animated_tile_vram_addr], &g_ram[0xa680 + atoi(af) * 0x400], 0x400);
  }
  FILE *f = fopen(name, "wb");
  if (strstr(name, ".lite")) {
    W(f, dung_bg2, 0x2000); W(f, dung_bg1, 0x2000);
    W(f, dung_bg2_attr_table, 0x1000); W(f, dung_bg1_attr_table, 0x1000);
    fclose(f);
    return;
  }
  uint8 hdr[16] = {dung_hdr_bg2_properties, dung_hdr_collision, dung_want_lights_out, main_tile_theme_index,
                   dung_hdr_tag[0], dung_hdr_tag[1], dung_layout_and_starting_quadrant, 0};
  W(f, hdr, 16);
  W(f, g_zenv.vram, 0x10000);
  W(f, main_palette_buffer, 512);
  W(f, aux_palette_buffer, 512);
  W(f, dung_bg2, 0x2000);
  W(f, dung_bg1, 0x2000);
  W(f, dung_bg2_attr_table, 0x1000);
  W(f, dung_bg1_attr_table, 0x1000);
  fclose(f);
}

int main(int argc, char **argv) {
  LoadAssets();
  ZeldaInitialize();
  sram_progress_indicator = 3;
  sram_progress_flags = 0xff;
  player_is_indoors = 1;
  which_entrance = 4;
  Dungeon_LoadEntrance();
  Init_LoadDefaultTileAttr();
  if (argc > 1 && strcmp(argv[1], "--jobs") == 0) {
    // job lines: outfile room door_layer n d1 d2 ...   (n = -1 keeps original doors)
    FILE *jf = fopen(argv[2], "r");
    char out[256]; int r, dl, n;
    int pal, bs, mn;
    while (fscanf(jf, "%255s %d %d %d %d %d %d", out, &r, &pal, &bs, &mn, &dl, &n) == 7) {
      g_pal = pal; g_bs = bs; g_main = mn;
      uint16 doors[32]; int nn = n < 0 ? 0 : n;
      for (int k = 0; k < nn; k++) { unsigned v; fscanf(jf, "%x", &v); doors[k] = v; }
      DumpRoom(out, r, n, doors, dl);
    }
    fclose(jf);
    printf("jobs done\n");
    return 0;
  }
  for (int r = 0; r <= 295; r++) {
    char name[64];
    sprintf(name, "out/room_%03d.bin", r);
    DumpRoom(name, r, -1, NULL, -1);
  }
  printf("done\n");
  return 0;
}
