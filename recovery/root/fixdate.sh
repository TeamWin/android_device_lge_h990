#!/sbin/ash
#This script fixes the time in TWRP for stock rom users
#stock and Lineage seem to produce ats files with different epochs and by default
#I made Lineage's time accurate

until pids=$(pidof recovery)
do
    sleep 1
done
sleep 2
#so now I have lineage 15.1 giving a year of 2019 with new kernel. sick of playing wackamole so forcing year to 2018 and will update for year end later
export ryear=2018
#day is now one off
export day=$(expr $(date +%j) - 1)
#now handle end of month
if [ $day -eq 0 ]; then
	export month=$(expr $(date +%m) -1)
	case $month in
		01|03|05|07|08|10|12) export day=31;;
		02) export day=28;;
		04|06|09|11) export day=30;;
		*) export day=31;; #shouldnt get here
	esac
#doing full adjustment hereand not below 
	date $month$day$(date +%H%M)$ryear.$(date +%S)
fi
#export year=`date +%Y`
#if [ $year -lt 2000 ]
#then
#export year=`expr $year + 46`
#date $(date +%m%d%H%M)$year.$(date +%S)
#fi
#On superv20 us996 10o I had it come up 2017 so handling this case
if [ `date +%Y`  -ne $ryear ]
then
export time=$(date +%H%M)
export second=$(date +%S)
date $(date +%m)$day$time$ryear.$second
#echo "Did 2017 date nudge" >>/twrp-date.log
fi
sleep 4
# Now not sure about the next comment, so being more aggressive and checking every 6 seconds.
#date gets switched back to 1972 20 seconds after twrp starts so waiting 19 seconds + 2 seconds to fix on the next run
exec /sbin/ash /fixdate.sh

