--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- ERROR : %type basic prameter

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




EVALUATE '%type, parameter';
create or replace procedure type_support(
   v_SHORT       type_support.T_SHORT%type,
   v_SMALLINT    type_support.T_SMALLINT%type,
   v_INTEGER     type_support.T_INTEGER%type,
   v_INT         type_support.T_INT%type,
   v_BIGINT      type_support.T_BIGINT%type,
   v_NUMERIC     type_support.T_NUMERIC%type,
   v_DECIMAL     type_support.T_DECIMAL%type,
   v_FLOAT       type_support.T_FLOAT%type,
   v_REAL        dba.type_support.T_REAL%type,
   v_DOUBLE      dba.type_support.T_DOUBLE%type,
   v_DATE        dba.type_support.T_DATE%type,
   v_TIME        dba.type_support.T_TIME%type,
   v_TIMESTAMP   dba.type_support.T_TIMESTAMP%type,
   v_DATETIME    dba.type_support.T_DATETIME%type,
   v_CHAR        dba.type_support.T_CHAR%type,
   v_VARCHAR     dba.type_support.T_VARCHAR%type
  ) as
begin 
    dbms_output.put_line('v_SHORT     ' || v_SHORT    );
    dbms_output.put_line('v_SMALLINT  ' || v_SMALLINT );
    dbms_output.put_line('v_INTEGER   ' || v_INTEGER  );
    dbms_output.put_line('v_INT       ' || v_INT      );
    dbms_output.put_line('v_BIGINT    ' || v_BIGINT   );
    dbms_output.put_line('v_NUMERIC   ' || v_NUMERIC  );
    dbms_output.put_line('v_DECIMAL   ' || v_DECIMAL  );
    dbms_output.put_line('v_FLOAT     ' || v_FLOAT    );
    dbms_output.put_line('v_REAL      ' || v_REAL     );
    dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE   );
    dbms_output.put_line('v_DATE      ' || v_DATE     );
    dbms_output.put_line('v_TIME      ' || v_TIME     );
    dbms_output.put_line('v_TIMESTAMP ' || v_TIMESTAMP);
    dbms_output.put_line('v_DATETIME  ' || v_DATETIME );
    dbms_output.put_line('v_CHAR      ' || v_CHAR     );
    dbms_output.put_line('v_VARCHAR   ' || v_VARCHAR  );
    dbms_output.put_line('===========================');
end;

-- The precision and scale of the NUMERIC (DECIMAL) type specified in the argument or return type are ignored.
-- So the result is normal.
call type_support(-32768, -32768, -2147483648, -2147483648,
-9223372036854775808, 0.1, 0.1, -3.402823466E+38, -3.402823466E+38, -1.7976931348623157E+308,
'0001-01-01', TIME '00:00:00', '1970-01-01 09:00:01', '0001-01-01 00:00:00.000',
'1234567890abcdef','1234567890abcdef');

-- The precision and scale of the NUMERIC (DECIMAL) type specified in the argument or return type are ignored. 
-- So the result is normal.
call type_support(32767, 32767, 2147483647, 2147483647,
9223372036854775807, 9876543210987654321098.7654321098765432, 987654321054321, 3.402823466E+38, 3.402823466E+38, 3.402823466E+38,
'9999-12-31', TIME '23:59:59', '2038-01-19 03:14:07', '9999-12-31 23:59:59.999',
'1234567890abcdef','1234567890abcdef');




EVALUATE 'T_SHORT';
create or replace procedure type_support(
   v_SHORT     IN  type_support.T_SHORT%type
  ) as
begin 
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;
--BUG ( nomal : not fit in a SHORT: -32769,  BUG : 32767 )
call type_support(-32769);

--BUG ( nomal : not fit in a SHORT: -32769,  BUG : -32768 )
call type_support( 32768);


EVALUATE 'T_INTEGER';
create or replace procedure type_support(
   v_INTEGER  IN  type_support.T_INTEGER%type
  ) as
begin 
   dbms_output.put_line('v_INTEGER    ' || v_INTEGER    );
end;
--BUG ( nomal : not fit in an INTEGER: -2147483649,  BUG : 2147483647 )
call type_support(-2147483649);
--BUG ( nomal : not fit in an INTEGER: 2147483648,  BUG : -2147483648 )
call type_support(2147483648);


EVALUATE 'T_BIGINT';
create or replace procedure type_support(
   v_BIGINT  IN   type_support.T_BIGINT%type
  ) as
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT    );
end;
--BUG ( nomal : not fit in an BIGINT: -9223372036854775809,  BUG : 9223372036854775807 )
call type_support(-9223372036854775809);
--BUG ( nomal : not fit in an BIGINT: 9223372036854775808,  BUG : -9223372036854775808 )
call type_support(9223372036854775808);



EVALUATE 'T_NUMERIC';
create or replace procedure type_support(
   v_NUMERIC  IN   type_support.T_NUMERIC%type 
  ) as
begin 
   dbms_output.put_line('v_NUMERIC    ' || v_NUMERIC    );
end;

--BUG ( nomal : Data overflow on data type "numeric",  BUG : -123456789012345678901234 )
call type_support(-123456789012345678901234);
--BUG ( nomal : Data overflow on data type "numeric",  BUG : 1234567890123456789012344 )
call type_support( 123456789012345678901234);



EVALUATE 'T_DECIMAL';
create or replace procedure type_support(
   v_DECIMAL IN    type_support.T_DECIMAL%type
  ) as
begin 
   dbms_output.put_line('v_DECIMAL    ' || v_DECIMAL    );
end;
-- The precision and scale of the NUMERIC (DECIMAL) type specified in the argument or return type are ignored.
--  So the result is normal.
call type_support(-1234567890123456);
call type_support(1234567890123456);




EVALUATE 'T_FLOAT';
create or replace procedure type_support(
   v_FLOAT  IN     type_support.T_FLOAT%type
  ) as
begin 
   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;
--BUG( normal : Data overflow on data type "float", BUG : -Infinity)
call type_support(-3.402823466E+39);
--BUG( normal : Data overflow on data type "float", BUG : Infinity)
call type_support( 3.402823466E+39);


EVALUATE 'T_DOUBLE';
create or replace procedure type_support(
   v_DOUBLE  IN    type_support.T_DOUBLE%type
  ) as
begin 
   dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE    );
end;
-- normal : 1.7976931348623157E+309 exceeds limit of double.
call type_support(-1.7976931348623157E+309);
-- normal : 1.7976931348623157E+309 exceeds limit of double.
call type_support( 1.7976931348623157E+309);



EVALUATE 'T_DATE';
create or replace procedure type_support(
   v_DATE  IN      type_support.T_DATE%type
  ) as
begin 
   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
--normal 
call type_support(date'0000-00-00');

--error
call type_support(date'0001-01-01 00:00:00');
call type_support(date'0000-13-00');
call type_support(date'0001-01-32');
call type_support(date'202A-12-27');


EVALUATE 'T_TIME';
create or replace procedure type_support(
   v_TIME  IN      type_support.T_TIME%type
  ) as
begin 
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
--normal 
call type_support(TIME'11:59:59 PM');
call type_support(TIME'11:59:59 AM');

--error
call type_support(TIME'24:30:21');
call type_support(TIME'23:60:21');
call type_support(TIME'23:59:60');
call type_support(TIME'11:59:59 CM');


EVALUATE 'T_TIMESTAMP';
create or replace procedure type_support(
   v_TIMESTAMP IN  type_support.T_TIMESTAMP%type
  ) as
begin 
   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;

--error
call type_support(TIMESTAMP'1970-01-01 08:00:01');
call type_support(TIMESTAMP'2038-01-20 03:14:07');



EVALUATE 'nomal';
create or replace procedure type_support(
   v_DATETIME  IN  type_support.T_DATETIME%type
  ) as
begin 
   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;

--normal 
call type_support(DATETIME'0000-00-00 00:00:00');
call type_support(DATETIME'0000-00-00');
call type_support(DATETIME'00-00-00');

--error
call type_support(DATETIME'0000-03-01 00:00:00');
call type_support(DATETIME'0001-13-01 00:00:00');
call type_support(DATETIME'0001-03-32 00:00:00');


EVALUATE 'T_CHAR';
create or replace procedure type_support(
   v_CHAR  IN      type_support.T_CHAR%type
  ) as
begin 
   dbms_output.put_line('v_CHAR    ' || v_CHAR    );
end;

call type_support('abcdefghijklmnopqrstuvwxyz1234567');


EVALUATE 'T_VARCHAR';
create or replace procedure type_support(
   v_VARCHAR IN    type_support.T_VARCHAR%type
  ) as
begin 
   dbms_output.put_line('v_VARCHAR    ' || v_VARCHAR    );
end;

call type_support('abcdefghijklmnopqrstuvwxyz1234567');




drop procedure type_support;

drop view  type_support ;

--+ server-message off

