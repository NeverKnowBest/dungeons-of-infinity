/// @function		xzip_verify(arch, dir, file);
/// @param			{string}		arch
/// @param			{string}		dir
/// @param			{string|int}	file
/// @requires		xzip_create
/// @description	Verifies an extracted file against its original archive and returns
///					`true` or `false` if the files' data matches.
///				
///					For files stored in the archive, a full path should NOT be used, just
///					the file name with extension. Use `xzip_list` to see what file names 
///					are available in the archive. The numerical index from `xzip_list` can 
///					also be used.
///				
///					This function does not support folders as file inputs. Any relative 
///					paths will be automatically applied to file names.
///				
///					Be warned that verification takes time, and verifying many files at
///					once can cause the game to temporarily appear frozen. It is recommended 
///					to verify large archives over a series of Steps and display a loading 
///					screen. (See example usage.)
///				
///					It is recommended to disable the filesystem sandbox for this script.
///					If the sandbox is enabled, archives can only be created and extracted
///					in `working_directory`.
///
/// @example		//CREATE
///					file_archive		= "C:\\archive.xz";
///					file_dest			= "C:\\my\\destination\\folder";
///					file_count			= xzip_count(file_archive);
///					file_current		= 0;
///					file_list			= xzip_list(file_archive);
///					file_fail_list		= 0;
///					file_fail_current	= 0;
///				
///					//STEP
///					if (file_current < file_count) {
///						//Create an array of failed files
///						if (!xzip_verify(file_archive, file_dest, file_list[file_current])) {
///							file_fail_list[file_fail_current] = file_list[file_current];
///							file_fail_current++;
///						}
///					
///						file_current++;
///					}
///				
///					//DRAW
///					var file_prog = file_current/file_count;
///				
///					draw_text(25, 25, "Verification: " + string(file_prog) + "% complete");
///					draw_text(25, 50, "Failed: " + string(array_length(file_fail_list)) + " files");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_verify(_arch, _dir, _file) {

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for verifying archive
	var buf_file,
		buf_file_comp,
		buf_str,
		fname,
		fpath,
		fverify = false;

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		return fverify;
	}

	//Open archive
	ini_open(_arch);

	//Get file to verify from table of contents, if index is supplied
	if (is_real(_file)) {
		fname = ini_read_string("?", string(_file), filename_error);
	} else {
		//Otherwise use file name as supplied
		fname = filename_name(_file);
	}

	//Get original file path
	fpath = ini_read_string(fname, "path", "");
	if (fpath != "") {
		fname = fpath + "\\" + fname;
	}

	//Compare extracted file hash to original file hash, if it exists
	if (file_exists(_dir + "\\" + fname)) {
		//Get file to compare
		buf_file = buffer_load(_dir + "\\" + fname);
		buf_file_comp = buffer_compress(buf_file, 0, buffer_get_size(buf_file));
		buf_str = buffer_base64_encode(buf_file_comp, 0, buffer_get_size(buf_file_comp));
	
		//Compare with original file
		fverify = (ini_read_string(fname, "data", "0") == buf_str);
	
		//Clear temp data from memory
		buffer_delete(buf_file);
		buffer_delete(buf_file_comp);
	}

	//End checking archive
	ini_close();

	//Return verification result
	return fverify;
}
