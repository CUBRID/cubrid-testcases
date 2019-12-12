drop table if exists t;

CREATE TABLE t (i int primary key auto_increment,string_col1 string default user(),string_col2 string default current_user, date_col date default sys_date, datetime_col datetime default sys_datetime, timestamp_col1 timestamp default sys_timestamp, timestamp_col2 timestamp default unix_timestamp()) partition by hash(i) partitions 2;

insert into t(i) values (null);

desc t;

--We expect to use the default value,not null
select i, if(length(string_col1) > length(string_col2), 'ok', 'nok') as ok_nok, string_col2 from t order by 1;

drop t;

CREATE TABLE t (i int primary key auto_increment,string_col1 string default user(),string_col2 string default current_user, date_col date default sys_date, datetime_col datetime default sys_datetime, timestamp_col1 timestamp default sys_timestamp, timestamp_col2 timestamp default unix_timestamp()) partition by hash(i) partitions 2;

insert into t(i) values (null);

insert into t(i) select null from db_class limit 43;

select i, if(length(string_col1) > length(string_col2), 'ok', 'nok') as ok_nok, string_col2 from t order by 1;

drop t;
