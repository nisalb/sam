#!/usr/bin/env sh

# build `example` script from `example.sh`
# basically insert from files `files/' dir into the script

echo "Removing existing build..."
rm -fv example

echo "Building 'example'"
cp example.sh example
chmod +x example

for file in `grep '##<!' example.sh | sed -E 's/##<! \((.*)\)/\1/'`
do
    if [ -r $file ]
    then
        cp $file $file.esc
        sed -i -e 's/\$/\\$/g' $file.esc
        sed -i -e "/##<! (${file/\//\\/})/r $file.esc" -e "/##<! (${file/\//\\/})/d" example
        rm $file.esc
    else
        echo "$file is not readable"
    fi
done
