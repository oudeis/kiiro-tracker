#!/bin/bash

# Extracting data
echo "Extracting data to /tmp/data.txt..."
git log --pretty=format:'%H|%s' analyzed_stats | head -30000 | 
while IFS="|" read commit message; do
    timestamp=$(echo $message | cut -d' ' -f4-8) 
    # echo $timestamp
    # echo $commit
    countTotal=$(git show ${commit}:analyzed_stats | awk 'NR==2{print $1}')
    countEnabled=$(git show ${commit}:analyzed_stats | awk 'NR==5{print $1}')
    echo "$timestamp $countTotal $countEnabled"
done > /tmp/data.txt
echo "Data extraction complete. Check /tmp/data.txt."


# Transform the data for gnuplot
awk '
BEGIN {
    MONTH["Jan"] = "01";
    MONTH["Feb"] = "02";
    MONTH["Mar"] = "03";
    MONTH["Apr"] = "04";
    MONTH["May"] = "05";
    MONTH["Jun"] = "06";
    MONTH["Jul"] = "07";
    MONTH["Aug"] = "08";
    MONTH["Sep"] = "09";
    MONTH["Oct"] = "10";
    MONTH["Nov"] = "11";
    MONTH["Dec"] = "12";
}
{print $5 "-" MONTH[$1] "-" $2 " " $3, $6, $7}' /tmp/data.txt > masternodes_plot_data.txt


echo "/tmp/data.txt:" 
cat /tmp/data.txt
echo " masternodes_plot_data.txt:" 
cat masternodes_plot_data.txt

# Plot the data using gnuplot
gnuplot -p -e "
    set terminal png;
    set output 'masternodes_plot.png';
    set xdata time;
    set timefmt '%Y-%m-%d %H:%M:%S';
    set format x '%d/%m'; 
    set xlabel 'Time';
    set ylabel 'Masternode count';
    plot 'masternodes_plot_data.txt' using 1:3 with linespoints title 'TOTAL Masternode count over time', \
         'masternodes_plot_data.txt' using 1:4 with linespoints title 'ENABLED Masternode count over time';
"
