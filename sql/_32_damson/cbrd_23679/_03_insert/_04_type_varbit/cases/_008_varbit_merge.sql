set system parameters 'allow_truncated_string=no';
---------- MERGE INTO ... USING ... ON
---------- WHEN MATCHED THEN UPDATE SET ...
---------- WHEN NOT MATCHED THEN INSERT ...

drop table if exists t1;
create table t1 (col1 int, col2 bit varying(10));
show columns in t1;
select * from t1 order by 1;

-- precision > value : OK
drop table if exists s1;
create table s1 (col1 int, col2 bit varying(4));
insert into s1 values (1, b'1010');
merge into t1 using s1 on t1.col1 = s1.col1
when matched then update set t1.col2 = s1.col2
when not matched then insert values (s1.col1, s1.col2);
select * from t1 order by 1;

-- precision = value : OK
drop table if exists s1;
create table s1 (col1 int, col2 bit varying(10));
insert into s1 values (2, b'1010111110');
merge into t1 using s1 on t1.col1 = s1.col1
when matched then update set t1.col2 = s1.col2
when not matched then insert values (s1.col1, s1.col2);
select * from t1 order by 1;

-- precision < value :data overflow
drop table if exists s1;
create table s1 (col1 int, col2 bit varying(12));
insert into s1 values (3, b'101011111010');
merge into t1 using s1 on t1.col1 = s1.col1
when matched then update set t1.col2 = s1.col2
when not matched then insert values (s1.col1, s1.col2);
select * from t1 order by 1;

drop table t1;
drop table s1;
set system parameters 'allow_truncated_string=no';
