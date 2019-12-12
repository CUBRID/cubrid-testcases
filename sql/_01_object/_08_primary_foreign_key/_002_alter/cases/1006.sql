-- [er]create a table with a primary key having two fields,create a table with a foreign key having two fields,drop one field of the foreign key

CREATE TABLE album(
  id_1 CHAR(10) ,
  id_2 CHAR(10),
  title VARCHAR(100),
  artist VARCHAR(100),
  CONSTRAINT "pk_album_id" PRIMARY KEY (id_1, id_2)
);

CREATE TABLE track(
  album_1 CHAR(10),
  album_2 CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album_1,album_2) REFERENCES album(id_1, id_2)
);

ALTER TABLE track DROP ATTRIBUTE album_1;
select * from db_index_key
where class_name in ('album','track') order by 2,1;

select * from db_index where class_name in ('album', 'track') order by 1;

select * from db_attribute
where class_name in ('album','track') order by 2,1;
drop class track;
drop class album;