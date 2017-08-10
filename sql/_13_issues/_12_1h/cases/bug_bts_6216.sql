create table pkfk (a int primary key, b int);
alter table pkfk add foreign key (b) references pkfk(a);
insert into pkfk values (1,1);

drop pkfk;

CREATE TABLE album2(
id CHAR(10) PRIMARY KEY,
title VARCHAR(100),
artist VARCHAR(100),
album CHAR(10),
FOREIGN KEY (album) REFERENCES album2(id) ON UPDATE NO ACTION ON DELETE CASCADE 
);

insert into album2(id, title, artist, album) values ('001','aaaa', 'aaaa', '001');
insert into album2(id, title, artist, album) values ('002','bbbb', 'bbbb', '002');
insert into album2(id, title, artist, album) values ('003','cccc', 'cccc', '003');
insert into album2(id, title, artist, album) values ('004','dddd', 'dddd', '004');
insert into album2(id, title, artist, album) values ('005','eeee', 'eeee', '005');

update album2 set id = '111' where id = '001';
update album2 set id = '007', album='007' where id = '003';
delete from album2 where id = '002';


delete from album2;
insert into album2(id, title, artist, album) values ('001','aaaa', 'aaaa', '001');
insert into album2(id, title, artist, album) values ('002','bbbb', 'bbbb', '001');
update album2 set id = '007', album='007' where id = '001';
delete from album2 where id = '001';

drop album2;

CREATE TABLE album3(
id CHAR(10) PRIMARY KEY,
title VARCHAR(100),
artist VARCHAR(100),
album CHAR(10),
FOREIGN KEY (album) REFERENCES album3(id) ON UPDATE NO ACTION ON DELETE SET NULL 
);

insert into album3(id, title, artist, album) values ('001','aaaa', 'aaaa', '001'); 
insert into album3(id, title, artist, album) values ('002','bbbb', 'bbbb', '001');
delete from album3 where id = '001';
select * from album3;

drop album3;

