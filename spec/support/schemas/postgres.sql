BEGIN TRANSACTION;

DROP TABLE IF EXISTS superheros;
CREATE TABLE superheros (
  id SERIAL PRIMARY KEY,
	name VARCHAR(256) NOT NULL,
	born_on DATE NOT NULL,
	photo bytea NULL,
	created_at TIME NOT NULL
);

DROP TABLE IF EXISTS powers;
CREATE TABLE powers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(256) NOT NULL,
  description TEXT NOT NULL
);

DROP TABLE IF EXISTS superheros_powers;
CREATE TABLE superheros_powers(
  id SERIAL PRIMARY KEY,
  superhero_id INTEGER NOT NULL,
  power_id INTEGER NOT NULL
);

COMMIT;