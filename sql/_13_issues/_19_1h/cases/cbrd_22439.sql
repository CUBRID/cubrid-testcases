drop if exists test_class;
create class test_class (bigint_col bigint, char_col char(10));

insert into test_class(bigint_col, char_col) values (-100, 'minus');

insert into test_class(bigint_col, char_col) values (0, 'zero');

insert into test_class(bigint_col, char_col) values (100, 'plus');

insert into test_class(bigint_col, char_col) values (109, 'plus');

insert into test_class(bigint_col, char_col) values (NULL, 'null');
select * from test_class where bigint_col is NULL WITH INCREMENT FOR bigint_col ;

drop table if exists t;
create table t(i int);
insert into t values(-1),(-2),(-3);
WITH cte AS
(
select * from test_class where bigint_col = 101 WITH INCREMENT FOR bigint_col
)
update t set i=(select count(*) from cte);
drop if exists t,test_class;
