-- [er]create a table,create the other table,alter the latter table to add a foreign key with an  invalid use of keyword 'FOREIGN' error

CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255)
);

ALTER TABLE track ADD ATTRIBUTE
CONSTRAINT   FOREIGN KEY(album)  REFERENCES album(id);

drop class track;
drop class album;