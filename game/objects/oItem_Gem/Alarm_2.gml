/// @description Shimmer frame delay

ShimmerFrame++;
if(ShimmerFrame > 2){
	alarm[1] = ShimmerDelay;
	Shimmer = false;
}else{
	alarm[2] = ShimmerFrameDelay;	
}
	
