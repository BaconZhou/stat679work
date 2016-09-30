for file in *.log
do
    analysis=`grep rootname $file | cut -f 2 -d ':'`
    outname="../out/${file%.*}.out"
#    echo $outname
    h=`grep hmax bt1.log | head -n 1 | cut -f 2 -d '='`
    CPUtime=`grep Elapsed\ time "${outname}"`
    CPUtime=${CPUtime##*:}
    CPUtime=${CPUtime%% seconds*}
    echo $analysis',' $h $CPUtime >> table.csv
done
