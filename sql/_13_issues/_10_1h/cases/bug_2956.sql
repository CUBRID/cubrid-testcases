create table testtb(id int, name varchar(50), bd date );

insert into testtb set id=default, name=default, bd=default;
select * from testtb order by 1,2,3;

insert into testtb set id=1, name='bill', bd='2010-01-31';
select * from testtb order by 1,2,3;

insert into testtb set id=mod(5,3),  name=to_char(333),  bd='2010-01-31';
select * from testtb order by 1,2,3;

insert testtb set id=3, name='bill', bd='2010-01-31';
select * from testtb order by 1,2,3;

insert testtb set id=mod(9,5),  name=to_char(333),  bd='2010-01-31';
select * from testtb order by 1,2,3;

insert testtb set id=default, name=default, bd=default;
select * from testtb order by 1,2,3;

drop table testtb;
