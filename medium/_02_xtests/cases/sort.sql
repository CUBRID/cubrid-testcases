autocommit off;
create class ints (i int);
insert into ints values (null);
insert into ints values (1);
insert into ints values (2);
insert into ints values (3);
create class doubles (d double);
insert into doubles values (null);
insert into doubles values (1);
insert into doubles values (1);
insert into doubles values (2);
create class strings (s string);
insert into strings values (null);
insert into strings values ('abcdefghijklmn');
insert into strings values ('abcdefghijklmn       ');
insert into strings values ('abcdefghijklm');
create class monetaries (m monetary);
insert into monetaries values (null);
insert into monetaries values (10);
insert into monetaries values (10);
insert into monetaries values (20);
select i from ints order by 1;
select i from ints order by 1 desc;
select d from doubles order by 1;
select d from doubles order by 1 desc;
select s from strings order by 1;
select s from strings order by 1 desc;
select m from monetaries order by 1;
select m from monetaries order by 1 desc;
select i, s from ints, strings order by 1, 2;
select i, s from ints, strings order by 1 desc, 2;
select i, s from ints, strings order by 1, 2 desc;
select i, s from ints, strings order by 1 desc, 2 desc;
select i, s from ints, strings order by 2, 1;
select i, s from ints, strings order by 2 desc, 1;
select i, s from ints, strings order by 2, 1 desc;
select i, s from ints, strings order by 2 desc, 1 desc;
select d, m from doubles, monetaries order by 1, 2;
select d, m from doubles, monetaries order by 1 desc, 2;
select d, m from doubles, monetaries order by 1, 2 desc;
select d, m from doubles, monetaries order by 1 desc, 2 desc;
select d, m from doubles, monetaries order by 2, 1;
select d, m from doubles, monetaries order by 2 desc, 1;
select d, m from doubles, monetaries order by 2, 1 desc;
select d, m from doubles, monetaries order by 2 desc, 1 desc;
select i0, d1, s2, m3, i4, d5, s6, m7, i8
from   (select i from ints) as t0(i0),
       (select d from doubles where d is null) as t1(d1),
       (select s from strings where s is null) as t2(s2),
       (select m from monetaries where m is null) as t3(m3),
       (select i from ints) as t4(i4),
       (select d from doubles where d is null) as t5(d5),
       (select s from strings where s is null) as t6(s6),
       (select m from monetaries where m is null) as t7(m7),
       (select i from ints) as t8(i8)
order by i0, d1, s2, m3, i4, d5, s6, m7, i8;
rollback;
