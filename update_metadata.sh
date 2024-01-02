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

            xml_releases+="        <release version=\"$version\" date=\"$date\">\n"
            xml_releases+="            <description>\n                <ul>\n"
            xml_releases+="$xml_output"
            xml_releases+="                </ul>\n            </description>\n"
            xml_releases+="        </release>\n"

            output=""
            xml_output=""
        fi
        inside_version=1
        version="${BASH_REMATCH[1]}"
        date="${BASH_REMATCH[2]}"
    elif [[ $inside_version -eq 1 ]]; then
        if [[ $line =~ ^- ]]; then
            list_item="${line:2}"
            output+="* $list_item\n"
            xml_output+="                    <li>$list_item</li>\n"  
        fi
    fi
done < "$changelog_file"

if [[ -n $output ]]; then
    version_number=$((version_number+1))
    echo -e "$output" > "$temp_dir/$version_number.txt"

    xml_releases+="        <release version=\"$version\" date=\"$date\">\n"
    xml_releases+="            <description>\n                <ul>\n"
    xml_releases+="$xml_output"
    xml_releases+="                </ul>\n            </description>\n"
    xml_releases+="        </release>\n"
fi

highest_version=$version_number
for ((i=1; i<=highest_version; i++)); do
    target_version=$((highest_version - i + 1))
    mv "$temp_dir/$i.txt" "$output_dir/$target_version.txt"
done

rm -rf "$temp_dir"

cp "$metainfo_file" "$metainfo_file.bak"

# Update release version

sed -i "/<releases>/,/<\/releases>/c\<releases>\n$xml_releases<\/releases>" "$metainfo_file"
latest_version=$(grep -m 1 '## \[' "$changelog_file" | sed -n 's/## \[\(.*\)\] - .*/\1/p')

if [ -z "$latest_version" ]; then
    echo "No version found in changelog"
    exit 1
fi

echo "Latest version from changelog: $latest_version"

pubspec_file="pubspec.yaml"
if [ -f "$pubspec_file" ]; then
    sed -i "s/^version: .*/version: $latest_version+$version_number/" "$pubspec_file"
    echo "Updated version in $pubspec_file to $latest_version+$version_number"
else
    echo "$pubspec_file does not exist"
fi

snapcraft_file="snapcraft.yaml"
if [ -f "$snapcraft_file" ]; then
    sed -i "s/^version: .*/version: '$latest_version'/" "$snapcraft_file"
    echo "Updated version in $snapcraft_file to $latest_version"
else
    echo "$snapcraft_file does not exist"
fi
