FROM ruby:2.6.5-alpine

ENV BUNDLER_VERSION=2.1.4

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

RUN gem install bundler -v 2.1.4

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install 

COPY package.json yarn.lock ./

RUN yarn install --check-files

COPY . ./ 

EXPOSE 3000

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]