create table m (a int, b datetime, c date, d time, e timestamp);
insert into m values (1, '2010-07-23 11:21', '1983-07-23', '11:21', '1985-02-10 00:00');
insert into m values (1, null, null, null, null);



select count(*) from m where a and a;
select count(*) from m where a and b;
select count(*) from m where a and c;
select count(*) from m where a and d;
select count(*) from m where a and e;

select count(*) from m where b and a;
select count(*) from m where b and b;
select count(*) from m where b and c;
select count(*) from m where b and d;
select count(*) from m where b and e;

select count(*) from m where c and a;
select count(*) from m where c and b;
select count(*) from m where c and c;
select count(*) from m where c and d;
select count(*) from m where c and e;

select count(*) from m where d and a;
select count(*) from m where d and b;
select count(*) from m where d and c;
select count(*) from m where d and d;
select count(*) from m where d and e;

select count(*) from m where e and a;
select count(*) from m where e and b;
select count(*) from m where e and c;
select count(*) from m where e and d;
select count(*) from m where e and e;

drop table m;


-- kinda useless
create table m (i int, s varchar, t varchar);
insert into m values (1, '1','0'),(1, '1','xxx'), (1,'1','0'), (1,'1',null), (1,'1', '');

select (i and s) from m;
select (s and t) from m;

drop table m;
