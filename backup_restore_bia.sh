HOST_ORIGEM=SEU_HOST_RDS
HOST_DESTINO=SEU_HOST_AURORA_SERVERLESS
USER_ORIGEM=SEU_USER_RDS
USER_DESTINO=SEU_USER_SERVERLESS
DATABASE=SEU_BANCO
FILE=dump_bia.tar

chmod 0600 .pgpass

echo 'Testando conexao com banco de origem'
PGPASSFILE=.pgpass pg_isready -d $DATABASE -h $HOST_ORIGEM -p 5432 -U $USER_ORIGEM

echo 'Iniciando backup'
PGPASSFILE=.pgpass pg_dump -U $USER_ORIGEM -h $HOST_ORIGEM -d $DATABASE --clean --no-privileges --no-owner --verbose --file $FILE
echo 'Backup finalizado'


echo 'Testando conexao com banco de destino'
PGPASSFILE=.pgpass pg_isready -d $DATABASE -h $HOST_DESTINO -p 5432 -U $USER_DESTINO

echo 'Fechando conexoes com detino'
PGPASSFILE=.pgpass psql -d postgres -h $HOST_DESTINO -p 5432 -U $USER_DESTINO -q -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DATABASE'"

echo 'Drop banco destino'
PGPASSFILE=.pgpass dropdb -U postgres -h $HOST_DESTINO $DATABASE

echo 'Create banco destino'
PGPASSFILE=.pgpass createdb -U postgres -h $HOST_DESTINO $DATABASE

echo 'Executando restore'
PGPASSFILE=.pgpass psql -d $DATABASE -h $HOST_DESTINO -p 5432 -U $USER_DESTINO -e -f $FILE

echo 'RESTORE FINALIZADO. PARABENS!!!'