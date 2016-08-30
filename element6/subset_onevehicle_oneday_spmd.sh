#!/bin/bash

# Bail at first error
set -e

init_file() {
    local file="$1"
    local header="$2"

    if [[ ! -e "$file" ]]; then
        echo "$header" > "$file"
    fi
}

sample_file() {
    local infile="$1"
    local outfile="$2"
    local vehicle_id="$3"
    local vehicle_id_col="$4"
    local min_time="$5"
    local min_time_col="$6"
    local max_time="$7"
    local max_time_col="$8"

    awk -F, -v vehicle_id="$vehicle_id" -v vehicle_id_col="$vehicle_id_col" -v min_time="$min_time" -v min_time_col="$min_time_col" -v max_time="$max_time" -v max_time_col="$max_time_col" -f 'subset.awk' "$infile" | tr -d "\r" >> "$outfile"

    echo "Finished extracting $infile to $outfile."
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
    echo "Usage: ./create_data.sh <BSM_DIR>"
    echo "'BSM_DIR' should be the directory containing all the"
    echo "  BSM zips."
fi

bsm_dir="$1"
out_dir="$bsm_dir/sampled"

if [[ ! -d "$out_dir" ]]; then
    mkdir -p "$out_dir"
fi


old_ifs="$IFS"
IFS=','
for i in \
    "$out_dir/bsm_p1.csv","$bsm_dir/april_BsmP1.csv","$bsm_dir/BsmP1.csv.zip","1","1566","4","291864241884364","4","291950641884364","RxDevice|FileId|TxDevice|GenTime|TxRandom|MsgCount|DSecond|Latitude|Longitude|Elevation|Speed|Heading|Ax|Ay|Az|Yawrate|PathCount|RadiusOfCurve|Confidence" \
    "$out_dir/bsm_brakebyte1.csv","$bsm_dir/BrakeByte1Events.csv","$bsm_dir/BrakeByte1Events.csv.zip","1","62","4","278031838967359","5","278118238967359","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_brakebyte2.csv","$bsm_dir/BrakeByte2Events.csv","$bsm_dir/BrakeByte2Events.csv.zip","1","23","4","278801694980062","5","278888094980062","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_eventflag.csv","$bsm_dir/BsmEventFlag_01_30_04_13_FINAL.csv","$bsm_dir/BsmEventFlag.csv.zip","1","10106","4","292885650297105","4","292972050297105","RxDevice|FileID|TxDevice|Gentime|EventFlag" \
    "$out_dir/bsm_summary.csv","$bsm_dir/Trip_Summary_File_BsmP1_April.csv","$bsm_dir/BsmP1Summary.csv.zip","1","1566","3","-1","6","-1","DeviceID|TripID|EpochStartTime|StartDate|StartTime|EpochEndTime|EndDate|EndTime|TotalTripDistance (km)|DistanceOver25MPH (km)|DistanceOver55MPH (km)|TripDuration (s)|AverageSpeed (m/s)|MaximumSpeed (m/s)" \
    "$out_dir/bsm_exteriorlights.csv","$bsm_dir/ExteriorLightsEvents.csv","$bsm_dir/ExteriorLightsEvents.csv.zip","1","40","4","276263942358717","5","276350342358716","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_posaccurbyte1.csv","$bsm_dir/PosAccurByte1Events.csv","$bsm_dir/PosAccurByte1Events.csv.zip","1","2497","4","276213266040071","5","276299666040071","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_posaccurbyte2.csv","$bsm_dir/PosAccurByte2Events.csv","$bsm_dir/PosAccurByte2Events.csv.zip","1","1127","4","276241476160264","5","276327876160264","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_posaccurbyte3.csv","$bsm_dir/PosAccurByte3Events.csv","$bsm_dir/PosAccurByte3Events.csv.zip","1","291","4","276266376154934","5","276342776154933","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_posaccurbyte4.csv","$bsm_dir/PosAccurByte4Events.csv","$bsm_dir/PosAccurByte4Events.csv.zip","1","291","4","276266376154934","5","276342776154933","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_steerangle.csv","$bsm_dir/SteerAngleEvents.csv","$bsm_dir/SteerAngleEvents.csv.zip","1","10","4","276176189642801","5","276262589642801","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_throttleposition.csv","$bsm_dir/ThrottlePositionEvents.csv","$bsm_dir/ThrottlePositionEvents.csv.zip","1","61","4","276976245704789","5","277062645704788","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_transstate.csv","$bsm_dir/TransStateEvents.csv","$bsm_dir/TransStateEvents.csv.zip","1","11","4","276811583822236","5","276897983822236","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    "$out_dir/bsm_wiperstatus.csv","$bsm_dir/WiperStatusFrontEvents.csv","$bsm_dir/WiperStatusFrontEvents.csv.zip","1","40","4","276185412443679","5","276271812443679","RxDevice|FileId|TxDevice|StartTime|Endtime|Value" \
    ; do set -- $i

    outfile="$1"
    infile="$2"
    zipfile="$3"
    vehicle_id_col="$4"
    vehicle_id="$5"
    min_time_col="$6"
    min_time="$7"
    max_time_col="$8"
    max_time="$9"
    header="${10}"

    # only unzip the file if we haven't already
    if [[ ! -e "$infile" ]]; then
        unzip -j "$zipfile" -d "$bsm_dir"
    fi

    # only sample the file if we haven't already
    if [[ ! -e "$outfile" ]]; then
        echo "$header" | tr '|' ',' > "$outfile"
        sample_file "$infile" "$outfile" "$vehicle_id" "$vehicle_id_col" "$min_time" "$min_time_col" "$max_time" "$max_time_col"
    fi
done

IFS="$old_ifs"

tar -cz "$out_dir"/*.csv > "$out_dir/spmd_sampled.tar.gz"
