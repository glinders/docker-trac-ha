#!/bin/bash

docker run -d --restart always -p 0.0.0.0:8080:80 --name gltrac gltrac:0.1 
