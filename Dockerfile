FROM zburgermeiszter/usermode:alpine-3.4

MAINTAINER Zoltan Burgermeiszter <zoltan@burgermeiszter.com>

USER root

# Skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

RUN apk add --update --no-cache build-base ruby-dev libffi-dev ruby-bundler ca-certificates libxml2 zlib-dev \
    git && \
    gem install io-console && \
    rm /var/cache/apk/* && \
    rm -rf /usr/share/ri

RUN mkdir /jekyll
WORKDIR /jekyll
VOLUME /jekyll

ADD Gemfile Gemfile.lock /jekyll/
RUN bundle install

RUN chown -R 1000:1000 /jekyll

USER user

ENV JEKYLL_HOST="0.0.0.0"

ENTRYPOINT ["bundle","exec","rake"]
CMD ["site:watch"]
