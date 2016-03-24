--addition in late binding using enum type
--+ holdcas on;

drop table if exists t1;
create table t1(e1 enum('Yes', 'No', 'Cancel') collate utf8_en_cs);
show full columns from t1;

insert into t1 values (2), (1), (3);

prepare x from 'select e1 + ?, ? + e1 from t1 order by 1, 2';
execute x using 1, 1;
select e1 + 1, 1 + e1 from t1 order by 1, 2;
execute x using 1.1, 1.1;
select e1 + 1.1, 1.1 + e1 from t1 order by 1, 2;
execute x using 123456789012345, 123456789012345;
select e1 + 123456789012345, 123456789012345 + e1 from t1 order by 1, 2;
execute x using '-a', 'a-';
select e1 + '-a', 'a-' + e1 from t1 order by 1, 2;
execute x using '1', '2';
select e1 + '1', '2' + e1 from t1 order by 1, 2;
execute x using datetime'2012-01-01 12:00:00.000', datetime'2012-01-01 12:00:00.000';
select e1 + datetime'2012-01-01 12:00:00.000', datetime'2012-01-01 12:00:00.000' + e1 from t1 order by 1, 2;
execute x using date'2012-01-01', date'2012-01-01';
select e1 + date'2012-01-01', date'2012-01-01' + e1 from t1 order by 1, 2;
execute x using time'13:13:13', time'13:13:13';
select e1 + time'13:13:13', time'13:13:13' + e1 from t1 order by 1, 2;
execute x using timestamp'2012-12-21 13:13:13', timestamp'2012-12-21 13:13:13';
select e1 + timestamp'2012-12-21 13:13:13', timestamp'2012-12-21 13:13:13' + e1 from t1 order by 1, 2;
drop prepare x;

drop table t1;

commit;
--+ holdcas off;
