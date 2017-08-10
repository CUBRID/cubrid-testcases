autocommit off;
create class temp1 (at1 int);
create class temp2 (at1 temp1);
drop class temp1
select * from temp2;
rollback;

create class xxx (abc int);
create class zzz (s9 string, x9 xxx);
insert into zzz values ('x', insert into xxx values (10));
select zzz.x9.abc from zzz order by 1;
rollback;

autocommit on;
drop class temp1;
drop class temp2;
drop class xxx;
drop class zzz;
