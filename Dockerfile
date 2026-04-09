FROM ruby:3.4.9

WORKDIR /course-rails

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client imagemagick libvips

COPY Gemfile /course-rails/Gemfile
COPY Gemfile.lock /course-rails/Gemfile.lock

ENV BUNDLER_VERSION=4.0.10 
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle install
RUN bundle update --bundler

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]