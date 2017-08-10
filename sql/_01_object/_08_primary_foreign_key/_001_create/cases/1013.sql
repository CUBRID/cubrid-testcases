--[er]create table with a primary key having two fields,create a table with a foreign key having one field based on the created table's primary key,then report error:The number of keys  error
CREATE TABLE album(
  id CHAR(10) ,
  title VARCHAR(100),
  artist VARCHAR(100),
  CONSTRAINT "pk_album_id" PRIMARY KEY (id, title)
);

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album) REFERENCES album(id,title)
);

drop class track;
drop class album;