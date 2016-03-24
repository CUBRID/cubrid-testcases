autocommit off;
create table aaa (a int);
insert into aaa values(1);
insert into aaa values(2);
insert into aaa values(3);
insert into aaa values(4);
insert into aaa values(5);
select * from aaa
where
rownum = 1 and
a >= (select min(a) from aaa);
select * from aaa
where
a >= (select min(a) from aaa) and
rownum = 1; 
rollback work;
rollback;
