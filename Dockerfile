FROM alpine:3.4

MAINTAINER Zoltan Burgermeiszter <zoltan@burgermeiszter.com>

# Skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

RUN apk add --update --no-cache build-base ruby-dev libffi-dev ruby-bundler ca-certificates libxml2 zlib-dev && \
    gem install io-console && \
    rm /var/cache/apk/* && \
    rm -rf /usr/share/ri

RUN mkdir /jekyll
ADD Gemfile /jekyll
WORKDIR /jekyll

RUN bundle install

ADD . /jekyll

ENTRYPOINT ["bundle","exec","jekyll"]
CMD ["serve","--verbose","--host","0.0.0.0"]
