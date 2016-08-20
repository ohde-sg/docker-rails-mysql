FROM ruby:2.3.1
RUN sed -i.bak -e "s%http://httpredir.debian.org/debian%http://ftp.jp.debian.org/debian/%g" /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN apt-get install -y mysql-client

# mysqlのクライアントのデフォルト文字コードをutf8に変更
RUN { \
    echo '[client]'; \
    echo 'default-character-set=utf8'; \
} > /etc/mysql/conf.d/charset.cnf

# 日本語入力環境設定
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y locales
RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# システム時刻を日本時間に変更
ENV TZ Asia/Tokyo

RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp

