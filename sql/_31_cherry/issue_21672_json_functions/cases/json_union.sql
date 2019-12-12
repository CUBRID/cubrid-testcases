--err
select cast (1 as int) union select cast('x' as varchar) order by 1;
--err
select cast ('x' as varchar) union select cast(1 as int) order by 1;

select 'a'  union select json_object('a', '1') order by 1;
--err
select 1  union select json_object('a', '1') order by 1;

select '"a"'  union select json_object('a', '1') order by 1;
select '1'  union select json_object('a', '1') order by 1;
select '"1"'  union select json_object('a', '1') order by 1;
select '1'  union select  '"a"'  order by 1;
select cast (1 as json) union select cast('"x"' as json) order by 1;  
select '1'  union select  '"a"' union select cast (1 as json) union select cast('"x"' as json) order by 1;  
select '{"a":"1"}' union all select json_object('a', '1') order by 1;
select '{"a":"1"}' union select json_object('a', '1') order by 1;
values (json_object('a',1)) union values (json_object('a',2)) order by 1;
values (json_object('a',1)) union values (json_array('a',2)) union values ('{"a":1, "b":2}') order by 1;
values (json_object('a',1)) union values (json_array('a',2)) union values ('{"a":1}') order by 1;
--err
values (json_object('a',1)) union values (json_array('a',2)) union values ({"a":1}) order by 1;

values (json_object('a',1)) union values (json_array('a',2)) union values ('["a",2]') order by 1;
values (json_object('a',1)) union values (json_array('a',2)) union values ('[" a  ",   2]   ') order by 1;

--err
select json_object('datetime','2012-05-10 15:30:59') union select json_array(datetime '2012-05-10 15:30:59', ) order by 1;
--err
select datetime '2012-05-10 15:30:59' union select json_array('2012-05-10 15:30:59') order by 1;

values('2012-10-10','def') union values(datetime '2012-05-10 15:30:59', '2012-05-10') order by 1;
select json_object('datetime','2012-05-10 15:30:59') union select  '"2012-05-10 15:30:59"'  order by 1;        
select json_array('2012-05-10 15:30:59') union select cast(json_array('2012-05-10 15:30:59') as string) order by 1;   

drop table if exists test_class;
create class test_class(colj json, 
			col1 char(5), col2 varchar(10), col3 nchar(5),
                        col4 bit(5),  col5 bit varying(5), col6 decimal,
                        col7 integer, col8 smallint, col9 monetary,
                        col10 float,  col11 double, col12 date,
                        col13 time,   col14 timestamp, col15 set integer,
                        col16 multiset integer , col17 list integer);
insert into test_class values('1','aaaa','xxxxxx',N'abc',B'00001',B'01',55555,10001,
                              32767,68888,-9999,1000001,DATE '09/05/2008',TIME'10:41 am',
                              TIMESTAMP'01/31/1998 8:15:00 pm',{1000,500,20},
                              {1000,1000,1000},{50,1000,1000,1000});
insert into test_class values('"a"','bca','xxadxx',N'abc',B'00111',B'11',57755,10601,
                              -32767,643288,-5999,1003241,DATE '09/05/2008',TIME'10:41 am',
                              TIMESTAMP'01/31/1998 8:15:00 pm',{1000,500,20},
                              {1000,1000,1000},{50,1000,1000,1000});
insert into test_class values(json_array('a',1,'','d'),'aaaa','xxxxxx',N'abc',B'00001',B'01',55555,10301,
                              32767,68888,-9999,1000001,DATE '09/05/2008',TIME'10:41 am',
                              TIMESTAMP'01/31/1998 8:15:00 pm',{1000,500,20},
                              {1000,1000,1000},{50,1000,1000,1000});
insert into test_class(colj) values(json_object('a','["abc",{"DD":2},3]'));
select * from test_class order by 1,2;
show columns from test_class;
select colj from test_class union select colj from test_class order by 1;
select colj from test_class union select json_object('a','abc');
select colj from test_class union select '{"a":3}';
select colj from test_class union select '"json"';
select colj from test_class union select 1;
select colj from test_class union select col1 from test_class order by 1;
select colj from test_class union select col2 from test_class order by 1;
select colj from test_class union select col3 from test_class order by 1;
select colj from test_class union select col4 from test_class order by 1;
select colj from test_class union select col5 from test_class order by 1;
select colj from test_class union select col6 from test_class order by 1;
select colj from test_class union select col7 from test_class order by 1;
select colj from test_class union select col8 from test_class order by 1;
select colj from test_class union select col9 from test_class order by 1;
select colj from test_class union select col10 from test_class order by 1;
select colj from test_class union select col11 from test_class order by 1;
select colj from test_class union select col12 from test_class order by 1;
select colj from test_class union select col13 from test_class order by 1;
select colj from test_class union select col14 from test_class order by 1;
select colj from test_class union select col15 from test_class order by 1;
select colj from test_class union select col16 from test_class order by 1;
select colj from test_class union select col17 from test_class order by 1;
select colj from test_class union select cast(col1  as json) from test_class order by 1;
select colj from test_class union select cast(col2  as json) from test_class order by 1;
select colj from test_class union select cast(col3  as json) from test_class order by 1;
select colj from test_class union select cast(col4  as json) from test_class order by 1;
select colj from test_class union select cast(col5  as json) from test_class order by 1;
select colj from test_class union select cast(col6  as json) from test_class order by 1;
select colj from test_class union select cast(col7  as json) from test_class order by 1;
select colj from test_class union select cast(col8  as json) from test_class order by 1;
select colj from test_class union select cast(col9  as json) from test_class order by 1;
select colj from test_class union select cast(col10 as json)  from test_class order by 1;
select colj from test_class union select cast(col11 as json)  from test_class order by 1;
select colj from test_class union select cast(col12 as json)  from test_class order by 1;
select colj from test_class union select cast(col13 as json)  from test_class order by 1;
select colj from test_class union select cast(col14 as json)  from test_class order by 1;
select colj from test_class union select cast(col15 as json)  from test_class order by 1;
select colj from test_class union select cast(col16 as json)  from test_class order by 1;
select colj from test_class union select cast(col17 as json)  from test_class order by 1;

insert into test_class(col1,col2,col3,col7) values ('"1"', '"1"', N'"1"', 100);
insert into test_class(col1,col2,col3,col7) values ('2', '2', N'2', 101);

select col7, colj from test_class union select col7, col1 from test_class where col7=100 order by 1,2;
select col7, colj from test_class union select col7, col2 from test_class where col7=100 order by 1,2;
select col7, colj from test_class union select col7, col3 from test_class where col7=100 order by 1,2;
select col7, colj from test_class union select col7, col1 from test_class where col7=101 order by 1,2;
select col7, colj from test_class union select col7, col2 from test_class where col7=101 order by 1,2;
select col7, colj from test_class union select col7, col3 from test_class where col7=101 order by 1,2;

alter table test_class change column col1 col1 char(50);   
alter table test_class change column col2 col2 varchar(100);
alter table test_class change column col3 col3 nchar(50);

select col7, colj from test_class union select col7, col1 from test_class where col7=100 order by 1,2;
select col7, colj from test_class union select col7, col2 from test_class where col7=100 order by 1,2;
select col7, colj from test_class union select col7, col3 from test_class where col7=100 order by 1,2;
select col7, colj from test_class union select col7, col1 from test_class where col7=101 order by 1,2;
select col7, colj from test_class union select col7, col2 from test_class where col7=101 order by 1,2;
select col7, colj from test_class union select col7, col3 from test_class where col7=101 order by 1,2;

drop table if exists test_class;

