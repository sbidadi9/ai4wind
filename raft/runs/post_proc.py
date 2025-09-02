import numpy as np
import matplotlib.pyplot as plt
import yaml
import raft
import os
import os.path as path
import subprocess
import matplotlib as mpl 

wave_params_and_forces_all_waves_nt  = []

with open('output_nt_fixed_wave_period.txt', 'r') as f:
    for line in f:

        wave_params_and_forces_per_wave_nt = [float(item) for item in line.strip().split()]
        print(wave_params_and_forces_per_wave_nt)
        wave_params_and_forces_all_waves_nt.append(wave_params_and_forces_per_wave_nt)

heights_nt = [row[1] for row in wave_params_and_forces_all_waves_nt]
int_load_nt = [row[6] for row in wave_params_and_forces_all_waves_nt]

wave_params_and_forces_all_waves_nt_period  = []

with open('output_nt_fixed_wave_height.txt', 'r') as f:
    for line in f:

        wave_params_and_forces_per_wave_nt_period = [float(item) for item in line.strip().split()]
        print(wave_params_and_forces_per_wave_nt_period)
        wave_params_and_forces_all_waves_nt_period.append(wave_params_and_forces_per_wave_nt_period)

period_nt = [row[0] for row in wave_params_and_forces_all_waves_nt_period]
int_load_nt_period = [row[6] for row in wave_params_and_forces_all_waves_nt_period]


# Create the plot
sorted_indices = np.argsort(heights_nt)
heights_nt_sorted = np.array(heights_nt)[sorted_indices]
int_load_nt_sorted = np.array(int_load_nt)[sorted_indices]
plt.figure(1)
plt.plot(heights_nt_sorted, int_load_nt_sorted, marker='o', linestyle='-', color='black')
#plt.scatter(heights_nt_soe, int_load_nt_soe, marker='o', color='red', label='Morrison eqn - SOE')
#plt.title('Integrated hydrodynamic loads vs. significant wave height on DeepCWind platform')
plt.xlabel('Significant wave height (m)')
plt.ylabel('Integrated hydrodynamic loads (N)')
#plt.legend()

sorted_indices = np.argsort(period_nt)
period_nt_sorted = np.array(period_nt)[sorted_indices]
int_load_nt_period_sorted = np.array(int_load_nt_period)[sorted_indices]
plt.figure(2)
plt.plot(period_nt_sorted, int_load_nt_period_sorted, marker='o', linestyle='-', color='black')
#plt.title('Integrated hydrodynamic loads vs. peak-spectral period on DeepCWind platform')
plt.xlabel('Peak-spectral period (s)')
plt.ylabel('Integrated hydrodynamic loads (N)')
#plt.legend()

# Save the plot as a PDF file
#plt.savefig('test.pdf', format='pdf', bbox_inches='tight')  # [4][6][10]

# (Optional) Show the plot window
plt.show()
