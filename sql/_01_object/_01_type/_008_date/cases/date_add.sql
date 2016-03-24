


-- date time types + integer

select datetime'01/01/2000' + 100;

select timestamp'01/01/2000' + 100;

select date'01/01/2000' + 100;

select time'00:00:00' + 100;

select '01/01/2000 00:00:00.000' + 100;

select '01/01/2000 00:00:00' + 100;

select '01/01/2000' + 100;

select '00:00:00' + 100;




-- integer + date time types

select 100 + datetime'01/01/2000';

select 100 + timestamp'01/01/2000';

select 100 + date'01/01/2000';

select 100 + time'00:00:00';

select 100 + '01/01/2000 00:00:00.000';

select 100 + '01/01/2000 00:00:00';

select 100 + '01/01/2000';

select 100 + '00:00:00';




