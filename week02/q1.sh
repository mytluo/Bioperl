#! /bin/sh

cd ~/proj/week02
mkdir -p q1_directory_tree
cd q1_directory_tree
for i in bin etc lib share tmp; do
	mkdir $i
done
