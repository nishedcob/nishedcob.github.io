
FROM debian:buster

RUN apt-get update

RUN apt-get install -y ruby ruby-dev ruby-bundler build-essential zlib1g-dev libcurl4-openssl-dev

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install

ADD . .

RUN timeout 60s jekyll build --verbose --trace || true

CMD [ "jekyll", "serve", "--verbose", "--trace", "--port", "8080", "--incremental", "--host", "0.0.0.0" ]
