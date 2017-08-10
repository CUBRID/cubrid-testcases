-- [er]create tables and alter a talbe to add a foreign key referencers a different data type field,then report error 
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

CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album INT,
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255)
);


ALTER TABLE track ADD ATTRIBUTE
CONSTRAINT "fk_track_album"  FOREIGN KEY (album) REFERENCES album(id);

drop class track;
drop class album;
