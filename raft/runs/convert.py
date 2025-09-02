import yaml
import re

with open("deepcwind_output.txt") as f:  
    matches = [line for line in f if line.startswith("surge")]
#    print(matches)

    print("---------------")

for i in range(len(matches)):
    print(matches[i])


print("--------------------------------")

sample = matches[0]
splits = re.split(r'\s+', sample)

print(splits[2])


with open("deepcwind_output.txt") as f:  
    matches = [line for line in f if line.startswith("OC4")]
    print(matches)


