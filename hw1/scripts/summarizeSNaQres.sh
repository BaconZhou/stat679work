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
