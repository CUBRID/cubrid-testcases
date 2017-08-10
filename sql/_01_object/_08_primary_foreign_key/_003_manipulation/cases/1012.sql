--Test the constraint of the foreign key using insert(data)
--it tests a test the constraint of the foreign key syntax using insert

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

insert into album values ('001','aaaa', 'aaaa');
insert into album values ('002','bbbb', 'bbbb');
insert into album values ('003','cccc', 'cccc');

insert into track values ( '001' , 1,1,'1212');
insert into track values ( '001' , 2,2,'2323');
insert into track values ( '002' , 3,3,'3434');
insert into track values ( '002' , 4,4,'4545');

select * from album order by 1;
select * from track order by 2;

select * from album a, track b where a.id = '001' and a.id = b.album order by 1,5;

drop class track;
drop class album;
