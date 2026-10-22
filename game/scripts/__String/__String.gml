function String_Shuffle(str){
	
	// Returns a string with contents shuffled.
	
	var ShuffledStr = "";
	var i = 1;
	// for each character in source,
	repeat (string_length(str)) {
	    // insert character at random
	    // position into destination string
	    ShuffledStr = string_insert( string_char_at(str, i), ShuffledStr, irandom(i));
	    i += 1;
	}
	return ShuffledStr;
}

function SplitStrToArray(Str, SplitStr, ConvertToReal = false){
	
	//returns array of split strings from Str split at SplitStr
	
	var SplitsArray = array_create(0);
	
	var slot = 0;
	var str2 = ""; //var to hold the current split we're working on building

	var i;
	for (i = 1; i < (string_length(Str)+1); i++) {
	    var currStr = string_copy(Str, i, 1);
	    if (currStr == SplitStr) {
	        SplitsArray[slot] = ConvertToReal ? real(str2) : str2; //add this split to the array of all splits
	        slot++;
	        str2 = "";
	    } else {
	        str2 = str2 + currStr;
	        SplitsArray[slot] = ConvertToReal ? real(str2) : str2;
	    }
	}
	
	return SplitsArray;
	
}

function CSVToList(Str){
	
	//returns ds_list of split strings from comma-seperated Str   "1,2,3,4" -> [| 1,2,3,4]
	
	var SplitList = ds_list_create();
	ds_list_clear(SplitList);
	
	var temp_str = "";
	for (var i = 1; i <= string_length(Str); i++) {
	   temp_str += string_char_at(Str, i);
	   if (string_char_at(Str, i+1) == ",") {
	      ds_list_add(SplitList, temp_str);
	      temp_str = "";
	      i++;
	   }
	}
	ds_list_add(SplitList, temp_str) //last value
	
	return SplitList;
	
}

function ArrayToCSV(_Array){
	
	//takes an array of values and convert it to a csv
	
	var _ArrayLen = array_length(_Array);
	
	var _CSV = "";
	
	for(var _ArrayIndex = 0; _ArrayIndex < _ArrayLen; _ArrayIndex++){
		_CSV = string_concat(_CSV, string(_Array[_ArrayIndex]), _ArrayIndex == _ArrayLen - 1 ? "" : ",");
	}
	
	
	return _CSV;
	
}

function SplitSentenceToArray(Sentence, Font, MaxPixelLen){
	
	//This function splits the sentence string in an array taking the words and max pixel length into account

	Sentence += " "; //need this buffer
	
	var Array = [];
	
	var SentenceLen = string_length(Sentence);
	
	var LineNo = 0;
	var LineStart = 1;

	draw_set_font(Font);

	var WordStart;
	do{
	
		var LineDone = false;
		var Line = ""
		WordStart = LineStart;
	
		do{

			var NextSpace = string_pos_ext(" ", Sentence, WordStart);
			
			var LineTry = string_copy(Sentence, LineStart, NextSpace - LineStart);
			var StrW = string_width(LineTry);
			if(StrW >= MaxPixelLen){
				LineStart += (string_length(Line) + 1);
				WordStart = LineStart;
				LineDone = true;
			}else{
				Line = LineTry;	
				WordStart = LineStart + string_length(Line) + 1;
			}
		
		}until LineDone || WordStart > SentenceLen
	
		Array[LineNo++] = Line;
		
	}until (WordStart > SentenceLen)
	
	return Array;
	
}