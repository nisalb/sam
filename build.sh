#!/usr/bin/env sh

# build `sam` script from `sam.sh`
# basically insert from files `files/' dir into the script

echo "Removing existing build..."
rm -fv sam

echo "Building 'sam'"
cp sam.sh sam
chmod +x sam

for file in `grep '##<!' sam.sh | sed -E 's/##<! \((.*)\)/\1/'`
do
    if [ -r $file ]
    then
        cp $file $file.esc
        sed -i -e 's/\$/\\$/g' $file.esc
        sed -i -e "/##<! (${file/\//\\/})/r $file.esc" -e "/##<! (${file/\//\\/})/d" sam
        rm $file.esc
    else
        echo "$file is not readable"
    fi
done
