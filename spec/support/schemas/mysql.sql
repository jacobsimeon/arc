DROP TABLE IF EXISTS superheros;
CREATE TABLE superheros (
  id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(256) NOT NULL,
	born_on DATE NOT NULL,
	photo BLOB NULL,
	created_at TIMESTAMP NOT NULL
);

DROP TABLE IF EXISTS powers;
CREATE TABLE powers (
  id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(256) NOT NULL,
  description TEXT NOT NULL
);

DROP TABLE IF EXISTS superheros_powers;
CREATE TABLE superheros_powers(
  id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  superhero_id INTEGER NOT NULL,
  power_id INTEGER NOT NULL
);
