drop table if exists t_par;
CREATE TABLE t_par (c_short smallint, c_bigint bigint,c_date DATE, 
c_timestamp TIMESTAMP,c_datetime DATETIME,  
c_timestampltz TIMESTAMPLTZ, c_timestamptz TIMESTAMPTZ, 
c_datetimeltz DATETIMELTZ, c_datetimetz DATETIMETZ);

insert into t_par values(1,1000,date'2020-12-12', timestamp'1999-04-23 14:35:56', datetime'1999-04-23 00:00:00',
        timestampltz'2013-10-01 12:13:14 -12:00', timestamptz'2012-10-01 12:13:14 Europe/Riga',
        datetimeltz'1983-12-31 23:59:59 +14:00', datetimetz'2009-11-23 12:00:00 AM Australia/Eucla');

insert into t_par values(2,1001,date'2010-11-12', timestamp'1986-04-23 14:35:56', datetime'1996-04-23 12:35:56.789',
        timestampltz'2015-10-01 12:13:14 -12:00', timestamptz'2002-10-01 12:13:14 Europe/Riga',
        datetimeltz'1989-12-31 23:59:59 +14:00', datetimetz'2014-11-23 12:00:00 AM Australia/Eucla');

insert into t_par values(3,1002,date'2000-02-12', timestamp'1972-04-23 14:35:56', datetime'2009-04-23 13:35:56.789',
        timestampltz'2013-11-01 12:13:14 -12:00', timestamptz'1999-10-01 12:13:14 Europe/Riga',
        datetimeltz'1996-12-31 23:59:59 +14:00', datetimetz'1999-11-23 12:00:00 AM Australia/Eucla');

insert into t_par values(4,1003,date'1960-12-12', timestamp'1997-04-23 14:35:56', datetime'2003-04-23 14:35:56.789',
        timestampltz'2013-10-11 12:13:14 -11:00', timestamptz'2022-10-01 12:13:14 Asia/Seoul',
        datetimeltz'2012-12-31 23:59:59 +14:00', datetimetz'2015-11-20 00:00:00 AM Australia/Eucla');

insert into t_par values(5,1004,date'1980-11-12', timestamp'2000-04-23 14:35:56', datetime'1996-04-23 15:35:56.789',
        timestampltz'2001-10-01 12:13:14 -12:00', timestamptz'2012-10-01 12:13:14 Asia/Seoul',
        datetimeltz'1911-12-31 23:59:59 +14:00', datetimetz'2017-11-23 12:00:00 AM Australia/Eucla');

--test case datetime
alter table t_par PARTITION BY RANGE (c_datetime)  (PARTITION before_2000 VALUES LESS THAN (datetime '12:00:00.001 AM 01/01/2000'), PARTITION last_one VALUES LESS THAN MAXVALUE);

create unique index inx on t_par(c_datetime);

select * from t_par where c_datetime > datetime '12:00:00.001 AM 01/01/2000' order by c_short;
select * from t_par where c_datetime > datetime '00:00:00 AM 01/01/2000' order by c_short;

--test case bigint
ALTER TABLE t_par REMOVE PARTITIONING;
drop unique index inx on t_par;
alter table t_par PARTITION BY RANGE (c_bigint)  (PARTITION before_2010 VALUES LESS THAN (1001), PARTITION last_one VALUES LESS THAN MAXVALUE);
create unique index inx on t_par(c_bigint,c_short);

select * from t_par where c_bigint > 1002 order by c_short;

--test case short
ALTER TABLE t_par REMOVE PARTITIONING;
drop unique index inx on t_par;
alter table t_par PARTITION BY RANGE (c_short)  (PARTITION before_10 VALUES LESS THAN (10), PARTITION last_one VALUES LESS THAN MAXVALUE);
create unique index inx on t_par(c_short,c_bigint);

select * from t_par where c_short > 2 order by c_short;

--test case timestamptz
ALTER TABLE t_par REMOVE PARTITIONING;
drop unique index inx on t_par;

alter table t_par PARTITION BY RANGE (c_timestamptz)  (PARTITION before_2010 VALUES LESS THAN (timestamptz'2010-01-01 12:13:14 Asia/Seoul'), PARTITION last_one VALUES LESS THAN MAXVALUE);
create unique index inx on t_par(c_timestamptz,c_timetz);

select * from t_par where c_timestamptz > timestamptz'2009-10-01 12:13:14 Asia/Seoul' order by c_short;

--test case datetimetz
ALTER TABLE t_par REMOVE PARTITIONING;
drop unique index inx on t_par;

alter table t_par PARTITION BY RANGE (c_datetimetz)  (PARTITION before_2010 VALUES LESS THAN (datetimetz'2010-01-01 12:00:00 AM Australia/Eucla'), PARTITION last_one VALUES LESS THAN MAXVALUE);
create unique index inx on t_par(c_datetimetz,c_date);

select * from t_par where c_datetimetz >  datetimetz'2010-11-23 12:00:00 AM Australia/Eucla' order by c_short;

--test case date
ALTER TABLE t_par REMOVE PARTITIONING;
drop unique index inx on t_par;

alter table t_par PARTITION BY RANGE (c_date)  (PARTITION before_2010 VALUES LESS THAN (date'2010-01-01'), PARTITION last_one VALUES LESS THAN MAXVALUE);
create unique index inx on t_par(c_date,c_datetimetz);

select * from t_par where c_date > date'2010-01-01' order by c_short;
select * from t_par where c_date > date'0000-00-00' order by c_short;

drop table t_par;
