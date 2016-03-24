create table aoo(id int, name char(20));

insert into aoo values(100, 'aaa');
insert into aoo values(4548, 'jkdflj');
insert into aoo values(884, 'hdsfl');
insert into aoo values(7691, 'bbd');
insert into aoo values(2545, 'qqi');
insert into aoo values(44, 'peie');
insert into aoo values(39845, 'bbsdfr');
insert into aoo values(1, 'uydf');
insert into aoo values(989234, 'zidf');
insert into aoo values(76, 'ighdfs');

select count(*) from aoo;
select count(*) from aoo order by id;

select sum(id) from aoo;
select sum(id) from aoo order by id;

select avg(id) from aoo;
select avg(id) from aoo order by id;

select max(name) from aoo;
select max(name) from aoo order by id;

select max(id) from aoo;
select max(id) from aoo order by name;

select min(id) from aoo;
select min(id) from aoo order by id;


drop table aoo;
