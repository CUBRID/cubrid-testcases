drop table if exists xoo,foo;
create class xoo (a int, b string);
insert into xoo values(1, '111');
insert into xoo values(2, '222');
prepare st from 'with cte as (select a from xoo where a = to_number(?) and a = ?) select *from cte' ;
execute st using '1', '1';
select * from xoo order by 1;

drop prepare st;
prepare st from 'with cte as (select a from xoo where a = to_number(?) and a = ?) select *from cte' ;
execute st using '1', 1 ;
select * from xoo order by 1;

prepare st from 'with cte as (select a from xoo where a = to_number(?) and a = ?) delete from xoo where a in (select a from cte)' ;
execute st using '1', 1 ;
select * from xoo order by 1;

prepare st from 'with cte as (select a from xoo where a = to_number(?) and a = ?) update xoo set a=3 where a in (select a from cte)' ;
execute st using '2', 2 ;
select * from xoo order by 1;

prepare st from 'insert into xoo with cte as (select a,-1 from xoo where a = to_number(?) and a = ?) select * from cte' ;
execute st using '3', 3 ;
select * from xoo order by 1;


prepare st from 'replace into xoo with cte as (select a,-1 from xoo where a = to_number(?) and a = ?) select * from cte' ;
execute st using '3', 3 ;
select * from xoo order by 1;

prepare st from 'create table foo as with cte as (select a from xoo where a = to_number(?) and a = ?) select * from cte' ;
execute st using '3', 3 ;
select * from foo order by 1;

drop table foo;
prepare st from 'create table foo as with cte as (select a from xoo where a = to_number(?) and a = ?) select * from cte' ;
execute st using 'aaa', 3 ;

drop prepare st;




select a from xoo where a = to_number('1') and a = 1;

drop table if exists xoo,foo;
