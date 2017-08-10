--Test count function with where condition
create class test_class(col1 char(5), col2 varchar(10), col3 nchar(5),
                        col4 bit(5),  col5 bit varying(5), col6 decimal,
                        col7 integer, col8 smallint, col9 monetary,
                        col10 float,  col11 double, col12 date,
                        col13 time,   col14 timestamp, col15 set integer,
                        col16 multiset integer , col17 list integer);
insert into test_class values('aaaa','xxxxxx',N'abc',B'00001',B'01',55555,10001,
                              32767,68888,-9999,1000001,DATE '09/05/2008',TIME'10:41 am',
                              TIMESTAMP'01/31/1998 8:15:00 pm',{1000,500,20},
                              {1000,1000,1000},{50,1000,1000,1000});
insert into test_class values('bca','xxadxx',N'abc',B'00111',B'11',57755,10601,
                              -32767,643288,-5999,1003241,DATE '09/05/2008',TIME'10:41 am',
                              TIMESTAMP'01/31/1998 8:15:00 pm',{1000,500,20},
                              {1000,1000,1000},{50,1000,1000,1000});
insert into test_class values('aaaa','xxxxxx',N'abc',B'00001',B'01',55555,10001,
                              32767,68888,-9999,1000001,DATE '09/05/2008',TIME'10:41 am',
                              TIMESTAMP'01/31/1998 8:15:00 pm',{1000,500,20},
                              {1000,1000,1000},{50,1000,1000,1000});
select * from test_class order by 1,2;                             
select count(all col1) from test_class
where col1='aaaa';

drop class test_class;