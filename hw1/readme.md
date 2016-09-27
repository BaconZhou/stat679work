# Instruction
-

Directory hw1 contains:

- log/ : directory used for storing _*.log_ files.
- out/ : directory used for storing _*.out_ files.
- readme.md : Instruction.
- normalizeFileNames.sh : Normalize file name. 
- summaryizeSNaQres.sh : Generate summary table.
- summary.csv : csv file for all summary.
Working directory: hw1

## normalizeFileNames.sh

Function doing for change files name.

**Example** _timetest1\_snaq.log timetest01\_snaq.log_

Used for loop and variable i to search the right file name, with
pattern *timetest$1\_snaq.log*. "$" using for eval the value of i. 

Code snapshoot:

```shell
for i in {1..9}
do
    mv log/timetest$i\_snaq.log log/timetest0$i\_snaq.log
    mv out/timetest$i\_snaq.out out/timetest0$i\_snaq.out
done
```

## summaryizeSnaQres.sh

Script using for summarize all data file from **log/** and the
corresponding **out/**.

Summmary contain:
 - analysis: file name
 - h: the maximum number of hybridizations
 - CPUtime: total CPU time
 - Nruns: number of runs
 - Nfail: tuning parameter
 - ...

**Example**

| analysis        | h | CPUtime          | Nruns | Nfail | fabs   | frel   | xabs   | xrel  | seed  | under3460 | under3450 | under3440 |
|-----------------|---|------------------|-------|-------|--------|--------|--------|-------|-------|-----------|-----------|-----------|
| bT1             | 0 | 103354.760381735 | 10    | 100   | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 66077 | 0         | 0         | 0         |
| net1_snaq       | 1 | 11648.984309726  | 10    | 100   | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 3322  | 1         | 1         | 1         |
| newtry1         | 1 | 88579.306341032  | 10    | 100   | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 36252 | 4         | 4         | 2         |
| temtest1_snaq   | 1 | 16688.01510346   | 10    | 10    | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 30312 | 2         | 1         | 0         |
| temtest2_snaq   | 1 | 37137.96354747   | 10    | 25    | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 28669 | 4         | 1         | 0         |
| timetest3_snaq  | 1 | 12630.994448551  | 10    | 100   | 0.1    | 0.1    | 0.0001 | 0.001 | 66086 | 0         | 0         | 0         |
| timetest4_snaq  | 1 | 21942.346502542  | 10    | 100   | 0.01   | 0.01   | 0.0001 | 0.001 | 62366 | 0         | 0         | 0         |
| timetest5_snaq  | 1 | 23949.375026384  | 10    | 100   | 0.005  | 0.005  | 0.0001 | 0.001 | 3888  | 2         | 1         | 0         |
| timetest6_snaq  | 1 | 39287.796202476  | 10    | 25    | 1.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 14351 | 4         | 4         | 3         |
| timetest7_snaq  | 1 | 29822.147601027  | 10    | 100   | 0.005  | 0.005  | 0.0001 | 0.001 | 14351 | 5         | 5         | 0         |
| timetest8_snaq  | 1 | 51589.342317181  | 10    | 100   | 1.0e-6 | 1.0e-5 | 0.001  | 0.1   | 15989 | 3         | 2         | 1         |
| timetest9_snaq  | 1 | 34831.465925074  | 10    | 50    | 0.0001 | 1.0e-5 | 0.0001 | 0.001 | 45123 | 1         | 1         | 0         |
| timetest10_snaq | 1 | 29394.463493788  | 10    | 50    | 1.0e-5 | 0.0001 | 0.0001 | 0.001 | 37792 | 0         | 0         | 0         |
| timetest11_snaq | 1 | 67926.502059791  | 10    | 50    | 5.0e-6 | 1.0e-5 | 0.0001 | 0.001 | 25765 | 2         | 2         | 0         |
| timetest12_snaq | 1 | 18935.630572383  | 10    | 50    | 1.0e-6 | 1.0e-5 | 0.01   | 0.1   | 39416 | 4         | 0         | 0         |
| timetest13_snaq | 1 | 31456.993676184  | 10    | 100   | 1.0e-5 | 1.0e-5 | 0.01   | 0.1   | 38112 | 3         | 1         | 1         |

Instruction: 
- In for loop, use file to denote the file in log/
- "file" in loop contain .log extension,
- "outname" changed the file name extension and relative path
- "CPUtime" use '##*: 'to cut string before *, and '%% seconds*' after string
- "Nfail" use `cut` function to cut the rigth string based on punctuation 

Code Snapshoot:

```shell
echo analysis, h, CPUtime, Nruns, Nfail, fabs, frel, xabs, xrel, seed, under3460, under3450, under3440 > summary.csv

for file in log/*.log
do
    analysis=`grep rootname $file | cut -f 2 -d ':'`
    outname="${file%.*}.out"
    outname="out/${outname##*/}"
    echo $outname
    h=`grep hmax $file | head -n 1 | cut -f 2 -d '=' | cut -f1 -d,`
    CPUtime=`grep Elapsed\ time "${outname}"`
    CPUtime=${CPUtime##*:}
    CPUtime=${CPUtime%% seconds*}

    Nruns=`grep runs $file | cut -f 2 -d ':'`
    Nruns=${Nruns%% runs*}

    Nfail=`grep "max number of failed proposals" $file | cut -f 2 -d "=" | cut -d "," -f 1`
    fabs=`grep ftolAbs $file | cut -f 3 -d '=' | cut -f 1 -d ','` 
    frel=`grep ftolRel $file | cut -f 2 -d '=' | cut -f 1 -d ','`
    xabs=`grep xtolAbs $file | cut -f 2 -d '=' | cut -f 1 -d ','`
    xrel=`grep xtolRel $file | cut -f 3 -d '=' | cut -d. -f1,2`
    seed=`grep seed $file | head -n1 | cut -f3 -d " "`
    loglik=`grep "loglik of best" $file |cut -f10 -d " "| cut -f1 -d.`
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

    echo $analysis, $h, $CPUtime, $Nruns, $Nfail, $fabs, $frel, $xabs, $xrel, $seed, $i1, $i2, $i3>> summary.csv
done

```
