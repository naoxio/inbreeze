#!/bin/bash

changelog_file="CHANGELOG.md"
output_dir="metadata/en-US/changelogs"
temp_dir="$output_dir/temp"
metainfo_file="metadata/flatpak/io.naox.InnerBreeze.metainfo.xml"

# Create output and temporary directories if they don't exist
mkdir -p "$output_dir"
mkdir -p "$temp_dir"

# Initialize variables
version_number=0
inside_version=0
output=""
xml_output=""
xml_releases=""

# Read the changelog file line by line
while IFS= read -r line
do
    if [[ $line =~ ^\#\#\ \[(.*)\]\ -\ (.*)$ ]]; then
        if [[ $inside_version -eq 1 ]]; then
            version_number=$((version_number+1))
            echo -e "$output" > "$temp_dir/$version_number.txt"
            # Prepend to XML releases
            xml_releases="<release version=\"$version\" date=\"$date\">\n<description><ul>\n$xml_output\n</ul></description>\n</release>\n$xml_releases"
            output=""
            xml_output=""
        fi
        inside_version=1
        # Extract version and date
        version="${BASH_REMATCH[1]}"
        date="${BASH_REMATCH[2]}"
    elif [[ $inside_version -eq 1 ]]; then
        if [[ $line =~ ^- ]]; then
            list_item="${line:2}"
            output+="* $list_item\n"
            # Format for XML
            xml_output+="<li>$list_item</li>\n"
        fi
    fi
done < "$changelog_file"

# Write the last version's content if it exists
if [[ -n $output ]]; then
    version_number=$((version_number+1))
    echo -e "$output" > "$temp_dir/$version_number.txt"
    # Prepend the last release to XML
    xml_releases="<release version=\"$version\" date=\"$date\">\n<description><ul>\n$xml_output\n</ul></description>\n</release>\n$xml_releases"
fi

# Reverse the order of text files to match version order
highest_version=$version_number
for ((i=1; i<=highest_version; i++)); do
    target_version=$((highest_version - i + 1))
    mv "$temp_dir/$i.txt" "$output_dir/$target_version.txt"
done

# Clean up the temporary directory
rm -rf "$temp_dir"

# Update metainfo.xml file
# Backup existing metainfo.xml
cp "$metainfo_file" "$metainfo_file.bak"

# Replace the <releases> section in the metainfo.xml file
sed -i "/<releases>/,/<\/releases>/c\<releases>\n$xml_releases<\/releases>" "$metainfo_file"
