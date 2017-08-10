-- [er] Test the constraint of the foreign key using insert(no data)
--create table1,create table2 and add foreign key,insert data into table2,report error


CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album) REFERENCES album(id)
);
insert into track values ( null , 1,1,'aaaa');

drop class track;
drop class album;
