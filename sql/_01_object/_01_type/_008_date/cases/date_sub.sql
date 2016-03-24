



-- date time types + integer

select datetime'01/01/2000' - 100;

select timestamp'01/01/2000' - 100;

select date'01/01/2000' - 100;

select time'00:00:00' - 100;

select '01/01/2000 00:00:00.000' - 100;

select '01/01/2000 00:00:00' - 100;

select '01/01/2000' - 100;

select '00:00:00' - 100;



-- integer - date time types

select 100 - datetime'01/01/2000';

select 100 - timestamp'01/01/2000';

select 100 - date'01/01/2000';

select 100 - time'00:00:00';

select 100 - '01/01/2000 00:00:00.000';

select 100 - '01/01/2000 00:00:00';

select 100 - '01/01/2000';

select 100 - '00:00:00';



-- datetime - other

select datetime'01/01/2000' - datetime'01/02/2000';

select datetime'01/01/2000' - timestamp'01/02/2000';

select datetime'01/01/2000' - date'01/02/2000';

select datetime'01/01/2000' - time'00:00:00';

select datetime'01/01/2000' - '01/02/2000 00:00:00.000';

select datetime'01/01/2000' - '01/02/2000 00:00:00';

select datetime'01/01/2000' - '01/02/2000';

select datetime'01/01/2000' - '00:00:00';


-- date - other

select date'01/01/2000' - datetime'01/02/2000';

select date'01/01/2000' - timestamp'01/02/2000';

select date'01/01/2000' - date'01/02/2000';

select date'01/01/2000' - time'00:00:00';

select date'01/01/2000' - '01/02/2000 00:00:00.000';

select date'01/01/2000' - '01/02/2000 00:00:00';

select date'01/01/2000' - '01/02/2000';

select date'01/01/2000' - '00:00:00';


-- timestamp - other

select timestamp'01/01/2000' - datetime'01/02/2000';

select timestamp'01/01/2000' - timestamp'01/02/2000';

select timestamp'01/01/2000' - date'01/02/2000';

select timestamp'01/01/2000' - time'00:00:00';

select timestamp'01/01/2000' - '01/02/2000 00:00:00.000';

select timestamp'01/01/2000' - '01/02/2000 00:00:00';

select timestamp'01/01/2000' - '01/02/2000';

select timestamp'01/01/2000' - '00:00:00';


-- time - other

select time'00:00:00' - datetime'01/02/2000';

select time'00:00:00' - timestamp'01/02/2000';

select time'00:00:00' - date'01/02/2000';

select time'00:00:00' - time'00:00:00';

select time'00:00:00' - '01/02/2000 00:00:00.000';

select time'00:00:00' - '01/02/2000 00:00:00';

select time'00:00:00' - '01/02/2000';

select time'00:00:00' - '00:00:00';



-- datetime string - other

select '01/01/2000 00:00:00.000' - datetime'01/02/2000';

select '01/01/2000 00:00:00.000' - timestamp'01/02/2000';

select '01/01/2000 00:00:00.000' - date'01/02/2000';

select '01/01/2000 00:00:00.000' - time'00:00:00';

select '01/01/2000 00:00:00.000' - '01/02/2000 00:00:00.000';

select '01/01/2000 00:00:00.000' - '01/02/2000 00:00:00';

select '01/01/2000 00:00:00.000' - '01/02/2000';

select '01/01/2000 00:00:00.000' - '00:00:00';


-- date string - other

select '01/01/2000' - datetime'01/02/2000';

select '01/01/2000' - timestamp'01/02/2000';

select '01/01/2000' - date'01/02/2000';

select '01/01/2000' - time'00:00:00';

select '01/01/2000' - '01/02/2000 00:00:00.000';

select '01/01/2000' - '01/02/2000 00:00:00';

select '01/01/2000' - '01/02/2000';

select '01/01/2000' - '00:00:00';


-- timestamp string - other

select '01/01/2000 00:00:00' - datetime'01/02/2000';

select '01/01/2000 00:00:00' - timestamp'01/02/2000';

select '01/01/2000 00:00:00' - date'01/02/2000';

select '01/01/2000 00:00:00' - time'00:00:00';

select '01/01/2000 00:00:00' - '01/02/2000 00:00:00.000';

select '01/01/2000 00:00:00' - '01/02/2000 00:00:00';

select '01/01/2000 00:00:00' - '01/02/2000';

select '01/01/2000 00:00:00' - '00:00:00';


-- time string - other

select '00:00:00' - datetime'01/02/2000';

select '00:00:00' - timestamp'01/02/2000';

select '00:00:00' - date'01/02/2000';

select '00:00:00' - time'00:00:00';

select '00:00:00' - '01/02/2000 00:00:00.000';

select '00:00:00' - '01/02/2000 00:00:00';

select '00:00:00' - '01/02/2000';

select '00:00:00' - '00:00:00';

