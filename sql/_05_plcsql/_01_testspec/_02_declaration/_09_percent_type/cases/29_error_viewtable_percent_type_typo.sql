--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- ERROR : %type error for typo

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



-- %type, cursor to variable, 1 record 
EVALUATE 'No table name was written.';
create or replace procedure type_support as
   v_SHORT       T_SHORT%type;
begin 
   v_SHORT      := -327;
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;

create or replace procedure type_support as
   v_INTEGER    CONSTANT  dba.T_INTEGER%type          := 2147483647;                                  
begin 
   dbms_output.put_line('v_INTEGER   ' || v_INTEGER  );
end;

create or replace procedure type_support(
   v_BIGINT     T_BIGINT%type
  ) as
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT   );
end;

create or replace function type_support_return() return  T_SMALLINT%type   as Begin   return 51 ;   end;    


EVALUATE 'Write a table name that does not exist';
create or replace procedure type_support as
   v_NUMERIC       support.v_NUMERIC%type;
begin 
   v_NUMERIC      := 9876543210987654321098.7654321098765432;
   dbms_output.put_line('v_NUMERIC   ' || v_NUMERIC  );
end;

create or replace procedure type_support as
   v_FLOAT    CONSTANT  dba.support.v_FLOAT%type          := 3.402823466E+38;
begin 
   dbms_output.put_line('v_FLOAT   ' || v_FLOAT  );
end;

create or replace procedure type_support(
   v_DOUBLE     support.v_DOUBLE%type
  ) as
begin 
   dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE   );
end;

create or replace function type_support_return() return  support.v_DATE%type       as Begin   return DATE'2024-08-08' ;   end;    


EVALUATE 'Create a table name without permission';
create user test_user1;
call login ('test_user1') on class db_user;

create or replace procedure type_support as
   v_SHORT       type_support.T_SHORT%type;
begin 
   v_SHORT      := -327;
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;

create or replace procedure type_support as
   v_INTEGER    CONSTANT  dba.type_support.T_INTEGER%type          := 2147483647;                                  
begin 
   dbms_output.put_line('v_INTEGER   ' || v_INTEGER  );
end;

create or replace procedure type_support(
   v_BIGINT     type_support.T_BIGINT%type
  ) as
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT   );
end;

create or replace function type_support_return() return  type_support.T_SMALLINT%type   as Begin   return 51 ;   end;    

call login ('dba') on class db_user;
drop user test_user1;


EVALUATE 'Do not write column names.';
create or replace procedure type_support as
   v_SHORT       type_support%type;
begin 
   v_SHORT      := -327;
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;

create or replace procedure type_support as
   v_INTEGER    CONSTANT  dba.type_support%type          := 2147483647;                                  
begin 
   dbms_output.put_line('v_INTEGER   ' || v_INTEGER  );
end;

create or replace procedure type_support(
   v_BIGINT     type_support.%type
  ) as
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT   );
end;

create or replace function type_support_return() return  type_support%type   as Begin   return 51 ;   end;    


EVALUATE 'Use a non-existent column name';

create or replace procedure type_support as
   v_SHORT       type_support.X_SHORT%type;
begin 
   v_SHORT      := -327;
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;

create or replace procedure type_support as
   v_INTEGER    CONSTANT  dba.type_support.X_INTEGER%type          := 2147483647;                                  
begin 
   dbms_output.put_line('v_INTEGER   ' || v_INTEGER  );
end;

create or replace procedure type_support(
   v_BIGINT     type_support.X_BIGINT%type
  ) as
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT   );
end;

create or replace function type_support_return() return  type_support.X_SMALLINT%type   as Begin   return 51 ;   end;    


EVALUATE 'written a column type';
create or replace procedure type_support as
   v_SHORT  SHORT     type_support.T_SHORT%type;
begin 
   v_SHORT      := -327;
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;

create or replace procedure type_support as
   v_INTEGER    CONSTANT  dba.type_support.T_INTEGER%type  INTEGER        := 2147483647;                                  
begin 
   dbms_output.put_line('v_INTEGER   ' || v_INTEGER  );
end;

create or replace procedure type_support(
   v_BIGINT  BIGINT   type_support.T_BIGINT%type
  ) as
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT   );
end;

create or replace function type_support_return() return SMALLINT type_support.T_SMALLINT%type   as Begin   return 51 ;   end;    


EVALUATE 'Use $,#,@ symbols instead of % symbols';
create or replace procedure type_support as
   v_SHORT       type_support.T_SHORT!type;
begin 
   v_SHORT      := -327;
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;

create or replace procedure type_support as
   v_INTEGER    CONSTANT  dba.type_support.T_INTEGER#type          := 2147483647;                                  
begin 
   dbms_output.put_line('v_INTEGER   ' || v_INTEGER  );
end;

create or replace procedure type_support(
   v_BIGINT     type_support.T_BIGINT@type
  ) as
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT   );
end;

create or replace function type_support_return() return  type_support.T_SMALLINT&type   as Begin   return 51 ;   end;    

create or replace function type_support_return() return  type_support.T_SMALLINT$type   as Begin   return 51 ;   end;    


drop view  type_support ;

--+ server-message off

