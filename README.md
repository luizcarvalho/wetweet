# WeTweet

<img src='docs/arts/logo.svg' height='120' alt='WeTweet Logo' />

[![Maintainability](https://api.codeclimate.com/v1/badges/ba534f892802ece033cd/maintainability)](https://codeclimate.com/github/luizcarvalho/wetweet/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ba534f892802ece033cd/test_coverage)](https://codeclimate.com/github/luizcarvalho/wetweet/test_coverage)

WeTweet é um projeto simples que permite por uma simples requisição HTTP enviar um tweet com o clima atual de uma cidade e a média da temperatura para os próximos 5 dias.

## Getting started

First of all, clone this repository and run bundle install inside of the project directory.

    bundle install

Now, you need to configure the credentials of Twitter, for this, you need to create a [developer account](https://developer.twitter.com/) on Twitter.

With the Twitter keys, run:

    bundle exec rails credentials:edit --environment development

This command will be open your main text editor, the encrypted credentials file, replace text for:

    twitter:
      consumer_key: xxxx
      consumer_secret: yyy
      access_token: www
      access_secret: kkk

And close editor.

## Starting project

Start the Rails server with the command:

   bundle exec rails s

If all occurs good, you can access the project on URL <http://localhost:3000/>

## Using WeTweet

To make a tweet using WeTweet, you need to request URL `/Twitter/send_weather` with text params. Like this:

    curl "http://localhost:3000/twitter/send_weather?text=Olaaaaa"

And receive the response message `'Tweet was successfully sent!'` and text will be displayed in the Twitter account.

Thanks for using WeTweet!
