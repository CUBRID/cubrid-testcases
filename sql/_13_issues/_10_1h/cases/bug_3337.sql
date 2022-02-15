create table ta1(a int, b int, c int);
create table ta2(a int, b int);
create table ta3(a int);

insert into ta1(a, b, c) values(1, 1, 3);
insert into ta1(a, b, c) values(1, 2, 2);
insert into ta1(a, b, c) values(1, 3, 1);
insert into ta1(a, b, c) values(2, 1, 1);
insert into ta1(a, b, c) values(2, 2, 2);

insert into ta2(a, b) values(1, 1);
insert into ta2(a, b) values(1, 2);
insert into ta2(a, b) values(1, 3);
insert into ta2(a, b) values(2, 1);
insert into ta2(a, b) values(2, 2);

insert into ta3(a) values(1);
insert into ta3(a) values(2);

select /*RECOMPILE */ ta3.a,
(select ta1.b from ta1 where ta1.a = ta3.a order by ta1.c for orderby_num() = 1) col1,
(select count( * ) from ta2 where ta2.a = ta3.a) col2
from ta3;

drop table ta1;
drop table ta2;
drop table ta3;
