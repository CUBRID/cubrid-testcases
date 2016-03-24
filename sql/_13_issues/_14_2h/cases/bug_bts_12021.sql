--+ holdcas on;
drop table if exists foo;

create table foo (a1 int, a2 int, a3 int, a4 int, a5 int,
                a6 int, a7 int, a8 int, a9 int, a10 int,
                a11 int, a12 int, a13 int, a14 int, a15 int);
create index idx1 on foo (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,
                        a11, a12, a13, a14, a15);
insert into foo values (1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
show index in foo;

drop table if exists foo;
--+ holdcas off;
commit;
