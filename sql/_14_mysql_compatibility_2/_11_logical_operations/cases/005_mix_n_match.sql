create table m (a int, b datetime, c date, d time, e timestamp);
insert into m values (1, '2010-07-23 11:21', '1983-07-23', '11:21', '1985-02-10 00:00');
insert into m values (1, null, null, null, null);



select count(*) from m where a<>0 and a<>0;
select count(*) from m where a<>0 and b<>0;
select count(*) from m where a<>0 and c<>0;
select count(*) from m where a<>0 and d<>0;
select count(*) from m where a<>0 and e<>0;

select count(*) from m where b<>0 and a<>0;
select count(*) from m where b<>0 and b<>0;
select count(*) from m where b<>0 and c<>0;
select count(*) from m where b<>0 and d<>0;
select count(*) from m where b<>0 and e<>0;

select count(*) from m where c<>0 and a<>0;
select count(*) from m where c<>0 and b<>0;
select count(*) from m where c<>0 and c<>0;
select count(*) from m where c<>0 and d<>0;
select count(*) from m where c<>0 and e<>0;

select count(*) from m where d<>0 and a<>0;
select count(*) from m where d<>0 and b<>0;
select count(*) from m where d<>0 and c<>0;
select count(*) from m where d<>0 and d<>0;
select count(*) from m where d<>0 and e<>0;

select count(*) from m where e<>0 and a<>0;
select count(*) from m where e<>0 and b<>0;
select count(*) from m where e<>0 and c<>0;
select count(*) from m where e<>0 and d<>0;
select count(*) from m where e<>0 and e<>0;

drop table m;


-- kinda useless
create table m (i int, s varchar, t varchar);
insert into m values (1, '1','0'),(1, '1','xxx'), (1,'1','0'), (1,'1',null), (1,'1', '');

select (i<>0 and s<>0) from m;
select (s<>0 and t<>0) from m;

drop table m;
