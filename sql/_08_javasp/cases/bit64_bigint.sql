-- sp for bigint

--+ holdcas on;
CREATE FUNCTION parseInt(i in string) return INT as language java name 'SpTest4bit64.parseBigint(java.lang.String) return long';
CREATE FUNCTION parseBigint(i in string) return BIGINT as language java name 'SpTest4bit64.parseBigint(java.lang.String) return long';
call parseBigint('10000');


CREATE FUNCTION addBigint(v1 BIGINT, v2 BIGINT) return BIGINT as language java name 'SpTest4bit64.addBigint(long, long) return long';
create table test_class (a bigint);
insert into test_class values (1000);
insert into test_class values (2000);
select a into v1 from test_class where a = 1000;
select a into v2 from test_class where a = 2000;
call addBigint(v1, v2);
drop table test_class;


CREATE PROCEDURE incrementBigint(a in out BIGINT) as language java name 'SpTest4bit64.incrementBigint(long[])';
call incrementBigint(1000);
create table test_class (a bigint);
insert into test_class values (1000);
select a into v1 from test_class where a = 1000;
call incrementBigint(v1);
evaluate v1;
drop table test_class;


drop FUNCTION  parseInt;
drop FUNCTION  parseBigint;
drop FUNCTION  addBigint;
drop PROCEDURE  incrementBigint;

commit;
--+ holdcas off;
