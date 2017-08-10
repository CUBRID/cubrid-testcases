drop table if exists machines;
create class machines(ip varchar(30) primary key);
insert into machines values('192.168.0.10');
select * from machines where ip in (values('192.168.0.10'),('192.168.0.10'),('192.168.1.43'));
insert into machines values('192.168.1.43');
select * from machines where ip in (values('192.168.0.10'),('192.168.0.10'),('192.168.1.43'));
drop table if exists machines;