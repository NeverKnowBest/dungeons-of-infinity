if async_load[? "id"] == msgFEN
{
	if ds_map_find_value(async_load, "status")
    {
		if ds_map_find_value(async_load, "result") != ""
        {
			var __r=ds_map_find_value(async_load, "result");
			if __r!=FEN_arr[FEN_index]//check if user enter new FEN Code and not equal global.Board Now
			{
				FenToBoard(__r)//change pieces based a new FEN code entered by user
				FEN_index++//increase FEN_index
				array_push(FEN_arr,BoardToFen())//add element to FEN array
				array_push(moved_arr,[0,[],[]])//add element to Moved array
				array_push(PGN_arr,"")//add element to PGN array 
				PGN_chk=false;//false because FEN changed by user and can't generate PGN Code
				check_king=[false,false]//reset check king anr recheck again
				checkmate="";//reset variable that used to know end game or not
				is_checkmate()//Make sure if checkmate or not
				check()//Make sure if check or not
			}
        }
    }
}

if async_load[? "id"] == msgPGN
{
	if ds_map_find_value(async_load, "status")
    {
		if ds_map_find_value(async_load, "result") != ""
        {
			var __r=ds_map_find_value(async_load, "result");
			var __PgnMove=PgnToMove(__r)
			if array_length(__PgnMove)==2
			{
				var __t=get_legal_moves(__PgnMove[0],false)
				if array_find(__t[0],__PgnMove[1]) or array_find(__t[1],__PgnMove[1])
				{
					move(__PgnMove[0],__PgnMove[1]);
				}
				else
				{
					show_message_async("wrong move")
				}
			}
			else
			{
				show_message_async("wrong text")
			}
        }
    }
}
	
	