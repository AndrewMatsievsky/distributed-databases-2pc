POSTGRES_USER="postgres"
DB_ACCOUNT="db_account"
DB_FLY="db_fly_booking"
DB_HOTEL="db_hotel_booking"
POSTGRES="psql --username ${POSTGRES_USER} --host=localhost"
POSTGRES_DB_ACCOUNT="psql --username ${POSTGRES_USER} --dbname ${DB_ACCOUNT} --host=localhost"
POSTGRES_DB_FLY="psql --username ${POSTGRES_USER} --dbname ${DB_FLY} --host=localhost"
POSTGRES_DB_HOTEL="psql --username ${POSTGRES_USER} --dbname ${DB_HOTEL} --host=localhost"

echo "Creating database: ${DB_ACCOUNT}"

$POSTGRES -c "CREATE DATABASE ${DB_ACCOUNT} OWNER ${POSTGRES_USER}"


$POSTGRES_DB_ACCOUNT <<EOSQL
CREATE SCHEMA default_schema;
CREATE TABLE default_schema.account_table
(
    account_id serial PRIMARY KEY NOT NULL,
    client_name varchar(100) NOT NULL,
    amount int DEFAULT 0 NOT NULL CHECK (amount >= 0),
    last_tr_id varchar(50)
);
INSERT INTO default_schema.account_table(account_id, client_name, amount) VALUES(1, 'Nikolas Cage', 200)
EOSQL

echo "Creating database: ${DB_FLY}"

$POSTGRES <<EOSQL
CREATE DATABASE ${DB_FLY} OWNER ${POSTGRES_USER};
EOSQL


$POSTGRES_DB_FLY <<EOSQL
CREATE SCHEMA default_schema;
CREATE TABLE default_schema.fly_table
(
    booking_id serial PRIMARY KEY NOT NULL,
    client_name varchar(100) NOT NULL,
    fly_number varchar(100) NOT NULL,
    f varchar(10) NOT NULL,
    t varchar(10) NOT NULL,
    date timestamp NOT NULL,
    tr_id varchar(50) NOT NULL,
    message varchar(200) NOT NULL
);
EOSQL


echo "Creating database: ${DB_HOTEL}"

$POSTGRES <<EOSQL
CREATE DATABASE ${DB_HOTEL} OWNER ${POSTGRES_USER};
EOSQL

$POSTGRES_DB_HOTEL <<EOSQL
CREATE SCHEMA default_schema;
CREATE TABLE default_schema.hotel_table
(
    booking_id serial PRIMARY KEY NOT NULL,
    client_name varchar(100) NOT NULL,
    hotel_name varchar(100) NOT NULL,
    arrival timestamp NOT NULL,
    departure timestamp NOT NULL,
    tr_id varchar(50) NOT NULL,
    message varchar(200) NOT NULL
);
EOSQL
