// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function array_find(___arr=[[-1,-1]],___value=[-1,-1])
{
	var __ss=array_length(___arr);
	for(var i=0;i<__ss;i++){if array_equals_(___arr[i],___value){return true}}
	return false
}

function array_equals_(___arr0=[-1,-1],___arr1=[-1,-1])//array_equals not working fine in html5 version IDE v2022.6.1.26
{
	if array_length(___arr0)==2 and array_length(___arr1)==2
	{
		return ___arr0[0]==___arr1[0] and ___arr0[1]==___arr1[1];
	}
	else
	{
		if array_length(___arr0)!=array_length(___arr1){return false;}
		else{return array_equals(___arr0,___arr1)}
	}
}


function explode(del,_str)//from gmlscripts.com
{
    var arr=[];
    var str = _str + del;
    var len =string_length(del);
    var ind = 0;
	if string_count(del,_str)>0
    {
		repeat (string_count(del, str)) {
	        var pos = string_pos(del, str) - 1;
			if string_copy(str, 1, pos)!=""
			{
	        arr[ind] = string_copy(str, 1, pos);
			str = string_delete(str, 1, pos + len);
	        ind++;
			}
	    }
	}
	else
	{
		if _str!=""{arr[0]=_str}
	}
    return arr;
}
