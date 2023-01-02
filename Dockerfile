
FROM jekyll/jekyll:4.0

ADD Gemfile .

RUN chown -R jekyll:jekyll .

RUN gem install bundler:1.16.1
