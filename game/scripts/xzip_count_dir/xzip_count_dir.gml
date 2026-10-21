/// @function		xzip_count(arch, dir);
/// @param			{string}	arch
/// @param			{string}	dir
/// @description	Returns the number of files in the given subfolder within the given 
///					archive created with `xzip_create`. An empty directory will return `0`, 
///					or `-1` if the archive doesn't exist at all.
///					
///					Unlike file names, the target directory should be written as a relative
///					path. (i.e. If the directory is a subfolder, parent folder(s) must be
///					included in the argument.)
///					
///					As archives have no mount point, you should not supply a disk letter 
///					when specifying a target folder. Separate subfolders with "\\", but 
///					do not begin or end the path with a backslash. Use "" to count files 
///					in the root directory.
/// 
/// @example		my_zip = xzip_create("C:\\archive.xz", "C:\\file1.txt", "C:\\file2.pdf");
///	
///					if (xzip_count_dir(my_zip, "my\\destination\\folder") == 0) {
///						xzip_move(my_zip, "my\\destination\\folder", "file1.txt", "file2.pdf");
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_count_dir(_arch, _dir) {
	//Initialize temporary variables for checking archive
	var f_in_dir,
		findex = 0, 
		fname,
		fpath,
		tindex = 0;

	//Skip if archive does not exist
	if (!file_exists(_arch)) {
		return -1;
	}

	//Get file count in archive	directory
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
				//Increase found directory file count
				findex++;
			}
		}
	
		//Continue to next file
		tindex++;
	}

	//End reading archive
	ini_close();
	
	//Return file count
	return findex;
}
