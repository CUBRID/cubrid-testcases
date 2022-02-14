autocommit off;
create table tb (
	dummy varchar(1)
);
insert into tb values ('X');
create table test_months_between (
	type_numeric numeric(10,5)
);
insert into test_months_between (type_numeric) values (months_between(date '12/1/1999', date '11/1/1999'));
select type_numeric ,months_between(date '12/1/1999', date '11/1/1999') from test_months_between;
select months_between(date '1/1/1', date '12/1/9999') from tb;
select months_between(date '1/1/1', date '1/1/1') from tb;
select months_between(date '2/1/1', date '1/1/1') from tb;
select months_between(date '3/1/1', date '1/1/1') from tb;
select months_between(date '4/1/1', date '1/1/1') from tb;
select months_between(date '5/1/1', date '1/1/1') from tb;
select months_between(date '6/1/1', date '1/1/1') from tb;
select months_between(date '7/1/1', date '1/1/1') from tb;
select months_between(date '8/1/1', date '1/1/1') from tb;
select months_between(date '9/1/1', date '1/1/1') from tb;
select months_between(date '10/1/1', date '1/1/1') from tb;
select months_between(date '11/1/1', date '1/1/1') from tb;
select months_between(date '12/1/1', date '1/1/1') from tb;
select cast (months_between(date '12/1/1', date '1/1/1') as integer )from tb;
select months_between(date '1/31/1', date '1/31/1') from tb;
select months_between(date '2/28/1', date '1/31/1') from tb;
select months_between(date '3/31/1', date '1/31/1') from tb;
select months_between(date '4/30/1', date '1/31/1') from tb;
select months_between(date '5/31/1', date '1/31/1') from tb;
select months_between(date '6/30/1', date '1/31/1') from tb;
select months_between(date '7/31/1', date '1/31/1') from tb;
select months_between(date '8/31/1', date '1/31/1') from tb;
select months_between(date '9/30/1', date '1/31/1') from tb;
select months_between(date '10/31/1', date '1/31/1') from tb;
select months_between(date '11/30/1', date '1/31/1') from tb;
select cast(months_between(date '12/1/1', date '1/31/1') as int) from tb;
drop table tb;
drop table test_months_between;
rollback;
