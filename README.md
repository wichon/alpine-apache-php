# alpine-apache-php
A simple and slim apache/php docker image using Alpine Linux

## Build
`docker build --no-cache -t [image-name]:latest .`

## Usage

### Environment Variables

#### WEBAPP_ROOT

Specify the web app root to a folder inside your website code, for example: public/.

#### WEBAPP_USER_ID

Specify the user id which apache will use to execute its child processes, useful for development mode.

### Development mode

Development mode will let you mount a folder containing your website inside the container, and be able to do live changes to code while the container is running, in order for this to work the **WEBAPP_USER_ID** env variable most be set to the user owning that folder (`id -u` will return that id in linux).

`docker run --name=webapp -v /path/to/webapp:/app -e WEBAPP_USER_ID=$(id -u) -p 80:80 [image-name]:latest`

The document root can be customized by using an env variable **WEBAPP_ROOT** to specify a subfolder containing the document app root.

`docker run --name=webapp -e "WEBAPP_ROOT=[Web app root if any, ex. public/]" -v /path/to/webapp:/app -e WEBAPP_USER_ID=$(id -u) -p 80:80 [image-name]:latest`

*Tested only in linux, user permissions may not work in windows envs.*

### Production mode

Build a new docker container using this one as base and copy the contents of your web site:

```dockerfile
FROM wichon/alpine-apache-php:latest

COPY . /app
```

## Notes

In development mode, this container will change the ownership of all your files inside /path/to/webapp to the user id running the container.
