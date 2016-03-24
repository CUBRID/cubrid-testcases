--substraction in late binding using enum type.
create table t1(e1 enum('Yes', 'No', 'Cancel'));
insert into t1 values (2), (1), (3);

prepare x from 'select e1 - ? from t1 order by 1';
execute x using 1;
select e1 - 1 from t1 order by 1;
execute x using 1.1;
select e1 - 1.1 from t1 order by 1;
execute x using 123456789012345;
select e1 - 123456789012345 from t1 order by 1;
execute x using '-a';
select e1 - '-a' from t1 order by 1;
execute x using '1';
select e1 - '1' from t1 order by 1;
execute x using datetime'2012-01-01 12:00:00.000';
select e1 - datetime'2012-01-01 12:00:00.000' from t1 order by 1;
execute x using date'2012-01-01';
select e1 - date'2012-01-01' from t1 order by 1;
execute x using time'13:13:13';
select e1 - time'13:13:13' from t1 order by 1;
execute x using timestamp'2012-12-21 13:13:13';
select e1 - timestamp'2012-12-21 13:13:13' from t1 order by 1;
drop prepare x;

prepare x from 'select ? - e1 from t1 order by 1';
execute x using 1;
select 1 - e1 from t1 order by 1;
execute x using 1.1;
select  1.1 - e1 from t1 order by 1;
execute x using 123456789012345;
select 123456789012345 - e1 from t1 order by 1;
execute x using 'a-';
select 'a-' - e1 from t1 order by 1;
execute x using '2';
select '2' - e1 from t1 order by 1;
execute x using datetime'2012-01-01 12:00:00.000';
select datetime'2012-01-01 12:00:00.000' - e1 from t1 order by 1;
execute x using date'2012-01-01';
select date'2012-01-01' - e1 from t1 order by 1;
execute x using time'13:13:13';
select time'13:13:13' - e1 from t1 order by 1;
execute x using timestamp'2012-12-21 13:13:13';
select timestamp'2012-12-21 13:13:13' - e1 from t1 order by 1;
drop prepare x;

drop table t1;