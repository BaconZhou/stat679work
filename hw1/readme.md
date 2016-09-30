# Instruction

Directory hw1 contains:

- `data/`
  - `log/`: directory used for storing _*.log_ files.
  - `out/` : directory used for storing _*.out_ files.
- `scripts`
  - `normalizeFileNames.sh` : Normalize file name. 
  - `summaryizeSNaQres.sh` : Generate summary table.
- `results/summary.csv` : csv file for all summary.
- `readme.md` : Instruction.
- `makeFile` : Excute scripts.

Working directory: hw1

## normalizeFileNames.sh

Function doing for change files name.

**Example** _timetest1\_snaq.log timetest01\_snaq.log_

Used for loop and variable i to search the right file name, with
pattern *timetest$1\_snaq.log*. "$" using for eval the value of i. 

Code snapshoot:

```shell
cd ../data/
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
 - ~~Nruns: number of runs~~
 - ~~Nfail: tuning parameter~~
 - ~~...~~

**Example**


Instruction: 
- In for loop, use file to denote the file in log/
- "file" in loop contain .log extension,
- "outname" changed the file name extension and relative path
- "CPUtime" use '##*: 'to cut string before *, and '%% seconds*' after string
- ~~"Nfail" use `cut` function to cut the rigth string based on punctuation~~ 

Code Snapshoot:

```shell
echo analysis, h, CPUtime, Nruns, Nfail, fabs, frel, xabs, xrel, seed, under3460, under3450, under3440 > summary.csv

for file in log/*.log
do
    analysis=`grep rootname $file | cut -f 2 -d ':'` # Cut string by second ":" sign
    outname="${file%.*}.out" # Change file name with *.out extension to match the file in out directory
    outname="out/${outname##*/}"
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
