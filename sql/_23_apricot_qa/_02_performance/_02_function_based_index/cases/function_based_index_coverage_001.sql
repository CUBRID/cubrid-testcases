--+ holdcas on;
create table testt (i1 int , d1 double);

create index idx1 on testt (sqrt(d1));

SHOW INDEXES FROM testt;

insert into testt values (4,25), (16,256), (20,400);
--Test
select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index on testt (sqrt(d1));

SHOW INDEXES FROM testt;


--Test
create index idx2 on testt (i1, sqrt(d1));

update statistics on testt;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index on testt (i1, sqrt(d1));

SHOW INDEXES FROM testt;


--Test
create index idx3 on testt (d1, sqrt(d1));

update statistics on testt;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index on testt (d1, sqrt(d1));

SHOW INDEXES FROM testt;


--Test
create index idx4 on testt (sqrt(d1), i1);

update statistics on testt;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index  on testt (sqrt(d1), i1);

SHOW INDEXES FROM testt;

--Test
create index idx5 on testt (sqrt(d1), d1);

update statistics on testt;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index on testt (sqrt(d1), d1);

SHOW INDEXES FROM testt;

--Test
create index idx6 on testt (i1, sqrt (d1), d1);

update statistics on testt;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index on testt (i1, sqrt(d1), d1);

SHOW INDEXES FROM testt;

--Test
create index idx7 on testt (sqrt (d1), i1, d1);

update statistics on testt;
SHOW INDEXES FROM testt;

select /*+ recompile */ * from testt where sqrt(d1) > 5; 

drop index on testt (sqrt(d1), i1, d1);

SHOW INDEXES FROM testt;

drop table testt;




commit;
--+ holdcas off;
