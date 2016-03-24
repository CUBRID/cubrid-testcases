--TEST:  [Multi-table Update] 'cannot coerce value' error occurs when executing multi-table update with right outer join.


create table t1(id1 numeric(10, 5));
insert into t1 values(44444.44444);

create table t2(id2 numeric(10, 5));
insert into t2 values(44444.44444), (90000);

select * from t1 right outer join t2 on t1.id1=t2.id2 order by 1, 2;
update t1 right outer join t2 on t1.id1=t2.id2 set t1.id1=t2.id2+10000;

select * from t1;

drop table t1, t2;


create table x (i int, s string);
insert into x values (1, '2012-01-01');
insert into x values (2, 'jjhsadghds');
insert into x values (3, '2013-01-01');

create table l1234 (i int, y int);
create table l123 (i int, y int);
create table l13 (i int, y int);
create table r1234 (i int, y int);
create table r123 (i int, y int);
create table r13 (i int, y int);

insert into l1234 (i) values (1), (2), (3), (4);
insert into l123 (i) values (1), (2), (3);
insert into l13 (i) values (1), (3);
insert into r1234 (i) values (1), (2), (3), (4);
insert into r123 (i) values (1), (2), (3);
insert into r13 (i) values (1), (3);




-- should already work
select 'should work';
update l13 left join x on l13.i = x.i set l13.y = year (x.s);
select if(count(*)=2, 'ok', 'nok') from l13 where y in (2012, 2013);
update x right join r13 on x.i = r13.i set r13.y = year (x.s);
select if(count(*)=2, 'ok', 'nok') from r13 where y in (2012, 2013);
update l13 inner join x on l13.i = x.i inner join r13 on x.i = r13.i set l13.y = year (x.s);
update l13 left join x on l13.i = x.i inner join r13 on x.i = r13.i set l13.y = year (x.s);
update l13 inner join x on l13.i = x.i right join r13 on x.i = r13.i set r13.y = year (x.s);
-- no rewrite, stopped by cross join
update l13 left join x on l13.i = x.i, r13 set r13.y = year (x.s);
update l13, x right join r123 on x.i = r123.i set l13.y = year (x.s);
select if(count(*)=2, 'ok', 'nok') from l13 where y in (2012, 2013);
select if(count(*)=2, 'ok', 'nok') from r13 where y in (2012, 2013);

-- should fail anyway, will not trigger rewrite
select 'should fail';
update l123 inner join x on l123.i = x.i left join r123 on x.i = r123.i set l123.y = year (x.s);
update l123 right join x on l123.i = x.i inner join r123 on x.i = r123.i set r123.y = year (x.s);
update l123 inner join x on l123.i = x.i inner join r123 on x.i = r123.i set l123.y = year (x.s);

-- should work, will trigger rewrite
select 'should work with rewrite';
update l13 right join x on l13.i = x.i set l13.y = year (x.s);
update x left join r13 on x.i = r13.i set r13.y = year (x.s);
update l13 left join x on l13.i = x.i right join r123 on x.i = r123.i set r123.y = year (x.s);
update l123 inner join x on l123.i = x.i left join r13 on x.i = r13.i set r13.y = year (x.s);
update l123 left join l13 on l123.i = l13.i inner join x on l123.i = x.i inner join r123 on x.i = r123.i inner join r13 on r123.i = r13.i set r13.y = year(x.s);

-- should fail, even with query rewrite
select 'should fail with rewrite';
update l123 inner join x on l123.i = x.i left join r123 on x.i = r123.i set r123.y = year (x.s);
update l123 right join x on l123.i = x.i set l123.y = year (x.s);

-- should work, rewrite with more classes updated
select 'should work with rewrite, multiple classes updated';
update l1234 left join x on l1234.i = x.i left join r123 on x.i = r123.i left join r13 on r123.i = r13.i set r13.y = year (x.s), l1234.y = r123.y, r123.y = r13.y;
update l13 right join l123 on l13.i = l123.i right join x on l123.i = x.i right join r1234 on x.i = r1234.i set l13.y = year (x.s), l123.y = l13.y, r1234.y = l123.y;



-- force broker execution and rerun all tests
create table decoy(a int);
create trigger trg after update on x execute insert into decoy values (null);




-- should already work
select 'should work';
update l13 left join x on l13.i = x.i set l13.y = year (x.s);
update x right join r13 on x.i = r13.i set r13.y = year (x.s);
update l13 inner join x on l13.i = x.i inner join r13 on x.i = r13.i set l13.y = year (x.s);
update l13 left join x on l13.i = x.i inner join r13 on x.i = r13.i set l13.y = year (x.s);
update l13 inner join x on l13.i = x.i right join r13 on x.i = r13.i set r13.y = year (x.s);
-- no rewrite, stopped by cross join
update l13 left join x on l13.i = x.i, r13 set r13.y = year (x.s);
update l13, x right join r123 on x.i = r123.i set l13.y = year (x.s);

-- should fail anyway, will not trigger rewrite
select 'should fail';
update l123 inner join x on l123.i = x.i left join r123 on x.i = r123.i set l123.y = year (x.s);
update l123 right join x on l123.i = x.i inner join r123 on x.i = r123.i set r123.y = year (x.s);
update l123 inner join x on l123.i = x.i inner join r123 on x.i = r123.i set l123.y = year (x.s);

-- should work, will trigger rewrite
select 'should work with rewrite';
update l13 right join x on l13.i = x.i set l13.y = year (x.s);
update x left join r13 on x.i = r13.i set r13.y = year (x.s);
update l13 left join x on l13.i = x.i right join r123 on x.i = r123.i set r123.y = year (x.s);
update l123 inner join x on l123.i = x.i left join r13 on x.i = r13.i set r13.y = year (x.s);
update l123 left join l13 on l123.i = l13.i inner join x on l123.i = x.i inner join r123 on x.i = r123.i inner join r13 on r123.i = r13.i set r13.y = year(x.s);

-- should fail, even with query rewrite
select 'should fail with rewrite';
update l123 inner join x on l123.i = x.i left join r123 on x.i = r123.i set r123.y = year (x.s);
update l123 right join x on l123.i = x.i set l123.y = year (x.s);

-- should work, rewrite with more classes updated
select 'should work with rewrite, multiple classes updated';
update l1234 left join x on l1234.i = x.i left join r123 on x.i = r123.i left join r13 on r123.i = r13.i set r13.y = year (x.s), l1234.y = r123.y, r123.y = r13.y;
update l13 right join l123 on l13.i = l123.i right join x on l123.i = x.i right join r1234 on x.i = r1234.i set l13.y = year (x.s), l123.y = l13.y, r1234.y = l123.y;




-- cleanup
drop trigger trg;
drop table decoy, x, l1234, l123, l13, r1234, r123, r13;



