#!/bin/bash
#SBATCH --job-name=wspd04_lev2
#SBATCH -p hbw
#SBATCH --nodes=10
#SBATCH --account=ai4wind
#SBATCH --time=5:00:00
#SBATCH --mail-user=shreyas.bidadi@nrel.gov
#SBATCH --mail-type=BEGIN,END,FAIL
##SBATCH --qos=high
##SBATCH --switches=1@01:00:00

export SPACK_MANAGER=/scratch/sbidadi/amrwind_March_2025/exawind-manager
source ${SPACK_MANAGER}/start.sh
spack-start
module load PrgEnv-intel
quick-activate /scratch/sbidadi/amrwind_March_2025/exawind-manager/environments/update_amrex
spack load amr-wind

ranks_per_node=104
mpi_ranks=$(expr $SLURM_JOB_NUM_NODES \* $ranks_per_node)

srun -N10 -n720 --ntasks-per-node=72 --cpu_bind=rank_ldom  --distribution=block:block amr_wind abl_slip_wall_big_domain_fine_mesh.i  &> log.out
