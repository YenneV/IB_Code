Instructions to use immersed boundary active code:

Currently the shell script files are set-up to be used on iceberg, such that linkers to the NAG libraries used correspond to those libraries on iceberg. If you are able to install these libraries on the machine you are using please change the linker directories in these scripts by changing the parameter $NAGLINK.

There are three scripts, each take a single argument, the source file.

- run.sh: runs a job locally
- submit.sh: submits a job to the iceberg queue
- submit_several.sh: submits numerous jobs to the iceberg queue

e.g.

./run.sh main_v3.cpp

will compile and run the source code in main_v3.cpp.

Note that the cpp files will not run alone as the shell script files generate necessary input files for the code. Input the desired parameters as the shell scripts instruct with spaces between input values if more than one is requested.

