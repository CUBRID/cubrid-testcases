--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- ERROR : %type basic variable declarations

-- create view table
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




EVALUATE 'ERROR : not fit in a SHORT: -32769';
create or replace procedure type_support as
   v_SHORT       type_support.T_SHORT%type;
begin 
   v_SHORT      := -32769;

   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;
call type_support();

EVALUATE 'ERROR : not fit in a SHORT: 32768';
create or replace procedure type_support as
   v_SHORT       type_support.T_SHORT%type;
begin 
   v_SHORT      := 32768;

   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;
call type_support();


EVALUATE 'ERROR : not fit in an INTEGER: -2147483649';
create or replace procedure type_support as
   v_INTEGER     type_support.T_INTEGER%type;
begin 
   v_INTEGER      := -2147483649;

   dbms_output.put_line('v_INTEGER    ' || v_INTEGER    );
end;
call type_support();

EVALUATE 'ERROR : not fit in an INTEGER: 2147483648';
create or replace procedure type_support as
   v_INTEGER     type_support.T_INTEGER%type;
begin 
   v_INTEGER      := 2147483648;

   dbms_output.put_line('v_INTEGER    ' || v_INTEGER    );
end;
call type_support();

EVALUATE 'ERROR : not fit in an BIGINT: -9223372036854775809';
create or replace procedure type_support as
   v_BIGINT     type_support.T_BIGINT%type;
begin 
   v_BIGINT      := -9223372036854775809;

   dbms_output.put_line('v_BIGINT    ' || v_BIGINT    );
end;
call type_support();

EVALUATE 'ERROR : not fit in an BIGINT: 9223372036854775808';
create or replace procedure type_support as
   v_BIGINT     type_support.T_BIGINT%type;
begin 
   v_BIGINT      := 9223372036854775808;

   dbms_output.put_line('v_BIGINT    ' || v_BIGINT    );
end;
call type_support();

 
EVALUATE 'ERROR-NUMERIC(38,15) : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_NUMERIC     type_support.T_NUMERIC%type;
begin 
   v_NUMERIC      := 123456789012345678901234;

   dbms_output.put_line('v_NUMERIC    ' || v_NUMERIC    );
end;
call type_support();


EVALUATE 'ERROR-NUMERIC(38,15) : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_NUMERIC     type_support.T_NUMERIC%type;
begin 
   v_NUMERIC      := -123456789012345678901234;

   dbms_output.put_line('v_NUMERIC    ' || v_NUMERIC    );
end;
call type_support();


EVALUATE 'ERROR-DECIMAL : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_DECIMAL     type_support.T_DECIMAL%type;
begin 
   v_DECIMAL      := 1234567890123456;

   dbms_output.put_line('v_DECIMAL    ' || v_DECIMAL    );
end;
call type_support();


EVALUATE 'ERROR-DECIMAL : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_DECIMAL     type_support.T_DECIMAL%type;
begin 
   v_DECIMAL      := -1234567890123456;

   dbms_output.put_line('v_DECIMAL    ' || v_DECIMAL    );
end;
call type_support();


-- error
EVALUATE 'ERROR : Data overflow on data type "float".';
create or replace procedure type_support as
   v_FLOAT       type_support.T_FLOAT%type;
begin 
   v_FLOAT      := -3.402823466E+39;

   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;
call type_support();


-- error
EVALUATE 'ERROR : Data overflow on data type "float".';
create or replace procedure type_support as
   v_FLOAT       type_support.T_FLOAT%type;
begin 
   v_FLOAT      := 3.402823466E+39;

   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;
call type_support();


-- error
EVALUATE 'ERROR : 1.7976931348623157E+309 exceeds limit of double.';
create or replace procedure type_support as
   v_DOUBLE      type_support.T_DOUBLE%type;
begin 
   v_DOUBLE      := -1.7976931348623157E+309;

   dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE    );
end;
call type_support();


-- error
EVALUATE 'ERROR : 1.7976931348623157E+309 exceeds limit of double.';
create or replace procedure type_support as
   v_DOUBLE      type_support.T_DOUBLE%type;
begin 
   v_DOUBLE      := 1.7976931348623157E+309;

   dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE    );
end;
call type_support();


EVALUATE 'normal';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin
   v_DATE      := date'0000-00-00';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 1: not in a DATE format';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin
   v_DATE      := '0001-01-01 00:00:00';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 2: not in a DATE format';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin
   v_DATE      := '0000-03-01';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 3: not in a DATE format';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin
   v_DATE      := '0001-13-01';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 4: not in a DATE format';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin
   v_DATE      := '0001-01-32';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 5: not in a DATE format';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin
   v_DATE      := '202A-12-27';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 1: not in a TIME format';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin
   v_TIME      := '24:30:21';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR 2: not in a TIME format';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin
   v_TIME      := '24:30:21';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 3: not in a TIME format';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin
   v_TIME      := '23:60:21';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR 4: not in a TIME format';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin
   v_TIME      := '23:59:60';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'normal TIME 1';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin
   v_TIME      := TIME'11:59:59 PM';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();

EVALUATE 'normal TIME 2';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin
   v_TIME      := TIME'11:59:59 AM';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : not in a TIME format';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin
   v_TIME      := '11:59:59 CM';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : invalid TIMESTAMP string: 1970-01-01 08:00:01';
create or replace procedure type_support as
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
begin
   v_TIMESTAMP      := TIMESTAMP'1970-01-01 08:00:01';

   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;


EVALUATE 'ERROR : not in a TIMESTAMP format';
create or replace procedure type_support as
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
begin
   v_TIMESTAMP      := '1970-01-01 08:00:01';

   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : invalid TIMESTAMP string: 2038-01-20 03:14:07';
create or replace procedure type_support as
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
begin
   v_TIMESTAMP      := TIMESTAMP'2038-01-20 03:14:07';

   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;


EVALUATE 'ERROR : not in a TIMESTAMP format';
create or replace procedure type_support as
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
begin
   v_TIMESTAMP      := '2038-01-20 03:14:07';

   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR : Conversion error in timestamp format.';
create or replace procedure type_support as
   v_TIMESTAMP type_support.T_TIMESTAMP%type;
begin
   v_TIMESTAMP := TIMESTAMP('0000-01-01 08:00:01');

   dbms_output.put_line('v_TIMESTAMP ' || v_TIMESTAMP );
end;
call type_support();
drop procedure type_support;


EVALUATE 'nomal 1';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin
   v_DATETIME      := DATETIME'0000-00-00 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'nomal 2';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin
   v_DATETIME      := DATETIME'0000-00-00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'nomal 3';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin
   v_DATETIME      := DATETIME'00-00-00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : not in a DATETIME format';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin
   v_DATETIME      := '0000-03-01 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : not in a DATETIME format';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin
   v_DATETIME      := '0001-13-01 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : not in a DATETIME format';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin
   v_DATETIME      := '0001-03-32 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : string does not fit in the target types length';
create or replace procedure type_support as
   v_CHAR        type_support.T_CHAR%type;
begin 
   v_CHAR      := 'abcdefghijklmnopqrstuvwxyz1234567';

   dbms_output.put_line('v_CHAR    ' || v_CHAR    );
end;


EVALUATE 'ERROR : string does not fit in the target types length';
create or replace procedure type_support as
   v_VARCHAR     type_support.T_VARCHAR%type;
begin 
   v_VARCHAR      := 'abcdefghijklmnopqrstuvwxyz1234567';

   dbms_output.put_line('v_VARCHAR    ' || v_VARCHAR    );
end;

create or replace procedure type_support as
   v_TIMESTAMP type_support.T_TIMESTAMP%type;
begin
   v_TIMESTAMP := TIMESTAMP('0000-01-01 08:00:01');

   dbms_output.put_line('v_TIMESTAMP ' || v_TIMESTAMP );
end;
call type_support();



drop view type_support ;

--+ server-message off
