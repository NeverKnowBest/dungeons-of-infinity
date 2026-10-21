/// @function		xzip_write(arch, buff, file);
/// @param			{string}	arch
/// @param			{buffer}	buff
/// @param			{string}	file
/// @requires		xzip_count
/// @description	Writes data from a buffer directly into the archive (instead of from a file on 
///					the disk) and assigns it a standard file name. Buffers will be compressed with 
///					zlib before writing. Once written, buffers can be restored with xzip_read or 
///					extracted and read from disk like any other file.
///				
///					Also returns true or false to indicate if the operation succeeded. Note that 
///					this includes failure to overwrite a file flagged as read-only. (This can be 
///					determined with `xzip_get_readonly`.)
///				
///					In GameMaker Studio, buffers are simply containers for binary data, and can 
///					store anything from text, to audio, to surfaces, and beyond. However, it's 
///					important to keep in mind that GameMaker must have a function to interpret the 
///					data in order to use it.
///
/// @example		var buf_surf = buffer_create(32, buffer_grow, 1);
///					buffer_get_surface(buf_surf, application_surface, buffer_surface_copy, 0, 0);
///	
///					xzip_write("C:\\archive.xz", buf_surf, "file5.surf");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_write(_arch, _buff, _file) {
	//Initialize temporary variables for modifying archive
	var buf_file_comp,
		buf_str,
		fname,
		tindex;

	//Skip if target archive does not exist
	if (!file_exists(_arch)) {
		return false;
	}

	//Get current archive size
	tindex = xzip_count(_arch);

	//Get input file name
	fname = filename_name(_file);

	//Open archive for writing
	ini_open(_arch);

	//Compress and convert input buffer to string
	buf_file_comp = buffer_compress(_buff, 0, buffer_get_size(_buff));
	buf_str = buffer_base64_encode(buf_file_comp, 0, buffer_get_size(buf_file_comp));

	//Write file name to archive table of contents
	if (!ini_section_exists(fname)) {
		ini_write_string("?", string(tindex), fname);
		ini_write_string(fname, "index", string(tindex));
	} else {
		//Do not overwrite read-only files
		if (ini_read_string(fname, "readonly", "true") == "true") {
			return false;
		}
	}

	//Write file data to archive
	ini_write_string(fname, "data", buf_str);
	ini_write_string(fname, "path", "");
	ini_write_string(fname, "readonly", "false");
	
	//Clear temp data from memory
	buffer_delete(buf_file_comp);

	//End writing archive
	ini_close();

	//Confirm file added successfully
	return true;
}
