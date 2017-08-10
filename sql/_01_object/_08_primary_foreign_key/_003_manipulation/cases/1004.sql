--+ holdcas on;
--Test the constraint of the foreign key using update (update no action)
--it tests a constraint of the foreign key syntax using update ,when data exist in the PK table,action of update is complete.

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

update album set id= '006' where id = '001';

set system parameters 'compat_mode=mysql';

update album set id= '007' where id = '002';

set system parameters 'compat_mode=cubrid';

select * from album order by id;
select * from track order by 1,2;

drop class track;
drop class album;
commit;
--+ holdcas off;
