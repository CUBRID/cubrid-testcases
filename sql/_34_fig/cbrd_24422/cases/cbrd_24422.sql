-- drop table t2, t1.
drop table if exists t2;
drop table if exists t1;


--Create table and add constraint foreign key.

create table t1 (c1 int primary key);
create table t2 (c1 int primary key, c2 int, c3 int) partition by hash(c1) partitions 2;
alter table t2 add constraint foreign key (c2) references t1 (c1);

/*
 * AS-IS:
 *   - DBA & User: Segmentation fault (core dumped)
 *   - Publuc: Aborted (core dumped)
 *
 * TO-BE: (Current)
 *   - ERROR: Constraint "fk_t2_c3" not found.
 */
alter table t2 add constraint foreign key (c3) references t2 (c1);

drop table if exists t2;
drop table if exists t1;

select DECODE(COUNT(*),0,'PASS','FAIL') AS chk from db_class where is_system_class = 'NO' and class_name in ('t1', 't2');



