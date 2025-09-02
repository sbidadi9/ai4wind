# example script for running RAFT with second-order loads computed internally with the slender-body approximation based on Rainey's equation

import numpy as np
import matplotlib.pyplot as plt
import yaml
import raft
import os
import os.path as path
import subprocess

all_forces = []

os.system("rm list_of_cases.dat")

result = subprocess.run("ls /scratch/sbidadi/ai4wind/raft/deepcwind/deepcwind_cases_nt >> list_of_cases.dat", shell=True, capture_output=True, text=True)

# Open the file using the 'with' statement
with open("list_of_cases.dat", "r") as file:
#with open("one_case.dat", "r") as file:

    # Loop over each line in the file
    for line in file:
        print(line.strip())  # Use .strip() to remove trailing newline characters

        print(line.split('_')[3], line.split('_')[5], line.split('_')[7])

        # open the design YAML file and parse it into a dictionary for passing to raft
        #flNm = 'deepcwind_runsOC4semi-RAFT_QTF_modified'

        # For fixed wave height:
        if (line.split('_')[5] == '5.0' and line.split('_')[7][0:3] == '0.0'):

        # For fixed wave period:
#        if (line.split('_')[3] == '10.0' and line.split('_')[7][0:3] == '0.0'):


           with open('/scratch/sbidadi/ai4wind/raft/deepcwind/deepcwind_cases_nt/'+line.strip()) as file:

                design = yaml.load(file, Loader=yaml.FullLoader)

                # Create the RAFT model (will set up all model objects based on the design dict)
                model = raft.Model(design)

                # Evaluate the system properties and equilibrium position before loads are applied
                model.analyzeUnloaded()

                model.solveEigen(display=1)

            # Due to the linearization of the quadratic drag term in RAFT, the QTFs depend on the sea state specified in the input file.
            # If more than one case is analyzed, the outputs are numbered sequentially.
            # Two output files are generated:
            # - The QTF, following WAMIT .12d file format. File name is qtf-slender_body-total_Head#p##_Case#_WT#.12d
            # - The RAOs used to computed the QTFs, following WAMIT .4 file format. File name is qtf-slender_body-total_Head#p##_Case#_WT#.12d
            # The Head#p## in the file name indicates the wave heading in degrees (p replaces the decimal point). 

            # Case number starts at 1, but turbine at 0 in conformity with the rest of the code.
                forces = model.analyzeCases(display=1, RAO_plot=0, compute_forces=1)
                all_forces.append([line.split('_')[3], line.split('_')[5], line.split('_')[7][0:3], forces])

#            print(forces[0], forces[1], forces[2], forces[3])
#            print(all_forces)

print(all_forces)

with open('output_nt_fixed_wave_height.txt', 'w') as f:

     for j, wave_params_and_forces_per_wave in enumerate(all_forces):

         wave_params = [wave_params_and_forces_per_wave[0], wave_params_and_forces_per_wave[1], wave_params_and_forces_per_wave[2]]
         wave_params = [float(x) for x in wave_params]
         print(wave_params)

         forces = wave_params_and_forces_per_wave[3]
         forces = [float(x) for x in forces]
         print(forces)

         f.write(' '.join(f"{x:.6f}" for x in wave_params))
         f.write(' ')
         f.write(' '.join(f"{x:.6f}" for x in forces))
         f.write("\n")

     f.close()

print("")

#wave_params_and_forces_all_waves  = []

#with open('output.txt', 'r') as f:
#    for line in f:

#        wave_params_and_forces_per_wave = [float(item) for item in line.strip().split()]
#        print(wave_params_and_forces_per_wave)
#        wave_params_and_forces_all_waves.append(wave_params_and_forces_per_wave)

#print(wave_params_and_forces_all_waves)

#print(wave_params_and_forces_all_waves[0][0])
#print(wave_params_and_forces_all_waves[1][0])

