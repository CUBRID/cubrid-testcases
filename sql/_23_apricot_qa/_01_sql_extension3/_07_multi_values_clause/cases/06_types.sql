drop table if exists [test];
create table [test] (id int primary key, name string, age  date , dating    TIMESTAMP);
select * from [test];

values (1, '2009-10-31'   , '23:15:45 10/31/2009'),(2 , '2009-10-31'   , '23:15:45 10/31/2010'),(3 , '2009-10-31'   , '23:15:45 10/31/2011');
values (1, '2009-10-31'   , '23:15:45 10/31/2009'),(2 , '2009-10-31'   , '23:15:45 10/31/2010'),(3 , '2009-10-31'   , '23:80:45 10/31/2011');

values (1 as column1 , '2009-10-31' as column2   , '23:15:45 10/31/2009' as column3 ),(2 , '2009-10-31'   , '23:15:45 10/31/2010'),(3 , '2009-10-31'   , '23:15:45 10/31/2011');

values( timestamp  '23:15:45 10/31/2009' + 1, timestamp  '23:15:45 10/31/2009' + 2), (timestamp  '23:15:45 10/31/2009' + 60, timestamp  '23:15:45 10/31/2009' + 61);
values( timestamp  '25:15:45 10/31/2009' + 1, timestamp  '23:15:45 10/31/2009' + 2), (timestamp  '23:15:45 10/31/2009' + 60, timestamp  '23:15:45 10/31/2009' + 61);

values ( timestamp '23:15:45 10/31/2009' + '65535',  timestamp '23:15:45 10/31/2009' + '65535000' );
values ( timestamp '23:15:45 10/31/2009' + 65535,    timestamp '23:15:45 10/31/2009' + 65535000 ,  timestamp '23:15:45 10/31/2009' - 10000000 );

values ( timestamp '23:15:45 10/31/2009' + '65535',  timestamp '23:15:45 10/31/2009' + '655350000' );
values ( timestamp '23:15:45 10/31/2009' + 65535,    timestamp '23:15:45 10/31/2009' + 65535000 ,  timestamp '23:15:45 10/31/2009' - 1000000000 );

prepare s from 'values(timestamp ''23:15:45 10/31/2009''),(?)';
execute s using 123;
deallocate prepare s;

prepare s from 'select (timestamp ''23:15:45 10/31/2009'') union select (?)';
execute s using 123;
deallocate prepare s;

prepare s from 'values(1+  ? )';
execute s using  timestamp '23:15:45 10/31/2009';
deallocate prepare s;

prepare s from 'values(1+ ''10'' + ? )';
execute s using  timestamp '23:15:45 10/31/2009';
deallocate prepare s;

prepare s from 'values(timestamp ''23:15:45 10/31/2009'' + ? )';
execute s using  10;
deallocate prepare s;


values (date '1989-10-01'), (date '1990-02-21');
values (time '01:02:03'), (time '11:22:33');
values (datetime '13:15:45 10/31/2008' ), (datetime '13:15:45  10/31/2009' );
values (timestamp  TIMESTAMP '2008-10-31 13:15:45' ), (timestamp TIMESTAMP '2008-10-31 13:15:45' );
values (b'1', b'01', b'001', b'0001');
values (0xa,0x123);
values ({1,'2',34}) , ({100, '200', 3400});


values (b'1'=b'1');
select (b'1'=b'1');

select * from (values (b'1'=b'1'));
select * from (select (b'1'=b'1'));

values (date '1989-10-01'), (date '1990-01-01');
values (time '01:02:03'), (time '11:22:33');
values (datetime '13:15:45 10/31/2008' ), (datetime '13:15:45  10/31/2009' );
values (timestamp  TIMESTAMP '2008-10-31 13:15:45' ), (timestamp TIMESTAMP '2008-10-31 13:15:45' );
values (b'1', b'01', b'001', b'0001');
values (0xa,0x123);
values ({1,'2',34}) , ({100, '200', 3400});

values ( cast (1 as string));
values ( 1, cast (2 as string)),  (cast (100 as string), 200);
values ( 1, cast (2 as string)),  (cast (100 as string), 200) union values ( '100', 2000);
values ( 1, cast (2 as string)),  (cast (100 as string), 200) union select '100', 2000 ;
values ( cast (b'110' as bit (16) ) );
values ( cast (b'11' as bit varying) );

values ( cast (b'11' as bit varying) ) union values ( cast (b'11' as bit (16) ) ) ;
values ( cast (b'11' as bit varying) ) union select cast ( b'1111' as bit(16) );
values ( cast (b'11' as bit varying) ) union values ( cast (b'11' as bit (16) ) ) ;
values ( cast (b'11' as bit varying) ) union select cast ( b'1111' as bit(16) );

values ( cast ( datetime '13:15:45  10/31/2009' as time));
values ( cast (datetime '13:15:45  10/31/2009' as date));
values ( cast (datetime '13:15:45  10/31/2009' as timestamp));
values ( cast (datetime '13:15:45  10/31/2009'  as varchar));
values ( cast (datetime '13:15:45  10/31/2009' as nchar(26) ));
values ( cast (datetime '13:15:45  10/31/2009' as char(26) ));
values ( cast (datetime '13:15:45  10/31/2009' as nchar varying(26) ) );
values ( cast (date '10/31/2009' as timestamp));
values ( cast (date '10/31/2009' as varchar));
values ( cast (date '10/31/2009' as nchar(26)));
values ( cast (date '10/31/2009' as char(26)) );
values ( cast (date '10/31/2009' as nchar varying(26)));
values ( cast (timestamp '13:15:45  10/31/2009' as timedate));
values ( cast (timestamp '13:15:45  10/31/2009' as time));
values ( cast (timestamp '13:15:45  10/31/2009' as date));
values ( cast ( datetime '13:15:45  10/31/2009' +1  as time));
values ( cast (datetime '13:15:45  10/31/2009' + 1  as date));
values ( cast (datetime '13:15:45  10/31/2009'  + 1 as timestamp));
values ( cast (datetime '13:15:45  10/31/2009'  + 1 as varchar));
values ( cast (datetime '13:15:45  10/31/2009'  + 1 as nchar(26) ));
values ( cast (datetime '13:15:45  10/31/2009'  + 1 as char(26) ));
values ( cast (datetime '13:15:45  10/31/2009'  + 1 as nchar varying(26) ) );
values ( cast (date '10/31/2009'  +1 as timestamp));
values ( cast (date '10/31/2009'  +1 as varchar));
values ( cast (date '10/31/2009'  +1 as nchar(26)));
values ( cast (date '10/31/2009'  +1 as char(26)) );
values ( cast (date '10/31/2009'  +1 as nchar varying(26)));
values ( cast (timestamp '13:15:45  10/31/2009' as +1  timedate));
values ( cast (timestamp '13:15:45  10/31/2009' as  +1 time));
values ( cast (timestamp '13:15:45  10/31/2009' as +1 date));


values ( cast (datetime '13:15:45  10/31/2009'  + '31' as date));
values ( cast (datetime '13:15:45  10/31/2009'  + '31' as timestamp));
values ( cast (datetime '13:15:45  10/31/2009'  + '31' as varchar));
values ( cast (datetime '13:15:45  10/31/2009'  + '31' as nchar(26) ));
values ( cast (datetime '13:15:45  10/31/2009'  + '31' as char(26) ));
values ( cast (datetime '13:15:45  10/31/2009'  + '31' as nchar varying(26) ) );
values ( cast (date '10/31/2009'  +'31' as timestamp));
values ( cast (date '10/31/2009'  +'31' as varchar));
values ( cast (date '10/31/2009'  +'31' as nchar(26)));
values ( cast (date '10/31/2009'  +'31' as char(26)) );
values ( cast (date '10/31/2009'  +'31' as nchar varying(26)));
values ( cast (timestamp '13:15:45  10/31/2009' as  +'31' timedate));
values ( cast (timestamp '13:15:45  10/31/2009' as  +'31' time));
values ( cast (timestamp '13:15:45  10/31/2009' as  +'31' date));

values ( cast (date '10/31/2009' +1 as timestamp)) union values (  date '10/31/1009' );
values ( cast (date '10/31/2009' +1 as timestamp)) union values (  date '10/31/1009' +1);
values ( cast (date '10/31/2009' +1 as timestamp)) union values (  cast ( '10/31/1009'  as date ) +1);
values ( cast (date '10/31/2009' +1 as timestamp)) union select  date '10/31/1009' ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   '10/31/1009' ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp);
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) +1 ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) +'12';
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union select  timestamp '13:15:45  10/31/2009'  ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union select  timestamp '13:15:45  10/31/2009'  + 12 ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union select  timestamp '13:15:45  10/31/1009'  + '12' ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union select  timestamp '13:15:45  10/31/1009'  union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union select  timestamp '13:15:45  10/31/1009' + 12    union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union values  (timestamp '13:15:45  10/31/1009' + '12')  union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union values  (cast (date '10/31/1009' as timestamp) + '12')  union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as timestamp) union values  (cast (date '10/31/1009' + '12' as timestamp) )  union values ( date '10/11/1983') ;


select date '10/31/5009';
select date '10/31/9999';
select date '10/31/9';

values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date);
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) +1 ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) +'12';
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union select  timestamp '13:15:45  10/31/2009'  ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union select  timestamp '13:15:45  10/31/2009'  + 12 ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union select  timestamp '13:15:45  10/31/1009'  + '12' ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union select  timestamp '13:15:45  10/31/1009'  union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union select  timestamp '13:15:45  10/31/1009' + 12    union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union values  (timestamp '13:15:45  10/31/1009' + '12')  union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union values  (cast (date '10/31/1009' as date) + '12')  union values ( date '10/11/1983') ;
values ( cast (timestamp '13:15:45  10/31/2009' as date)) union  select   cast ('10/31/1009' as date) union values  (cast (date '10/31/1009' + '12' as date) )  union values ( date '10/11/1983') ;



drop table [test];