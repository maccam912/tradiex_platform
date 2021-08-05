FROM alpine:latest AS build

ENV MIX_ENV=prod
ARG SECRET_KEY_BASE=n9ozzj0+EqGrB2OZtOpVk8+PJRdaO/oDP2isR+2Xs3cvJqH36icMWV6Np8OswGg6
ARG PORT=5000

WORKDIR /opt/app

RUN apk --no-cache add elixir npm bash git

ADD . .

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile
RUN npm install --prefix ./assets
RUN npm run deploy --prefix ./assets
RUN mix phx.digest
#RUN mix release

EXPOSE 80

CMD ["bash", "run.sh"]
