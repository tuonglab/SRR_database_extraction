#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --job-name=move
#SBATCH --time=50:00:00
#SBATCH --partition=general
#SBATCH --account=a_kelvin_tuong
#SBATCH -o move.out
#SBATCH -e move.error

rsync -av --progress --remove-source-files /scratch/project/tcr_ml/SRR_database_extraction/fastqfilesncbi/SRR1799031 /QRISdata/Q7361/SRRIDS/fastqfilesncbi
rsync -av --progress --remove-source-files /scratch/project/tcr_ml/SRR_database_extraction/fastqfilesncbi/SRR1811183 /QRISdata/Q7361/SRRIDS/fastqfilesncbi
