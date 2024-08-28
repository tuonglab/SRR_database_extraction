#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=400G
#SBATCH --job-name=sra
#SBATCH --time=200:00:00
#SBATCH --partition=general
#SBATCH --account=a_kelvin_tuong
#SBATCH -o SRR.out
#SBATCH -e SRR.error

cd /scratch/user/uqsdemon/ApplicationGNN/gnn_training
source gnnenvo/bin/activate

cd /scratch/user/uqsdemon/rnewbashscriptvf
chmod +x fastqfetch.sh

srun fastqfetch.sh