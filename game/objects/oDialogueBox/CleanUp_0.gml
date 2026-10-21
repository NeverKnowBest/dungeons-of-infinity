global.DB_Inst = noone;

if(!ds_queue_empty(global.DB_MsgBoxQueue)){
	
	var _msg = ds_queue_dequeue(global.DB_MsgBoxQueue);
	MsgBox(_msg[0], _msg[1], _msg[2], _msg[3]);
	
}