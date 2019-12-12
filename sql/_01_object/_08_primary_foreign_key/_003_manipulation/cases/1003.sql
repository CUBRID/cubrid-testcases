--Test the constraint of the foreign key using update (action is updatae restrict and FK table data don't exist)
--it tests a constraint of the foreign key syntax using update PK table,when data don't exist in the FK table,execute action of update.

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
  ON UPDATE RESTRICT
);

insert into album values ('001','aaaa', 'aaaa');
insert into album values ('002','bbbb', 'bbbb');
insert into album values ('003','cccc', 'cccc');
insert into album values ('004','dddd', 'dddd');
insert into album values ('005','eeee', 'eeee');

insert into track values ( '001' , 1,1,'1212');
insert into track values ( '001' , 2,2,'2323');
insert into track values ( '002' , 3,3,'3434');
insert into track values ( '002' , 4,4,'4545');
insert into track values ( '003' , 5,5,'5656');
insert into track values ( '003' , 6,6,'6767');

update album set id= '006' where id= '004';

select * from album order by id;
select * from track order by 1,2;

drop class track;
drop class album;
