/// @function		xzip_rename(arch, file, name);
/// @param			{string}		arch
/// @param			{string|int}	file
/// @param			{string}		name
/// @requires		xzip_create, xzip_list_dir
/// @description	Renames a file or folder inside an archive created with `xzip_create`. 
///					Also returns `true` or `false` to indicate if the operation succeeded. 
///					Note that this includes failure to rename a file flagged as read-only. 
///					(This can be determined with `xzip_get_readonly`.)
///				
///					If a folder is input, the `file` argument must include the folder's
///					relative path with no beginning or ending slash. However, no relative
///					path should be supplied for `name`.
///				
///					Note that this does **not** rename the archive itself! For that, use 
///					the built-in `file_rename` function.
///
/// @example		xzip_rename("C:\\archive.xz", "file3.png", "image.png");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_rename(_arch, _file, _name) {

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for modifying archive
	var dindex,
		dlist,
		f_is_dir = false,
		fname,
		fpath,
		fpath_orig,
		fsuccess = true,
		tindex;

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		return false;
	}

	//Open archive for modification
	ini_open(_arch);

	//Get file to rename from table of contents, if index is supplied
	if (is_real(_file)) {
		fname = ini_read_string("?", string(_file), filename_error);
	} else {
		//Otherwise use file name as supplied
		fname = filename_name(_file);
	}
	
	//If file is not found, try as directory
	if (!ini_section_exists(fname)) {
		//Temporarily close archive
		ini_close();
		
		//Get list of files in directory
		dlist = xzip_list_dir(_arch, _file);
	
		//Check if input is directory
		f_is_dir = is_array(dlist);
	
		//Otherwise error if not found
		if (!f_is_dir) {
			fname = filename_error;
		}
		
		//Reopen archive
		ini_open(_arch);
	}


	/*
	RENAME OPERATION
	*/

	//Rename files
	if (f_is_dir) {
	
		/*
		DIRECTORIES
		*/
		
		//Get new file path
		fpath = string_copy(_file, 1, (string_length(_file) - string_length(fname))) + _name;
	
		//Rename directories
		for (dindex = 0; dindex < array_length(dlist); dindex++) {
			//Get current file to rename directory
			fname = dlist[dindex];
		
			//Do not rename read-only files
			if (ini_read_string(fname, "readonly", "true") == "true") {
				fsuccess = false;
				continue;
			}
		
			//Get original file path
			fpath_orig = ini_read_string(fname, "path", "");
		
			//Write new file path
			ini_write_string(fname, "path", string_replace(fpath_orig, _file, fpath));
		}
	} else {
	
		/*
		FILES
		*/
	
		//Do not rename read-only files
		if (ini_read_string(fname, "readonly", "true") == "true") {
			fsuccess = false;
		} else {
			//Get table of contents index
			tindex = ini_read_string(fname, "index", "-1");
	
			//Rename file in table of contents
			ini_write_string("?", tindex, _name);
	
			//Copy file data to new section
			ini_write_string(_name, "data", ini_read_string(fname, "data", "0"));
			ini_write_string(_name, "index", tindex);
			ini_write_string(_name, "path", ini_read_string(fname, "path", ""));
			ini_write_string(_name, "readonly", ini_read_string(fname, "readonly", "false"));	
		
			//Delete original file section
			ini_section_delete(fname);
		}
	}

	//End writing archive
	ini_close();

	//Confirm file renamed successfully
	return fsuccess;
}
