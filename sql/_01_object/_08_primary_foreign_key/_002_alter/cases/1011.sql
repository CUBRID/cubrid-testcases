-- [er]create a table,create the other table,alter the latter table and add a foreign key references the first table

CREATE TABLE album(
  id CHAR(10),
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
CONSTRAINT "fk_track_album"  FOREIGN KEY (album) REFERENCES album(id);

drop class track;
drop class album;