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
