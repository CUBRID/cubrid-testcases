create table foo(i int, p int);
create view foo_view(i, p, lvl) as select i, p, level from foo start with i=1 connect by prior i=p;

select i, p from foo_view where lvl=1;
select i, p, lvl from foo_view;

drop view foo_view;
drop table foo;

