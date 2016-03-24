--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (i1 int, i2 int, date_col date);

create index idx on t1 (year(date_col));

insert into t1 values (1,1,date'1999-01-01');
insert into t1 values (2,2,date'2000-01-01');
insert into t1 values (3,3,date'2001-01-01');
insert into t1 values (4,4,date'2002-01-01');
insert into t1 values (5,5,date'2003-01-01');
insert into t1 values (6,6,date'2004-01-01');
insert into t1 values (7,7,date'2005-01-01');
insert into t1 values (8,8,date'2006-01-01');
insert into t1 values (9,9,date'2007-01-01');

--Test
select /*+ recompile */ * from t1 where year(date_col) > 2001;

--Test
select /*+ recompile */ * from t1 where year(date_col) = 2001;

--Test
select /*+ recompile */ * from t1 where year(date_col) < 2003 and year(date_col) > 2000;

--Test
select /*+ recompile */ * from t1 where date_col > date'2001-01-01';

drop index idx on t1;

create index idx on t1 (year(date_col));

--Test
select /*+ recompile */ * from t1 where year(date_col) > 2001;

--Test
select /*+ recompile */ * from t1 where year(date_col) = 2001;

--Test
select /*+ recompile */ * from t1 where year(date_col) < 2003 and year(date_col) > 2000;

--Test
select /*+ recompile */ * from t1 where date_col > date'2001-01-01';

drop index idx on t1;

drop table t1;


create table t1 (i1 int, i2 int, date_col date);

create index idx on t1 (i2, year(date_col));

insert into t1 values (1,1,date'1999-01-01');
insert into t1 values (2,2,date'2000-01-01');
insert into t1 values (3,3,date'2001-01-01');
insert into t1 values (4,3,date'2002-01-01');
insert into t1 values (5,3,date'2003-01-01');
insert into t1 values (6,3,date'2004-01-01');
insert into t1 values (7,3,date'2005-01-01');
insert into t1 values (8,3,date'2006-01-01');
insert into t1 values (9,3,date'2007-01-01');

--Test
select /*+ recompile */ * from t1 where i2 = 3 and year(date_col) > '2003-01-01';

--Test
select /*+ recompile */ * from t1 where i2 = 3 and year(date_col) > '2003-01-01' and year(date_col) < '2007-01-01';

--Test
select /*+ recompile */ * from t1 where i2 > 2 and date_col > '2001-01-01';

--Test
select /*+ recompile */ * from t1 where date_col > '2001-01-01';

drop index idx on t1;

create index idx on t1 (i2, year(date_col));

--Test
select /*+ recompile */ * from t1 where i2 = 3 and year(date_col) > '2003-01-01';

--Test
select /*+ recompile */ * from t1 where i2 = 3 and year(date_col) > '2003-01-01' and year(date_col) < '2007-01-01';

--Test
select /*+ recompile */ * from t1 where i2 > 2 and date_col > '2001-01-01';

--Test
select /*+ recompile */ * from t1 where date_col > '2001-01-01';

drop index idx on t1;

drop table t1;


set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
