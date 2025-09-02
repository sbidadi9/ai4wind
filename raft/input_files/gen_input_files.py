import yaml, json, glob, sys
from pathlib import Path
import numpy as np
import pandas as pd
import os
import shutil
from ruamel.yaml import YAML

yaml = YAML()
yaml.preserve_quotes = True

def gen_yaml_input_files(height_range, period_range, angle_range, run_folder='deepcwind_cases', template="OC4semi-RAFT_QTF.yaml"):

    if ( not Path(template).exists() ):
        print("Template file ", template, " doesn't exist. Please check your inputs")
        sys.exit()

    tfile = yaml.load(open(template))

    for i, period in enumerate(period_range):
        for j, height in enumerate(height_range):
            for k, angle in enumerate(angle_range):
                tfile['cases']['data'][0][6] = period
                tfile['cases']['data'][0][7] = height
                tfile['cases']['data'][0][8] = angle

                print(period, height, angle)
                yaml.dump(tfile, open(run_folder+'/OC4semi-RAFT-nt_QTF_T_'+str(period)+'_h_'+str(height)+'_theta_'+str(angle)+'.yaml','w'))

if __name__=="__main__":

    wave_height_range = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
    wave_period_range = [5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0]
    wave_angle_range = [0.0]

#    gen_yaml_input_files(height_range=wave_height_range, period_range=wave_period_range, angle_range=wave_angle_range, run_folder='deepcwind_cases', template="OC4semi-RAFT_QTF.yaml")

    gen_yaml_input_files(height_range=wave_height_range, period_range=wave_period_range, angle_range=wave_angle_range, run_folder='deepcwind_cases_nt', template="OC4semi-RAFT_QTF_no_turbine.yaml")

#    gen_yaml_input_files(height_range=wave_height_range, period_range=wave_period_range, angle_range=wave_angle_range, run_folder='deepcwind_cases_nt_soe', template="OC4semi-RAFT_QTF_no_turbine_soe.yaml")
