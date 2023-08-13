#!/bin/bash

# TODO:
# - fix: chart active and total nodes
# - fix: use commit timestamp instead of commit message
# - chart addresses wth more than one node -- number of nodes for each
# - chart added/deleted addresses (think how)

# Extracting data
echo "Extracting data to /tmp/data.txt..."
git log --pretty=format:'%H|%s' analyzed_stats | head -30 |
while IFS="|" read commit message; do
    timestamp=$(echo $message | cut -d' ' -f4-8) # Adjusted cut field to omit the day of the week
    count=$(git diff ${commit}^ $commit -- analyzed_stats | grep -A 1 "Total Masternodes:" | tail -1)
    count=$(echo $count | tr -d -c "0-9") # this ensures we only take the absolute value of the count
    echo "$timestamp $count"
done > /tmp/data.txt
echo "Data extraction complete. Check /tmp/data.txt."

# Transform the data for proper formatting
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
{print $5 "-" MONTH[$1] "-" $2 " " $3, $6}' /tmp/data.txt > /tmp/plot_data.txt



# Plot the data using gnuplot
gnuplot -p -e "
    set xdata time;
    set timefmt '%Y-%m-%d %H:%M:%S';
    set format x '%d/%m\n%H:%M';
    set xlabel 'Time';
    set ylabel 'Masternode count';
    plot '/tmp/plot_data.txt' using 1:3 with linespoints title 'Masternode count over time';
"

# End of the script
