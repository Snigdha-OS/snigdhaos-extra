#!/bin/bash

#-----------------------------------------------------------
# Script to update Snigdha OS Core repository
# Author            : Eshan Roy
# Author URI        : https://eshanized.github.io
# Contributor       : RiO
# Contributor URI   : https://d3v1l0n.github.io
# Date              : 2024-12-27
# Description       : This script updates the Snigdha OS Core repository
# by adding new package files and updating the database files.
#-----------------------------------------------------------

# Set the name for the repository database
repo_name="snigdhaos-core"

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Step 1: Remove old packages and database files
echo "Cleaning up old package and database files..."
rm -f "${repo_name}"* || handle_error "Failed to remove old packages."

# Step 2: Adding new packages to the repository
echo "Adding new packages to the repository..."
repo-add -s -n -R "${repo_name}.db.tar.gz" *.pkg.tar.zst || handle_error "Failed to add packages."

# Sleep to ensure all files are processed
sleep 1

# Step 3: Remove old database and files
echo "Cleaning up old database and files..."
rm -f "${repo_name}.db" "${repo_name}.db.sig" "${repo_name}.files" "${repo_name}.files.sig" || handle_error "Failed to remove old database files."

# Step 4: Move new files into place
echo "Moving new database and file archive..."
mv -f "${repo_name}.db.tar.gz" "${repo_name}.db" || handle_error "Failed to move database file."
mv -f "${repo_name}.db.tar.gz.sig" "${repo_name}.db.sig" || handle_error "Failed to move database signature file."
mv -f "${repo_name}.files.tar.gz" "${repo_name}.files" || handle_error "Failed to move files archive."
mv -f "${repo_name}.files.tar.gz.sig" "${repo_name}.files.sig" || handle_error "Failed to move files signature."

# Step 5: Confirmation
echo "Repository updated successfully!"
echo "*******************************************************************************"
echo "You can now sync the repository with 'pacman -Sy' to fetch the latest packages."
echo "*******************************************************************************"