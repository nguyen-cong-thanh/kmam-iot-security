#!/usr/bin/env bash
# Run once to initialize ThingsBoard database schema (per official docs).
# Must be executed before starting thingsboard-ce for the first time,
# or after wiping the postgres volume.
# Ref: https://thingsboard.io/docs/installation/docker/

set -e

COMPOSE_FILE="$(dirname "$0")/docker-compose.yaml"

echo "Ensuring postgres and kafka are running..."
docker compose -f "$COMPOSE_FILE" up -d postgres kafka

echo "Waiting for postgres to be healthy..."
until docker compose -f "$COMPOSE_FILE" ps postgres | grep -q "healthy"; do
  sleep 2
done

echo "Running ThingsBoard install..."
docker compose -f "$COMPOSE_FILE" run --rm \
  -e INSTALL_TB=true \
  thingsboard-ce

echo "Starting ThingsBoard CE..."
docker compose -f "$COMPOSE_FILE" up -d thingsboard-ce
