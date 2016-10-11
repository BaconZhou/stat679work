# Instruction

## Updata Exercise 3

**Updata:**

- **summaryizeSNaQres.sh** : Given more summary from log files.
- **results/summary.csv** : csv file for more summary.

Working directory: **hw1**	

```shell
make # normalizeFileName and give summary in exercise 2 and 3.
make summary # Just do summary part.
```

New table

|     analysis    | h |      CPUtime     | Nruns | Nfail |  fabs  |  frel  |  xabs  |  xrel |  seed | under3460 | under3450 | under3440 |
|:---------------:|:-:|:----------------:|:-----:|:-----:|:------:|:------:|:------:|:-----:|:-----:|:---------:|:---------:|:---------:|
|       bT1       | 0 | 103354.760381735 |   10  |  100  | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 66077 |     0     |     0     |     0     |
|    net1_snaq    | 1 |  11648.984309726 |   10  |  100  | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 |  3322 |     1     |     1     |     1     |
|     newtry1     | 1 |  88579.306341032 |   10  |  100  | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 36252 |     4     |     4     |     2     |
| timetest10_snaq | 1 |  29394.463493788 |   10  |   50  | 1.0e-5 | 0.0001 | 0.0001 | 0.001 | 37792 |     0     |     0     |     0     |
| timetest11_snaq | 1 |  67926.502059791 |   10  |   50  | 5.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 25765 |     2     |     2     |     0     |
| timetest12_snaq | 1 |  18935.630572383 |   10  |   50  | 1.0e-6 | 1.0e-5 |  0.01  |  0.1  | 39416 |     4     |     0     |     0     |
| timetest13_snaq | 1 |  31456.993676184 |   10  |  100  | 1.0e-5 | 1.0e-5 |  0.01  |  0.1  | 38112 |     3     |     1     |     1     |
|  temtest1_snaq  | 1 |  16688.01510346  |   10  |   10  | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 30312 |     2     |     1     |     0     |
|  temtest2_snaq  | 1 |  37137.96354747  |   10  |   25  | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 28669 |     4     |     1     |     0     |
|  timetest3_snaq | 1 |  12630.994448551 |   10  |  100  |   0.1  |   0.1  | 0.0001 | 0.001 | 66086 |     0     |     0     |     0     |
|  timetest4_snaq | 1 |  21942.346502542 |   10  |  100  |  0.01  |  0.01  | 0.0001 | 0.001 | 62366 |     0     |     0     |     0     |
|  timetest5_snaq | 1 |  23949.375026384 |   10  |  100  |  0.005 |  0.005 | 0.0001 | 0.001 |  3888 |     2     |     1     |     0     |
|  timetest6_snaq | 1 |  39287.796202476 |   10  |   25  | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 14351 |     4     |     4     |     3     |
|  timetest7_snaq | 1 |  29822.147601027 |   10  |  100  |  0.005 |  0.005 | 0.0001 | 0.001 | 14351 |     5     |     5     |     0     |
|  timetest8_snaq | 1 |  51589.342317181 |   10  |  100  | 1.0e-6 | 1.0e-5 |  0.001 |  0.1  | 15989 |     3     |     2     |     1     |
|  timetest9_snaq | 1 |  34831.465925074 |   10  |   50  | 0.0001 | 1.0e-5 | 0.0001 | 0.001 | 45123 |     1     |     1     |     0     |

Code for **summaryizeSNaQres.sh**

```shell
echo analysis,h,CPUtime,Nruns,Nfail,fabs,frel,xabs,xrel,seed,under3460,under3450,under3440 > ../results/temp.csv

for file in ../data/log/*.log
do
    analysis=`grep rootname ${file} | grep -o [:/].* | grep -E "[[:alnum:]]\w+" -o`
    outname=`basename -s ".log" ${file}`
    outname="../data/out/${outname}.out"
    h=`grep hmax ${file} | head -n 1|grep -E "\d" -o`
    CPUtime=`grep -E "Elapsed time. \d+\.\d+" -o "${outname}"| grep -E "\d+\.\d+" -o`
    Nruns=`grep -E "BEGIN.\s\d+\sruns" ${file} -o | grep -E "\d+" -o`
    Nfail=`grep "max number of failed proposals" ${file} | grep -E "proposals\s.\s\d+" -o | grep -E "\d+" -o`
    fabs=`grep -o "ftolAbs.*" ${file} | sed 's/,//;s/ftolAbs=//'`
    frel=`grep -o "ftolRel.*" ${file} | sed s/ftolA.*// | sed s/,// | sed 's/ftolRel=//'`
    xabs=`grep xtolAbs ${file} | cut -f 2 -d '=' | cut -f 1 -d ','`
    xrel=`grep xtolRel ${file} | cut -f 3 -d '=' | cut -d. -f1,2`
    seed=`grep seed ${file} | head -n1 | cut -f3 -d " "`
    loglik=`grep "loglik of best" ${file} |cut -f10 -d " "| cut -f1 -d.`
    i1=0
    i2=0
    i3=0
    for lik in $loglik
    do
	if [ $lik -le 3460 ]
	then
	    i1=$((i1+1))
	fi

	if [ $lik -le 3450 ]
	then
	    i2=$((i2+1))
	fi

	if [ $lik -le 3440 ]
	then
	    i3=$((i3+1))
	fi

    done

    echo $analysis,$h,$CPUtime,$Nruns,$Nfail,$fabs,$frel,$xabs,$xrel,$seed,$i1,$i2,$i3>> ../results/temp.csv
done

sed s/[[:space:]]// ../results/temp.csv > ../results/summary.csv
rm -f ../results/temp.csv
```

## Exercise 1-2

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
- **makefile** : Execute scripts.

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
    mv ../data/log/timetest${i}_snaq.log ../data/log/timetest0${i}_snaq.log
    mv ../data/out/timetest${i}_snaq.out ../data/out/timetest0${i}_snaq.out
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
echo analysis,h,CPUtime > ../results/summary.csv

for file in ../data/log/*.log
do
    analysis=`grep rootname ${file} | grep -o [:/].* | grep -E "[[:alnum:]]\w+" -o`
    outname="${file%.*}.out"
    outname="../data/out/${outname##*/}"
    h=`grep hmax ${file} | head -n 1|grep -E "\d" -o`
    CPUtime=`grep -E "Elapsed time. \d+\.\d+" -o "${outname}"| grep -E "\d+\.\d+" -o`
    echo $analysis,$h,$CPUtime>> ../results/summary.csv
done
```

## undoNormalizeFileNames.sh

```shell
for i in {1..9}
do
    mv ../data/log/timetest0${i}_snaq.log ../data/log/timetest${i}_snaq.log
    mv ../data/out/timetest0${i}_snaq.out ../data/out/timetest${i}_snaq.out
done
```
