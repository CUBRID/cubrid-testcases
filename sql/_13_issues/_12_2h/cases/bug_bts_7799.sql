CREATE TABLE t1(id int);
CREATE TABLE t2(id int,a int);
insert into t1 values (1);
insert into t1 values (2);
insert into t2 values (1,1);
select * FROM t1 WHERE id >any (SELECT id FROM t2);
select * FROM t1 WHERE id >any (SELECT id FROM t2 ORDER BY a);
select * FROM t1 WHERE id >some (SELECT id FROM t2 ORDER BY a);
drop t1,t2;

