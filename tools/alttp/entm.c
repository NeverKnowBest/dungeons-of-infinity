#include <stdio.h>
#include <stdlib.h>
#include "src/types.h"
#include "src/assets.h"
#include "src/util.h"
const uint8 *g_asset_ptrs[kNumberOfAssets];
uint32 g_asset_sizes[kNumberOfAssets];
void Die(const char *e){exit(1);}
int main(){size_t length=0;uint8 *data=ReadWholeFile("zelda3_assets.dat",&length);
uint32 offset=88+kNumberOfAssets*4+*(uint32*)(data+84);
for(size_t i=0;i<kNumberOfAssets;i++){uint32 size=*(uint32*)(data+88+i*4);offset=(offset+3)&~3;g_asset_sizes[i]=size;g_asset_ptrs[i]=data+offset;offset+=size;}
const uint16 *rooms=(const uint16*)kEntranceData_rooms;
for(int i=0;i<kEntranceData_musicTrack_SIZE;i++) printf("%d:r%x:m%d ",i,rooms[i],kEntranceData_musicTrack[i]);
printf("\n");}
