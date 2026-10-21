/// @function		xzip_read(arch, file);
/// @param			{string}	arch
/// @param			{string}	file
/// @requires		xzip_create
/// @description	Reads a file from an archive directly into memory (instead of extracting 
///					to the disk) and returns the result as a buffer. This is especially useful 
///					for game data like audio and surfaces.
///				
///					If the input archive or file within do not exist, `-1` will be returned 
///					instead, so it's a good idea to run `buffer_exists` before handling data 
///					returned by this script.
///
/// @example		var buf_surf = xzip_read("C:\\archive.xz", "file5.surf");
///	
///					if (buffer_exists(buf_surf)) {
///						buffer_set_surface(buf_surf, application_surface, 0, 0, 0);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_read(_arch, _file) {

	/*
	INITIALIZATION
	*/

	//Initialize temporary variables for modifying archive
	var buf_file = -1,
		buf_file_comp,
		fname;

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		return buf_file;
	}

	//Open archive for reading
	ini_open(_arch);

	//Get file to read from table of contents, if index is supplied
	if (is_real(_file)) {
		fname = ini_read_string("?", string(_file), filename_error);
	} else {
		//Otherwise use file name as supplied
		fname = filename_name(_file);
	}


	/*
	READ OPERATION
	*/

	//Ensure file data exists
	if (ini_section_exists(fname)) {
		//Get file data from archive
		buf_file_comp = ini_read_string(fname, "data", "0");
		
		//Decompress file data
		buf_file_comp = buffer_base64_decode(buf_file_comp);
		buf_file = buffer_decompress(buf_file_comp);
	
		//Clear temp data from memory
		buffer_delete(buf_file_comp);
	}

	//End reading archive
	ini_close();

	//Return read file as buffer
	return buf_file;
}
