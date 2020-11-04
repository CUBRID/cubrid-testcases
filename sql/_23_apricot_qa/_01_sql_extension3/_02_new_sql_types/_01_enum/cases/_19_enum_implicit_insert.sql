--implicit conversion in insert operation


create table iconv(id smallint primary key auto_increment, t enum('10:11:12', '10/12/2009', '10:10:10 1999-12-12', '10:10:10.999 1999-12-12', '8'));


--TEST: implicit type conversion in insert
--TEST: insert numeric value into enum column
insert into iconv(t) values(cast (1 as int));
insert into iconv(t) values(cast (2 as short));
insert into iconv(t) values(cast (3 as bigint));
insert into iconv(t) values(cast (4 as float));
insert into iconv(t) values(cast (5 as double));
insert into iconv(t) values(cast (2 as numeric(10, 3)));
insert into iconv(t) values(cast (3 as monetary));

select * from iconv order by 1;


--TEST: insert date/time value into enum column
insert into iconv(t) values(time'10:11:12');
insert into iconv(t) values(date'10/12/2009');
insert into iconv(t) values(timestamp'10:10:10 1999-12-12');
insert into iconv(t) values(datetime'10:10:10.999 1999-12-12');


--TEST: insert string value into enum column
insert into iconv(t) values(cast('10:11:12' as char(8)));
insert into iconv(t) values(cast('10/12/2009' as varchar));
insert into iconv(t) values(cast('10:10:10 1999-12-12' as string));


--TEST: insert bit/varbit value into enum column
insert into iconv(t) values(cast (X'8' as bit(10)));
insert into iconv(t) values(cast (X'8' as bit varying));

select * from iconv order by 1;


drop table iconv;
