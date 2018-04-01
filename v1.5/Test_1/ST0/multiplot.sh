#!bin/bash

#Shell script for plotting in bulk using bulk and boundary files and plotsims.sh shell script

#User input starting number
#start=$1

#User input finishing number
#finish=$2

for number in {0..200}
do
echo $number
plotname=$(printf "%5d\n" $number | tr ' ' '0')
echo "$plotname"
bash ./plotsims.sh "$plotname"
done
exit 0
