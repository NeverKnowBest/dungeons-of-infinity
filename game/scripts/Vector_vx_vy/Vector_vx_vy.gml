function Vector_vx_vy(Inst, p1_x, p1_y, p2_x, p2_y, Speed) {

	//This sets the vx and vy component velocity vectors of an instance based on the (x1,y1,x2,y2) vector

	var component_x = (p2_x - p1_x);
	var component_y = (p2_y - p1_y);


	var len = sqrt(sqr(component_x) + sqr(component_y));

	//normalize vectors (between 0.0 - 1.0)
	component_x = component_x / len;
	component_y = component_y / len;

	Inst.vx = component_x * Speed;
	Inst.vy = component_y * Speed;


}
