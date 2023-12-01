#!/bin/bash

mkdir -p ./data/output/output_fugepsd

echo "------------------- EXP 1 -------------------"
date +"%T"
java -jar ./FuGePSD/FuGePSD.jar ./FuGePSD/param/param-exp1.txt

echo "------------------- EXP 2 -------------------"
date +"%T"
java -jar ./FuGePSD/FuGePSD.jar ./FuGePSD/param/param-exp2.txt

echo "------------------- EXP 3 -------------------"
date +"%T"
java -jar ./FuGePSD/FuGePSD.jar ./FuGePSD/param/param-exp3.txt

echo "------------------- EXP 4 -------------------"
date +"%T"
java -jar ./FuGePSD/FuGePSD.jar ./FuGePSD/param/param-exp4.txt
