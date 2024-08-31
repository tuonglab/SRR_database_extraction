#!/usr/bin/bash
help(){
    echo "This script is going to download the SRA files from an SRA list provided after sorting the ID from an SRA table"
    echo "and place them inside of a new folder"
    echo "No argument is needed"
    echo
    echo "This script functions if the table file has a header"
    echo "If not, just change the done by the one behind a #"
    exit 1
}
# Add sratoolkit to PATH
# export PATH="/scratch/user/uqsdemon/ApplicationGNN/gnnenvo/bin/sratoolkit.3.1.1-ubuntu64/bin:$PATH"
export PATH="/scratch/project/tcr_ml/SRR_database_extraction/sratoolkit.3.1.1-ubuntu64/bin:$PATH"
# Load necessary modules (if still required)
module load sra-tools
module load samtools

# Path to the file containing SRR IDs
fastq_ids_file="SRRIDS/fastq_ids.txt"
# List of IDs to exclude
exclude_ids_file="filedone.txt"
outputpath="/QRISdata/Q7361/SRRIDS/fastqfilesncbi"
keypath="prj_33410_D38764.ngc"

# Check that sra-tools is loaded correctly
if ! command -v fasterq-dump &> /dev/null; then
  echo "fasterq-dump could not be found. Please check your sratoolkit installation and PATH."
  help
fi

if [ ! -f "$fastq_ids_file" ]; then
    echo "Error: the file with SRA IDs does not exist."
    help
fi

if [ ! -f "$keypath" ]; then
    echo "Error: the NGC file does not exist at the specified path."
    help
fi

# Load the IDs to exclude into an array
mapfile -t exclude_ids < "$exclude_ids_file"

temp_path="/QRISdata/Q7361/temp"

# Ensure the temporary directory exists
mkdir -p "$temp_path"

# Function to download and convert SRA files
download_and_convert() {
  srr_id=$1
  if printf '%s\n' "${exclude_ids[@]}" | grep -qx "$srr_id"; then
    echo "Skipping excluded ID: $srr_id"
    return
  fi
  echo "Downloading and converting $srr_id to FASTQ format from NCBI..."
  mkdir -p "$outputpath/$srr_id"
  fasterq-dump --ngc "$keypath" --split-files "$srr_id" -O "$outputpath/$srr_id" --temp "$temp_path"
}

export -f download_and_convert
export outputpath keypath temp_path exclude_ids

# Use GNU Parallel to run the download_and_convert function in parallel
cat "$fastq_ids_file" | parallel -j 4 download_and_convert

echo "Download over"
