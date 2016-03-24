drop table if exists foo;
drop table if exists bar;

create table foo (a int, c int);
create index foo_a on foo (a);

insert into foo values (1,10);
insert into foo values (2,10);
insert into foo values (3,10);
insert into foo values (4,10);
insert into foo values (5,10);
insert into foo values (6,10);
insert into foo values (7,10);
insert into foo values (8,10);
insert into foo values (9,10);
insert into foo values (10,10);

create table bar (a int, c int);
create index bar_a on bar (a);
insert into bar values (1, 20);
insert into bar values (3, 20);
insert into bar values (5, 20);
insert into bar values (7, 20);
insert into bar values (9, 20);

select * from foo f, bar b where f.a > 0 and f.a = b.a and rownum <=4 order by f.a for orderby_num()<=10;
select * from (select f.a a, f.c b, b.a c, b.c d  from foo f, bar b where f.a > 0 and f.a = b.a order by f.a desc limit 4) as m where rownum <=4 order by m.a desc for orderby_num()<=10; 
select * from foo f, bar b where f.a > 0 and f.a = b.a and rownum <=4 order by f.a for orderby_num()<=4; 
select * from foo f, bar b where f.a > 0 and f.a = b.a and rownum <=4 order by f.a for orderby_num()>=2;
select * from foo f, bar b where f.a > 0 and f.a = b.a and rownum <=4 order by f.a for orderby_num()>=10;

drop foo;
drop bar;
