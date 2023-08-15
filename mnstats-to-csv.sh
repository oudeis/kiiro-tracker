#!/bin/bash

json_file="$1"
timestamp="$2"  # $(date +%s)

# Use jq to extract masterNodes from the JSON file and add the timestamp
jq -r '.masterNodes[] | 
    [
        .proTxHash, 
        .address, 
        .payee, 
        .status, 
        .lastpaidtime, 
        .lastpaidblock, 
        .owneraddress, 
        .votingaddress, 
        .collateraladdress, 
        .pubkeyoperator, 
        "'$timestamp'"
    ] | @csv' $json_file