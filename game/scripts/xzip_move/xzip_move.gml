/// @function		xzip_move(arch, dir, file1, [file2], ...);
/// @param			{string}			arch
/// @param			{string}			dir
/// @param			{string|int|array}	file1
/// @param			{string|int}		[file2]
/// @requires		xzip_create, xzip_list
/// @description	Moves one or more files to a subfolder within an archive previously created
///					with `xzip_create`. Upon extraction, files will appear in the new subfolder.
///					If any subfolder in the destination path does not exist, it will be created.
///				
///					If a folder is input, all files inside will be moved to the new location--
///					the relative path will **not** be preserved.
///				
///					Also returns true or false to indicate if the operation succeeded. Note
///					that this includes failure to move a file flagged as read-only. (This can 
///					be determined with `xzip_get_readonly`.)
///				
///					As archives have no mount point, you should not supply a disk letter when
///					specifying a destination folder. Separate subfolders with "\\", but do not
///					begin or end the path with a backslash. Use "" to move files to the root 
///					directory.
///				
///					Note that this does **not** move files that have already been extracted. For
///					that, use the included `file_move` function from GML+.
///
/// @example		xzip_move("C:\\archive.xz", "my\\destination\\folder", "file1.txt");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_move() {

	/*
	INITIALIZATION
	*/
	
	// Get arguments
	var _arch = argument[0],
		_dir  = argument[1];

	//Initialize temporary variables for modifying archive
	var dindex,
		dlist,
		findex,
		flist,
		fname,
		fsuccess = true;

	//Clear previous error report, if any
	ds_list_clear(xzip_report);

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		ds_list_add(xzip_report, filename_name(_arch));
		return false;
	}

	//Move all files, if specified
	if (string(argument[2]) == string(all)) {
		flist = xzip_list(_arch);
	} else {
		//Otherwise only move the requested files
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


	/*
	MOVE OPERATION
	*/

	//Move files in archive
	ini_open(_arch);
	for (findex = 0; findex < array_length(flist); findex++) {
		//Get file to move from table of contents, if index is supplied
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
	
		//Move files
		for (dindex = 0; dindex < array_length(dlist); dindex++) {
			//Get current file to move
			fname = dlist[dindex];

			//Do not move read-only files
			if (ini_read_string(fname, "readonly", "true") == "true") {
				ds_list_add(xzip_report, fname);
				fsuccess = false;
				continue;
			}
		
			//Set new file path
			ini_write_string(fname, "path", _dir);
		}
	
		//Clear directory file list
		dlist = 0;
	}

	//End writing archive
	ini_close();

	//Confirm file(s) moved successfully
	return fsuccess;
}
