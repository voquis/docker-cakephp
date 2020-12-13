Docker CakePHP base
===
PHP with extensions required for [CakePHP 4](https://book.cakephp.org/4/en/installation.html), including [Composer](https://getcomposer.org/download/), the PHP dependency manager.

This image may be used directly for development or as a base for deploying an existing application.  In both cases it is assumed a MySQL server is needed by the application.

# Using as a development container

## Creating a Docker network
In order for the CakePHP container to be able to resolve the MySQL container by hostname, both containers need to be on the same Docker network.
```shell
docker network create my-app
```

## Creating a MySQL database container
Create a [MySQL container](https://hub.docker.com/_/mysql) with a random root password and a database/username/password with the name `my-app-mysql` for the application:
```shell
docker run -d \
       --network my-app \
       --name my-app-mysql \
       -e MYSQL_RANDOM_ROOT_PASSWORD=yes \
       -e MYSQL_DATABASE=cake \
       -e MYSQL_USER=cake \
       -e MYSQL_PASSWORD=cake \
       mysql:5.7.31
```
The `-d` flag will start the container in detached mode and logs will not be displayed in the terminal, though are still available with:
```shell
docker logs my-app-mysql
```

## Creating an application container
On the host machine, create a project directory, for example `project`.
```shell
mkdir project
```

[Mount](https://docs.docker.com/engine/reference/commandline/run/#add-bind-mounts-or-volumes-using-the---mount-flag) the new project directory on the host machine as the `/var/www/html` directory in a new container from this image (attached to the network created previously), [publishing](https://docs.docker.com/engine/reference/commandline/run/#publish-or-expose-port--p---expose) port `80` in the container to the arbitrary port `2531` on the host:
```shell
docker run -it \
       --network my-app \
       --name my-app-cakephp \
       --mount type=bind,src=`pwd`/project,dst=/var/www/html \
       -p 2531:80 \
       -e DEBUG=true \
       -e SECURITY_SALT=abc123 \
       -e DATABASE_URL="mysql://cake:cake@my-app-mysql/cake?encoding=utf8mb4&timezone=UTC&cacheMetadata=true&quoteIdentifiers=false&persistent=false" \
       voquis/cakephp:7.4.11-apache-buster \
       bash
```

Note that environment variables are used to reference the MySQL database.  For a list of all CakePHP environment variables, see the [configuration section of the docs](https://book.cakephp.org/4/en/development/configuration.html#general-configuration).

Create a new cakephp project with:
```shell
composer create-project --prefer-dist cakephp/app .
```

Note the `.` at the end, if ommitted, the new CakePHP app will be created in a new sub-directory title `app` and apache paths will not work.  If asked to `Set Folder Permissions?`, reply `Y` to allow apache write access to the `tmp` and `log` directories.

Start the apache service with:
```shell
apachectl start
```
This step is necessary because apache is configured with a webroot of `/var/www/html/webroot` which does not exist when the container starts (causing the apache process to exit) but is created after the CakePHP project is.

The application will be available at http://127.0.0.1:2531 on the host machine.

# Using as a base for an existing project
Create a `Dockerfile` in the root of your existing CakePHP directory with the following content:

```dockerfile
FROM voquis/cakephp:7.4.11-apache-buster

# Copy application and config files
COPY . .

# Install production dependencies only
RUN composer install --no-dev
```

Build a new image using this dockerfile with:
```shell
docker build -t my/company/name:tag .
```

Run the newly built container with:
```shell
docker run -it \
       --network my-app \
       --name my-company-app-cakephp \
       -p 2532:80 \
       -e DEBUG=false \
       -e SECURITY_SALT=abc123 \
       -e DATABASE_URL="mysql://cake:cake@my-app-mysql/cake?encoding=utf8mb4&timezone=UTC&cacheMetadata=true&quoteIdentifiers=false&persistent=false" \
       my/company/name:tag \
       bash
```
