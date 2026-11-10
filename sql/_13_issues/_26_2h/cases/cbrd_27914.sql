/**
 *  This test case verifies CBRD-27914: information_schema views show values
 *  that differ from the column definitions of CBRD-25863.
 *
 *  Each case reads an information_schema view whose output the fix changed,
 *  except Case 14, which calls current_schema() in a PL/CSQL function. Where a
 *  db_ view shows the same information, the case prints both side by side.
 *
 *  Coverage:
 *    Case 1:   a view column of undetermined length shows the maximum VARCHAR
 *              length
 *    Case 2:   datetime_precision is 0 for DATE, TIME and TIMESTAMP types and 3
 *              for DATETIME types
 *    Case 3:   sub_part is NULL for a whole-column key and the prefix length
 *              for a prefix key
 *    Case 4:   column_key is PRI for the instance column a and empty for the
 *              CLASS ATTRIBUTE a
 *    Case 5:   statistics shows one row for the one-column primary key beside
 *              the CLASS ATTRIBUTE a
 *    Case 6:   target_catalog is NULL for a remote synonym and the database
 *              name for a local one
 *    Case 7:   an ENUM column shows the charset and collation that
 *              db_attribute shows
 *    Case 8:   partition_expression is the partition_expr that db_partition
 *              shows
 *    Case 9:   external_name of a Java function is the target that
 *              db_stored_procedure shows
 *    Case 10:  numeric_precision of a serial is 38
 *    Case 11:  is_cached is NO for CACHE 1 and YES for CACHE 2
 *    Case 12:  table_rows and avg_row_length of a partitioned table equal those
 *              of the same rows without partitions
 *    Case 13:  action_statement shows REJECT, INVALIDATE TRANSACTION and the
 *              PRINT statement
 *    Case 14:  current_schema() in a PL/CSQL function returns what schema()
 *              returns
 *    Case 15:  auto_increment is a NUMERIC(38,0) that shows the next id after
 *              an insert
 */

drop view if exists v_len;
drop table if exists t_len, t_dt, t_sub, t_ca, t_enum, t_part_hash, t_rows_part, t_rows_heap, t_trig, t_ai;
drop synonym if exists s_remote;
drop synonym if exists s_local;
drop server if exists srv_27914;
drop serial if exists s_prec;
drop serial if exists s_cache1;
drop serial if exists s_cache2;

create table t_len (a varchar(10), b varchar(10));
create view v_len as select a || b as c_concat, null as c_null from t_len;

evaluate 'Case 1: a view column of undetermined length shows the maximum VARCHAR length';
select column_name, character_maximum_length, character_octet_length > 0, column_type from information_schema.columns where table_name = 'v_len' order by column_name;

create table t_dt (c_date date, c_time time, c_timestamp timestamp, c_timestamptz timestamptz, c_timestampltz timestampltz, c_datetime datetime, c_datetimetz datetimetz, c_datetimeltz datetimeltz);

evaluate 'Case 2: datetime_precision is 0 for DATE, TIME and TIMESTAMP types and 3 for DATETIME types';
select column_name, data_type, datetime_precision from information_schema.columns where table_name = 't_dt' order by ordinal_position;

create table t_sub (a int, c varchar(10));
create index i_sub_full on t_sub (a);
create index i_sub_prefix on t_sub (c(3));

evaluate 'Case 3: sub_part is NULL for a whole-column key and the prefix length for a prefix key';
select index_name, column_name, sub_part from information_schema.statistics where table_name = 't_sub' order by index_name;

-- is_nullable and nullable tell the instance column a (NO) from the CLASS ATTRIBUTE a (YES)
create table t_ca class attribute (a int) (a int primary key);

evaluate 'Case 4: column_key is PRI for the instance column a and empty for the CLASS ATTRIBUTE a';
select column_name, is_nullable, column_key from information_schema.columns where table_name = 't_ca' and column_name = 'a' order by is_nullable;

evaluate 'Case 5: statistics shows one row for the one-column primary key beside the CLASS ATTRIBUTE a';
select index_name, column_name, seq_in_index, nullable from information_schema.statistics where table_name = 't_ca' order by index_name, seq_in_index;

-- the server is only a catalog entry: no statement connects to it
create server srv_27914 (host = 'localhost', port = 30001, dbname = 'rdb', user = 'dba', password = '');
create synonym s_remote for dba.t_remote@srv_27914;
create synonym s_local for t_ca;

evaluate 'Case 6: target_catalog is NULL for a remote synonym and the database name for a local one';
select synonym_name, target_catalog is null, target_catalog = database (), target_name from information_schema.synonyms where synonym_name in ('s_local', 's_remote') order by synonym_name;

create table t_enum (e enum ('x', 'y'));

evaluate 'Case 7: an ENUM column shows the charset and collation that db_attribute shows';
select i.character_set_name, i.collation_name, a.charset, a.collation from information_schema.columns i, db_attribute a where i.table_name = 't_enum' and i.column_name = 'e' and a.class_name = 't_enum' and a.attr_name = 'e';

create table t_part_hash (id int) partition by hash (id) partitions 2;

evaluate 'Case 8: partition_expression is the partition_expr that db_partition shows';
select i.partition_name, i.partition_expression, d.partition_expr from information_schema.partitions i, db_partition d where i.table_name = 't_part_hash' and d.class_name = 't_part_hash' and d.partition_name = i.partition_name order by i.partition_name;

-- the function is only a catalog entry: no statement calls it
create or replace function f27914_java (x int) return int as language java name 'SpTest.testInt(int) return int';

evaluate 'Case 9: external_name of a Java function is the target that db_stored_procedure shows';
select i.external_name, s.target from information_schema.routines i, db_stored_procedure s where i.routine_name = 'f27914_java' and s.sp_name = 'f27914_java';

create serial s_prec;
create serial s_cache1 cache 1;
create serial s_cache2 cache 2;

evaluate 'Case 10: numeric_precision of a serial is 38';
select sequence_name, numeric_precision from information_schema.sequences where sequence_name = 's_prec';

evaluate 'Case 11: is_cached is NO for CACHE 1 and YES for CACHE 2';
select sequence_name, is_cached from information_schema.sequences where sequence_name in ('s_cache1', 's_cache2') order by sequence_name;

create table t_rows_part (id int) partition by hash (id) partitions 2;
create table t_rows_heap (id int);
insert into t_rows_part select level from db_root connect by level <= 1000;
insert into t_rows_heap select level from db_root connect by level <= 1000;

evaluate 'Case 12: table_rows and avg_row_length of a partitioned table equal those of the same rows without partitions';
select table_name, table_rows, avg_row_length from information_schema.tables where table_name in ('t_rows_heap', 't_rows_part') order by table_name;

create table t_trig (a int);
create trigger tr27914_reject before delete on t_trig execute reject;
create trigger tr27914_invalidate before update on t_trig execute invalidate transaction;
create trigger tr27914_print after insert on t_trig execute print 'p';

evaluate 'Case 13: action_statement shows REJECT, INVALIDATE TRANSACTION and the PRINT statement';
select trigger_name, action_statement from information_schema.triggers where event_object_table = 't_trig' order by trigger_name;

create or replace function f27914_current_schema return string as begin return current_schema(); end;
create or replace function f27914_schema return string as begin return schema(); end;

evaluate 'Case 14: current_schema() in a PL/CSQL function returns what schema() returns';
select f27914_current_schema (), f27914_schema () from db_root;

-- with the AUTO_INCREMENT cache off, auto_increment is the next id, not the end of a cache block
set system parameters 'auto_increment_cache_size=0';
create table t_ai (id int auto_increment, v int);
insert into t_ai (v) values (1);

evaluate 'Case 15: auto_increment is a NUMERIC(38,0) that shows the next id after an insert';
select typeof (auto_increment), auto_increment from information_schema.tables where table_name = 't_ai';

set system parameters 'auto_increment_cache_size=default';
drop function f27914_java;
drop function f27914_current_schema;
drop function f27914_schema;
drop synonym s_remote;
drop synonym s_local;
drop server srv_27914;
drop serial s_prec;
drop serial s_cache1;
drop serial s_cache2;
drop view v_len;
drop table t_len, t_dt, t_sub, t_ca, t_enum, t_part_hash, t_rows_part, t_rows_heap, t_trig, t_ai;
