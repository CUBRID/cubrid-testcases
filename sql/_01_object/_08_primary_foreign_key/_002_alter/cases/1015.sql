-- [er]create a table with a primary key,create a table,alter the latter table with an The number of keys error

CREATE TABLE album(
  id CHAR(10) ,
  title VARCHAR(100),
  artist VARCHAR(100),
  CONSTRAINT "pk_album_id" PRIMARY KEY (id)
);

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255)
);


ALTER TABLE track ADD ATTRIBUTE
CONSTRAINT "fk_track_album"  FOREIGN KEY (album, dsk) REFERENCES album(id);

drop class track;
drop class album;