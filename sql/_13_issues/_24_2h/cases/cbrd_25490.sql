drop table if exists track;
drop table if exists album;

CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

insert into album values ('001','aaaa', 'aaaa');

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255)
);

insert into track values ( '001' , 1,1,'1212');

ALTER TABLE track ADD ATTRIBUTE CONSTRAINT "fk_track_album" FOREIGN KEY (album) REFERENCES album(id);
