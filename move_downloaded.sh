#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --job-name=move
#SBATCH --time=100:00:00
#SBATCH --partition=general
#SBATCH --account=a_kelvin_tuong
#SBATCH -o move_sra.out
#SBATCH -e move_sra.error


# Define the source and destination directories
SRC_DIR="/scratch/project/tcr_ml/SRR_database_extraction/bamfilesncbi"
DEST_DIR="/QRISdata/Q7361/SRRIDS/bamfilesncbi"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Find all non-empty subdirectories and rsync them to the destination directory
find "$SRC_DIR" -mindepth 1 -type d ! -empty -exec rsync -a --remove-source-files {} "$DEST_DIR" \;

echo "All non-empty subdirectories have been synced to $DEST_DIR."
