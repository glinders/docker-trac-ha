#!/bin/bash

docker run -d --restart always -p 127.0.0.1:8080:80 --name gltrac gltrac:0.1 
