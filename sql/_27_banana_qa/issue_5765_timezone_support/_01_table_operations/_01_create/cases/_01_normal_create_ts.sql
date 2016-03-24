--create table with TIMESTAMP(L)TZ columns without constraints


--test: table with timestamp column
drop table if exists ts;
create table ts(c_ts timestamp without time zone);
desc ts;
drop table ts;

--test: table with timestamptz column
drop table if exists tz;
create table tz(c_tstz timestamp with time zone);
desc tz;
drop table tz;

--test: table with timestampltz column
drop table if exists ltz;
create table ltz(c_tsltz timestamp with local time zone);
show full columns in ltz;
drop table ltz;

--test: table with multi-columns
drop table if exists tztest;
create table tztest(c_ts timestamp, c_tstz timestamp with time zone, c_tsltz timestamp with local time zone);
show full columns in tztest;
drop table tztest;
