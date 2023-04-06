FROM elixir:1.11.4-alpine as build

RUN apk add --update git build-base nodejs npm yarn python3

RUN mkdir /app

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=dev

COPY mix.exs mix.lock ./

COPY config config

RUN mix deps.get --only $MIX_ENV

RUN iex -S mix
