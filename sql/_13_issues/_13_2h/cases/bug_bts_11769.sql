-- Test in memory sort does not correctly evaluate the size of the in memory tuples

-- Overflow caused by floating point precision
drop table if exists t;

create table t(s varchar(255));

insert into t select concat('2010010', rownum) from _db_class limit 9;

SELECT DECODE(NVL(s,'00'),'00', '?????','99','???','') from t order by 1 limit 5;

drop t;

-- Overflow of the sort-buffer size
drop table if exists u;

create table u(i int, sv varchar(1024), sc char(1024));

insert into u select rownum, repeat(rownum, 300), rownum from _db_class limit 30;

set system parameters 'sort_buffer_size=1';

select i, sv, sc from u order by 1 limit 15;

drop u;
