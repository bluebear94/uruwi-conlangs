#!/bin/bash

# Usage:
# ./export-images.sh <pdf-name> <output-path>
#  <pdf-name>: the name of the pdf without the extension
#  <output-path>: path to directory where you want to store the pngs

convert -monitor -density 150 out/$1.pdf $2/$1.png
