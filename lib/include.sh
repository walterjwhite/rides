#!/bin/sh

. _LIBRARY_PATH/git-helpers/include.sh

_BIKE_MILEAGE=bike.ride
_PROJECT=$_PROJECT_BASE_PATH/$_BIKE_MILEAGE

# checks if the entry already exists
# NOTE: if we enter the date differently, it'll be entered twice
_exists() {
    local _matches=$(grep -c "^$_DATE,$_INDEX,$_BIKE" $_FILE)
    if [ "$_matches" -gt "0" ]
    then
        echo "Entry already exists, please double-check: $_DATE,$_INDEX,$_BIKE - $_FILE"
        exit 2
    fi
}

_file() {
    _YEAR=$(echo $_DATE | cut -f 1 -d '/')
    _decade

    _FILE=$_PROJECT/$_DECADE/$_YEAR.csv
}

# @see: /usr/local/sbin/zfs-media-backup
_decade() {
  _end_year=$(echo $_YEAR | head -c 4 | tail -c 1)
  _event_decade_prefix=$(echo -e "$_YEAR" | /usr/local/bin/grep -Po "[0-9]{3}")

  if [ "$_end_year" -eq "0" ]
  then
    _event_decade_start=${_event_decade_prefix}
    _event_decade_start=$(echo "$_event_decade_start-1" | bc)

    _event_decade_end=${_event_decade_prefix}0
  else
    _event_decade_start=$_event_decade_prefix
    _event_decade_end=$_event_decade_prefix

    _event_decade_end=$(echo "$_event_decade_end+1" | bc)
    _event_decade_end="${_event_decade_end}0"
  fi

  _event_decade_start=${_event_decade_start}1

  _DECADE=${_event_decade_start}-${_event_decade_end}
}
