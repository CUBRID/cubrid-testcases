--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- ERROR : %type basic return

-- create table & insert data
create table type_support (
   ID INT AUTO_INCREMENT,
   T_SHORT SHORT,
   T_SMALLINT SMALLINT,
   T_INTEGER INTEGER,
   T_INT INT,
   T_BIGINT BIGINT,
   T_NUMERIC NUMERIC(38,15),
   T_DECIMAL DECIMAL,
   T_FLOAT FLOAT,
   T_REAL REAL,
   T_DOUBLE DOUBLE,
   T_DATE DATE,
   T_TIME TIME,
   T_TIMESTAMP TIMESTAMP,
   T_DATETIME DATETIME,
   T_CHAR CHAR(32),
   T_VARCHAR VARCHAR(32)
);

insert into type_support
(T_SHORT,T_SMALLINT,T_INTEGER,T_INT,
T_BIGINT,T_NUMERIC,T_DECIMAL,T_FLOAT,T_REAL,T_DOUBLE,
T_DATE,T_TIME,T_TIMESTAMP,T_DATETIME,
T_CHAR,T_VARCHAR)
values
(-32768, -32768, -2147483648, -2147483648,
-9223372036854775808, 0.1, 0.1, -3.402823466E+38, -3.402823466E+38, -1.7976931348623157E+308,
'0001-01-01', TIME '00:00:00', '1970-01-01 09:00:01', '0001-01-01 00:00:00.000',
'1234567890abcdef','1234567890abcdef');

insert into type_support
(T_SHORT,T_SMALLINT,T_INTEGER,T_INT,
T_BIGINT,T_NUMERIC,T_DECIMAL,T_FLOAT,T_REAL,T_DOUBLE,
T_DATE,T_TIME,T_TIMESTAMP,T_DATETIME,
T_CHAR,T_VARCHAR)
values
(32767, 32767, 2147483647, 2147483647,
9223372036854775807, 9876543210987654321098.7654321098765432, 987654321054321, 3.402823466E+38, 3.402823466E+38, 3.402823466E+38,
'9999-12-31', TIME '23:59:59', '2038-01-19 03:14:07', '9999-12-31 23:59:59.999',
'1234567890abcdef','1234567890abcdef');


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

drop table  type_support ;

--+ server-message off

