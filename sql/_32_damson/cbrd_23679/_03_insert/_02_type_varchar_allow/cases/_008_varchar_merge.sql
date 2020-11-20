set system parameters 'allow_truncated_string=yes';

---------- MERGE INTO ... USING ... ON
---------- WHEN MATCHED THEN UPDATE SET ...
---------- WHEN NOT MATCHED THEN INSERT ...
drop table if exists t1;
create table t1 (col1 int, col2 varchar(5));
show columns in t1;
select * from t1 order by 1;

-- precision > value : OK
drop table if exists s1;
create table s1 (col1 int, col2 varchar(3));
insert into s1 values (1, 'abc');
merge into t1 using s1 on t1.col1 = s1.col1
when matched then update set t1.col2 = s1.col2
when not matched then insert values (s1.col1, s1.col2);
select * from t1 order by 1;

-- precision = value : OK
drop table if exists s1;
create table s1 (col1 int, col2 varchar(5));
insert into s1 values (2, 'abcde');
merge into t1 using s1 on t1.col1 = s1.col1
when matched then update set t1.col2 = s1.col2
when not matched then insert values (s1.col1, s1.col2);
select * from t1 order by 1;

-- precision < value : truncated string
drop table if exists s1;
create table s1 (col1 int, col2 varchar(7));
insert into s1 values (3, 'abcde12');
merge into t1 using s1 on t1.col1 = s1.col1
when matched then update set t1.col2 = s1.col2
when not matched then insert values (s1.col1, s1.col2);
select * from t1 order by 1;

drop table t1;
drop table s1;
set system parameters 'allow_truncated_string=no';
