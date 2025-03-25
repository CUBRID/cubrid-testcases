--+ server-message on
-- verified the CBRD-25040

-- timestampltz
create table t(i char(4), d timestampltz);
insert into t values ('pass', '2013-10-09');

create or replace procedure proc_timestampltz() as
    ii string;
begin
    select i into ii from t where d = timestampltz'2013-10-09';
    dbms_output.put_line(ii);
end;

create or replace function func_timestampltz() return string as
    ii string;
begin
    select i into ii from t where d = timestampltz'2013-10-09';
    return ii;
end;

call proc_timestampltz();
select func_timestampltz() from dual;

drop procedure proc_timestampltz;
drop function func_timestampltz;
drop table t;



-- timestamptz
create table t(i char(4), d timestamptz);
insert into t values ('pass', '2013-10-09');

create or replace procedure proc_timestamptz() as
    ii string;
begin
    select i into ii from t where d = timestamptz'2013-10-09';
    dbms_output.put_line(ii);
end;

create or replace function func_timestamptz() return string as
    ii string;
begin
    select i into ii from t where d = timestamptz'2013-10-09';
    return ii;
end;

call proc_timestamptz();
select func_timestamptz() from dual;

drop procedure proc_timestamptz;
drop function func_timestamptz;
drop table t;



-- datetimeltz
create table t(i char(4), d datetimeltz);
insert into t values ('pass', '2013-10-09');

create or replace procedure proc_datetimeltz() as
    ii string;
begin
    select i into ii from t where d = datetimeltz'2013-10-09';
    dbms_output.put_line(ii);
end;

create or replace function func_datetimeltz() return string as
    ii string;
begin
    select i into ii from t where d = datetimeltz'2013-10-09';
    return ii;
end;

call proc_datetimeltz();
select func_datetimeltz() from dual;

drop procedure proc_datetimeltz;
drop function func_datetimeltz;
drop table t;



-- datetimetz
create table t(i char(4), d datetimetz);
insert into t values ('pass', '2013-10-09');

create or replace procedure proc_datetimetz() as
    ii string;
begin
    select i into ii from t where d = datetimetz'2013-10-09';
    dbms_output.put_line(ii);
end;

create or replace function func_datetimetz() return string as
    ii string;
begin
    select i into ii from t where d = datetimetz'2013-10-09';
    return ii;
end;

call proc_datetimetz();
select func_datetimetz() from dual;

drop procedure proc_datetimetz;
drop function func_datetimetz;
drop table t;



-- bit
create table t(i char(4), d bit);
insert into t values ('pass', b'1');

create or replace procedure proc_bit() as
    ii string;
begin
    select i into ii from t where d = b'1';
    dbms_output.put_line(ii);
end;

create or replace function func_bit() return string as
    ii string;
begin
    select i into ii from t where d = b'1';
    return ii;
end;

call proc_bit();
select func_bit() from dual;

drop procedure proc_bit;
drop function func_bit;
drop table t;



-- bit varying
create table t(i char(4), d bit varying);
insert into t values ('pass', b'1');

create or replace procedure proc_bv() as
    ii string;
begin
    select i into ii from t where d = b'1';
    dbms_output.put_line(ii);
end;

create or replace function func_bv() return string as
    ii string;
begin
    select i into ii from t where d = b'1';
    return ii;
end;

call proc_bv();
select func_bv() from dual;

drop procedure proc_bv;
drop function func_bv;
drop table t;



-- enum
create table t(i char(4), d enum('val1'));
insert into t values ('pass', 1);

create or replace procedure proc_enum() as
    ii string;
begin
    select i into ii from t where d = 1;
    dbms_output.put_line(ii);
end;

create or replace function func_enum() return string as
    ii string;
begin
    select i into ii from t where d = 1;
    return ii;
end;

call proc_enum();
select func_enum() from dual;

drop procedure proc_enum;
drop function func_enum;
drop table t;



-- clob
create table t(i char(4), d clob);
insert into t values ('pass', '1');

create or replace procedure proc_clob() as
    ii string;
begin
    select i into ii from t where clob_to_char(d) = '1';
    dbms_output.put_line(ii);
end;

create or replace function func_clob() return string as
    ii string;
begin
    select i into ii from t where clob_to_char(d) = '1';
    return ii;
end;

call proc_clob();
select func_clob() from dual;

drop procedure proc_clob;
drop function func_clob;
drop table t;



-- blob
create table t(i char(4), d blob);
insert into t values ('pass', b'1');

create or replace procedure proc_blob() as
    ii string;
begin
    select i into ii from t where blob_to_bit(d) = b'1';
    dbms_output.put_line(ii);
end;

create or replace function func_blob() return string as
    ii string;
begin
    select i into ii from t where blob_to_bit(d) = b'1';
    return ii;
end;

call proc_blob();
select func_blob() from dual;

drop procedure proc_blob;
drop function func_blob;
drop table t;



-- json
-- but it occurs to error, will be fix in CBDR-25981
create table t(i char(4), d json);
insert into t values ('pass', '{"a":1}');

create or replace procedure proc_json() as
    ii string;
begin
    select i into ii from t where d = cast('{"a":1}' as json);
    dbms_output.put_line(ii);
end;

create or replace function func_json() return string as
    ii string;
begin
    select i into ii from t where d = cast('{"a":1}' as json);
    return ii;
end;

call proc_json();
select func_json() from dual;

drop procedure proc_json;
drop function func_json;
drop table t;

--+ server-message off
