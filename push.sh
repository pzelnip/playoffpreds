#!/bin/sh

tar -cvzf app.tar.gz .
scp app.tar.gz pzelnip@pzelnip.pw:/home/pzelnip
rm app.tar.gz

