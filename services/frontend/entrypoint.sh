#!/bin/sh
cd /workspace
sed -i "s#http://backend:8080#$BASE_URI#g" $(grep -l -r "http://backend:8080" build/*)
serve -s build
