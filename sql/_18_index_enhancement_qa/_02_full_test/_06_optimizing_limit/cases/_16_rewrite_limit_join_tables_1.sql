--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table x (a int);
create table y (a int);

create index i_x_a on x(a);
create index i_y_a on y(a);

insert into x values (1);
insert into x values (2);
insert into x values (3);
insert into x values (4);
insert into x values (null);

insert into y values (1);
insert into y values (2);
insert into y values (3);
insert into y values (5);
insert into y values (null);

set system parameters 'xasl_debug_dump=yes';
update statistics on all classes;

select /*+ recompile */ x.a, y.a from x,y where x.a>0 and y.a > 0 limit 2;
select /*+ recompile */ x.a, y.a from x,y where x.a>0 and y.a > 0 limit 2,3;


select /*+ recompile */ x.a, y.a from x left join y on x.a=y.a where x.a>0 and y.a > 0 limit 2;

select /*+ recompile */ x.a, y.a from x left join y on x.a=y.a where x.a is not null and y.a is not null limit 10;

select /*+ recompile */ x.a, y.a from x right join y on x.a=y.a where x.a>0 and y.a > 0 limit 2;

set system parameters 'xasl_debug_dump=no';

drop table x;
drop table y;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
