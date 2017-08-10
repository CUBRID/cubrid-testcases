--Test the constraint of the foreign key using update (update no action,delete cascade,cache object)2
----it tests a constraint of the foreign key syntax using update no action,delete cascade and cache object


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
  FOREIGN KEY (album) REFERENCES album(id) ON UPDATE NO ACTION ON DELETE CASCADE 
);

insert into album values ('001','aaaa', 'aaaa');
insert into album values ('002','bbbb', 'bbbb');
insert into album values ('003','cccc', 'cccc');
insert into album values ('004','dddd', 'dddd');
insert into album values ('005','eeee', 'eeee');

insert into track(album, dsk, posn, song) values ( '001' , 1,1,'1212');
insert into track(album, dsk, posn, song) values ( '001' , 2,2,'2323');
insert into track(album, dsk, posn, song) values ( '002' , 3,3,'3434');
insert into track(album, dsk, posn, song) values ( '002' , 4,4,'4545');
insert into track(album, dsk, posn, song) values ( '003' , 5,5,'5656');
insert into track(album, dsk, posn, song) values ( '003' , 6,6,'6767');

delete from album where id = '006';

select * from album order by id;
select * from track order by 1,2;

delete from album;

insert into album values ('001','fff','fff');
insert into album values ('006','ggg','ggg');
insert into track(album, dsk, posn, song)  values ('001',7,7,'7878');
insert into track(album, dsk, posn, song)  values ('006',8,8,'8989');

select * from album order by id;
select * from track order by 1,2;

select album, dsk, posn, song  from track order by 1,2;

drop class track;
drop class album;
