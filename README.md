# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  I used ruby *version 2.6.5* as it is indicated in *.ruby-version* file
* System dependencies
  Here are the packages that were needed for this deployment
```
  binutils-gold 
  build-base 
  curl 
  file 
  g++ 
  gcc 
  git 
  less 
  libstdc++
  libffi-dev 
  libc-dev 
  linux-headers
  libxml2-dev
  libxslt-dev 
  libgcrypt-dev 
  make 
  netcat-openbsd 
  nodejs 
  openssl 
  pkgconfig 
  postgresql-dev 
  python
  tzdata 
  yarn 
  sqlite-dev
```

* Configuration
  I created the Dockerfile as follows, I'm trying to explain each line of the file, but I ommited this in the actual Docker file:
```
# I decided to choose alpine version of ruby due to I tried previously with a ruby ubuntu based and was much heavy than this.
FROM ruby:2.6.5-alpine
# Set the variable to specify the bundler version wich is needed
ENV BUNDLER_VERSION=2.1.4
# Install the packages that need to work with the application to the Dockerfile
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      python \
      tzdata \
      yarn \
      sqlite-dev
# Installing the bundler 2.1.4
RUN gem install bundler -v 2.1.4
# Working directory for the application on the container
WORKDIR /app
# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./
# Configuration options for the nokogiri gem build
RUN bundle config build.nokogiri --use-system-libraries
# Installation of the project gems
RUN bundle check || bundle install
# This two files is to get started with the Javascript section of our Dockerfile
COPY package.json yarn.lock ./
# Installation of required packages
RUN yarn install --check-files
# Copy over the application code
COPY . ./
# Set the port to expose the application on the Container
EXPOSE 3000
# Start the application with an entry point script
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
```
As you can see I added an ENTRYPOINT script located in *./entrypoints*
```
#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0
```
After this, make the script executable:
```
chmod +x entrypoints/docker-entrypoint.sh
```

With this, proceed to build the docker image:
```
docker build -t runa-app .
```

* Database creation
  N/A
* Database initialization
  N/A
* How to run the test suite
  After the docker image was created I tested locally as follow:
```
$ docker run -p 3000:3000 runa-app
```
and curl to localhost:
```
curl http://localhost:3000
```
* Services (job queues, cache servers, search engines, etc.)
  N/A
* Deployment instructions
  Once I tested the container I taged and pushed my image to [my docker repository](https://hub.docker.com/r/raulbh/runa-app "my docker repository")
```
$ docker tag runa-app raulbh/runa-app:v1
$ docker push raulbh/runa-app:v1
```
