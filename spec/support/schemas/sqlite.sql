BEGIN TRANSACTION;
CREATE TABLE superheros (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	name VARCHAR(256) NOT NULL
);
INSERT INTO superheros(name)
VALUES('superman');
INSERT INTO superheros(name)
VALUES('spiderman');
INSERT INTO superheros(name)
VALUES('batman');
COMMIT;