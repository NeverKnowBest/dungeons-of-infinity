/// @function		xzip_count(arch);
/// @param			{string}	arch
/// @description	Returns the number of files in the given archive created with `xzip_create`.
///					An empty archive will return `0`, or `-1` if it doesn't exist at all.
/// 
/// @example		my_zip = xzip_create("C:\\archive.xz");
///	
///					if (xzip_count(my_zip) == 0) {
///						xzip_add(my_zip, "C:\\file1.txt", "C:\\file2.pdf");
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xzip_count(_arch) {
	//Initialize temporary variables for checking archive
	var findex = 0;

	//Skip if archive does not exist
	if (!file_exists(_arch)) {
		return -1;
	}

	//Get file count in archive	
	ini_open(_arch);
	while (ini_key_exists("?", string(findex))) {
		findex++;
	}
	ini_close();
	
	//Return file count
	return findex;
}
