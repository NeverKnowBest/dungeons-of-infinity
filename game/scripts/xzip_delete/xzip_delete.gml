/// @function		xzip_delete(arch, file1, [file2], ...);
/// @param			{string}						arch
/// @param			{string|integer|array|keyword}	file1
/// @param			{string|integer}				[file2]
/// @requires		xzip_create, xzip_list
/// @description	Checks if one or more files exist in the given archive and deletes
///					them. If a folder is supplied, all contents of the folder will be
///					deleted.
///				
///					Also returns `true` or `false` to indicate if the operation succeeded. 
///					Note that this includes failure to delete a file flagged as read-only. 
///					(This can be determined with `xzip_get_readonly`.)
///				
///					For files stored in the archive, a full path should NOT be used, just
///					the file name with extension. Use `xzip_list` to see what file names 
///					are available in the archive. The numerical index from `xzip_list`, an 
///					array, or the `all` keyword can also be used.
///				
///					Also note that this script does **not** delete the archive itself! 
///					For that, use the built-in `file_delete` function.
///				
///					Be warned that deletion takes time, and deleting many files at once 
///					can cause the game to temporarily appear frozen.
///
/// @example		xzip_delete("C:\\archive.xz", "file4.jpg");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_delete() {

	/*
	INITIALIZATION
	*/
	
	//Get arguments
	var _arch = argument[0];

	//Initialize temporary variables for modifying archive
	var dindex,
		dlist,
		findex,
		flist,
		fname,
		fsuccess = true,
		tindex;

	//Clear previous error report, if any
	ds_list_clear(xzip_report);

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		ds_list_add(xzip_report, filename_name(_arch));
		return false;
	}

	//Delete all files, if specified
	if (string(argument[1]) == string(all)) {
		flist = xzip_list(_arch);
	} else {
		//Otherwise only delete the requested files
		if (is_array(argument[1])) {
			//Use existing file array, if provided
			flist = argument[1];
		} else {
			//Otherwise create file array
			for (findex = 0; findex < (argument_count - 1); findex++) {
				flist[findex] = argument[findex + 1];
			}
		}
	}


	/*
	DELETION
	*/

	//Delete files from archive
	ini_open(_arch);
	for (findex = 0; findex < array_length(flist); findex++) {
		//Get file to delete from table of contents, if index is supplied
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
	
		//Delete files
		for (dindex = 0; dindex < array_length(dlist); dindex++) {
			//Get current file to delete
			fname = dlist[dindex];

			//Do not delete read-only files
			if (ini_read_string(fname, "readonly", "true") == "true") {
				ds_list_add(xzip_report, fname);
				fsuccess = false;
				continue;
			}
		
			//Get table of contents index
			tindex = real(ini_read_string(fname, "index", "-999"));
		
			//Delete file data
			ini_section_delete(fname);
		
			//Shift other files' indices
			while (ini_key_exists("?", string(tindex + 1))) {
				//Get other file to shift
				fname = ini_read_string("?", string(tindex + 1), filename_error);
			
				//Shift other file index
				ini_write_string(fname, "index", string(tindex));
			
				//Shift other table of contents index
				ini_write_string("?", string(tindex), fname);
			
				//Continue to next file
				tindex++;
			}
		
			//Delete table of contents index
			ini_key_delete("?", tindex);
		}
	
		//Clear directory file list
		dlist = 0;
	}

	//End writing archive
	ini_close();

	//Confirm file(s) deleted successfully
	return fsuccess;
}
