#!/bin/bash -e
# Usage: ./add-file.sh [-f FILE_NAME] [-u URL] [-p]

pin="false"

while getopts ":f:u:p" opt; do
    case "$opt" in
        f)  # Local file option
            file="$OPTARG"
            ;;
        u)  # URL option
            url="$OPTARG"
            ;;
        p)  # Pin option
            pin="true"
            ;;
        \?) # Invalid option
            echo "Error: Invalid option -$OPTARG"
            exit 1
            ;;
        :)  # Missing argument for option
            echo "Error: Option -$OPTARG requires an argument"
            exit 1
            ;;
    esac
done

# Check if either -f or -u option is provided
if [ -z "$file" ] && [ -z "$url" ]; then
    echo "Error: Please provide either a local filename using -f or a URL using -u."
    exit 1
fi

# Function to upload the file using API call
upload_file() {
    local_file="$1"
    api_endpoint="http://localhost:5001/api/v0/add"
    cid_version=1

    # Check if the file exists locally
    if [ -f "$local_file" ]; then
        curl -X POST -F "file=@$local_file" "$api_endpoint?cid-version=$cid_version&pin=$pin"
    else
        echo "Error: Local file '$local_file' not found."
        exit 1
    fi
}

if [ -n "$file" ]; then
    # Upload the local file
    upload_file "$file"
elif [ -n "$url" ]; then
    # Download the file from URL and upload it
    temp_file=$(mktemp)
    curl -L "$url" -o "$temp_file"
    upload_file "$temp_file"
    rm "$temp_file"
fi
