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
