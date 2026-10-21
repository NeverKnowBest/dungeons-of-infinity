/// @function		xzip_add(arch, file1, [file2], ...);
/// @param			{string}		arch
/// @param			{string|array}	file1
/// @param			{string}		[file2]
/// @requires		file_list, filename_is_dir, xzip_count
/// @description	Adds one or more files to an archive previously created with `xzip_create`.
///					In place of individual file paths, an array of file paths can also be
///					supplied. If a path points to a folder, the contents of the folder will
///					be added, preserving the relative path of files and subfolders inside.
///				
///					Also returns `true` or `false` to indicate if the operation succeeded.
///					Note that this includes failure to overwrite an existing file flagged 
///					as read-only. (This can be determined with `xzip_get_readonly`.)
///				
///					Be warned that adding takes time, and archiving many files at once can 
///					cause the game to temporarily appear frozen.
///
/// @example		xzip_add("C:\\archive.xz", "C:\\file4.jpg");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_add() {

	/*
	INITIALIZATION
	*/
	
	//Get arguments
	var _arch = argument[0];

	//Initialize temporary variables for modifying archive
	var buf_file,
		buf_file_comp,
		buf_str,
		dindex,
		dlist,
		findex,
		flist,
		fname,
		fsuccess = true,
		tindex = max(0, xzip_count(_arch));

	//Clear previous error report, if any
	ds_list_clear(xzip_report);

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		ds_list_add(xzip_report, filename_name(_arch));
		return false;
	}

	//Add files from array, if specified
	if (is_array(argument[1])) {
		flist = argument[1];
	} else {
		//Otherwise get array of files to add
		for (findex = 0; findex < (argument_count - 1); findex++) {
			flist[findex] = argument[findex + 1];
		}
	}


	/*
	ADD OPERATION
	*/

	//Add files to archive
	ini_open(_arch);
	for (findex = 0; findex < array_length(flist); findex++) {
	
		/*
		DIRECTORIES
		*/
	
		//If directory is input, get list of subdirectories
		if (filename_is_dir(flist[findex])) {
			dlist = file_list(flist[findex], 0, true);
		} else {
			//Otherwise use only root directory if single file is input
			dlist = ds_list_create();
			dlist[| 0] = filename_name(flist[findex]);
			flist[findex] = filename_dir(flist[findex]);
		}
	
	
		/*
		FILES
		*/
	
		//Add files from directories
		for (dindex = ds_list_size(dlist) - 1; dindex >= 0; dindex--) {
			//Get file name to add
			fname = filename_name(dlist[| dindex]);
		
			//Do not overwrite existing read-only files
			if (ini_section_exists(fname)) {
				if (ini_read_string(fname, "readonly", "true") == "true") {
					//Continue to next file
					ds_list_add(xzip_report, fname);
					fsuccess = false;
					continue;
				}
			}

			//Load file to add
			buf_file = buffer_load(flist[findex] + "\\" + dlist[| dindex]);
		
			//Show error if file could not be read
			if (!buffer_exists(buf_file)) {
				show_error(
					"ERROR: Path or file not readable!\n" +
					"Click 'Ignore' to continue adding other files...", 
					false
				);
				ds_list_add(xzip_report, fname);
				fsuccess = false;
				continue;
			}
		
			//Compress and convert file to base64
			buf_file_comp = buffer_compress(buf_file, 0, buffer_get_size(buf_file));
			buf_str = buffer_base64_encode(buf_file_comp, 0, buffer_get_size(buf_file_comp));
	
			//Write file name to archive table of contents
			ini_write_string("?", string(tindex + findex), fname);
	
			//Write file data to archive
			ini_write_string(fname, "data", buf_str);
			ini_write_string(fname, "index", string(tindex + findex));
			ini_write_string(fname, "path", filename_dir(dlist[| dindex]));
			ini_write_string(fname, "readonly", "false");
	
			//Clear temp data from memory
			buffer_delete(buf_file);
			buffer_delete(buf_file_comp);
				
			//If more than one file exists in directory...
			if (dindex > 0) {
				//Increase table of contents file count
				tindex++
			}
		}
	
		//Clear directory file list
		ds_list_destroy(dlist);
	}


	/*
	FINALIZATION
	*/

	//End writing archive
	ini_close();

	//Confirm file(s) added successfully
	return fsuccess;
}
