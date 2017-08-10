--arithmetic operators with enum type column and other types


create table oper1(
	id bigint unique auto_increment, 
	col1 enum('100', '123.45678', '999999999.999999999', '2e+30', '2e+39', '2e+309') default 2,
	col2 enum('cubrid', 'mysql', 'oracle', 'sqlite', 'mssql') default left('cubrid', 6),
	col3 enum('12:12:12', '10:11:12', '15:16:17 PM', '22:22:22', '25:25:25') default '10:11:12',
	col4 enum('2000-10-10', '1554-09-08', '12/11/1786', '01/01/2001', '1983-15-12') default '12/11/1786',
	col5 enum('1998-10-10 12:12:12', '12:12:12 10/10/1998', '2010-08-20 07:20:34', '1654-12:12 12:12:12') default 4
);

insert into oper1 values(default, 1, 1, 1, 1, 1);
insert into oper1 values(default, 2, 2, 2, 2, 2);
insert into oper1 values(default, 3, 3, 3, 3, 3);
insert into oper1 values(default, 4, 4, 4, 4, 4);
insert into oper1 default;
insert into oper1(id, col1) values(default, 5);
insert into oper1(col1) values(6);


--TEST: arithmetic parameters with enum and numeric constant
select col1+100 from oper1 order by 1;
select col1-20.123 from oper1 order by 1;
select col1*2 from oper1 order by 1;
select col1/25 from oper1 order by 1;
select col1%13 from oper1 order by 1;

--TEST: arithmetic parameters with enum and string constant
select col2+'abcdefg' from oper1 order by 1;

create table oper2(
	id smallint primary key auto_increment,
	col1 float,
	col2 varchar(200),
	col3 time,
	col4 date,
	col5 timestamp
);

insert into oper2 values(default, 100, 'mysql', time'10:11:12', date'1554-09-08', timestamp'2010-08-20 07:20:34');
insert into oper2 values(default, 200, 'cubrid', time'11:12:13', date'2000-1-1', timestamp'1999-08-20 07:20:34');
insert into oper2 values(default, 2e+30, 'cubrid', time'22:22:22', date'2001-1-1', timestamp'2010-08-20 07:20:34');
insert into oper2 values(default, 100, 'oracle', time'10:11:12 PM', date'1786-12-11', '2010-08-20 07:20:34');
insert into oper2 values(default, 123.45678, 'mssql', time'23:59:59', date'10/10/2000', timestamp'12:12:12 10/10/1998');
insert into oper2 values(default, 800, 'oracle', time'15:16:17', date'2022-10-12', timestamp'1998-10-10 12:12:12');


create index i1 on oper1(col1, col2);
create index i2 on oper1(col3, col5);


--TEST: comparison operators with enum and numeric
select t1.id, t1.col1+t2.col1 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;
select t1.id, t1.col1-t2.col1 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;
select t1.id, t1.col1*t2.col1 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;
select t1.id, t1.col1/t2.col1 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;
select t1.id, t1.col1%t2.col1 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;


--TEST: comparison operators with enum and other types
select t1.id, t1.col2+t2.col2 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;
select t1.id, t1.col3+t2.col3 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;
select t1.id, t1.col4+t2.col4 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;
select t1.id, t1.col5+t2.col5 from oper1 t1, oper2 t2 where t1.id=t2.id order by 1;



drop table oper1, oper2;


