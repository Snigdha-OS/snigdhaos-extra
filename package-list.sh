#!/bin/bash

#-----------------------------------------------------------
# Script to generate a list of package details from a GitHub repository URL
# Author: RiO <d3v1l0n@outlook.in>
# Date: 2024-12-27
# Description: This script fetches the list of package filenames
# from a specified GitHub repository and processes them into a clean output.
# It also removes duplicate package names.
#-----------------------------------------------------------

# GitHub API URL for the directory
repo_url="https://api.github.com/repos/Snigdha-OS/snigdhaos-core/contents/x86_64"

# Output file
output_file="packages.txt"

# Function to install curl if not installed (for Arch Linux)
install_curl() {
    echo "curl is not installed. Attempting to install..."

    # Check if the system is using the pacman package manager (Arch Linux)
    if command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm curl
    else
        echo "Error: Could not detect pacman package manager. Please install curl manually."
        exit 1
    fi

    # Verify if curl was successfully installed
    if command -v curl &> /dev/null; then
        echo "curl has been installed successfully."
    else
        echo "Error: Failed to install curl. Please install it manually."
        exit 1
    fi
}

# Function to fetch and process the package list (only package names, with duplicates removed)
fetch_packages() {
    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        install_curl
    fi

    # Fetch the directory content from the GitHub API, extract package names, remove duplicates
    curl -s "$repo_url" | \
    jq -r '.[].name' | \
    grep -oP '^[^/]+(?=-[0-9]+-[a-z0-9]+\.pkg\.tar\.zst)' | \
    sort | \
    uniq > "$output_file"

    # Check if the output file is generated successfully
    if [[ $? -eq 0 ]]; then
        echo "Generated $output_file with package names (duplicates removed)."
    else
        echo "Error: Failed to generate the package list."
        exit 1
    fi
}

# Run the function
fetch_packages