#!/bin/bash

mkdir -p ./data/output/output_sdmap

echo "------------------- EXP 1 -------------------"
date +"%T"
java -jar ./SDMap/SDMap.jar ./SDMap/param/param-exp1.txt

echo "------------------- EXP 2 -------------------"
date +"%T"
java -jar ./SDMap/SDMap.jar ./SDMap/param/param-exp2.txt

echo "------------------- EXP 3 -------------------"
date +"%T"
java -jar ./SDMap/SDMap.jar ./SDMap/param/param-exp3.txt

echo "------------------- EXP 4 -------------------"
date +"%T"
java -jar ./SDMap/SDMap.jar ./SDMap/param/param-exp4.txt
