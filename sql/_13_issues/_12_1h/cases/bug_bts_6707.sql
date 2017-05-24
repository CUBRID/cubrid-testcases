--TEST: add column with CURRENT_TIMESTAMP default value using alter table ... add column statement


create table foo(a int);

insert into foo values(1), (2), (3);

--TEST: add column with CURRENT_TIMESTAMP default value
alter table foo add column b timestamp default CURRENT_TIMESTAMP;

--CURRENT_TIMESTAMP default value will not be evaluated at declaration time
select a, if ( b is not null , 'ok','nok') from foo order by 1;
show columns in foo;

--TEST: insert after add column
insert into foo(a) values(4), (5), (6);

select if((SYSTIMESTAMP-b) < 2, 'ok', 'nok') from foo where a > 3;


drop table foo;




