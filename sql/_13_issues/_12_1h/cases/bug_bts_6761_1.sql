create table foo(col int default 9999999999999999999999999999);
create table foo(col short default 9999999999999999999999999999);
create table foo(col smallint default 9999999999999999999999999999);
create table foo(col bigint default 9999999999999999999999999999);
create table foo(col numeric default 1.7976931348623157E+309);
create table foo(col decimal default 1.7976931348623157E+309);
create table foo(col float default 1.7976931348623157E+309);
create table foo(col real default 1.7976931348623157E+309);
create table foo(col double default 1.8976931348623157E+309);
desc foo;
drop table foo;
create table foo(col double precision default 1.7976931348623157E+309);
desc foo;
drop table foo;
create table foo(col monetary default 9999999999999999999999999999);
desc foo;
drop table foo;

create table foo(col date default '0001-00-00');
create table foo(col date default '10000-01-01');
create table foo(col date default '2038-01-10 03:14:07 (GMT)');
desc foo;
drop table foo;

--create table foo(col time default '10000-01-01');
create table foo(col time default '24:00:00');
create table foo(col time default '2038-01-10 03:14:07 (GMT)');
desc foo;
drop table foo;

create table foo(col datetime default '0000-01-11 03:14:07.0001 (GMT)');
create table foo(col timestamp default '2039-01-10 03:14:07.0001 (GMT)');

create table foo(col bit(10) default 6);
create table foo(col bit(1) default X'6');
desc foo;
drop table foo;
create table foo(col  BIT VARYING(2) default b'0101');

create table foo(col char(1) default 1);
create table foo(col varchar(1) default 1);
create table foo(col string(1) default 1);
create table foo(col nchar(1) default 1);
create table foo(col nchar varying(1) default 1);

CREATE TABLE foo(col set(int, CHAR(1)) default 1);
CREATE TABLE foo(col multiset(int, CHAR(1)) default 1);
CREATE TABLE foo(col list(int, CHAR(1)) default 1);
drop table foo;
