/// @function		xzip_get_readonly(arch, file);
/// @param			{string}		arch
/// @param			{string|int}	file
/// @requires		xzip_create
/// @description	Checks whether the read-only flag is enabled or disabled for the given file 
///					and returns `true` or `false`. If the input archive or file within do not 
///					exist, `false` will also be returned, as this indicates the archive/file can
///					be written.
///				
///					This function does not support folders as file inputs.
///
/// @example		if (!xzip_get_readonly("C:\\archive.xz", "file1.txt")) {
///						xzip_rename("C:\\archive.xz", "file1.txt", "textfile.txt");
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_get_readonly(_arch, _file) {
	//Initialize temporary variables for checking archive
	var fread = false,
		fname;

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		return fread;
	}

	//Open archive
	ini_open(_arch);

	//Get file to check from table of contents, if index is supplied
	if (is_real(_file)) {
		fname = ini_read_string("?", string(_file), filename_error);
	} else {
		//Otherwise use file name as supplied
		fname = filename_name(_file);
	}
	
	//Ensure file exists in archive
	if (ini_section_exists(fname)) {
		//Get read-only state from file
		fread = (ini_read_string(fname, "readonly", "true") == "true");
	}

	//End checking archive
	ini_close();

	//Return read-only state
	return fread;
}
