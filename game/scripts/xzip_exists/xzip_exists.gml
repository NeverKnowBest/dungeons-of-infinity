/// @function		xzip_exists(arch, file);
/// @param			{string}		arch
/// @param			{string|int}	file
/// @requires		xzip_create
/// @description	Checks if a file or folder exists in the given archive and returns 
///					`true` or `false`.
///				
///					Note that this does **not** check if the archive itself exists! For
///					that, use the built-in `file_exists` function.
///
/// @example		if (!xzip_exists("C:\\archive.xz", "file4.jpg")) {
///						xzip_add("C:\\archive.xz", "file4.jpg");
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_exists(_arch, _file) {
	//Initialize temporary variables for checking archive
	var fexists = false,
		fname;

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		return fexists;
	}

	//Check files from archive
	ini_open(_arch);

	//Get file to check from table of contents, if index is supplied
	if (is_real(_file)) {
		fname = ini_read_string("?", string(_file), filename_error);
	} else {
		//Otherwise use file name as supplied
		fname = filename_name(_file);
	}
	
	//Check if file exists in archive
	fexists = ini_section_exists(fname);

	//End checking archive
	ini_close();

	//If file was not found...
	if (!fexists) {
		//Check if folder exists in archive
		fexists = is_array(xzip_list_dir(_arch, _file));
	}

	//Return file state
	return fexists;
}
