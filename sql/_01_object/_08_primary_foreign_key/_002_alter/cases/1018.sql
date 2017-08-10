-- [er]create table,create another table,alter the latter table with an  invalid use of keyword 'REFERENCES' error


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
CONSTRAINT "fk_track_album"  FOREIGN KEY  REFERENCES album(id);

drop class track;
drop class album;