--explicit conversion to other types

create table conv(
	a int primary key,
	b enum('a', 'b', 'c', 'd'),
	c char(10) unique,
	d enum('100', '200', '300', '400'),
	e timestamp unique not null,
	f enum('12:12:12', '1999-12-12', '2000-10-01 10:10:10', '1998-05-06 13:20:21.123') not null
);

insert into conv values(1, 'a', 'aa', '100', '12:12:12', '12:12:12');
insert into conv values(2, 'b', 'b', '200', '1999-12-12', '1999-12-12');
insert into conv values(3, 'c', 'cc', 3, '2000-10-01 10:10:10', '2000-10-01 10:10:10');
insert into conv values(4, 4, 'd', 4, '1998-05-06 13:20:21.123', 4);

select * from conv order by 1;


--TEST: convert enum to numeric type
select cast(b as bit(10)) from conv order by 1;
select cast(b as bit varying) from conv order by 1;
select blob_to_bit(cast(b as blob)) from conv order by 1;
select clob_to_char(cast(b as clob)) from conv order by 1;

--TEST: convert enum to numeric type
select cast(d as bit(16)) from conv order by 1;
select cast(d as bit varying) from conv order by 1;
select blob_to_bit(cast(d as blob)) from conv order by 1;
select clob_to_char(cast(d as clob)) from conv order by 1;

--TEST: convert enum to numeric type
select cast(f as bit(10)) from conv order by 1;
select cast(f as bit varying) from conv order by 1;
select blob_to_bit(cast(f as blob)) from conv order by 1;
select clob_to_char(cast(f as clob)) from conv order by 1;


drop table conv;








