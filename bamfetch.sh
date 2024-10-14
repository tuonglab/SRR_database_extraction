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
  help
fi

temp_path="$TMPDIR"
# Load the IDs to exclude into an array
mapfile -t exclude_ids < "$exclude_ids_file"


# Ensure the temporary directory exists
mkdir -p "$temp_path"
mkdir -p "$output_scratch"

# Function to download and convert SRA files
download_and_convert() {
  srr_id=$1
  if printf '%s\n' "${exclude_ids[@]}" | grep -qx "$srr_id"; then
    echo "Skipping excluded ID: $srr_id"
    return
  fi
  echo "Downloading and converting $srr_id to FASTQ format from NCBI..."
  mkdir -p "$output_scratch/$srr_id"
  sam-dump "$srr_id" --ngc "$keypath" --fastq --output-file "$output_scratch/$srr_id/$srr_id.fastq"
#   fasterq-dump --ngc "$keypath" --split-files "$srr_id" -O "$output_scratch/$srr_id" --temp "$temp_path"
}

export -f download_and_convert
export output_scratch keypath temp_path exclude_ids

# Use GNU Parallel to run the download_and_convert function in parallel
cat "$srr_bam" | parallel -j 16 download_and_convert

echo "Download over"