drop table if exists x, y;
create table x(i int);
create table y(i int);
create index i_y_a on y(i);
update statistics on y with fullscan;

--@queryplan
select /*+ recompile ordered */ * from y inner join x where y.i=x.i;
--@queryplan
update /*+ recompile ordered */ y inner join x on y.i=x.i set x.i=y.i, y.i=x.i;
drop table if exists x, y;
