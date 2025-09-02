# example script for running RAFT with second-order loads computed internally with the slender-body approximation based on Rainey's equation

import numpy as np
import matplotlib.pyplot as plt
import yaml
import raft
import os
import os.path as path
import subprocess
import xarray as xr

all_forces = []

#os.system("rm list_of_cases.dat")
#result = subprocess.run("ls /scratch/sbidadi/ai4wind/raft/deepcwind/OC4semi_cases_low_freq >> list_of_cases.dat", shell=True, capture_output=True, text=True)
#result = subprocess.run("ls /scratch/sbidadi/ai4wind/raft/deepcwind/OC4semi_cases >> list_of_cases.dat", shell=True, capture_output=True, text=True)

# Open the file using the 'with' statement
with open("list_of_cases.dat", "r") as file:

    # Loop over each line in the file
    for line in file:
        print(line.strip())  # Use .strip() to remove trailing newline characters

 #       print(line.split('_')[2], line.split('_')[4], line.split('_')[6], line.split('_')[8], line.split('_')[10], (line.split('_')[12]).split('.yaml')[0] )

        with open('/scratch/sbidadi/ai4wind/raft/deepcwind/OC4semi_cases_low_freq/'+line.strip()) as file:
#        with open('/scratch/sbidadi/ai4wind/raft/deepcwind/OC4semi_cases/'+line.strip()) as file:

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
#
             # Case number starts at 1, but turbine at 0 in conformity with the rest of the code.
             forces = model.analyzeCases(display=1, RAO_plot=0, compute_forces=1)
             
             all_forces.append([line.split('_')[2], line.split('_')[4], line.split('_')[6], line.split('_')[8], line.split('_')[10], (line.split('_')[12]).split('.yaml')[0], forces])


##################### Saving PSDs into NetCDF file #####################
#my_array = np.array(all_forces, dtype=object)
#
#PSDx = []
#PSDy = []
#PSDz = []
#
#for j, wave_params_and_forces_per_wave in enumerate(all_forces):
#
#    PSDx.append(my_array[j][6][4][0])
#    PSDy.append(my_array[j][6][4][1])
#    PSDz.append(my_array[j][6][4][2])
#
#print(np.shape(PSDx))
#
#ds = xr.Dataset({
#    'PSDx': (('index', 'PSD'), PSDx),
#    'PSDy': (('index', 'PSD'), PSDy),
#    'PSDz': (('index', 'PSD'), PSDz),
#})

#ds.to_netcdf('PSDs_RAFT.nc')

with open('output_OC4_wamit_low_freq_one_case.txt', 'w') as f:
#with open('output_OC4_wamit.txt', 'w') as f:
     for j, wave_params_and_forces_per_wave in enumerate(all_forces):

         wave_params = [wave_params_and_forces_per_wave[0], wave_params_and_forces_per_wave[1], wave_params_and_forces_per_wave[2], wave_params_and_forces_per_wave[3], wave_params_and_forces_per_wave[4], wave_params_and_forces_per_wave[5]]
         wave_params = [float(x) for x in wave_params]
         print(wave_params)

         forces = wave_params_and_forces_per_wave[6]

         print(forces)

         for x in forces:
             print(x, type(x))

         forces = [float(x) for x in forces[:-1]]
         print(forces)

         f.write(' '.join(f"{x:.6f}" for x in wave_params))
         f.write(' ') 
         f.write(' '.join(f"{x:.6f}" for x in forces))
         f.write("\n")

     f.close()

print("")
