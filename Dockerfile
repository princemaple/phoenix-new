FROM gliderlabs/alpine:edge

ENV ELIXIR_VERSION 1.3.2

RUN apk-install build-base erlang \
    erlang-inets erlang-erl-interface erlang-dev \
    erlang-sasl erlang-asn1 erlang-public-key erlang-ssl \
    erlang-crypto erlang-parsetools erlang-syntax-tools \
    inotify-tools wget ca-certificates && \
    wget https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip && \
    mkdir -p /opt/elixir-${ELIXIR_VERSION}/ && \
    unzip Precompiled.zip -d /opt/elixir-${ELIXIR_VERSION}/ && \
    rm Precompiled.zip && \
    apk del wget ca-certificates && \
    rm -rf /etc/ssl && \
    rm -rf /var/cache/apk/*

ENV PATH $PATH:/opt/elixir-${ELIXIR_VERSION}/bin

RUN mix local.hex --force && mix local.rebar
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

VOLUME /var/app

ENTRYPOINT ["mix", "phoenix.new"]
CMD ["/var/app"]
