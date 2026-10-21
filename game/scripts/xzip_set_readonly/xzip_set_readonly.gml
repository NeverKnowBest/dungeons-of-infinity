/// @function		xzip_set_readonly(arch, enable, file1, [file2], ...);
/// @param			{string}			arch
/// @param			{boolean}			enable
/// @param			{string|int|array}	file1
/// @param			{string}			[file2]
/// @requires		xzip_create, xzip_list
/// @description	Enables or disables flagging files as read-only within the given archive
///					created with `xzip_create`. Files flagged as read-only cannot be over-
///					written, deleted, renamed, or moved without first disabling the read-only
///					flag.
///				
///					If a folder is input, all files inside will be modified.
///				
///					This script will also return `true` or `false` to indicate if the operation 
///					succeeded.
///
/// @example		xzip_set_readonly("C:\\archive.xz", true, all);
///					xzip_set_readonly("C:\\archive.xz", false, "file1.txt", "file3.png");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_set_readonly() {

	/*
	INITIALIZATION
	*/
	
	//Get arguments
	var _arch = argument[0],
		_read = argument[1];

	//Initialize temporary variables for modifying archive
	var dindex,
		dlist,
		findex,
		flist,
		fname,
		fread = "true",
		fsuccess = true;

	//Clear previous error report, if any
	ds_list_clear(xzip_report);
	
	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		return false;
	}

	//Modify all files, if specified
	if (string(argument[2]) == string(all)) {
		flist = xzip_list(_arch);
	} else {
		//Otherwise only modify the requested files
		if (is_array(argument[2])) {
			//Use existing file array, if provided
			flist = argument[2];
		} else {
			//Otherwise create file array
			for (findex = 0; findex < (argument_count - 2); findex++) {
				flist[findex] = argument[findex + 2];
			}
		}
	}

	//Get read-only setting to apply
	if (_read == false) {
		fread = "false";
	}


	/*
	SET OPERATION
	*/

	//Modify files from archive
	ini_open(_arch);
	for (findex = 0; findex < array_length(flist); findex++) {
		//Get file to modify from table of contents, if index is supplied
		if (is_real(flist[findex])) {
			fname = ini_read_string("?", string(flist[findex]), filename_error);
		} else {
			//Otherwise use file name as supplied
			fname = filename_name(flist[findex]);
		}
	
		//If file is not found, try as directory
		if (!ini_section_exists(fname)) {
			//Temporarily close archive
			ini_close();
		
			//Get list of files in directory
			dlist = xzip_list_dir(_arch, flist[findex]);
		
			//If directory is not found, skip to next file
			if (!is_array(dlist)) {
				ds_list_add(xzip_report, fname);
				fsuccess = false;
				continue;
			}
		
			//Otherwise reopen archive
			ini_open(_arch);
		} else {
			//Otherwise use single file instead of directory
			dlist[0] = fname;
		}
	
		//Modify files
		for (dindex = 0; dindex < array_length(dlist); dindex++) {
			//Get current file to delete
			fname = dlist[dindex];
		
			//Set read-only state
			ini_write_string(fname, "readonly", fread);
		}
	
		//Clear directory file list
		dlist = 0;
	}

	//End writing archive
	ini_close();

	//Confirm file(s) modified successfully
	return fsuccess;
}
