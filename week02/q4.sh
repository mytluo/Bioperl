#! /bin/sh

cd ~/project

for f in $(find ./html); do
	if [ $f -nt ~/public_html/html/$f -a -z $COPY_ALL ] ; then
		cp $f ~/public_html/html 
	fi
done		

for f in $(find ./cgi); do
	if [ $f -nt ~/public_html/cgi/$f -a -z $COPY_ALL ] ; then
		cp $f ~/public_html/cgi
	fi
done

