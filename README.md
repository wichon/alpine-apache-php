# alpine-apache-php
A simple and slim apache/php docker image using Alpine Linux

## Build
`docker build --no-cache -t [image-name]:latest .`

## Usage
`docker run --name=webapp -v /path/to/webapp:/app -p 80:80 [image-name]:latest`

## Notes 
This container will change the owner of all your files inside /path/to/webapp to apache:apache in order to be compatible with the apache installation inside the container.
