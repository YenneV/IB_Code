#!/bin/bash

#make temp directory so we don't overwrite anything
tdir="temp"       
while [ -d "$tdir" ]
do
    tdir+="a"
done
mkdir $tdir
cd $tdir

#get simulation options
tick="0"
while [ $tick -eq 0 ]
do
    echo "Include active boundary in simulations? (y or n):"
    read opt1
    if [ $opt1 == "y" ] ; then
	echo "#define CONC true          //include concentration on the boundary" >> simops.cpp
	tick="1"
    elif [ $opt1 == "n" ] ; then
	echo "#define CONC false         //don't include concentration on the boundary" >> simops.cpp
	tick="1"
    else echo "Sorry, I didn't catch that."
    fi
done

tick="0"
while [ $tick -eq 0 ]
do
    echo "Include internal active fluid in simulations? (y or n):"
    read opt2
    if [ $opt2 == "y" ] ; then
	echo "#define BULKPOL true          //include internal active fluid" >> simops.cpp
	tick="1"
    elif [ $opt2 == "n" ] ; then
	echo "#define BULKPOL false         //don't include internal active fluid" >> simops.cpp
	tick="1"
    else echo "Sorry, I didn't catch that."
    fi
done

tick="0"
while [ $tick -eq 0 ]
do
    echo "Include walls in simulations? (y or n):"
    read opt3
 if [ $opt3 == "y" ] ; then
echo "#define WALLS true          //include walls" >> simops.cpp
echo "const int Lx = 160;         //number of point in x direction" >> simops.cpp
echo "const int Ly = 40;          //number of points in y direction" >> simops.cpp
tick="1"
elif [ $opt3 == "n" ] ; then
echo "#define WALLS false         //don't include walls" >> simops.cpp
echo "const int Lx = 120;         //number of point in x direction" >> simops.cpp
echo "const int Ly = 120;          //number of points in y direction" >> simops.cpp
tick="1"
    else echo "Sorry, I didn't catch that."
    fi
done
echo " " >> simops.cpp
cd ../

echo "Surface tension value:"
read ST
dir="ST"$ST
echo "double ST=$ST;    //bare surface tension" >> $tdir/simops.cpp
if [ $opt1 == "y" ] ; then
    echo "Boundary Activity value:"
    read Zc
    echo "Boundary Off-rate:"
    read koff
    dir+="_Zc"$Zc"_koff"$koff
    echo "double Zc=$Zc;    //boundary activity" >> $tdir/simops.cpp
    echo "double koff=$koff;    //boundary unbinding rate" >> $tdir/simops.cpp
fi
if [ $opt2 == "y" ] ; then
    echo "Bulk Activity value:"
    read Zb
    echo "Elastic constant K value:"
    read K
    dir+="_Zb"$Zb"_K"$K
    echo "double Zeta=$Zb;    //bulk activity" >> $tdir/simops.cpp
    echo "double K=$K;        //elastic constant" >> $tdir/simops.cpp
fi
if [ $opt3 == "y" ] ; then
    dir+="_walls"
fi

while [ -d "$dir" ]
do
    dir+="a"
done
mkdir $dir

cp $1 $dir/
cp $tdir/simops.cpp $dir/
cp *.in $dir/
rm -r $tdir
cd $dir/
g++ $1 -I/opt/NAG/clmi623dgl/include /opt/NAG/clmi623dgl/lib/libnagc_nag.a -lpthread  -lm
./a.out
