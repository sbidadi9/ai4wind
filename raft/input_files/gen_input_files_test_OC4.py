import yaml, json, glob, sys
from pathlib import Path
import numpy as np
import pandas as pd
import os
import shutil
from ruamel.yaml import YAML
from ruamel.yaml.comments import CommentedSeq

yaml = YAML()
yaml.preserve_quotes = True
yaml.representer.ignore_aliases = lambda x: True  # Prevent anchors

def gen_yaml_input_files(height_range, period_range, diameter_uc_range, diameter_bc_range, diameter_mc_range, diameter_p_range, run_folder='deepcwind_cases', template="OC4semi-RAFT_QTF.yaml"):

    if ( not Path(template).exists() ):
        print("Template file ", template, " doesn't exist. Please check your inputs")
        sys.exit()

    tfile = yaml.load(open(template))

    for i in range(len(height_range)):

        tfile['cases']['data'][0][6] = period_range[i]
        tfile['cases']['data'][0][7] = height_range[i]

       # main column:
        mc_d = tfile['platform']['members'][0]['d']
        mc_d[:] = [diameter_mc_range[i]]*len(mc_d)
        tfile['platform']['members'][0]['d'] = [mc_d[0], mc_d[1]]
        da_seq = CommentedSeq(tfile['platform']['members'][0]['d'])
        da_seq.fa.set_flow_style()
        tfile['platform']['members'][0]['d'] = da_seq
 
        # offset column:
        oc_d = tfile['platform']['members'][1]['d']
        oc_d[0:2] = [diameter_bc_range[i]]*2
        oc_d[2:4] = [diameter_uc_range[i]]*2
        tfile['platform']['members'][1]['d'] = [oc_d[0], oc_d[1], oc_d[2], oc_d[3]]
        da_seq = CommentedSeq(tfile['platform']['members'][1]['d'])
        da_seq.fa.set_flow_style()
        tfile['platform']['members'][1]['d'] = da_seq
 
        #delta_upper_pontoon
        dup_d = tfile['platform']['members'][2]['d']           
        dup_d[:] = [diameter_p_range[i]]*2
        tfile['platform']['members'][2]['d'] = [dup_d[0], dup_d[1]]
        da_seq = CommentedSeq(tfile['platform']['members'][2]['d'])
        da_seq.fa.set_flow_style()
        tfile['platform']['members'][2]['d'] = da_seq
 
        #delta_lower_pontoon
        tfile['platform']['members'][3]['d'] = da_seq 

        #Y_upper_pontoon
        tfile['platform']['members'][4]['d'] = da_seq
 
        #Y_lower_pontoon
        tfile['platform']['members'][5]['d'] = da_seq  
 
        #cross_brace
        tfile['platform']['members'][6]['d'] = da_seq
 
        print(height_range[i], period_range[i], diameter_mc_range[i], diameter_uc_range[i], diameter_bc_range[i], diameter_p_range[i])

        yaml.dump(tfile, open(run_folder+'/OC4semi-RAFT_h_'+ str(height_range[i]) + '_T_' + str(period_range[i]) + '_dmc_' + str(diameter_mc_range[i]) +
                  '_duc_' + str(diameter_uc_range[i]) + '_dbc_' + str(diameter_bc_range[i]) + '_dp_' + str(diameter_p_range[i]) +
                  '.yaml','w'))

if __name__=="__main__":

    # Read the CSV file into a DataFrame
    df = pd.read_csv('/projects/ai4wind/cvillato/00_OC4_Semi/input_data.csv')  # Replace with your filename

    # Extract a column as a Python list
    wave_height_range = df['WaveHs'].tolist()  # Replace 'ColumnName' with your actual column name
    wave_period_range = df['WaveTp'].tolist()  # Replace 'ColumnName' with your actual column name
    wave_angle_range = [0.0]
 
    diameter_mc = df['Main Column'].tolist()  # Replace 'ColumnName' with your actual column name
    diameter_uc = df['Upper Column'].tolist()  # Replace 'ColumnName' with your actual column name
    diameter_bc = df['Base Column'].tolist()  # Replace 'ColumnName' with your actual column name
    diameter_p = df['Pontoon Column'].tolist()  # Replace 'ColumnName' with your actual column name

#    wave_height_range = [1.0]
#    wave_period_range = [5.0]
   
#    diameter_uc = [9.6]
#    diameter_bc = [19.2]
#    diameter_mc = [5.2]
#    diameter_p = [1.28]

    gen_yaml_input_files(height_range=wave_height_range, period_range=wave_period_range, diameter_uc_range=diameter_uc, diameter_bc_range=diameter_bc, diameter_mc_range=diameter_mc, diameter_p_range=diameter_p, run_folder='OC4semi_cases_low_freq', template="OC4semi-RAFT_wamit_low_freq.yaml")
