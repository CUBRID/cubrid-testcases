--CONV function is not correct when argument is fixed CHAR column

--scenario in the issue
drop table if exists t1;
CREATE TABLE t1 (hex CHAR(1), pad CHAR(4));
insert into t1 (hex) values ('0');
update t1 set pad='FFFF';

select conv (hex, 16, 10) from t1;

drop table t1;

--additional scenarios
drop table if exists t;
create table t (a CHAR(1), b CHAR(4), c varchar(4), d string);

insert into t values('0', 'AB', '13B', '1234567');
insert into t values('1', '10', 'ABC', '1010110');
insert into t values('9', 'FFFF', '1011', '19E7F32');

select a, conv(a, 16, 10) from t order by 1;
select a, conv(a, 16, -10) from t order by 1;
select a, conv(a, 10, 16) from t order by 1;
select a, conv(a, 8, 16) from t order by 1;
select a, conv(a, 2, 10) from t order by 1;
select a, conv(a, 10, 20) from t order by 1;

select b, conv(b, 16, 10) from t order by 1;
select b, conv(b, 10, 16) from t order by 1;
select b, conv(b, 10, -16) from t order by 1;
select b, conv(b, 8, 16) from t order by 1;
select b, conv(b, 2, 10) from t order by 1;
select b, conv(b, 10, 20) from t order by 1;

select c, conv(c, 16, 10) from t order by 1;
select c, conv(c, 10, 16) from t order by 1;
select c, conv(c, 8, 16) from t order by 1;
select c, conv(c, 8, -16) from t order by 1;
select c, conv(c, 2, 10) from t order by 1;
select c, conv(c, 10, 20) from t order by 1;

select d, conv(d, 16, 10) from t order by 1;
select d, conv(d, 10, 16) from t order by 1;
select d, conv(d, 8, 16) from t order by 1;
select d, conv(d, 2, 10) from t order by 1;
select d, conv(d, 10, 20) from t order by 1;
select d, conv(d, 10, -20) from t order by 1;


drop table t;
