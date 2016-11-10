import sys
import re

arg = sys.argv

with open(arg[1]) as f:
    temperature = [line.rstrip('\n').split(',') for line in f if line.rstrip('\n') != '']

with open(arg[2]) as f:
    energy = [line.rstrip('\n').split(',') for line in f if line.rstrip('\n') != '']

for i in energy:
    if (energy.index(i) == 0) or (energy.index(i) == len(energy)-1):
        pass
    else:
        i[0] = re.sub(r'([0-9]{2})([0-9]{2})-([0-9]{2})-([0-9]{2})', r'\3/\4/\2', i[0])

temperatureData = temperature[2:]
temperatureDate = [i[1].split(" ")[0] for i in temperatureData]


for i in energy:
    if (energy.index(i) == 0) or (energy.index(i) == len(energy)-1):
        pass
    else:
        if energy.index(i) == 1:
            pass
        else:
            energyDate = i[0].split(" ")[0]
            index = temperatureDate.index(energyDate)
            temperatureData[index-1].append(str(float(i[1])/1000))

with open(arg[3],'w') as f:
    for i in temperature:
        f.write(",".join(i))
        f.write("\n")