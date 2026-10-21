/// @function		xzip_extract(arch, dir, file1, [file2], ... );
/// @param			{string}			arch
/// @param			{string}			dir
/// @param			{string|int|array}	file1
/// @param			{string|int}		[file2]
/// @requires		xzip_create, xzip_list, xzip_list_dir
/// @description	Extracts one or more files from an archive created with `xzip_create` 
///					to the destination folder. Also returns true or false to indicate if 
///					theoperation succeeded.
///				
///					For files stored in the archive, a full path should NOT be used, just
///					the file name with extension. Use `xzip_list` to see what file names 
///					are available in the archive. The numerical index from `xzip_list`, an 
///					array, or the `all` keyword can also be used. If a folder is input, all 
///					files from the folder will be extracted, preserving the relative path.
///				
///					Be warned that extraction takes time, and extracting many files at
///					once can cause the game to temporarily appear frozen. It is recommended 
///					to extract large archives over a series of Steps and display a loading 
///					screen. (See example usage.)
///				
///					It is recommended to disable the filesystem sandbox for this script.
///					If the sandbox is enabled, archives can only be created and extracted
///					in `working_directory`.
/// 
/// @example		//CREATE
///					file_archive	= "C:\\archive.xz";
///					file_dest		= "C:\\my\\destination\\folder";
///					file_count		= xzip_count(file_archive);
///					file_current	= 0;
///					file_list		= xzip_list(file_archive);
///				
///					//STEP
///					if (file_current < file_count) {
///						xzip_extract(file_archive, file_dest, file_list[file_current]);
///					
///						file_current++;
///					}
///				
///					//DRAW
///					var file_prog = file_current/file_count;
///				
///					draw_text(25, 25, "Extraction: " + string(file_prog) + "% complete");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_extract() {

	/*
	INITIALIZATION
	*/
	
	//Get arguments
	var _arch = argument[0],
		_dir  = argument[1];

	//Initialize temporary variables for extracting archive
	var buf_file,
		buf_file_comp,
		dindex,
		dlist,
		findex,
		flist,
		fname,
		fpath,
		fsuccess = true;

	//Clear previous error report, if any
	ds_list_clear(xzip_report);
	
	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		ds_list_add(xzip_report, filename_name(_arch));
		return false;
	}

	//Extract all files, if specified
	if (string(argument[2]) == string(all)) {
		flist = xzip_list(_arch);
	} else {
		//Otherwise only extract the requested files
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
	EXTRACTION
	*/

	//Extract files from archive
	ini_open(_arch);
	for (findex = 0; findex < array_length(flist); findex++) {
		//Get file to extract from table of contents, if index is supplied
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

		//Extract files
		for (dindex = 0; dindex < array_length(dlist); dindex++) {
			//Get current file to extract
			fname = dlist[dindex];
		
			//Get file data from archive
			buf_file_comp = ini_read_string(fname, "data", "0");
		
			//Decompress file data
			buf_file_comp = buffer_base64_decode(buf_file_comp);
			buf_file = buffer_decompress(buf_file_comp);
			
			//Get relative path to write to
			fpath = ini_read_string(fname, "path", "");
			if (fpath != "") {
				fpath = fpath + "\\";
			}
	
			//Write extracted data to disk
			buffer_save(buf_file, _dir + "\\" + fpath + fname);
	
			//Clear temp data from memory
			buffer_delete(buf_file);
			buffer_delete(buf_file_comp);
		}
	
		//Clear directory file list
		dlist = 0;
	}

	//End reading archive
	ini_close();

	//Confirm file(s) extracted successfully
	return fsuccess;
}
