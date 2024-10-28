#!/bin/bash

# Ensure the SRA Toolkit is in the PATH
export PATH="/scratch/project/tcr_ml/SRR_database_extraction/sratoolkit.3.1.1-ubuntu64/bin:$PATH"
srr_bam="/scratch/project/tcr_ml/SRR_database_extraction/SRRIDS/bam_ids.txt"
output_scratch="/scratch/project/tcr_ml/SRR_database_extraction/bamfilesncbi"
keypath="/scratch/project/tcr_ml/SRR_database_extraction/prj_33410_D38764.ngc"
exclude_ids_file="filedone.txt"

# Check that sra-tools is loaded correctly
if ! command -v sam-dump &> /dev/null; then
  echo "sam-dump could not be found. Please check your sratoolkit installation and PATH."
  exit 1
fi

temp_path="$TMPDIR"

# Ensure the temporary directory exists
mkdir -p "$temp_path"
mkdir -p "$output_scratch"

# Load the IDs to exclude into a temporary file
temp_exclude_file=$(mktemp)
cat "$exclude_ids_file" > "$temp_exclude_file"
echo "Excluded IDs loaded."

# Function to download and convert SRA files
download_and_convert() {
  srr_id=$1
  # Check if ID exists in the exclusion file
  if grep -qx "$srr_id" "$temp_exclude_file"; then
    echo "Skipping excluded ID: $srr_id"
    return
  fi
  echo "Downloading and converting $srr_id to FASTQ format from NCBI..."
  mkdir -p "$output_scratch/$srr_id"
  sam-dump "$srr_id" --ngc "$keypath" --fastq --output-file "$output_scratch/$srr_id/$srr_id.fastq"
#   fasterq-dump --ngc "$keypath" --split-files "$srr_id" -O "$output_scratch/$srr_id" --temp "$temp_path"
}

export -f download_and_convert
export output_scratch keypath temp_path temp_exclude_file

# Use GNU Parallel to run the download_and_convert function in parallel
cat "$srr_bam" | parallel -j 2 download_and_convert

# Cleanup temporary file
rm "$temp_exclude_file"
echo "Download over"
