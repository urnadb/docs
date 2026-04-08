#!/bin/bash

sudo cp -r public/* ../urnadb.github.io

cd ../urnadb.github.io

git add -A .

git commit -m "add: urnadb document transaction chapter."

git push origin main -f


