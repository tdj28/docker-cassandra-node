#!/bin/bash

cp ~/.ssh/id_rsa.pub ./adds
docker build -t hadoop .
rm ./adds/id_rsa.pub
