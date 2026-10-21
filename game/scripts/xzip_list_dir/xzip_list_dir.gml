/// @function		xzip_list_dir(arch, dir, [relative]);
/// @param			{string}	arch
/// @param			{string}	dir
/// @param			{boolean}	[relative]
/// @requires		xzip_create
/// @description	Returns an array of strings containing the file names and extensions
///					(and optionally, relative paths) contained within an individual dir-
///					ectory within the given archive. An empty directory will return `0`,
///					or `-1` if the archive doesn't exist at all.
///				
///					Unlike file names, the target directory should be written as a rel-
///					ative path. (i.e. If the directory is a subfolder, parent folder(s)
///					must be included in the argument.)
///				
///					As archives have no mount point, you should not supply a disk letter 
///					when specifying a target folder. Separate subfolders with "\\", but 
///					do not begin or end the path with a backslash. Use "" to list files 
///					in the root directory.
///				
///					Unlike `xzip_list`, the resulting array indices **do not** correspond 
///					to archive indices. However, many functions support inputting an array 
///					of files, in which case an array returned by this function can be 
///					passed in directly.
///
/// @example		file_dir_array = xzip_list_dir("C:\\archive.xz", "my\\sub\\folder");
///	
///					xzip_extract("C:\\archive.xz", "C:\\extracted", file_dir_array[0]);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_list_dir() {
	//Get arguments
	var _arch = argument[0],
		_dir  = argument[1];
	
	//Initialize temporary variables for checking archive
	var f_in_dir,
		findex = 0,
		flist = 0,
		fname,
		fpath,
		frelative = false,
		tindex = 0;

	//Skip if archive does not exist
	if (!file_exists(_arch)) {
		return -1;
	}

	//Enable including relative paths, if specified
	if (argument_count > 2) {
		frelative = argument[2];
	}
	
	//Create array of archive contents
	ini_open(_arch);
	while (ini_key_exists("?", string(tindex))) {
		//Get file name and extension
		fname = ini_read_string("?", string(tindex), filename_error);
	
		//Get file path, if file exists
		if (fname != filename_error) {
			fpath = ini_read_string(fname, "path", "");
			f_in_dir = false;
		
			//Check all subfolders for file, if recursive
			if (xzip_recurse) {
				if (string_pos(_dir, fpath) == 1) or (_dir == "") {
					f_in_dir = true;
				}
			} else {
				//Otherwise check only the specified folder
				if (fpath == _dir) {
					f_in_dir = true;
				}
			}
	
			//If file belongs to the requested directory...
			if (f_in_dir) {
				//Add file to the array
				flist[findex] = fname;
	
				//Include relative paths, if enabled
				if (frelative) {
					//Prepend relative path, if any
					if (fpath != "") {
						flist[findex] = fpath + "\\" + flist[findex];
					}
				}
			
				//Increase found directory file count
				findex++;
			}
		}
	
		//Continue to next file
		tindex++;
	}

	//End reading archive
	ini_close();

	//Return contents array
	return flist;
}
