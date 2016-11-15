from __future__ import print_function
import sys
import re

arg = sys.argv # caputer input arguments: arg[1] is temerature file, arg[2] is engergy file, arg[3] is output filename

with open(arg[1]) as f:
	temperature = [line.rstrip('\n').split(',') for line in f if line.rstrip('\n') != ''] # split by line, if line is empty not included

with open(arg[2]) as f:
	energy = [line.rstrip('\n').split(',') for line in f if line.rstrip('\n') != '']

for i in energy:
	if (energy.index(i) == 0) or (energy.index(i) == len(energy)-1):
		pass # pass the first and last line of energy file(first is header, last is total)
	else:
		i[0] = re.sub(r'([0-9]{2})([0-9]{2})-([0-9]{2})-([0-9]{2})', r'\3/\4/\2', i[0]) # change energy date to the same pattern as temperature pattern.

temperatureData = temperature[2:] # only focus on data rows
temperatureDate = [i[1].split(" ")[0] for i in temperatureData] # consider the temperature date, assume date has been ordered


for i in energy:
	if (energy.index(i) == 0) or (energy.index(i) == len(energy)-1):
		pass
	else:
		if energy.index(i) == 1:
			pass # we know the first line is not listed in temperature file
		else:
			energyDate = i[0].split(" ")[0]
			index = temperatureDate.index(energyDate)
			temperatureData[index-1].append(str(float(i[1])/1000))

temperature[0][0] = temperature[0][0].replace('\xef\xbb\xbf','').replace('\r\r','')
try:
	with open(arg[3],'w') as f:
		for i in temperature:
			i = [instance.replace('\r\r','') for instance in i] # delete windows new line character
			f.write(",".join(i))
			f.write("\n")
except IndexError:
	for i in temperature:
		i = [instance.replace('\r\r','') for instance in i]
		print(",".join(i))
