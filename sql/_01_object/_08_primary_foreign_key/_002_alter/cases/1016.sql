-- [er]create a table with a char data type primary key,create the other table,alter the latter table to add a varchar data type foreign key references the first table's primary key,they are different data type .so report error

CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album VARCHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255)
);


ALTER TABLE track ADD ATTRIBUTE
CONSTRAINT "fk_track_album"  FOREIGN KEY (album) REFERENCES album(id);

drop class track;
drop class album;