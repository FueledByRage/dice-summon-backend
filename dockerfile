FROM elixir:1.15-alpine

RUN apk add --no-cache build-base git

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

COPY . .

RUN mix do deps.get, deps.compile

CMD ["mix", "run", "--no-halt"]