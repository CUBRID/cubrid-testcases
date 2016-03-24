--+ holdcas on;
drop table if exists t1;
create table t1(a int,b int);
insert into t1 values(1,1);
insert into t1 values(2,null);
insert into t1 values(3,null);
insert into t1 values(4,2);
insert into t1 values(5,1);
insert into t1 values(6,1);

select a,b from t1 order by 1,2;
select a,b as bx from t1 group by b order by b,1;
select a,b as bx from t1 group by bx order by bx,1;
select a,b as bx from t1 group by bx order by b,1;
select a,b as bx from t1 group by b order by bx,1;
select a,b as b from t1 group by b order by b,1;

select a,b as bx from t1 where b = 1 group by b order by b,1;

-error
select a,b as bx from t1 where bx = 1 group by b order by b,1;

select a,b as bx from t1 group by b order by bx,1;
select a,b as bx from t1 group by bx order by bx,1;
select a,b as bx from t1 group by bx order by b,1;
select a,b as bx from t1 group by b order by bx,1;
select a,b as b from t1 group by b order by b,1;

drop table if exists t1;

---------------------------------------------------

drop table if exists t1;

CREATE TABLE t1(a INT); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES(3); 
select * from t1 where a <>1 order by 1;

drop table if exists t1;

---------------------------------------------------

drop table if exists t1;

CREATE TABLE t1(a varchar(20)); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES(3); 
select * from t1 where a <>1 order by 1;


drop table if exists t1;

---------------------------------------------------
drop table if exists t1;
drop table t1;
CREATE TABLE t1(a varchar(20)); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES(3); 
select * from t1 where a <>1 order by 1;


drop table if exists t1;


--+ holdcas off;
commit;