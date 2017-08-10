-- create a table ,create the other table,select data,alter table to add a foreign key,select data on class information  to look

CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255)
);
select * from db_index_key
where class_name in ('album','track') order by 2,1;

select * from db_index where class_name in ('album', 'track') order by 1;

select * from db_attribute
where class_name in ('album','track') order by 2,1;

ALTER TABLE track ADD ATTRIBUTE
CONSTRAINT "fk_track_album"  FOREIGN KEY (album) REFERENCES album(id);

select * from db_index_key
where class_name in ('album','track') order by 2,1;

select * from db_index where class_name in ('album', 'track') order by 1;

select * from db_attribute
where class_name in ('album','track') order by 2,1;
drop class track;
drop class album;