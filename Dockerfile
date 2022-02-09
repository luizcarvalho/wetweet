FROM ruby:3.0.1


# RUN apt-get update -qq && apt-get install -y build-essential nodejs

# Set locale
ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR.UTF-8
ENV LC_ALL=pt_BR.UTF-8
ENV LC_CTYPE=pt_BR.UFT-8
ENV LC_MESSAGES=pt_BR.UFT-8

ENV TZ America/Araguaina

# Set Timezone
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /app
WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .
# COPY vendor/gems /app/vendor/gems

RUN bundle install

