--implicit conversion in update operation


create table iconv(id smallint primary key auto_increment, t enum('10:11:12', '10/12/2009', '10:10:10 1999-12-12', '10:10:10.999 1999-12-12', '8'));

insert into iconv(t) values(1), (2), (3), (4), (5);

--TEST: implicit type conversion in update
--TEST: update enum column with numeric values
update iconv set t=cast (1 as int);
select * from iconv order by 1;
update iconv set t=cast (2 as short);
select * from iconv order by 1;
update iconv set t=cast (3 as bigint);
select * from iconv order by 1;
update iconv set t=cast (4 as float);
select * from iconv order by 1;
update iconv set t=cast (5 as double);
select * from iconv order by 1;



--TEST: insert date/time value into enum column
update iconv set t=time'10:11:12';
select * from iconv order by 1;
update iconv set t=date'10/12/2009';
select * from iconv order by 1;
update iconv set t=timestamp'10:10:10 1999-12-12';
select * from iconv order by 1;
update iconv set t=datetime'10:10:10.999 1999-12-12';
select * from iconv order by 1;


--TEST: insert string value into enum column
update iconv set t=cast('10:11:12' as char(10));
select * from iconv order by 1;
update iconv set t=cast('10/12/2009' as varchar);
select * from iconv order by 1;
update iconv set t=cast('10:10:10 1999-12-12' as string);
select * from iconv order by 1;


--TEST: insert bit/varbit value into enum column
update iconv set t=cast (X'8' as bit(10));
select * from iconv order by 1;
update iconv set t=cast (X'8' as bit varying);
select * from iconv order by 1;



drop table iconv;
