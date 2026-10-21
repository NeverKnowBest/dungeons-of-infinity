
function SetPropertyValue(PropertiesArray, PropertyName, NewValue){

	var Properties = array_length(PropertiesArray);
	
	if(Properties == 0) exit;
	
	for(var i = 0; i < Properties; i++){
		if(PropertiesArray[i][$ "name"] == PropertyName){
			PropertiesArray[i][$ "value"] = NewValue;
			break;
		}
	}

}