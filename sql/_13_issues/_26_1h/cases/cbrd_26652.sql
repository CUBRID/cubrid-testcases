-- CBRD-26652
-- predicates and expressions that involve implicit coercion of string literals / non-integers into NUMERIC domains.


drop table if exists t_autocast_num;
create table t_autocast_num
(
  id   int,
  n10  numeric(10,0),
  n20  numeric(20,0),
  n38  numeric(38,9)
);

insert into t_autocast_num values (1, 1111111, 1111111, 1111111);
insert into t_autocast_num values (2, 9999999, 123456789012345, 123456789012345);
insert into t_autocast_num values (3, 1234567, 12345678901234567890, 12345678901234567890);

evaluate 'Query that previously caused error';
select id
  from t_autocast_num
 where n10 = '1111111'
 order by id;

select id
  from t_autocast_num
 where n20 = '12345678901234567890'
 order by id;

update t_autocast_num
   set id = id + 10
 where n10 = '9999999';

evaluate 'query with implicit conversion in IN / BETWEEN clause';
select id, n10
  from t_autocast_num
 where n10 in ('1111111', '9999999', '1234567')
 order by id;

select id
  from t_autocast_num
 where n10 between '1111111' and '9999999'
 order by id;

evaluate 'query with implicit conversion in INSERT ... SELECT statement';
insert into t_autocast_num (id, n10, n20, n38)
select id + 100, n10, n10, n10
  from t_autocast_num
 where n10 = '1234567';

select *
  from t_autocast_num
 order by 1;

evaluate 'query with implicit conversion in DELETE statement';
delete from t_autocast_num where n10 = '1111111';

select id, n10 from t_autocast_num order by id;

evaluate 'query with integer exceeding numeric(10,0) domain';
select *
  from t_autocast_num
 where n10 = '12345678901';

evaluate 'query with integer exceeding numeric(20,0) domain';
select *
  from t_autocast_num
 where n20 = '123456789012345678901';

evaluate 'query with ORDER BY expression';
select id, n10
  from t_autocast_num
 where n10 > '1000000'
 order by n10, id;

evaluate 'query with arithmetic with implicit coercion (string literal in expression)';
select id, n10 + '1'
  from t_autocast_num
 where id in (3, 12)
 order by id;

evaluate 'query with non-integers';
update t_autocast_num set n38 = '0.123456789' where id = 3;

select id, cast(n38 as numeric(38,9))
  from t_autocast_num
 where n38 = '0.123456789'
 order by id;

drop table if exists t_autocast_num;

drop table if exists t_autocast_l;
drop table if exists t_autocast_r;

create table t_autocast_l (id int, n10 numeric(10,0));
create table t_autocast_r (id int, n10 numeric(10,0));

insert into t_autocast_l values (1, 1111111);
insert into t_autocast_l values (2, 2222222);
insert into t_autocast_r values (10, 1111111);
insert into t_autocast_r values (20, 3333333);

evaluate 'query with join column = string literal';
select l.id, r.id
  from t_autocast_l l
  join t_autocast_r r
    on l.n10 = '1111111' and r.n10 = '1111111'
 order by l.id, r.id;

evaluate 'query with join using derived table with literal';
select l.id
  from t_autocast_l l
  join (select '2222222' as s) x
    on l.n10 = x.s
 order by l.id;

drop table if exists t_autocast_l;
drop table if exists t_autocast_r;

drop table if exists t_autocast_int;
create table t_autocast_int
(
  id int,
  s  smallint,
  i  int,
  b  bigint
);

insert into t_autocast_int values (1, 32767, 2147483647, 9223372036854775807);
insert into t_autocast_int values (2, -32768, -2147483648, -9223372036854775808);

evaluate 'query with SMALLINT comparisons with string literals';
select id
  from t_autocast_int
 where s = '32767'
 order by id;

select id
  from t_autocast_int
 where s = '-32768'
 order by id;

evaluate 'query with smallint overflow';
select id
  from t_autocast_int
 where s = '32768'
 order by id;

evaluate 'query with smallint underflow';
select id
  from t_autocast_int
 where s = '-32769'
 order by id;

evaluate 'query with INT comparisons with string literals';
select id
  from t_autocast_int
 where i = '2147483647'
 order by id;

select id
  from t_autocast_int
 where i = '-2147483648'
 order by id;

evaluate 'query with int overflow';
select id
  from t_autocast_int
 where i = '2147483648'
 order by id;

evaluate 'query with int underflow';
select id
  from t_autocast_int
 where i = '-2147483649'
 order by id;

evaluate 'query with BIGINT comparisons with string literals';
select id
  from t_autocast_int
 where b = '9223372036854775807'
 order by id;

select id
  from t_autocast_int
 where b = '-9223372036854775808'
 order by id;

evaluate 'query with bigint overflow';
select id
  from t_autocast_int
 where b = '9223372036854775808'
 order by id;

evaluate 'query with bigint underflow';
select id
  from t_autocast_int
 where b = '-9223372036854775809'
 order by id;

drop table if exists t_autocast_int;