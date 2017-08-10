-- create a table with a primary key,create a table with foreign key,drop the table with foreign key,drop a table with a primary key
CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
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

select * from db_class where class_name in ('album','track');