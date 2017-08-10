--Test add the constraint of the foreign key in the class where data exists
--create table1,insert data into table1,create table2,insert data into table2,retrieve table1 and table2,add FK for tabl2,insert data into table1,retrieve tabl1,drop table2 and table1

CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

insert into album values ('001','aaaa', 'aaaa');
insert into album values ('002','bbbb', 'bbbb');
insert into album values ('003','cccc', 'cccc');

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255)
);

insert into track values ( '001' , 1,1,'1212');
insert into track values ( '001' , 2,2,'2323');
insert into track values ( '002' , 3,3,'3434');
insert into track values ( '002' , 4,4,'4545');

select * from album order by id;
select * from track order by 1,2;

ALTER TABLE track ADD ATTRIBUTE 
CONSTRAINT "fk_track_album"  FOREIGN KEY (album) REFERENCES album(id);

select * from album where id = '001' order by 1,2;
select * from track where album = '001' order by 1,2;

insert into album values ('004','dddd', 'eeee');

select * from album where id = '004' order by 1,2;
select * from album a, track b where a.id = b.album order by 1,2;
select * from album where id like '%1' order by 1,2;
select * from album where to_number(id) = 001 order by 1,2;

drop class track;
drop class album;
