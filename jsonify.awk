#!/usr/bin/awk -f

BEGIN {
    FS = "\t";
    output_file = "Build/fr.json";

    # Start conversion
    print "Starting conversion...";

    # Start JSON
    print "{" > output_file;
}
{
    key = $1;
    value = $2;

    line = "\"" $1 "\": \"" $2 "\",";

    print line >> output_file;
}
END {
    # End JSON
    print "}" >> output_file;

    # File conversion complete
    print "Conversion Complete.";
}