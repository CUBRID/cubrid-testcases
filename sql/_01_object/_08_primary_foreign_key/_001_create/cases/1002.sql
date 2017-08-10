--[er]create a table with a char data type primary key,create a table with varchar data type  foreign key  references a char data type field,then report error

CREATE TABLE album(
  id CHAR(10) primary key,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album VARCHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album) REFERENCES album(id)
);

drop class track;
drop class album;