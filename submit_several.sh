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
echo "const int Ly = 80;          //number of points in y direction" >> simops.cpp
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

if [ $opt1 == "y" ] ; then
echo "How many boundary activity values would you like to loop over?"
read Zcval
echo "Enter" $Zcval "EFFECTIVE boundary activity values"
read -a Zc
echo "How many off rate values would you like to loop over?"
read koval
echo "Enter" $koval "off rate values:"
read -a koff
echo "How many bulk diffusion values would you like to loop over?"
read Dbval
echo "Enter" $Dbval "bulk diffusion values:"
read -a Db
else
Zcval=1
koval=1
Dbval=1
fi
if [ $opt2 == "y" ] ; then
echo "How many surface tension values would you like to loop over?"
read Sval
echo "Enter" $Sval "ST values:"
read -a ST
echo "How many bulk activity values would you like to loop over?"
read Zval
echo "Enter" $Zval "bulk activity values"
read -a Z
echo "How many K values would you like to loop over?"
read Kval
echo "Enter" $Kval "K values:"
read -a K
else
Zval=1
Kval=1
Sval=1
fi

for i in $(seq 0 $((Sval-1)))
do
    for j in $(seq 0 $((Zcval-1)))
    do
	for k in $(seq 0 $((koval-1)))
	do
	    for l in $(seq 0 $((Zval-1)))
	    do
		for m in $(seq 0 $((Kval-1)))
		do
                    for n in $(seq 0 $((Dbval-1)))
                    do
                       #make another temp directory so we don't overwrite anything
		       echo "Here"
                       tdir1="temp1"       
		       while [ -d "$tdir1" ]
		       do
		          tdir1+="a"
		       done
		       mkdir $tdir1
		       cp $tdir/simops.cpp $tdir1/
		       dir="SIM"
		       if [ $opt1 == "y" ] ; then
		   	  dir+="_Zc"${Zc[$j]}"_koff"${koff[$k]}"_Db"${Db[$n]}
			  echo "double Zc=${Zc[$j]};    //boundary activity" >> $tdir1/simops.cpp
			  echo "double koff=${koff[$k]};    //boundary unbinding rate" >> $tdir1/simops.cpp
                          echo "double Dfb=${Db[$n]};    //Bulk diffusion rate" >> $tdir1/simops.cpp
		       fi

		       if [ $opt2 == "y" ] ; then
		           dir+="_Zb"${Z[$l]}"_K"${K[$m]}
			   echo "double Zeta=${Z[$l]};    //bulk activity" >> $tdir1/simops.cpp
			   echo "double K=${K[$m]};        //elastic constant" >> $tdir1/simops.cpp
                           echo "double ST=${ST[$i]};    //Surface tension" >> $tdir1/simops.cpp
		       else
                           echo "double ST=0.2;      //Surface tension" >> $tdir1/simops.cpp
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
		       cp $tdir1/simops.cpp $dir/
		       cp *.in $dir/
                       rm -r $tdir1
		       cd $dir/
		       filename=$dir".q"
		       echo "#!/bin/bash" >> $filename
		       echo "#$ -l h_rt=72:00:00" >> $filename
		       echo "#$ -l mem=0.4G" >> $filename
		       echo "#$ -l rmem=0.2G" >> $filename
		       echo "#$ -e "$dir".e" >> $filename
		       echo "#$ -o "$dir".o" >> $filename
		       echo "g++ "$1" -I/usr/local/packages5/nag/cll6a23dgl/include /usr/local/packages5/nag/cll6a23dgl/lib/libnagc_nag.a -lpthread  -lm" >> $filename
		       echo "./a.out" >> $filename
		       qsub $filename
		       cd ../
                    done
		done
	    done
	done
    done
done

rm -r $tdir
