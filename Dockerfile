FROM ruby:3.1.2-slim AS base

ENV BUNDLER_VERSION=2.3.13 \
    TZ=Asia/Jakarta \
    LANG=C.UTF-8

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends curl gnupg gnupg2 imagemagick openssh-server git python3.10 && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash && \
#    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
#    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    echo "deb http://apt.postgresql.org/pub/repos/apt `lsb_release -cs`-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y  \
            shared-mime-info nodejs build-essential libpq-dev \
            postgresql-client-13 && \
    apt-get clean && \
    corepack enable && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3.10 /usr/bin/python

RUN groupadd -r sempoa --gid=10000 && \
    useradd --create-home -r sempoa -g sempoa --uid=10000 && \
    mkdir -m 755 /sempoa && \
    chown sempoa:sempoa -R /sempoa

WORKDIR /sempoa

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000

########## DEV & TEST IMAGE ##########
FROM base as devtest

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
            build-essential libpq-dev ruby-dev libxml2-dev wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -qqy \
    && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
    && rm /etc/apt/sources.list.d/google-chrome.list \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN apt-get update -qqy && \
    apt-get install -y libsqlite3-dev

COPY --chown=sempoa:sempoa Gemfile Gemfile.lock package.json yarn.lock /sempoa/

ENV BUNDLE_JOBS=3 \
    BUNDLE_RETRY=3 \
    RAILS_ENV=development \
    REDIS_URL=redis://

RUN gem install bundler:$BUNDLER_VERSION --no-document \
    && bundle config set --local with 'development test' \
    && bundle install \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY --chown=sempoa:sempoa . /sempoa/
RUN --mount=type=ssh yarn

#Start the main process.
CMD ["./bin/dev"]
#ENTRYPOINT ["./bin/dev"]
