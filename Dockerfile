
FROM jekyll/jekyll

ADD Gemfile .

RUN chown -R jekyll:jekyll .

RUN gem install bundler:1.16.1
RUN bundle install

RUN chown -R jekyll:jekyll /usr/gem/cache/bundle

