drop if exists t1,t2; 

CREATE TABLE t1 (i INT, j INT);
CREATE TABLE t2 (i INT, j INT) PARTITION BY LIST (i) (
    PARTITION p0 VALUES IN (1,3,5,7,9),
    PARTITION p1 VALUES IN (0,2,4,6,8)
);

CREATE TRIGGER tri2
BEFORE INSERT ON t1
EXECUTE UPDATE t2 PARTITION (p0) set i=1;

CREATE TRIGGER tri1
BEFORE INSERT ON t1
EXECUTE INSERT INTO t2 PARTITION (p0) VALUES (3,3);

insert into t1 values(-1,-1);

select * from t2 order by 1;

update t1 set i=2;

select * from t2__p__p0 order by 1;

drop t1,t2; 


CREATE TABLE t1 (i varchar(200), j varchar(200));
CREATE TABLE t2 (i int, j varchar(300)) PARTITION BY LIST (i) (
    PARTITION p0 VALUES IN (1,3,5,7,9),
    PARTITION p1 VALUES IN (0,2,4,6,8)
);

insert into t1 select rownum,rownum from db_class limit 10;

insert into t2 values(0,0);


CREATE TRIGGER tri2
BEFORE DELETE ON t1
EXECUTE DELETE from t2 PARTITION (p0) ;

CREATE TRIGGER tri1
BEFORE INSERT ON t1
EXECUTE INSERT INTO t2 PARTITION (p0) VALUES (3,3);

insert into t1 values(-1,-1);

select * from t2__p__p0 order by 1;

delete from t1 where i<5;

select * from t2__p__p0 order by 1;

select * from t1 order by 1;

insert into t1 values(-1,-1);

select * from t2__p__p0 order by 1;

delete from t1 where i<5;

select * from t2__p__p0 order by 1;

drop t1,t2; 