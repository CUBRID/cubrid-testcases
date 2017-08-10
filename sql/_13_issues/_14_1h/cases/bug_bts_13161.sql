CREATE TABLE t (id VARCHAR (40), col int)
PARTITION BY LIST (id) (
    PARTITION p1 VALUES IN ('Swimming', 'Athletics'),
    PARTITION p2 VALUES IN ('Judo', 'Taekwondo', 'Boxing'),
    PARTITION p3 VALUES IN ('Football', 'Basketball', 'Baseball')
);
insert into t values('Swimming',1);
insert into t values('Swimming',2);
insert into t values('Swimming',3);
insert into t values('Swimming',4);
insert into t values('Boxing',5);
insert into t values('Boxing',6);
insert into t values('Boxing',7);
insert into t values('Boxing',8);
insert into t values('Football',9);
insert into t values('Football',10);
insert into t values('Football',11);
insert into t values('Football',12);

select min(col) from t__p__p1;
select min(col) from t__p__p2;
select min(col) from t__p__p3;

select max(col) from t__p__p1;
select max(col) from t__p__p2;
select max(col) from t__p__p3;

create unique index idx on t(col);
create unique index idx1 on t(col,id);
create unique index idx2 on t(id,col);

select min(col) from t__p__p1;
select min(col) from t__p__p2;
select min(col) from t__p__p3;

select max(col) from t__p__p1;
select max(col) from t__p__p2;
select max(col) from t__p__p3;

drop table t;
