drop table if exists x;
drop table if exists y;
create table x (a int primary key, b int);
insert into x values (1, 1);
insert into x values (2, 1);
insert into x values (3, 1);
insert into x values (4, 1);
insert into x values (5, 1);
insert into x values (6, 1);
insert into x values (7, 1);
insert into x values (8, 1);
insert into x values (9, 1);
insert into x values (10, 1);

create table y (a int primary key, b int);
insert into y values (1, 1);
insert into y values (2, 1);
insert into y values (3, 1);
insert into y values (4, 1);
insert into y values (5, 1);
insert into y values (6, 1);
insert into y values (7, 1);
insert into y values (8, 1);
insert into y values (11, 1);

--@queryplan
select /*+ recompile ORDERED */ * from x, y where x.a = y.a and x.a > 5 order by x.a desc;
drop table if exists x;
drop table if exists y;
