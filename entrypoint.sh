#!/bin/sh
echo "Executando migrations..."
npx sequelize-cli db:migrate

echo "Iniciando aplicação..."
exec npm start
