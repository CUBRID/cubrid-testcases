--[er]create a table with a char data type primary key,create a table with an int data type foreign key references a char data type primary key,then report the domain error
CREATE TABLE album(
  id CHAR(10) primary key,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album int,
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album) REFERENCES album(id)
);

drop class track;
drop class album;