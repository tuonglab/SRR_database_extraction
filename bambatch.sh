#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=32G
#SBATCH --job-name=sra_bam
#SBATCH --time=48:00:00
#SBATCH --partition=general
#SBATCH --account=a_kelvin_tuong
#SBATCH -o SRR_bam.out
#SBATCH -e SRR_bam.error

# ./names.sh
# ./fastqfetch.sh
./bamfetch.sh