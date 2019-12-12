drop table if exists t_hierarchical;
create table t_hierarchical(emp int,mgr int,emp_name char(20));
INSERT INTO t_hierarchical VALUES (1,NULL,'AA');
INSERT INTO t_hierarchical VALUES (2,1,'BB');
INSERT INTO t_hierarchical VALUES (3,2,'CC');
INSERT INTO t_hierarchical VALUES (4,3,'DD');
INSERT INTO t_hierarchical VALUES (5,2,'EE');
INSERT INTO t_hierarchical VALUES (6,3,'FF');

select emp, mgr, emp_name from t_hierarchical t;


select emp, mgr, LEVEL from t_hierarchical t
CONNECT BY PRIOR emp=mgr
order by emp;

select emp, mgr, LEVEL from t_hierarchical t
START WITH emp=1
CONNECT BY PRIOR emp=mgr;

select emp, mgr, LEVEL, SYS_CONNECT_BY_PATH(emp,'/') path from t_hierarchical t
START WITH emp=1
CONNECT BY PRIOR emp=mgr;

select emp, mgr, LEVEL, SYS_CONNECT_BY_PATH(emp,'/') path from t_hierarchical t
where CONNECT_BY_ISLEAF=1
START WITH emp=1
CONNECT BY PRIOR emp=mgr;

drop table if exists t_hierarchical;