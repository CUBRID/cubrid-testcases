-- [er]drop a primary key with two fields, at the same time they are also be referenced by a foreign key,then report error, a member of the primary key, could not be dropped
CREATE TABLE album(
  id_1 CHAR(10) ,
  id_2 CHAR(10),
  title VARCHAR(100),
  artist VARCHAR(100),
  CONSTRAINT "pk_album_id" PRIMARY KEY (id_1, id_2)
);

CREATE TABLE track(
  album_1 CHAR(10),
  album_2 CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album_1,album_2) REFERENCES album(id_1, id_2)
);

ALTER TABLE album DROP ATTRIBUTE id_1;

drop class track;
drop class album;