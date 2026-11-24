-- CBRD-27381: radix-sorted index builds of the date and time types
--
-- t_r and t_c hold the same rows. Every column of t_r is indexed with index_sort_method=radix and the
-- same column of t_c with compare, both with index_build_buffer_size 64K so a build sorts several
-- runs. Read in index order, each radix-built index must return the rows of its compare-built twin
-- in the same order (0 rows differ) and find as many rows.
--
-- Rows: 6000 values in four shapes of 1500 (scattered, ascending, descending, few distinct values)
-- with a NULL every 101st row, then the extremes of DATE, TIME and DATETIME, and one instant written
-- in three time zones. The zone of a TZ value is not part of its order: the same instant in other
-- zones is an equal key.
--
-- Covers: DATE, TIME, TIMESTAMP, DATETIME, TIMESTAMPTZ, TIMESTAMPLTZ, DATETIMETZ, DATETIMELTZ, and
-- descending indexes of DATETIME and TIMESTAMPTZ

drop table if exists g;
drop table if exists t_r;
drop table if exists t_c;

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table t_r (id int, d1 date, d2 time, d3 timestamp, d4 datetime, d5 timestamptz, d6 timestampltz,
                  d7 datetimetz, d8 datetimeltz);

insert into t_r
  select n, adddate (date'2000-01-01', v * 3), sec_to_time (mod (v * 37 + 864000, 86400)),
         timestamp'2010-06-01 12:00:00' + v * 3601, datetime'2010-06-01 12:00:00.000' + cast (v as bigint) * 3601007,
         cast (concat (to_char (timestamp'2010-06-01 12:00:00' + v * 3601, 'YYYY-MM-DD HH24:MI:SS'), ' ', z) as timestamptz),
         cast (concat (to_char (timestamp'2010-06-01 12:00:00' + v * 3601, 'YYYY-MM-DD HH24:MI:SS'), ' ', z) as timestampltz),
         cast (concat (to_char (datetime'2010-06-01 12:00:00.000' + cast (v as bigint) * 3601007, 'YYYY-MM-DD HH24:MI:SS.FF'), ' ', z) as datetimetz),
         cast (concat (to_char (datetime'2010-06-01 12:00:00.000' + cast (v as bigint) * 3601007, 'YYYY-MM-DD HH24:MI:SS.FF'), ' ', z) as datetimeltz)
  from (select n, v, case mod (n, 3) when 0 then 'UTC' when 1 then 'Asia/Seoul' else 'America/New_York' end as z from g) x
  order by n;

insert into t_r values (6001, date'0001-01-01', time'00:00:00', timestamp'1971-01-01 00:00:00', datetime'0001-01-01 00:00:00.000',
  timestamptz'1971-01-01 00:00:00 UTC', timestampltz'1971-01-01 00:00:00 UTC', datetimetz'1900-01-01 00:00:00.000 UTC',
  datetimeltz'1900-01-01 00:00:00.000 UTC');
insert into t_r values (6002, date'9999-12-31', time'23:59:59', timestamp'2037-12-31 00:00:00', datetime'9999-12-31 23:59:59.999',
  timestamptz'2037-12-31 00:00:00 UTC', timestampltz'2037-12-31 00:00:00 UTC', datetimetz'2999-12-31 23:59:59.999 UTC',
  datetimeltz'2999-12-31 23:59:59.999 UTC');
insert into t_r values (6003, date'2015-03-01', time'09:00:00', timestamp'2015-03-01 09:00:00', datetime'2015-03-01 09:00:00.000',
  timestamptz'2015-03-01 09:00:00 Asia/Seoul', timestampltz'2015-03-01 09:00:00 Asia/Seoul',
  datetimetz'2015-03-01 09:00:00.000 Asia/Seoul', datetimeltz'2015-03-01 09:00:00.000 Asia/Seoul');
insert into t_r values (6004, date'2015-03-01', time'09:00:00', timestamp'2015-03-01 09:00:00', datetime'2015-03-01 09:00:00.000',
  timestamptz'2015-03-01 00:00:00 UTC', timestampltz'2015-03-01 00:00:00 UTC',
  datetimetz'2015-03-01 00:00:00.000 UTC', datetimeltz'2015-03-01 00:00:00.000 UTC');
insert into t_r values (6005, date'2015-03-01', time'09:00:00', timestamp'2015-03-01 09:00:00', datetime'2015-03-01 09:00:00.000',
  timestamptz'2015-02-28 19:00:00 America/New_York', timestampltz'2015-02-28 19:00:00 America/New_York',
  datetimetz'2015-02-28 19:00:00.000 America/New_York', datetimeltz'2015-02-28 19:00:00.000 America/New_York');

create table t_c like t_r;
insert into t_c select * from t_r order by id;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_r1 on t_r (d1);
create index i_r2 on t_r (d2);
create index i_r3 on t_r (d3);
create index i_r4 on t_r (d4);
create index i_r5 on t_r (d5);
create index i_r6 on t_r (d6);
create index i_r7 on t_r (d7);
create index i_r8 on t_r (d8);
create index i_r4d on t_r (d4 desc);
create index i_r5d on t_r (d5 desc);
set system parameters 'index_sort_method=compare';
create index i_c1 on t_c (d1);
create index i_c2 on t_c (d2);
create index i_c3 on t_c (d3);
create index i_c4 on t_c (d4);
create index i_c5 on t_c (d5);
create index i_c6 on t_c (d6);
create index i_c7 on t_c (d7);
create index i_c8 on t_c (d8);
create index i_c4d on t_c (d4 desc);
create index i_c5d on t_c (d5 desc);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- rows read in index order that differ from the compare-built index: 0 each
select 'd1', count(*) from ((select rownum, d1 from t_r where d1 >= date'0001-01-01' using index i_r1)
  difference (select rownum, d1 from t_c where d1 >= date'0001-01-01' using index i_c1)) x;
select 'd2', count(*) from ((select rownum, d2 from t_r where d2 >= time'00:00:00' using index i_r2)
  difference (select rownum, d2 from t_c where d2 >= time'00:00:00' using index i_c2)) x;
select 'd3', count(*) from ((select rownum, d3 from t_r where d3 >= timestamp'1970-06-01 00:00:00' using index i_r3)
  difference (select rownum, d3 from t_c where d3 >= timestamp'1970-06-01 00:00:00' using index i_c3)) x;
select 'd4', count(*) from ((select rownum, d4 from t_r where d4 >= datetime'0001-01-01 00:00:00.000' using index i_r4)
  difference (select rownum, d4 from t_c where d4 >= datetime'0001-01-01 00:00:00.000' using index i_c4)) x;
select 'd5', count(*) from ((select rownum, d5 from t_r where d5 >= timestamptz'1970-06-01 00:00:00 UTC' using index i_r5)
  difference (select rownum, d5 from t_c where d5 >= timestamptz'1970-06-01 00:00:00 UTC' using index i_c5)) x;
select 'd6', count(*) from ((select rownum, d6 from t_r where d6 >= timestampltz'1970-06-01 00:00:00 UTC' using index i_r6)
  difference (select rownum, d6 from t_c where d6 >= timestampltz'1970-06-01 00:00:00 UTC' using index i_c6)) x;
select 'd7', count(*) from ((select rownum, d7 from t_r where d7 >= datetimetz'1800-01-01 00:00:00.000 UTC' using index i_r7)
  difference (select rownum, d7 from t_c where d7 >= datetimetz'1800-01-01 00:00:00.000 UTC' using index i_c7)) x;
select 'd8', count(*) from ((select rownum, d8 from t_r where d8 >= datetimeltz'1800-01-01 00:00:00.000 UTC' using index i_r8)
  difference (select rownum, d8 from t_c where d8 >= datetimeltz'1800-01-01 00:00:00.000 UTC' using index i_c8)) x;
select 'd4 desc', count(*) from ((select rownum, d4 from t_r where d4 >= datetime'0001-01-01 00:00:00.000' using index i_r4d)
  difference (select rownum, d4 from t_c where d4 >= datetime'0001-01-01 00:00:00.000' using index i_c4d)) x;
select 'd5 desc', count(*) from ((select rownum, d5 from t_r where d5 >= timestamptz'1970-06-01 00:00:00 UTC' using index i_r5d)
  difference (select rownum, d5 from t_c where d5 >= timestamptz'1970-06-01 00:00:00 UTC' using index i_c5d)) x;

-- rows each radix-built index finds: all but the NULL ones. With 0 rows differing above, the same count
-- means the radix-built index holds exactly the rows of its twin
select count(*) from t_r where d1 >= date'0001-01-01' using index i_r1;
select count(*) from t_r where d2 >= time'00:00:00' using index i_r2;
select count(*) from t_r where d3 >= timestamp'1970-06-01 00:00:00' using index i_r3;
select count(*) from t_r where d4 >= datetime'0001-01-01 00:00:00.000' using index i_r4;
select count(*) from t_r where d5 >= timestamptz'1970-06-01 00:00:00 UTC' using index i_r5;
select count(*) from t_r where d6 >= timestampltz'1970-06-01 00:00:00 UTC' using index i_r6;
select count(*) from t_r where d7 >= datetimetz'1800-01-01 00:00:00.000 UTC' using index i_r7;
select count(*) from t_r where d8 >= datetimeltz'1800-01-01 00:00:00.000 UTC' using index i_r8;
select count(*) from t_r where d4 >= datetime'0001-01-01 00:00:00.000' using index i_r4d;
select count(*) from t_r where d5 >= timestamptz'1970-06-01 00:00:00 UTC' using index i_r5d;

-- the instant written in three zones is one key: three rows each
select count(*) from t_r where d5 = timestamptz'2015-03-01 00:00:00 UTC' using index i_r5;
select count(*) from t_r where d7 = datetimetz'2015-03-01 00:00:00.000 UTC' using index i_r7;

drop table g;
drop table t_r;
drop table t_c;
