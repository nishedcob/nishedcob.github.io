
FROM ruby:2.4

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install

ADD . .

RUN timeout 60s jekyll build --verbose --trace

CMD [ "jekyll", "serve", "--verbose", "--trace", "--port", "8080", "--incremental", "--host", "0.0.0.0" ]
