#!/bin/bash

# Bail at first error
set -e

sample_file() {
    local infile="$1"
    local outfile="$2"
    local sample_size="$3"

    # Write the first `sample_size` lines of infile to outfile
    head -n "$sample_size" "$infile" > "$outfile"
}

# Website data dir
#data_dir="../../website/element6/data"
#if [[ ! -d "$data_dir" ]]; then
#    mkdir -p "$data_dir"
#fi

# We want to use the current dir since this is just a sample
# for some exploratory analysis
output_dir="data"
if [[ ! -d "$output_dir" ]]; then
    mkdir -p "$output_dir"
fi

# Make sure the user passed the correct arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: ./create_data.sh <ONE_DAY_SAMPLE_DIR>"
    echo "'ONE_DAY_SAMPLE_DIR' should be the directory containing all the"
    echo "  unzipped files from the one day sample."
fi

oneday_sample_dir="$1"

for full_path in "$oneday_sample_dir"/*; do
    filename=$(basename "$full_path")
    sample_file "$full_path" "$output_dir/$filename" 300
done

tar -cz "$output_dir"/*.csv > "$output_dir/spmd_sampled.tar.gz"
