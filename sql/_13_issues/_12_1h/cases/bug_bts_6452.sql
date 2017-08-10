drop table if exists t3;
CREATE TABLE t3 (a INT unique, b INT unique, c int);
insert into t3 values (1,1, 1);
insert into t3 values (2,2, 2);
--MySQL will fail for below sql. But CUBRID will success.
insert into t3 values (2,1, 3) ON DUPLICATE KEY UPDATE b=1, c=100;
--to check result
drop table if exists t3;


CREATE TABLE t3 (a INT unique, b INT unique, c int);
insert into t3 values (1,1, 1);
insert into t3 values (2,2, 2);
set system parameters 'insert_execution_mode = 31';
insert into t3 values (2,1, 3) ON DUPLICATE KEY UPDATE b=1, c=100;
set system parameters 'insert_execution_mode = 1';
drop table if exists t3;
set system parameters 'insert_execution_mode = 3';
