

select timestamp(date'2001-01-01', cast(1 as short));
select timestamp(date'2001-01-01', cast(1 as int));
select timestamp(date'2001-01-01', cast(1 as bigint));
select timestamp(date'2001-01-01', time'0:0:1');


select timestamp(date'2001-01-01', cast(-1 as short));
select timestamp(date'2001-01-01', cast(-1 as int));
select timestamp(date'2001-01-01', cast(-1 as bigint));


select timestamp(date'2001-01-01', cast(1.1 as numeric(10,5)));
select timestamp(date'2001-01-01', cast(1.1 as float));
select timestamp(date'2001-01-01', cast(1.1 as double));
select timestamp(date'2001-01-01', cast(1.1 as monetary));


select timestamp(date'2001-01-01', cast(1.999 as numeric(10,5)));
select timestamp(date'2001-01-01', cast(1.9999 as numeric(10,5)));


select timestamp(date'2001-01-01', cast(-1.1 as numeric(10,5)));


select timestamp(date'2001-01-01', cast(-1.999 as numeric(10,5)));
select timestamp(date'2001-01-01', cast(-1.9999 as numeric(10,5)));

select timestamp(date'2001-01-01', 130); 
select timestamp(date'2001-01-01', -130); 
select timestamp(date'2001-01-01', 10130); 
select timestamp(date'2001-01-01', -10130); 
select timestamp(date'2001-01-01', 1010130); 
select timestamp(date'2001-01-01', -1010130); 



select timestamp(timestamp'2001-01-01 00:00:00', cast(1 as short));
select timestamp(timestamp'2001-01-01 00:00:00', cast(1 as int));
select timestamp(timestamp'2001-01-01 00:00:00', cast(1 as bigint));
select timestamp(timestamp'2001-01-01 00:00:00', time'0:0:1');


select timestamp(timestamp'2001-01-01 00:00:00', cast(-1 as short));
select timestamp(timestamp'2001-01-01 00:00:00', cast(-1 as int));
select timestamp(timestamp'2001-01-01 00:00:00', cast(-1 as bigint));


select timestamp(timestamp'2001-01-01 00:00:00', cast(1.1 as numeric(10,5)));
select timestamp(timestamp'2001-01-01 00:00:00', cast(1.1 as float));
select timestamp(timestamp'2001-01-01 00:00:00', cast(1.1 as double));
select timestamp(timestamp'2001-01-01 00:00:00', cast(1.1 as monetary));


select timestamp(timestamp'2001-01-01 00:00:00', cast(1.999 as numeric(10,5)));
select timestamp(timestamp'2001-01-01 00:00:00', cast(1.9999 as numeric(10,5)));


select timestamp(timestamp'2001-01-01 00:00:00', cast(-1.1 as numeric(10,5)));


select timestamp(timestamp'2001-01-01 00:00:00', cast(-1.999 as numeric(10,5)));
select timestamp(timestamp'2001-01-01 00:00:00', cast(-1.9999 as numeric(10,5)));

select timestamp(timestamp'2001-01-01 00:00:00', 130); 
select timestamp(timestamp'2001-01-01 00:00:00', -130); 
select timestamp(timestamp'2001-01-01 00:00:00', 10130); 
select timestamp(timestamp'2001-01-01 00:00:00', -10130); 
select timestamp(timestamp'2001-01-01 00:00:00', 1010130); 
select timestamp(timestamp'2001-01-01 00:00:00', -1010130); 



select timestamp(datetime'2001-01-01 00:00:00.001', cast(1 as short));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(1 as int));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(1 as bigint));
select timestamp(datetime'2001-01-01 00:00:00.001', time'0:0:1');


select timestamp(datetime'2001-01-01 00:00:00.001', cast(-1 as short));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(-1 as int));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(-1 as bigint));


select timestamp(datetime'2001-01-01 00:00:00.001', cast(1.1 as numeric(10,5)));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(1.1 as float));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(1.1 as double));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(1.1 as monetary));

select timestamp(datetime'2001-01-01 00:00:00.001', cast(1.9988 as numeric(10,5)));


select timestamp(datetime'2001-01-01 00:00:00.001', cast(-1.1 as numeric(10,5)));


select timestamp(datetime'2001-01-01 00:00:00.001', cast(-1.999 as numeric(10,5)));
select timestamp(datetime'2001-01-01 00:00:00.001', cast(-1.9999 as numeric(10,5)));

select timestamp(datetime'2001-01-01 00:00:00.001', 130); 
select timestamp(datetime'2001-01-01 00:00:00.001', -130); 
select timestamp(datetime'2001-01-01 00:00:00.001', 10130); 
select timestamp(datetime'2001-01-01 00:00:00.001', -10130); 
select timestamp(datetime'2001-01-01 00:00:00.001', 1010130); 
select timestamp(datetime'2001-01-01 00:00:00.001', -1010130); 



select timestamp(date'2001-01-01', '15:30:30');

select timestamp(date'2001-01-01', '150:30:30');

select timestamp(date'2001-01-01', '-15:30:30');
select timestamp(date'2001-01-01', '-  15:30:30');

select timestamp(date'2001-01-01', '-150:30:30'); 

select timestamp(date'2001-01-01', '30:30');

select timestamp(date'2001-01-01', '-30:30');

select timestamp(date'2001-01-01', '15:30:30.1'); 
select timestamp(date'2001-01-01', ':30:30.1'); 
select timestamp(date'2001-01-01', ':30.1'); 
select timestamp(date'2001-01-01', '.1'); 
select timestamp(date'2001-01-01', ':30:30'); 
select timestamp(date'2001-01-01', ':30'); 

select timestamp(date'2001-01-01', '-15:30:30.1'); 
select timestamp(date'2001-01-01', '-:30:30.1'); 
select timestamp(date'2001-01-01', '-:30.1'); 
select timestamp(date'2001-01-01', '-.1'); 
select timestamp(date'2001-01-01', '-:30:30'); 
select timestamp(date'2001-01-01', '-:30'); 


select timestamp(date'2001-01-01', '15::30');
select timestamp(date'2001-01-01', '15::');

select timestamp(date'2001-01-01', '-15::30');
select timestamp(date'2001-01-01', '-15::');



select timestamp(timestamp'2001-01-01 00:00:00', '15:30:30');

select timestamp(timestamp'2001-01-01 00:00:00', '150:30:30');

select timestamp(timestamp'2001-01-01 00:00:00', '-15:30:30');
select timestamp(timestamp'2001-01-01 00:00:00', '-  15:30:30');

select timestamp(timestamp'2001-01-01 00:00:00', '-150:30:30'); 

select timestamp(timestamp'2001-01-01 00:00:00', '30:30');

select timestamp(timestamp'2001-01-01 00:00:00', '-30:30');


select timestamp(timestamp'2001-01-01 00:00:00', '15:30:30.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', ':30:30.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', ':30.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', '.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', ':30:30'); 

select timestamp(timestamp'2001-01-01 00:00:00', ':30'); 

select timestamp(timestamp'2001-01-01 00:00:00', '-15:30:30.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', '-:30:30.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', '-:30.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', '-.1'); 

select timestamp(timestamp'2001-01-01 00:00:00', '-:30:30'); 

select timestamp(timestamp'2001-01-01 00:00:00', '-:30'); 


select timestamp(timestamp'2001-01-01 00:00:00', '15::30');
select timestamp(timestamp'2001-01-01 00:00:00', '15::');

select timestamp(timestamp'2001-01-01 00:00:00', '-15::30');
select timestamp(timestamp'2001-01-01 00:00:00', '-15::');




select timestamp(datetime'2001-01-01 00:00:00.001', '15:30:30');

select timestamp(datetime'2001-01-01 00:00:00.001', '150:30:30');

select timestamp(datetime'2001-01-01 00:00:00.001', '-15:30:30');
select timestamp(datetime'2001-01-01 00:00:00.001', '-  15:30:30');

select timestamp(datetime'2001-01-01 00:00:00.001', '-150:30:30'); 

select timestamp(datetime'2001-01-01 00:00:00.001', '30:30');

select timestamp(datetime'2001-01-01 00:00:00.001', '-30:30');

select timestamp(datetime'2001-01-01 00:00:00.001', '15:30:30.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', ':30:30.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', ':30.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', '.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', ':30:30'); 
select timestamp(datetime'2001-01-01 00:00:00.001', ':30'); 
select timestamp(datetime'2001-01-01 00:00:00.001', '-15:30:30.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', '-:30:30.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', '-:30.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', '-.1'); 
select timestamp(datetime'2001-01-01 00:00:00.001', '-:30:30'); 
select timestamp(datetime'2001-01-01 00:00:00.001', '-:30'); 


select timestamp(datetime'2001-01-01 00:00:00.001', '15::30');
select timestamp(datetime'2001-01-01 00:00:00.001', '15::');

select timestamp(datetime'2001-01-01 00:00:00.001', '-15::30');
select timestamp(datetime'2001-01-01 00:00:00.001', '-15::');




select timestamp('2001-01-01', '15:30:30'); 

select timestamp('2001-01-01 00:00:00', '15:30:30'); 

select timestamp('2001-01-01 00:00:00.001', '15:30:30'); 

select timestamp('2001-01-01 01', '15:30:30'); 

select timestamp('2001-01-01 01:', '15:30:30'); 

select timestamp('2001-01-01 01:1', '15:30:30'); 

select timestamp('2001-01-01 01:1:1', '15:30:30'); 



select timestamp('2001-01-01 01::1', '15:30:30'); 

select timestamp('2001-01-01 01:1::1', '15:30:30'); 

select timestamp('2001-01-01 01:1::1.', '15:30:30'); 

select timestamp('2001-01-01 01:1::1.1', '15:30:30'); 


select timestamp('2001-01-01', '-15:30:30'); 

select timestamp('2001-01-01 00:00:00', '-15:30:30'); 

select timestamp('2001-01-01 00:00:00.001', '-15:30:30'); 

select timestamp('2001-01-01 01', '-15:30:30'); 

select timestamp('2001-01-01 01:', '-15:30:30'); 

select timestamp('2001-01-01 01:1', '-15:30:30'); 

select timestamp('2001-01-01 01:1:1', '-15:30:30'); 


select timestamp('2001-01-01 01::1', '-15:30:30'); 
select timestamp('2001-01-01 01:1::1', '-15:30:30'); 
select timestamp('2001-01-01 01:1::1.', '-15:30:30'); 
select timestamp('2001-01-01 01:1::1.1', '-15:30:30'); 


select timestamp('2001', 1);
select timestamp('2001-', 1);
select timestamp('2001-01', 1);
select timestamp('2001-01-', 1);
select timestamp('2001-01-0', 1); 
select timestamp('-2001-01-01', 1);



select timestamp(date'9999-12-31', cast(240001 as int));
select timestamp(date'9999-12-31', cast(240001 as bigint));
select timestamp(date'9999-12-31', cast(240000.1 as numeric(38,1)));
select timestamp(date'9999-12-31', '24:00:01');
select timestamp(date'9999-12-31', '240001');
select timestamp(date'9999-12-31', '240000.1');


select timestamp(datetime'9999-12-31 23:59:59.999', cast(1 as short));
select timestamp(datetime'9999-12-31 23:59:59.999', cast(1 as int));
select timestamp(datetime'9999-12-31 23:59:59.999', cast(1 as bigint));
select timestamp(datetime'9999-12-31 23:59:59.999', cast(1.1 as numeric(10,5)));
select timestamp(datetime'9999-12-31 23:59:59.999', '00:00:01');
select timestamp(datetime'9999-12-31 23:59:59.999', '1');
select timestamp(datetime'9999-12-31 23:59:59.999', '1.1');


select timestamp(timestamp'2038-1-1 0:0:0', 700800000000);
select timestamp(timestamp'2038-1-1 0:0:0', '70080000:00:00');


select timestamp('9999-12-31 23:59:59.999', cast(1 as short));
select timestamp('9999-12-31 23:59:59.999', cast(1 as int));
select timestamp('9999-12-31 23:59:59.999', cast(1 as bigint));
select timestamp('9999-12-31 23:59:59.999', cast(1.1 as numeric(10,5)));
select timestamp('9999-12-31 23:59:59.999', '00:00:01');
select timestamp('9999-12-31 23:59:59.999', '1');
select timestamp('9999-12-31 23:59:59.999', '1.1');




select timestamp(date'100-1-1', -8760000000);
select timestamp(datetime'100-1-1', '-876000:00:00');
select timestamp(timestamp'1970-1-1 9:0:0', -17257200000000);
select timestamp(timestamp'1970-1-1 9:0:0', '-1725720000:00:00');
select timestamp(datetime'100-1-1 0:0:0.0', -8760000000);
select timestamp(datetime'100-1-1 0:0:0.0', '-876000:00:00');
select timestamp('100-1-1 0:0:0.0', -8760000000);
select timestamp('100-1-1 0:0:0.0', '-876000:00:00');



select timestamp(date'2001-01-01'); 
select timestamp(date'01-01-01');
select timestamp('2001-01-01');
select timestamp('01-01-01');
select timestamp(timestamp'2001-01-01 00:00:00');
select timestamp(datetime'2001-01-01 00:00:00.000');
select timestamp(datetime'01-01-01 00:00:00.000');
select timestamp('2001-01-01 00:00:00');
select timestamp('01-01-01 00:00:00');


select timestamp(timestamp'01-01-01 00:00:00');


select timestamp('2001-01-01 00:00:00.001'); 
select timestamp(datetime'2001-01-01 00:00:00.001');


select timestamp('2001-01-01 01');
select timestamp(datetime'2001-01-01 01');
select timestamp(timestamp'2001-01-01 01');
select timestamp('2001-01-01 01:');
select timestamp(datetime'2001-01-01 01:');
select timestamp(timestamp'2001-01-01 01:');


select timestamp('2001-01-01 01:1');
select timestamp(datetime'2001-01-01 01:1');
select timestamp(timestamp'2001-01-01 01:1');



select timestamp('2001-01-01 01::1');
select timestamp(datetime'2001-01-01 01::1');
select timestamp(timestamp'2001-01-01 01::1');


select timestamp('2001-01-01 01:1:1');
select timestamp(datetime'2001-01-01 01:1:1');
select timestamp(timestamp'2001-01-01 01:1:1');



select timestamp('2001-01-01 01:1:.1');
select timestamp(datetime'2001-01-01 01:1:.1');


select timestamp(timestamp'2001-01-01 01:1:.1');



select timestamp('2001-01-01 01:1::1.');

select timestamp('2001-01-01 01:1::1.1');


create table x (d1 date,
d2 date,
dt1 datetime,
dt2 datetime,
ts timestamp,
s1 varchar(32),
s2 varchar(32),
add1 time, 
add2 varchar(32),
add3 bigint
);
insert into x values(date'2001-01-01', date'01-01-01',
datetime'2001-01-01 01:01:01.001', datetime'01-01-01 01:01:01.001', 
timestamp'2001-01-01 01:01:01',
'2001-01-01 01:01:01.001', '01-01-01 01:01:01.001',
time'01:01:01', '01:01:01.001', 10101
);


select timestamp(d1),timestamp(d2) from x;

select timestamp(dt1),timestamp(dt2) from x;
select timestamp(s1),timestamp(s2) from x;

select timestamp(ts) from x;


select timestamp(d1, add1),timestamp(d2, add1) from x;

select timestamp(dt1, add1),timestamp(dt2, add1) from x;
select timestamp(s1, add1),timestamp(s2, add1) from x;

select timestamp(ts, add1) from x;


select timestamp(d1, add2),timestamp(d2, add2) from x;

select timestamp(dt1, add2),timestamp(dt2, add2) from x;
select timestamp(s1, add2),timestamp(s2, add2) from x;

select timestamp(ts, add2) from x;


select timestamp(d1, add3),timestamp(d2, add3) from x;

select timestamp(dt1, add3),timestamp(dt2, add3) from x;
select timestamp(s1, add3),timestamp(s2, add3) from x;

select timestamp(ts, add3) from x;

drop table x;



select timestamp(date'2001-01-01', NULL);
select timestamp(timestamp'2001-01-01 00:00:00', NULL);
select timestamp(datetime'2001-01-01 00:00:00.001', NULL);


select timestamp(date'2001-01-01', 0);
select timestamp(timestamp'2001-01-01 00:00:00', 0);

select timestamp(datetime'2001-01-01 00:00:00.001', 0);






select timestamp('2001-01-01 9:0:0', '- 1'); 

select timestamp('2001-01-01 9:0:0', '- 9'); 

select timestamp('2001-01-01 9:0:0', '- 10'); 

select timestamp('2001-01-01 9:0:0', '-1'); 


select timestamp('2001-01-01 9:0:0', '0:60:0');
select timestamp('2001-01-01 9:0:0', '0:0:60');




