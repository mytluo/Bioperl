#! /bin/sh

mkdir -p ~/public_html/{html,cgi}
cd ~/project
for f in $(find ./html); do
	cp $f ~/public_html/html 
done		

for f in $(find ./cgi); do
	cp $f ~/public_html/cgi
done
