create table x (a int, b int);
insert into x values (1, 1);
insert into x values (2, 2);

select /*+ recompile*/* from x where a > 0 order by b limit 1, 10;
insert into x values (3, 1);
insert into x values (4, 2);
insert into x values (5, 1);
insert into x values (6, 2);
insert into x values (7, 1);
insert into x values (8, 2);
insert into x values (9, 1);
insert into x values (10, 2);
insert into x values (11, 1);
insert into x values (12, 2);
select /*+ recompile*/* from x where a > 0 order by a limit 1, 10;
select /*+ recompile*/* from x where a > 0 order by a limit 2, 6;
drop x;
