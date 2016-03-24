--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(
  a char(1200), 
  b varchar(1200),
  c nchar(1200),
  d NCHAR VARYING(1200),
  e BIT(1200),
  f BIT VARYING(1200),
  g int,
  h SMALLINT,
  i BIGINT,
  j NUMERIC,
  k FLOAT,
  l DOUBLE,
  m MONETARY,
  n DATE,
  o TIME,
  p TIMESTAMP,
  q DATETIME
);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  0,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
  
  
create index idx on t1 (g) where g > 0 AND g < 1000;
  
select /*+ recompile */ g from t1 where g > 0  AND g < 1000 using index idx(+);
  
drop index idx on t1;
 
create index idx on t1(g) where g BETWEEN 0 and 1000;
 
select /*+ recompile */ g from t1 where g between 0  AND 1000 using index idx(+);
 
drop index idx on t1;

create index idx on t1(g) where g NOT BETWEEN 10000 and 100000;
 
select /*+ recompile */ g from t1 where g not between 10000 and 100000 using index idx(+);
 
drop index idx on t1;

create index idx on t1(a) where a like '123%';

select /*+ recompile */ g from t1 where a like '123%' using index idx(+);

drop index idx on t1;

create index idx on t1(a) where a not like '456%';

select /*+ recompile */ g from t1 where a not like '456%' using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g not in (1,2,3,4,5,6,7,8,9,11);

select /*+ recompile */ g from t1 where g not in (1,2,3,4,5,6,7,8,9,11) using index idx(+);

drop index idx on t1;

create index idx on t1(g, h) where (g < 0 and h < 10) is false;

select /*+ recompile */ g, h from t1 where (g < 0 and h < 10) is false using index idx(+);

drop index idx on t1;

create index idx on t1(g, h) where (g < 0 and h < 10) is not true;

select /*+ recompile */ g, h from t1  where (g < 0 and h < 10) is not true using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g = any {1,2,3,4,5,6,7,8,9,10,11};

select /*+ recompile */ g from t1 where g = any {1,2,3,4,5,6,7,8,9,10,11} using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g = all {10};

select /*+ recompile */ g from t1 where g = all {10} using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g > any {1,2,3,4,5,6,7};

select /*+ recompile */ g from t1 where g > any {1,2,3,4,5,6,7} using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g > all {1,2,3,4,5,6,7};

select /*+ recompile */ g from t1 where g  > all {1,2,3,4,5,6,7} using index idx(+);

drop index idx on t1;
 
 create index idx on t1(g) where g < any {11,12,13,14,15,16,17};

select /*+ recompile */ g from t1 where g < any {11,12,13,14,15,16,17} using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g < all {11,12,13,14,15,16,17};

select /*+ recompile */ g from t1 where g  < all {11,12,13,14,15,16,17} using index idx(+);

drop index idx on t1;
 
 create index idx on t1(g) where g >= any {1,2,3,4,5,6,7};

select /*+ recompile */ g from t1 where g >= any {1,2,3,4,5,6,7} using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g >= all {1,2,3,4,5,6,7};

select /*+ recompile */ g from t1 where g  >= all {1,2,3,4,5,6,7} using index idx(+);

drop index idx on t1;
 
create index idx on t1(g) where g <= any {11,12,13,14,15,16,17};

select /*+ recompile */ g from t1 where g <= any {11,12,13,14,15,16,17} using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g <= all {11,12,13,14,15,16,17};

select /*+ recompile */ g from t1 where g <= all {11,12,13,14,15,16,17} using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g > 0;

select /*+ recompile */ g from t1 where g > 0 using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g = 0;

select /*+ recompile */ g from t1 where g = 0 using index idx(+);

drop index idx on t1; 

create index idx on t1(g) where g < 1000;

select /*+ recompile */ g from t1 where g < 1000 using index idx(+);

drop index idx on t1; 

create index idx on t1(g) where g >= 0;

select /*+ recompile */ g from t1 where g >= 0 using index idx(+);

drop index idx on t1; 

create index idx on t1(g) where g <= 1000;

select /*+ recompile */ g from t1 where g <= 1000 using index idx(+);

drop index idx on t1; 

create index idx on t1(g) where g - 1 >= 0;

select /*+ recompile */ g from t1 where g - 1 >= 0 using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g + 1 >= 0;

select /*+ recompile */ g from t1 where g + 1 >= 0 using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g * 2 >= 0;

select /*+ recompile */ g from t1 where g * 2 >= 0 using index idx(+);

drop index idx on t1;

create index idx on t1(g) where g / 2 >= 0;

select /*+ recompile */ g from t1 where g / 2 >= 0 using index idx(+);

drop index idx on t1;

create index idx on t1(g) where -g <= 0;

select /*+ recompile */ g from t1 where -g >= 0 using index idx(+);

drop index idx on t1;

drop table t1;
commit;
set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
