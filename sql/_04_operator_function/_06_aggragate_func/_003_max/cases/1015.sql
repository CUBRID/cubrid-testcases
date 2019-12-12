--[er]test max function with update statement
create class tb(
		col1 varchar,
		col2 char(10),
		col3 string,
		col4 int,
		col5 date,
		col6 time,
		col7 timestamp
);

insert into tb values('varchar01', 'char01', 'string01', 1, date'1/1/2001', time'1:1:1 am', timestamp'2/2/2002 2:2:2 am');
insert into tb values('varchar02', 'char02', 'string02', 2, date'1/2/2001', time'1:2:1 am', timestamp'2/3/2002 2:2:2 am');
insert into tb values('varchar03', 'char03', 'string03', 3, date'1/3/2001', time'1:3:1 am', timestamp'2/4/2002 2:2:2 am');

update tb set col4=9 where max(col4)=3;

drop class tb;
