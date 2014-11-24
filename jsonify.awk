#!/usr/bin/awk -f

BEGIN {
    FS = "\t";
    prev_filename = ""; # Initially, there is no previous file

    # Start conversion
    print "Starting conversion...";

    # Create output directory if not available
    if(system("mkdir Build") == 0) {
	print "Creating a directory \"Build\", which contains the output.";
    }
}
{
    # Check if FILENAME has changed during execution of script. If it has, change output file.
    if(FILENAME != prev_filename) {
	# End JSON of current file
	if(prev_filename != "") {
	    print "}" >> output_file;
	}

	# Set initial value of file_name_end_index [in case file extension is not available]
	file_name_end_index = length(FILENAME);

	# Extract extension stripped filename and file path
	for (i=length(FILENAME); i>1; i--) {
	    char = substr(FILENAME, i, 1);
	    if(char == ".") {
		file_name_end_index = i - 1;
	    }
	    if(char == "/") {
		dir_path_end_index = i;
		break;
	    }
	}

	file_path = substr(FILENAME, 1, dir_path_end_index);
	filename_stripped = substr(FILENAME, dir_path_end_index + 1, file_name_end_index - dir_path_end_index);
	output_file = "Build/" filename_stripped ".json";

	# Set current file to be previous one
	prev_filename = FILENAME;

	# Log read start
	print "Reading file " FILENAME;
	print "Printing to file " output_file;

	# Start JSON
	print "{" > output_file;
    }

    key = $1;
    value = $2;

    # [Validation] Read next line if key is not available
    if(key == "") {
	next;
    }

    line = "\"" $1 "\": \"" $2 "\",";

    print line >> output_file;
}
END {
    # End JSON (of last file)
    print "}" >> output_file;

    # File conversion complete
    print "Conversion Complete.";
    exit 0;
}