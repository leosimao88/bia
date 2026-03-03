versao=$(git rev-parse HEAD | cut -c 1-7)
echo TAG=$versao > .env
docker compose -f compose-eb.yml config > docker-compose.yml