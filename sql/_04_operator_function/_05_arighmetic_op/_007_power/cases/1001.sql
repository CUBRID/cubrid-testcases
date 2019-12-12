--[er]test the power() function with two numeric types and overflow result.
--it test the power() function with two numeric types and overflow result.it used 2 select queries and each has a power function.
create table dummy( id numeric(15,3));
insert into dummy values(1);
select to_char(power(22.34,29),'9.9999999EEEE') from dummy order by 1;
select to_char(power(22.34,28),'9.9999999EEEE') from dummy order by 1;

drop table dummy;
