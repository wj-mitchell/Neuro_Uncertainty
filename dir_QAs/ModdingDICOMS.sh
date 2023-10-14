#/!/bin/bash

# install the dcm package
#sudo apt-get install dcmtk

#SUBJECT refers to which subject or subjects we'd like to modify
SUBJECT="6215"
#PROJECT refers to the project name
PROJECT="Helion-SocReg"
#DIR refers to the parent directory of the lower level directories to modify
DIR=/data/Uncertainty/data/raw/sub-$SUBJECT/

find DIR -type f -name *.dcm -execdir dcmodify -m "(0010,0010)=$PROJECT-$SUBJECT" *.dcm \;

