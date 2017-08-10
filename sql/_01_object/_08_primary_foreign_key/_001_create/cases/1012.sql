--[er]create a table,create a table with a foreign key have two keys based on only one primary key of another talbe 

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
  FOREIGN KEY (album, dsk) REFERENCES album(id)
);

drop class track;
drop class album;
