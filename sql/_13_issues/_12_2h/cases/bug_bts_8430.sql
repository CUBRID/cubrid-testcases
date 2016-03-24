--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
--case 1
create table a (i int primary key, j int);
insert into a values(1,1);
insert into a values(1,1) on duplicate key update j=2;
select * from a;
--set optimization level for insert
SET OPTIMIZATION LEVEL 258;
insert into a values(1,1) on duplicate key update j=2;
insert into a values(1,1) on duplicate key update j=5;
--recovery optimization level 
SET OPTIMIZATION LEVEL 1;
drop a;
--case 2
create table t1 (i int primary key, j int);
insert into t1 values(1,1);
CREATE TABLE t2 (x int);
CREATE TRIGGER t1 BEFORE INSERT ON t1  EXECUTE DELETE FROM t2;
INSERT INTO t1 SELECT 1,1  FROM t1 on duplicate key update j=2;

SET OPTIMIZATION LEVEL 258;
INSERT INTO t1 SELECT 1,1  FROM t1 on duplicate key update j=2;

SET OPTIMIZATION LEVEL 1;

drop trigger t1;
drop t1;
drop t2;
set  system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
commit;

