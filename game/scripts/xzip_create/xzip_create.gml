/*
INITIALIZATION
*/

/// @description	Define macros
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

#region xzip_init()

// Xzip properties
#macro xzip_version "1.0.2 build 010921"

//Initialize random filename for use as an error
#macro filename_error "7Y30NZ38EPK25FQ.ERR"

//Initialize global recurse setting
#macro xzip_recurse global.sys_xzip_recurse
global.sys_xzip_recurse = false;

//Initialize and manage error report data structure
#macro xzip_report xzip_get_report()
global.sys_xzip_report = -1;
function xzip_get_report() {
	if (!ds_exists(global.sys_xzip_report, ds_type_list)) { 
		global.sys_xzip_report = ds_list_create(); 
	} 

	return global.sys_xzip_report;	
}
#endregion


/// @function		xzip_create(arch, file1, [file2], ...);
/// @param			{string}		arch
/// @param			{string|array}	file1
/// @param			{string}		[file2]
/// @requires		xzip_add
/// @description	Creates a new archive on the disk with the specified filename and adds 
///					one or more files to it. Also returns the archive path as a string to 
///					be stored in a variable for future reference.
///				
///					See `xzip_add` for details on acceptable input files. Files added to the 
///					archive will be compressed using zlib. However, Xzip uses additional 
///					metadata which may result in compressed files not being much smaller 
///					than their uncompressed originals. 
///				
///					The resulting archive can be added to the game's Included Files area as 
///					a means of storing external assets for future use.
///				
///					To access files in the created archive, use `xzip_extract`.
///				
///					Be warned that creation takes time, and archiving many files at once 
///					can cause the game to temporarily appear frozen.
///				
///					It is recommended to disable the filesystem sandbox for this script.
///					If the sandbox is enabled, archives can only be created and extracted
///					in working_directory.
///
/// @example		my_zip = xzip_create(
///						//Archive
///						"C:\\archive.xz",
///					
///						//Files
///						"C:\\file1.txt",
///						"C:\\file2.pdf",
///						"C:\\file3.png"
///					);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_create() {
	//Get arguments
	var _arch = argument[0];

	//Initialize temporary variables for creating archive
	var findex,
		flist;

	//Clear previous file, if any
	if (file_exists(_arch)) {
		file_delete(_arch);
	}

	//Initialize new empty archive
	ini_open(_arch);
	ini_write_string("?", "?", "Xzip by XGASOFT");
	ini_close();

	//Add files from array, if specified
	if (is_array(argument[1])) {
		flist = argument[1];
	} else {
		//Otherwise get array of files to add
		for (findex = 0; findex < (argument_count - 1); findex++) {
			flist[findex] = argument[findex + 1];
		}
	}

	//Add files to archive
	xzip_add(_arch, flist);

	//Return archive path for future reference
	return _arch;
}
