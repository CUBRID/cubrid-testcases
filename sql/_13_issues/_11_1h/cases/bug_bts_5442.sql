create table x(i int);
insert into x values(3),(1),(7),(5),(4),(2),(6);

select i from x where i>1 union select i from x where i>1 order by 1 limit 3;
select i from x where i>1 union select i from x where i>1 order by 1 limit 1,2;

select i from x where i>1 union select i from x where i>1 order by 1 desc limit 3;
select i from x where i>1 union select i from x where i>1 order by 1 desc limit 1,2;

select i from x where i>1 union select i from x where i>1 limit 3;
select i from x where i>1 union select i from x where i>1 limit 1,2;

select i from x where i>1 union select i from x where i>1 order by 1 for orderby_num()<=2 limit 2;

drop table x;

