--test octet_length with to_char function and date, time, timestamp
create class tb(
		col1 date,
		col2 time,
		col3 timestamp
);

insert into tb values('5/5/2005', '3:3:3 am', '3/3/2003 5:5:5 am');

select octet_length(to_char(col1)), octet_length(to_char(col2)), octet_length(to_char(col3)) from tb;
 
drop class tb;