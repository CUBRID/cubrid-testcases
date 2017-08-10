--[er]create a table,create a table having a FOREIGN KEY REFERENCES the created table

CREATE TABLE album(
  id CHAR(10),
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

drop class track;
drop class album;