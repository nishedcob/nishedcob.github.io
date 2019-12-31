
FROM ruby:2.4

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install

ADD . .

RUN bundle exec jekyll build --verbose --trace

ENTRYPOINT bundle

CMD [ "exec", "jekyll", "serve" ]
