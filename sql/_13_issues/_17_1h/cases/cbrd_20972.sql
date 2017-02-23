drop table if exists t1;
create table t1 (a int, b varchar(5000));
insert into t1 values (1, repeat('a', 1024));
insert into t1 values (2, repeat('b', 1024));
insert into t1 values (3, repeat('c', 1024));

SELECT sys_connect_by_path(b, ','), length(sys_connect_by_path(b, ',')) FROM t1 START WITH a = 1 CONNECT BY PRIOR a + 1 = a order by 1;
SELECT sys_connect_by_path(b, ','), length(sys_connect_by_path(b, ',')) FROM t1 START WITH a = 1 CONNECT BY PRIOR a + 2 = a order by 1;
SELECT sys_connect_by_path(b, ','), length(sys_connect_by_path(b, ',')) FROM t1 START WITH a = 1 CONNECT BY PRIOR a + 3 = a order by 1;

drop table if exists t1;

