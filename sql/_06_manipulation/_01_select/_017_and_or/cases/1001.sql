--Test OR expression

create class xoo ( a int, b char(10) );
insert into xoo values(1, '1');
insert into xoo values(null, '3');
insert into xoo values(3, null);
select * from xoo where a in ( null, 1) order by 1;
select * from xoo where a in ( 1, null) order by 1;
select * from xoo where a in ( null, 1, null) order by 1;
select * from xoo where a in ( 1) order by 1;
select * from xoo where a = 1 order by 1;
select * from xoo where ( a = 1 or a is null ) order by 1;
select * from xoo where ( a = null or a= 1 ) order by 1;
select * from xoo where ( a = null or a= 1 ) order by 1;
select * from xoo where ( a = null and a= 1 ) order by 1;
select * from xoo where ( a = null and a= 1 ) order by 1;
select * from xoo where a = null order by 1;
select * from xoo where b in ( null, '1') order by 1;
select * from xoo where b in ( '1', null) order by 1;
select * from xoo where b in ( null, '1', null) order by 1;
select * from xoo where b in ( '1') order by 1;
select * from xoo where b = '1' order by 1;
select * from xoo where ( b = null or b= '1' ) order by 1;
select * from xoo where ( b = '1' or b =  null ) order by 1;
select * from xoo where ( b = null and b= '1' ) order by 1;
select * from xoo where ( b = '1' and b =  null ) order by 1;
select * from xoo where b = null order by 1;


drop table xoo;
