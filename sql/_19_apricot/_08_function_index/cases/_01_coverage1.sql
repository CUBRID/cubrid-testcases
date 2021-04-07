--+ holdcas on;

create table testt (i1 int , d1 double);

create index idx on testt (sqrt(d1));
update statistics on all classes;
SHOW INDEXES FROM testt;

insert into testt values (4,25), (16,256), (20,400);
update statistics on all classes;
select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index idx on testt (sqrt(d1));
update statistics on all classes;
SHOW INDEXES FROM testt;



create index idx on testt (i1, sqrt(d1));
update statistics on all classes;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index idx on testt (i1, sqrt(d1));
update statistics on all classes;
SHOW INDEXES FROM testt;



create index idx on testt (d1, sqrt(d1));
update statistics on all classes;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index idx on testt (d1, sqrt(d1));
update statistics on all classes;
SHOW INDEXES FROM testt;



create index idx on testt (sqrt(d1), i1);
update statistics on all classes;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index idx on testt (sqrt(d1), i1);
update statistics on all classes;
SHOW INDEXES FROM testt;


create index idx on testt (sqrt(d1), d1);
update statistics on all classes;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index idx on testt (sqrt(d1), d1);
update statistics on all classes;
SHOW INDEXES FROM testt;


create index idx on testt (i1, sqrt (d1), d1);
update statistics on all classes;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index idx on testt (i1, sqrt(d1), d1);
update statistics on all classes;
SHOW INDEXES FROM testt;


create index idx on testt (sqrt (d1), i1, d1);
update statistics on all classes;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index idx on testt (sqrt(d1), i1, d1);
update statistics on all classes;
SHOW INDEXES FROM testt;

drop table testt;


--+ holdcas off;

