#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=32G
#SBATCH --job-name=sra
#SBATCH --time=200:00:00
#SBATCH --partition=general
#SBATCH --account=a_kelvin_tuong
#SBATCH -o SRR.out
#SBATCH -e SRR.error

./names.sh
./fastqfetch.sh