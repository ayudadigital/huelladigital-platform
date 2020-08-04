#!/bin/sh
cd /workspace
sed -i "s#http://backend:8080#$BASE_URI#g" $(grep -l -r "http://backend:8080" build/*)
sed -i "s#http://localhost:3000#$BASE_URI#g" $(grep -l -r "http://localhost:3000" build/*)
serve -s build
