#!/bin/bash

echo "------------------- Preprocessing data -------------------"
date +"%T"


echo "------------ Generate data for experiment 1 -------------"
exp=1
ncat=2 

Rscript ./preprocessing/main_preproc.R "$exp" "$ncat"


echo "------------ Generate data for experiment 2 -------------"
exp=2
ncat=3
include_median="F" 

Rscript ./preprocessing/main_preproc.R "$exp" "$ncat" "$include_median"


echo "------------ Generate data for experiment 3 -------------"
exp=3
ncat=3
include_median="T" 

Rscript ./preprocessing/main_preproc.R "$exp" "$ncat" "$include_median"


echo "------------ Generate data for experiment 4 -------------"
exp=4
ncat=5

Rscript ./preprocessing/main_preproc.R "$exp" "$ncat"