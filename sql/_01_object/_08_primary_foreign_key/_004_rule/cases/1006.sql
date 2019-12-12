-- create a table with a char data type primary key,create a table with a foreign key references the primary key on update no action

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
ON UPDATE NO ACTION
);
select * from db_index_key
where class_name in ('album','track') order by 2,1;

select * from db_index where class_name in ('album', 'track') order by 1;

select * from db_attribute
where class_name in ('album','track') order by 2,1;
drop class track;
drop class album;