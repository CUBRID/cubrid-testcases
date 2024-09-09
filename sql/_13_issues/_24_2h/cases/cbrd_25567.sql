drop table if exists t;
create table t (a int auto_increment, b varchar);
create index idx on t (b);

-- Insert test data
insert into t (b)
  select to_char (datetime'2024-08-01 00:00:00' + (rownum * 1000), 'YYYYMMDDHH24MISS')
  from db_class a, db_class b, db_class c, db_class d
  limit 10000;

insert into t (b)
  values (to_char (datetime'2024-09-01 00:00:01', 'YYYYMMDDHH24MISS')),
         (to_char (datetime'2024-09-01 00:00:02', 'YYYYMMDDHH24MISS'));

insert into t (b)
  select to_char (datetime'2024-10-01 00:00:00' + (rownum * 1000), 'YYYYMMDDHH24MISS')
  from db_class a, db_class b, db_class c, db_class d
  limit 10000;

-- Using pipe (combined into key_range)
prepare q from'
select /*+ recompile */ count (*)
from t
where b >= ? || ''000000'' and b <= ? || ''999999''
';
set trace on;
execute q using '20240901', '20240901';
show trace;

-- Using concat (combined into key_range)
prepare q from'
select /*+ recompile */ count (*)
from t
where b >= concat (?, ''000000'') and b <= concat (?, ''999999'')
';
set trace on;
execute q using '20240901', '20240901';
show trace;

-- Using session variable (not combined into key_range)
set @v = '20240901';
set trace on;
select /*+ recompile */ count (*)
from t
where b >= concat (@v, '000000') and b <= concat (@v, '999999');
show trace;

set trace off;
drop table if exists t;
