/// @function		xzip_list(arch, [relative]);
/// @param			{string}	arch
/// @param			{boolean}	[relative]
/// @requires		xzip_create
/// @description	Returns an array of strings containing the file names and extensions
///					(and optionally, relative paths) contained within the given archive. 
///					The array index for each file also corresponds to the archive index 
///					and can be used when extracting files in place of a file name itself.
///					
///					Many functions support inputting an array of files, in which case an
///					array returned by this function can be passed in directly.
///
/// @example		file_array = xzip_list("C:\\archive.xz");
///	
///					xzip_extract("C:\\archive.xz", "C:\\extracted", file_array[0]);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_list() {
	//Get arguments
	var _arch = argument[0];
	
	//Initialize temporary variables for checking archive
	var findex = 0,
		flist = 0,
		fpath,
		frelative = false;

	//Skip if archive does not exist
	if (!file_exists(_arch)) {
		return -1;
	}

	//Enable including relative paths, if specified
	if (argument_count > 1) {
		frelative = argument[1];
	}
	
	//Create array of archive contents
	ini_open(_arch);
	while (ini_key_exists("?", string(findex))) {
		//Get file name and extension
		flist[findex] = ini_read_string("?", string(findex), filename_error);
	
		//Include relative paths, if enabled
		if (frelative) {
			//Get file path
			fpath = ini_read_string(flist[findex], "path", "");
		
			//Prepend relative path, if any
			if (fpath != "") {
				flist[findex] = fpath + "\\" + flist[findex];
			}
		}
	
		//Continue to next file
		findex++;
	}

	//End reading archive
	ini_close();

	//Return contents array
	return flist;
}
