#!/bin/bash

json_file="$1"

# Total number of masternodes
echo "Total Masternodes:"
jq '.masterNodes | length' "$json_file"

# Status aggregates
echo -e "\nMasternodes by Status:"
jq -r '.masterNodes[] | select(.status) | .status' "$json_file" | sort | uniq -c

# Aggregates by Payee
# echo -e "\nMasternodes by Payee:"
# jq -r '.masterNodes[] | select(.payee) | .payee' "$json_file" | sort | uniq -c

# Analysis: Payees with more than one masternode
echo -e "\nPayees with More Than 1 Masternode:"
jq -r '.masterNodes[] | select(.payee) | .payee' "$json_file" | sort | uniq -c | sort -nr | awk '$1 > 1'

# Analysis: List of Masternodes not ENABLED 
echo -e "\nList of Masternodes with Status Other Than 'ENABLED':"
jq '.masterNodes[] | select(.status != "ENABLED") | {proTxHash, status}' "$json_file"
