-- [er]drop a primary key ,at the same time it is also a foreign key,then report error

CREATE TABLE album(
  id CHAR(10) NOT NULL PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album) REFERENCES album(id)
);

ALTER TABLE album DROP ATTRIBUTE id;

drop class track;
drop class album;