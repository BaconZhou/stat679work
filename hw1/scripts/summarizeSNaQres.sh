cp ../data/
echo analysis, h, CPUtime > summary.csv

for file in log/*.log
do
    analysis=`grep rootname $file | cut -f 2 -d ':'`
    outname="${file%.*}.out"
    outname="out/${outname##*/}"
    h=`grep hmax $file | head -n 1 | cut -f 2 -d '=' | cut -f1 -d,`
    CPUtime=`grep Elapsed\ time "${outname}"`
    CPUtime=${CPUtime##*:}
    CPUtime=${CPUtime%% seconds*}
    
    echo $analysis, $h, $CPUtime >> summary.csv
done
