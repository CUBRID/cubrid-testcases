--Test and operator


create class xoo ( a int, b char(10) );
insert into xoo values(1, '1');
insert into xoo values(null, '3');

select * from xoo where a = 1 and b = '1';
select * from xoo where a = 1 or b = '1';


drop table xoo;
