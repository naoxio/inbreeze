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
            # Append to XML releases
            xml_releases="$xml_releases<release version=\"$version\" date=\"$date\">\n<description><ul>\n$xml_output\n</ul></description>\n</release>\n"
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
    # Append the last release to XML
    xml_releases="$xml_releases<release version=\"$version\" date=\"$date\">\n<description><ul>\n$xml_output\n</ul></description>\n</release>\n"
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

# Extract the latest version from the changelog
latest_version=$(grep -m 1 '## \[' "$changelog_file" | sed -n 's/## \[\(.*\)\] - .*/\1/p')

if [ -z "$latest_version" ]; then
    echo "No version found in changelog"
    exit 1
fi

echo "Latest version from changelog: $latest_version"

# Update pubspec.yaml with the latest version and the version number as suffix
pubspec_file="pubspec.yaml"
if [ -f "$pubspec_file" ]; then
    sed -i "s/^version: .*/version: $latest_version+$version_number/" "$pubspec_file"
    echo "Updated version in $pubspec_file to $latest_version+$version_number"
else
    echo "$pubspec_file does not exist"
fi

# Update snapcraft.yaml with the latest version
snapcraft_file="snap/snapcraft.yaml"
if [ -f "$snapcraft_file" ]; then
    sed -i "s/^version: .*/version: '$latest_version'/" "$snapcraft_file"
    echo "Updated version in $snapcraft_file to $latest_version"
else
    echo "$snapcraft_file does not exist"
fi
