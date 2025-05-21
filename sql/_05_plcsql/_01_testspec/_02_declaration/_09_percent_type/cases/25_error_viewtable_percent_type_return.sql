--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- ERROR : %type basic return

-- create view
create or replace view type_support AS 
   SELECT 
      1 as ID,
      cast( -32768                    as short          ) t_short,
      cast( -32768                    as smallint       ) t_smallint,
      cast( -2147483648               as integer        ) t_integer,
      cast( -2147483648               as int            ) t_int,
      cast( -9223372036854775808      as bigint         ) t_bigint,
      cast( 0.1                       as numeric(38,15) ) t_numeric,
      cast( 0.1                       as DECIMAL        ) t_decimal,
      cast( -3.402823466E+38          as float          ) t_float,
      cast( -3.402823466E+38          as real           ) t_real,
      cast( -1.7976931348623157E+308  as double         ) t_double,
      cast( '0001-01-01'              as date           ) t_date,
      cast( '00:00:00'                as time           ) t_time,
      cast( '1970-01-01 09:00:01'     as timestamp      ) t_timestamp,
      cast( '0001-01-01 00:00:00.000' as datetime       ) t_datetime,
      cast('c'                        as char(32)       ) t_char, 
      cast('v'                        as varchar(32)    ) t_varchar
    FROM dual  union all 
   SELECT 
      2 as ID,
      cast( 32768                                   as short          ) t_short,
      cast( 32768                                   as smallint       ) t_smallint,
      cast( 2147483647                              as integer        ) t_integer,
      cast( 2147483647                              as int            ) t_int,
      cast( 9223372036854775807                     as bigint         ) t_bigint,
      cast( 9876543210987654321098.7654321098765432 as numeric(38,15) ) t_numeric,
      cast( 987654321054321                         as DECIMAL        ) t_decimal,
      cast( 3.402823466E+38                         as float          ) t_float,
      cast( 3.402823466E+38                         as real           ) t_real,
      cast( 1.7976931348623157E+308                 as double         ) t_double,
      cast( '9999-12-31'                            as date           ) t_date,
      cast( '23:59:59'                              as time           ) t_time,
      cast( '2038-01-19 03:14:07'                   as timestamp      ) t_timestamp,
      cast( '9999-12-31 23:59:59.999'               as datetime       ) t_datetime,
      cast('cahr_cubrid'                            as char(32)       ) t_char, 
      cast('varchar_cubrid'                         as varchar(32)    ) t_varchar
   FROM dual;



EVALUATE '1 T_SHORT';
create or replace function type_support_return() return  type_support.T_SHORT%type          as Begin   return -32769    ;   end;    
select type_support_return();
create or replace function type_support_return() return  type_support.T_SHORT%type          as Begin   return 32768    ;   end;    
select type_support_return();

EVALUATE '2 T_SMALLINT';
create or replace function type_support_return() return  type_support.T_SMALLINT%type       as Begin   return -32769  ;   end;
select type_support_return();
create or replace function type_support_return() return  type_support.T_SMALLINT%type       as Begin   return  32768  ;   end;
select type_support_return();

EVALUATE '3 T_INTEGER';
create or replace function type_support_return() return  type_support.T_INTEGER%type        as Begin   return -2147483649  ;   end;
select type_support_return();
create or replace function type_support_return() return  type_support.T_INTEGER%type        as Begin   return  2147483648  ;   end;
select type_support_return();

EVALUATE '4 T_INT';
create or replace function type_support_return() return  type_support.T_INT%type            as Begin   return  -2147483649      ;   end;    
select type_support_return();
create or replace function type_support_return() return  type_support.T_INT%type            as Begin   return   2147483648      ;   end;    
select type_support_return();

EVALUATE '5 T_BIGINT';
create or replace function type_support_return() return  type_support.T_BIGINT%type         as Begin   return -9223372036854775809    ;   end;    
select type_support_return();       
create or replace function type_support_return() return  type_support.T_BIGINT%type         as Begin   return  9223372036854775808   ;   end;    
select type_support_return();

EVALUATE '6 T_NUMERIC';
create or replace function type_support_return() return  type_support.T_NUMERIC%type        as Begin   return -123456789012345678901234  ;   end;    
select type_support_return();       
create or replace function type_support_return() return  type_support.T_NUMERIC%type        as Begin   return 123456789012345678901234  ;   end;    
select type_support_return();

EVALUATE '7 T_DECIMAL';
create or replace function type_support_return() return  type_support.T_DECIMAL%type        as Begin   return -1234567890123456  ;   end;    
select type_support_return();       
create or replace function type_support_return() return  type_support.T_DECIMAL%type        as Begin   return 1234567890123456  ;   end;    
select type_support_return( );

EVALUATE '8 T_FLOAT';
create or replace function type_support_return() return  type_support.T_FLOAT%type          as Begin   return -3.402823466E+39    ;   end;    
-- error
select type_support_return();       
create or replace function type_support_return() return  type_support.T_FLOAT%type          as Begin   return  3.402823466E+39    ;   end;    
-- error
select type_support_return();

EVALUATE '9 T_REAL';
create or replace function type_support_return() return  type_support.T_REAL%type           as Begin   return -3.402823466E+39     ;   end;    
-- error
select type_support_return();       
create or replace function type_support_return() return  type_support.T_REAL%type           as Begin   return  3.402823466E+39     ;   end;    
-- error
select type_support_return();

EVALUATE '10 T_DOUBLE';
create or replace function type_support_return() return  dba.type_support.T_DOUBLE%type     as Begin   return -1.7976931348623157E+309   ;   end;    
-- error
select type_support_return();       
create or replace function type_support_return() return  dba.type_support.T_DOUBLE%type     as Begin   return  1.7976931348623157E+309   ;   end;    
-- error
select type_support_return();


EVALUATE '11 T_DATE';
create or replace function type_support_return() return  dba.type_support.T_DATE%type       as Begin   return date'0000-00-00'     ;   end;
-- error
select type_support_return();
drop function type_support_return;

EVALUATE '12 T_DATE';
create or replace function type_support_return() return  dba.type_support.T_DATE%type       as Begin   return '0001-01-01 00:00:00'     ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_DATE%type       as Begin   return '0000-13-00'     ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_DATE%type       as Begin   return '0001-01-32'     ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_DATE%type       as Begin   return '202A-12-27'     ;   end;
select type_support_return();
drop function type_support_return;


EVALUATE '13 T_TIME';
create or replace function type_support_return() return  dba.type_support.T_TIME%type       as Begin   return '24:30:21'        ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_TIME%type       as Begin   return '23:60:21'        ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_TIME%type       as Begin   return '23:59:60'        ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_TIME%type       as Begin   return '11:59:59 CM'     ;   end;
select type_support_return();
drop function type_support_return;




EVALUATE '14 T_TIMESTAMP';
create or replace function type_support_return() return  dba.type_support.T_TIMESTAMP%type  as Begin   return '1970-01-01 08:00:01';   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_TIMESTAMP%type  as Begin   return '2038-01-20 03:14:07';   end;
select type_support_return();
drop function type_support_return;




EVALUATE '15 T_DATETIME';
create or replace function type_support_return() return  dba.type_support.T_DATETIME%type   as Begin   return DATETIME'0000-00-00 00:00:00' ;   end;
-- error
select type_support_return();
drop function type_support_return;


create or replace function type_support_return() return  dba.type_support.T_DATETIME%type   as Begin   return DATETIME'0000-00-00' ;   end;
-- error
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_DATETIME%type   as Begin   return DATETIME'00-00-00' ;   end;
-- error
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_DATETIME%type   as Begin   return '0000-03-01 00:00:00' ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_DATETIME%type   as Begin   return '0001-13-01 00:00:00' ;   end;
select type_support_return();
drop function type_support_return;

create or replace function type_support_return() return  dba.type_support.T_DATETIME%type   as Begin   return '0001-03-32 00:00:00' ;   end;
select type_support_return();
drop function type_support_return;


EVALUATE '16 T_CHAR';
create or replace function type_support_return() return  dba.type_support.T_CHAR%type       as Begin   return 'abcdefghijklmnopqrstuvwxyz1234567'     ;   end;    

select type_support_return();

EVALUATE '17 T_VARCHAR';
create or replace function type_support_return() return  dba.type_support.T_VARCHAR%type    as Begin   return 'abcdefghijklmnopqrstuvwxyz1234567'  ;   end;    

select type_support_return();       


drop function type_support_return;

drop view  type_support ;

--+ server-message off

