DROP CLASS IF EXISTS X,Y;
CREATE TABLE x (col SET OF INT);
CREATE TABLE y (col SET OF INT);
INSERT INTO x VALUES({0,1,2});
INSERT INTO x VALUES({3,4,5});
INSERT INTO x VALUES({6,7,8});
INSERT INTO x VALUES({9,10,11});

INSERT INTO y VALUES({0,1,2});
INSERT INTO y VALUES({3,4,5});
INSERT INTO y VALUES({6,7,8});

select col from x where col not in (select col from y) order by col;

select col from x where col in (select col from y) order by col;

DROP CLASS X,Y;

create class DML_0001 ( 
int_col integer,
var_col varchar(20),
set_col set (varchar(10), varchar(10)) );

insert into DML_0001 values (1,'test1', {'1','test1'});
insert into DML_0001 values (2,'test1', {'1','test1'});
insert into DML_0001 values (3,'test2', {'1','test2'});
insert into DML_0001 values (4,'test1', {'2','test1'});
insert into DML_0001 values (5,'test2', {'2','test2'});

select * from DML_0001 where int_col in (select int_col from DML_0001) order by 1,2,3;
select * from DML_0001 where {int_col} in (select {int_col} from DML_0001) order by 1,2,3;
select * from DML_0001 where set_col in (select set_col from DML_0001) order by 1,2,3;


select * from DML_0001 where int_col in (select int_col from DML_0001) order by 1,2,3;
select * from DML_0001 where set_col in (select set_col from DML_0001) order by 1,2,3;

drop class if exists t1;
create class t1 (c1 set int, c2 varchar(20));

insert into t1 values({101,102}, 'aaa');

insert into t1 values({102,103}, 'bbb');

insert into t1 values({103,104}, 'ddd');

insert into t1 values({104,105}, 'ccc');

insert into t1 values({105,106}, 'eee');

insert into t1 values({107,108}, 'eee');

select * from t1 where c1 < some(select c1 from t1 where c2='eee') order by 1,2;

select * from t1 where c1 = some(select c1 from t1 where c2='eee') order by 1,2;

select * from t1 where c1 > some(select c1 from t1 where c2='eee') order by 1,2;

select * from t1 where c1 <> some(select c1 from t1 where c2='eee') order by 1,2;

DROP CLASS DML_0001,t1;
