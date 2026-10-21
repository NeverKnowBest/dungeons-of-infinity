
function GetPropertyValue(PropertiesArray, PropertyName){
	
	//This function returns the Tiled property value of the property name from a ds list
	
	for(var i = 0; i < array_length(PropertiesArray); i++){
		if(PropertiesArray[i].name == PropertyName)	return PropertiesArray[i].value;
	}
			
	return -1; 

}