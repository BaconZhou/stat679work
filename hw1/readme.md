# Instruction

Directory hw1 contains:

- **data/**
  - **log/**: directory used for storing _*.log_ files.
  - **out/** : directory used for storing _*.out_ files.
- **scripts**
  - **normalizeFileNames.sh** : Normalize file names. 
  - **summaryizeSNaQres.sh** : Generate summary table.
  - **undoNormalizeFileNames.sh** : Undo normalized file names.
- **results/summary.csv** : csv file for all summary.
- **readme.md** : Instruction.
- **makeFile** : Execute scripts.

Working directory: **hw1**

## makefile

Instruction:
- `make filename`: nomalized filename
- `make summary`: generate summary table
- `make clean`: undo what you have done

```make
filename:
	cd scripts;sh normalizeFileNames.sh
summary: 
	cd scripts;sh summarizeSNaQres.sh
clean:
	cd scripts;sh undoNormalizeFileNames.sh
	rm -f results/summary.csv
```

## normalizeFileNames.sh

Function doing for change files name.

**Example** _timetest1\_snaq.log timetest01\_snaq.log_

Used for loop and variable i to search the right file name, with
pattern *timetest$1\_snaq.log*. "$" using for eval the value of i. 

Code snapshoot:

```shell
for i in {1..9}
do
    mv ../data/log/timetest$i\_snaq.log ../data/log/timetest0$i\_snaq.log
    mv ../data/out/timetest$i\_snaq.out ../data/out/timetest0$i\_snaq.out
done

```

## summaryizeSnaQres.sh

Script using for summarize all data file from **log/** and the
corresponding **out/**.

Summmary contain:
 - analysis: file name
 - h: the maximum number of hybridizations
 - CPUtime: total CPU time
 - ~~Nruns: number of runs~~
 - ~~Nfail: tuning parameter~~
 - ~~...~~

**Example**

| analysis        | h | CPUtime          |
|-----------------|---|------------------|
| bT1             | 0 | 103354.760381735 |
| net1_snaq       | 1 | 11648.984309726  |
| newtry1         | 1 | 88579.306341032  |
| temtest1_snaq   | 1 | 16688.01510346   |
| temtest2_snaq   | 1 | 37137.96354747   |
| timetest3_snaq  | 1 | 12630.994448551  |
| timetest4_snaq  | 1 | 21942.346502542  |
| timetest5_snaq  | 1 | 23949.375026384  |
| timetest6_snaq  | 1 | 39287.796202476  |
| timetest7_snaq  | 1 | 29822.147601027  |
| timetest8_snaq  | 1 | 51589.342317181  |
| timetest9_snaq  | 1 | 34831.465925074  |
| timetest10_snaq | 1 | 29394.463493788  |
| timetest11_snaq | 1 | 67926.502059791  |
| timetest12_snaq | 1 | 18935.630572383  |
| timetest13_snaq | 1 | 31456.993676184  |

Instruction: 
- In for loop, use file to denote the file in log/
- "file" in loop contain .log extension,
- "outname" changed the file name extension and relative path
- "CPUtime" use '##*: 'to cut string before *, and '%% seconds*' after string
- ~~"Nfail" use `cut` function to cut the rigth string based on punctuation~~ 

Code Snapshoot:

```shell
echo analysis, h, CPUtime > ../results/summary.csv

for file in ../data/log/*.log
do
    analysis=`grep rootname $file | cut -f 2 -d ':'`
    outname="${file%.*}.out"
    outname="../data/out/${outname##*/}"
    h=`grep hmax $file | head -n 1 | cut -f 2 -d '=' | cut -f1 -d,`
    CPUtime=`grep Elapsed\ time "${outname}"`
    CPUtime=${CPUtime##*:}
    CPUtime=${CPUtime%% seconds*}

    echo $analysis, $h, $CPUtime >> ../results/summary.csv
done
```

## undoNormalizeFileNames.sh

```shell
for i in {1..9}
do
    mv ../data/log/timetest0$i\_snaq.log ../data/log/timetest$i\_snaq.log
    mv ../data/out/timetest0$i\_snaq.out ../data/out/timetest$i\_snaq.out
done
```
