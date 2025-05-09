#!/bin/bash

# % bash query_timer.sh label num_reps query db_file csv_file
  
  #Arguments:
  #    label:    explanatory label that will be output
  #    num_reps: number of repetitions
  #    query:    SQL query to run
  #    db_file:  database file
  #    csv_file: CSV file to create or append to

# Define arguments
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# Get current time and store it
# Start timing
start_time=$(date +%s)

# Loop num_reps times 
# Run the query num_reps times

for i in $(seq "$num_reps"); do
    duckdb "$db_file" "$query" > /dev/null 2>&1
done

# get current time - End timing
end_time=$(date +%s)

# Compute elapsed time 
elapsed=$((end_time - start_time)) # in seconds

# divide elapsed time by num_reps

# First check to avoid division by zero
if [ "$num_reps" -eq 0 ]; then
    avg_time="0"
else
    # Use bc for floating-point division
    avg_time=$(echo "scale=6; $elapsed / $num_reps" | bc)
fi


# Append result to the CSV file
echo "${label},${avg_time}" >> "$csv_file"