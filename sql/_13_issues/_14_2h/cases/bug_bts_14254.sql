drop table if exists t;
create table t(i double);
insert into t values('123e2');
select * from t;
insert into t values('-1.7976931348623157E+308');
insert into t values('-1.7976931348623157E+309');
insert into t values('+1.7976931348623157E+308');
insert into t values('+1.7976931348623157E+309   ');
insert into t values('+1.7976931348623157E+309');
select * from t order by 1;

drop table if exists t;
create table t(i float);
insert into t values('123e2');
select * from t;
insert into t values('-3.402823466E+38');
select * from t order by 1;
insert into t values('-3.402823466E+39');
insert into t values('+3.402823466E+38');
select * from t order by 1;
insert into t values('+3.402823466E+39');
select * from t order by 1;

drop table if exists t;
create table t(i real);
insert into t values('123e2');
select * from t;
insert into t values('-3.402823466E+38');
select * from t order by 1;
insert into t values('-3.402823466E+39');
insert into t values('+3.402823466E+38');
select * from t order by 1;
insert into t values('+3.402823466E+39');
select * from t order by 1;

drop table if exists t;
create table t(i int);
insert into t values('123e2');
select * from t;
insert into t values('-2.14e9');
insert into t values('-2.147483648e9');
insert into t values('2.147483647e9');
insert into t values('2.14e9');
insert into t values('2.14e10');
insert into t values('-2.14e10');
select *  from t order by 1;

drop table if exists t;
create table t(i short);
insert into t values('123e2');
select * from t;
insert into t values('-2.14e2');
insert into t values('-3.2768e4');
insert into t values('3.2767e4');
insert into t values('3.2e5');
insert into t values('-3.2e5');
insert into t values('-3.2e10');
select *  from t order by 1;

drop table if exists t;
create table t(i smallint);
insert into t values('123e2');
select * from t;
insert into t values('-2.14e2');
insert into t values('-3.2768e4');
insert into t values('3.2767e4');
insert into t values('3.2e5');
insert into t values('-3.2e5');
insert into t values('-3.2e10');
select *  from t order by 1;

drop table if exists t;
create table t(i bigint);
insert into t values('123e2');
insert into t values('.5e1');
insert into t values('123e-2');
insert into t values('153e-2');
select * from t order by 1;
insert into t values('-9.2e18');
insert into t values('9.2e18');
insert into t values('-9.2e20');
insert into t values('9.2e20');
insert into t values('-9.223372036854775808e18');
insert into t values('+9.223372036854775807e18');
insert into t values('9.223372036854775807e18');
select * from t order by 1;
insert into t values(9.22337203685e18);

select ascii('1.2e2');
select bin('1.2e2');
select bin('-9.2e18');
select bin('9.2e18');
select bin('-9.2e20');
select bin('9.2e20');
select bin('-9.223372036854775808e18');
select bin('+9.223372036854775807e18');
select bin(9.223372036854775e18);

select bit_length('1.23e3');
select length('123e3');

select elt(1,'123e1',123e1);
select elt(2,'123e1',123e1);

select cast('9223372036854775807e0' as bigint);
select cast('9.223372036854775807e18' as bigint);

select cast('9223372036854775908e0' as bigint);
select cast('9.223372036854775908e18' as bigint);

select cast('-9223372036854775808e0' as bigint);
select cast('-9223372036854775809e0' as bigint);
select cast('-9.223372036854775808e18' as bigint);
select cast('-9.223372036854775809e18' as bigint);
select cast('9223372036854775807.4e0' as bigint);
select cast('9223372036854775907.5e0' as bigint);
select cast('-9223372036854775808.4e0' as bigint);
select cast('-9223372036854775808.5e0' as bigint);

select cast('1e308' as bigint);
select cast('1e-308' as bigint);
select cast('1e309' as bigint);
select cast('1e-309' as bigint);
select cast('123' as bigint);
select cast('123.123' as bigint);
select cast('123.5' as bigint);
select cast('-123' as bigint);
select cast('-123.123' as bigint);
select cast('-123.5' as bigint);
select cast('.4' as bigint);
select cast('-.4' as bigint);
select cast('.5' as bigint);
select cast('-.5' as bigint);

select cast('  123   ' as bigint);
select cast('123.' as bigint);
select cast('     123.5   ' as bigint);
select cast('123 .5' as bigint);
select cast('123. 5' as bigint);
select cast('9223372036854775807' as bigint);
select cast('9223372036854775808' as bigint);
select cast('-9223372036854775808' as bigint);
select cast('-9223372036854775809' as bigint);

select cast('0x1ff' as bigint);
select cast('0x1ff.1ff' as bigint);
select cast('0x1ff.8' as bigint);
select cast('-0x1ff' as bigint);
select cast('-0x1ff.1ff' as bigint);
select cast('-0x1ff.5' as bigint);
select cast('0x.7' as bigint);
select cast('-0x.7' as bigint);
select cast('0x.8' as bigint);
select cast('-0x.8' as bigint);

select cast('  0x1ff   ' as bigint);
select cast('0x1ff.' as bigint);
select cast('     0x1ff.8   ' as bigint);
select cast('     0x1ff.8   a ' as bigint);
select cast('0x1ff .8' as bigint);
select cast('0x1ff. 8' as bigint);
select cast('0xabcdef' as bigint);
select cast('0xABCDEF' as bigint);
select cast('0xabcdefg' as bigint);
select cast('0x7fffffffffffffff' as bigint);
select cast('0x8000000000000000' as bigint);
select cast('-0x7fffffffffffffff' as bigint);
select cast('-0x8000000000000000' as bigint);
select cast('-0x8000000000000001' as bigint);
select cast('0x7fffffffffffffff.7' as bigint);
select cast('0x7fffffffffffffff.8' as bigint);
select cast('-0x8000000000000000.7' as bigint);
select cast('-0x8000000000000000.8' as bigint);


select cast('123e10' as bigint);
select cast('123.123e10' as bigint);
select cast('123.5e0' as bigint);
select cast('-123e10' as bigint);
select cast('-123.123e10' as bigint);
select cast('-123.5e0' as bigint);
select cast('.4e0' as bigint);
select cast('-.4e0' as bigint);
select cast('.5e0' as bigint);
select cast('-.5e0' as bigint);

select cast('  123e10   ' as bigint);
select cast('123.e10' as bigint);
select cast('     123.5e0   ' as bigint);
select cast('123 .5e0' as bigint);
select cast('123. 5e0' as bigint);
select cast('.e' as bigint);
select cast('e' as bigint);
select cast('e10' as bigint);
select cast('1e100' as bigint);
select cast('55.55e+1' as bigint);
select cast('55.54e+1' as bigint);
select cast('55.55e+2' as bigint);
select cast('55.55e+3' as bigint);
select cast('55.55e-1' as bigint);
select cast('54.55e-1' as bigint);
select cast('55.55e-2' as bigint);
select cast('55.55e-3' as bigint);

select cast('.5e1' as bigint);
select cast('.5e0' as bigint);
select cast('.5e-1' as bigint);
select cast('5e1' as bigint);
select cast('5e0' as bigint);
select cast('5e-1' as bigint);


drop table t;
create table t(i bigint);
insert into t values('123e6');
select i, conv(i,10,16) from t;

drop table t;
create table t(i int);
insert into t values('123e6');
select i, conv(i,10,16) from t;
drop t;








