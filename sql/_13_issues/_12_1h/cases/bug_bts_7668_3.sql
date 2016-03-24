--TEST: [ENUM TYPE] Enum column can not be altered using alter table ... change ... statement.

--+ holdcas on;
set system parameters 'alter_table_change_type_strict=yes';

create table t1(si smallint, i int, bi bigint, n numeric, f float, d double, m monetary, t time, da date, dt datetime, ts timestamp, c char(10), v varchar(10), nc nchar(10), vnc nchar varying(10));
insert into t1 values (1, 1, 1, 1, 1, 1, 1, time'10:00:00', date '12/21/2012', datetime '10:00:00 AM 12/21/2012', timestamp '10:00:00 AM 12/21/2012', 'a', 'a', N'a', N'a');
insert into t1 values (2, 2, 2, 2, 2, 2, 2, time'12:00:00', date '12/22/2012', datetime '12:00:00 PM 12/22/2012', timestamp '12:00:00 PM 12/22/2012', 'b', 'b', N'b', N'b');
insert into t1 values (3, 3, 3, 3, 3, 3, 3, time'03:00:00', date '12/23/2012', datetime '01:00:00 PM 12/23/2012', timestamp '01:00:00 PM 12/23/2012', 'c', 'c', N'c', N'c');

alter table t1 change si si enum('a', 'b');
select si from t1 order by 1;

alter table t1 change si si enum('a', 'b', 'c');
select si from t1 order by 1;

alter table t1 change i i enum('a', 'b', 'c');
select i from t1 order by 1;

alter table t1 change bi bi enum('a', 'b', 'c');
select bi from t1 order by 1;

alter table t1 change n n enum('a', 'b', 'c');
select n from t1 order by 1;

alter table t1 change f f enum('a', 'b', 'c');
select f from t1 order by 1;

alter table t1 change d d enum('a', 'b', 'c');
select d from t1 order by 1;

alter table t1 change m m enum('a', 'b', 'c');
select m from t1 order by 1;

alter table t1 change t t enum('10:00:00 AM', '12:00:00 PM', '03:00:00 AM');
select t from t1 order by 1;

alter table t1 change da da enum('12/21/2012', '12/22/2012', '12/23/2012');
select da from t1 order by 1;

alter table t1 change dt dt enum('10:00:00.000 AM 12/21/2012', '12:00:00.000 PM 12/22/2012', '01:00:00.000 PM 12/23/2012');
select dt from t1 order by 1;

alter table t1 change ts ts enum('10:00:00 AM 12/21/2012', '12:00:00 PM 12/22/2012', '01:00:00 PM 12/23/2012');
select ts from t1 order by 1;

alter table t1 change c c enum('a', 'b', 'c');
select c from t1 order by 1;

alter table t1 change v v enum('a', 'b', 'c');
select v from t1 order by 1;

alter table t1 change nc nc enum('a', 'b', 'c');
select nc from t1 order by 1;

alter table t1 change vnc vnc enum('a', 'b', 'c');
select vnc from t1 order by 1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';
commit;
--+ holdcas off;
