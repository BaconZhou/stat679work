all: filename summary
filename:
	cd scripts;sh normalizeFileNames.sh
summary: 
	cd scripts;sh summarizeSNaQres.sh
clean:
	cd scripts;sh undoNormalizeFileNames.sh
	rm -f results/summary.csv
