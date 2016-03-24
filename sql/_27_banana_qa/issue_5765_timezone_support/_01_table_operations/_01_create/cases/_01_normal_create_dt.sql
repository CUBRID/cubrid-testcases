--create table with DATETIME(L)TZ columns without constraints


--test: table with datetime column
drop table if exists dt;
create table dt(c_dt datetime without time zone);
desc dt;
drop table dt;

--test: table with datetimetz column
drop table if exists tz;
create table tz(c_dttz datetime with time zone);
desc tz;
drop table tz;

--test: table with datetimeltz column
drop table if exists ltz;
create table ltz(c_dtltz datetime with local time zone);
show full columns in ltz;
drop table ltz;

--test: table with multi-columns
drop table if exists tztest;
create table tztest(c_dt datetime, c_dttz datetime with time zone, c_dtltz datetime with local time zone);
show full columns in tztest;
drop table tztest;
