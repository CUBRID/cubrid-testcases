--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic variable declarations

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



-- %type, variable
EVALUATE '%type, variable';
create or replace procedure type_support as
   v_SHORT       type_support.T_SHORT%type;
   v_SMALLINT    type_support.T_SMALLINT%type;
   v_INTEGER     type_support.T_INTEGER%type;
   v_INT         type_support.T_INT%type;
   v_BIGINT      type_support.T_BIGINT%type;
   v_NUMERIC     type_support.T_NUMERIC%type;
   v_DECIMAL     type_support.T_DECIMAL%type;
   v_FLOAT       type_support.T_FLOAT%type;
   v_REAL        type_support.T_REAL%type;
   v_DOUBLE      type_support.T_DOUBLE%type;
   v_DATE        type_support.T_DATE%type;
   v_TIME        type_support.T_TIME%type;
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
   v_DATETIME    type_support.T_DATETIME%type;
   v_CHAR        type_support.T_CHAR%type;
   v_VARCHAR     type_support.T_VARCHAR%type;
begin 
   v_SHORT      := -32768;
   v_SMALLINT   := -32768;
   v_INTEGER    := -2147483648;
   v_INT        := -2147483648;
   v_BIGINT     := -9223372036854775808;
   v_NUMERIC    := 0.1;
   v_DECIMAL    := 0.1;
   v_FLOAT      := -3.402823466E+38;
   v_REAL       := -3.402823466E+38;
   v_DOUBLE     := -1.7976931348623157E+308;
   v_DATE       := '0001-01-01';
   v_TIME       := TIME '00:00:00';
   v_TIMESTAMP  := '1970-01-01 09:00:01';
   v_DATETIME   := '0001-01-01 00:00:00.000';
   v_CHAR       := '1234567890abcdef';
   v_VARCHAR    := '1234567890abcdef';

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
end;
call type_support();


-- CBRD-25149 : Compile failure when getting %TYPE with schema name
-- %type, variable, user schema
EVALUATE '%type, variable, user schema';
create or replace procedure type_support as
   v_SHORT       dba.type_support.T_SHORT%type;
   v_SMALLINT    dba.type_support.T_SMALLINT%type;
   v_INTEGER     dba.type_support.T_INTEGER%type;
   v_INT         dba.type_support.T_INT%type;
   v_BIGINT      dba.type_support.T_BIGINT%type;
   v_NUMERIC     dba.type_support.T_NUMERIC%type;
   v_DECIMAL     dba.type_support.T_DECIMAL%type;
   v_FLOAT       dba.type_support.T_FLOAT%type;
   v_REAL        dba.type_support.T_REAL%type;
   v_DOUBLE      dba.type_support.T_DOUBLE%type;
   v_DATE        dba.type_support.T_DATE%type;
   v_TIME        dba.type_support.T_TIME%type;
   v_TIMESTAMP   dba.type_support.T_TIMESTAMP%type;
   v_DATETIME    dba.type_support.T_DATETIME%type;
   v_CHAR        dba.type_support.T_CHAR%type;
   v_VARCHAR     dba.type_support.T_VARCHAR%type;
begin 
   v_SHORT      := -32768;
   v_SMALLINT   := -32768;
   v_INTEGER    := -2147483648;
   v_INT        := -2147483648;
   v_BIGINT     := -9223372036854775808;
   v_NUMERIC    := 0.1;
   v_DECIMAL    := 0.1;
   v_FLOAT      := -3.402823466E+38;
   v_REAL       := -3.402823466E+38;
   v_DOUBLE     := -1.7976931348623157E+308;
   v_DATE       := '0001-01-01';
   v_TIME       := TIME '00:00:00';
   v_TIMESTAMP  := '1970-01-01 09:00:01';
   v_DATETIME   := '0001-01-01 00:00:00.000';
   v_CHAR       := '1234567890abcdef';
   v_VARCHAR    := '1234567890abcdef';

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
end;
call type_support();



-- %type, variable, variable%type
EVALUATE '%type, variable, variable%type';
create or replace procedure type_support as
   v_SHORT       type_support.T_SHORT%type;
   v_SMALLINT    type_support.T_SMALLINT%type;
   v_INTEGER     type_support.T_INTEGER%type;
   v_INT         type_support.T_INT%type;
   v_BIGINT      type_support.T_BIGINT%type;
   v_NUMERIC     type_support.T_NUMERIC%type;
   v_DECIMAL     type_support.T_DECIMAL%type;
   v_FLOAT       type_support.T_FLOAT%type;
   v_REAL        type_support.T_REAL%type;
   v_DOUBLE      type_support.T_DOUBLE%type;
   v_DATE        type_support.T_DATE%type;
   v_TIME        type_support.T_TIME%type;
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
   v_DATETIME    type_support.T_DATETIME%type;
   v_CHAR        type_support.T_CHAR%type;
   v_VARCHAR     type_support.T_VARCHAR%type;
   
   v_SHORT2     v_SHORT%type;
   v_SMALLINT2  v_SMALLINT%type;
   v_INTEGER2   v_INTEGER%type;
   v_INT2       v_INT%type;
   v_BIGINT2    v_BIGINT%type;
   v_NUMERIC2   v_NUMERIC%type;
   v_DECIMAL2   v_DECIMAL%type;
   v_FLOAT2     v_FLOAT%type;
   v_REAL2      v_REAL%type;
   v_DOUBLE2    v_DOUBLE%type;
   v_DATE2      v_DATE%type;
   v_TIME2      v_TIME%type;
   v_TIMESTAMP2 v_TIMESTAMP%type;
   v_DATETIME2  v_DATETIME%type;
   v_CHAR2      v_CHAR%type;
   v_VARCHAR2   v_VARCHAR%type;
   
begin 
   v_SHORT2      := 32767;
   v_SMALLINT2   := 32767;
   v_INTEGER2    := 2147483647;
   v_INT2        := 2147483647;
   v_BIGINT2     := 9223372036854775807;
   v_NUMERIC2    := 9876543210987654321098.7654321098765432;
   v_DECIMAL2    := 987654321054321;
   v_FLOAT2      := 3.402823466E+38;
   v_REAL2       := 3.402823466E+38;
   v_DOUBLE2     := 1.7976931348623157E+307;
   v_DATE2       := '9999-12-31';
   v_TIME2       := TIME '23:59:59';
   v_TIMESTAMP2  := '2038-01-19 03:14:07';
   v_DATETIME2   := '9999-12-31 23:59:59.999';
   v_CHAR2       := '1234567890abcdef';
   v_VARCHAR2    := '1234567890abcdef';

   dbms_output.put_line('v_SHORT2     ' || v_SHORT2    );
   dbms_output.put_line('v_SMALLINT2  ' || v_SMALLINT2 );
   dbms_output.put_line('v_INTEGER2   ' || v_INTEGER2  );
   dbms_output.put_line('v_INT2       ' || v_INT2      );
   dbms_output.put_line('v_BIGINT2    ' || v_BIGINT2   );
   dbms_output.put_line('v_NUMERIC2   ' || v_NUMERIC2  );
   dbms_output.put_line('v_DECIMAL2   ' || v_DECIMAL2  );
   dbms_output.put_line('v_FLOAT2     ' || v_FLOAT2    );
   dbms_output.put_line('v_REAL2      ' || v_REAL2     );
   dbms_output.put_line('v_DOUBLE2    ' || v_DOUBLE2   );
   dbms_output.put_line('v_DATE2      ' || v_DATE2     );
   dbms_output.put_line('v_TIME2      ' || v_TIME2     );
   dbms_output.put_line('v_TIMESTAMP2 ' || v_TIMESTAMP2);
   dbms_output.put_line('v_DATETIME2  ' || v_DATETIME2 );
   dbms_output.put_line('v_CHAR2      ' || v_CHAR2     );
   dbms_output.put_line('v_VARCHAR2   ' || v_VARCHAR2  );
end;

call type_support();


-- %type, variable, variable%type, user schema
EVALUATE '%type, variable, variable%type, user schema';
create or replace procedure type_support as
   v_SHORT       dba.type_support.T_SHORT%type;
   v_SMALLINT    dba.type_support.T_SMALLINT%type;
   v_INTEGER     dba.type_support.T_INTEGER%type;
   v_INT         dba.type_support.T_INT%type;
   v_BIGINT      dba.type_support.T_BIGINT%type;
   v_NUMERIC     dba.type_support.T_NUMERIC%type;
   v_DECIMAL     dba.type_support.T_DECIMAL%type;
   v_FLOAT       dba.type_support.T_FLOAT%type;
   v_REAL        dba.type_support.T_REAL%type;
   v_DOUBLE      dba.type_support.T_DOUBLE%type;
   v_DATE        dba.type_support.T_DATE%type;
   v_TIME        dba.type_support.T_TIME%type;
   v_TIMESTAMP   dba.type_support.T_TIMESTAMP%type;
   v_DATETIME    dba.type_support.T_DATETIME%type;
   v_CHAR        dba.type_support.T_CHAR%type;
   v_VARCHAR     dba.type_support.T_VARCHAR%type;
   
   v_SHORT2     v_SHORT%type;
   v_SMALLINT2  v_SMALLINT%type;
   v_INTEGER2   v_INTEGER%type;
   v_INT2       v_INT%type;
   v_BIGINT2    v_BIGINT%type;
   v_NUMERIC2   v_NUMERIC%type;
   v_DECIMAL2   v_DECIMAL%type;
   v_FLOAT2     v_FLOAT%type;
   v_REAL2      v_REAL%type;
   v_DOUBLE2    v_DOUBLE%type;
   v_DATE2      v_DATE%type;
   v_TIME2      v_TIME%type;
   v_TIMESTAMP2 v_TIMESTAMP%type;
   v_DATETIME2  v_DATETIME%type;
   v_CHAR2      v_CHAR%type;
   v_VARCHAR2   v_VARCHAR%type;
   
begin 
   v_SHORT2      := 32767;
   v_SMALLINT2   := 32767;
   v_INTEGER2    := 2147483647;
   v_INT2        := 2147483647;
   v_BIGINT2     := 9223372036854775807;
   v_NUMERIC2    := 9876543210987654321098.7654321098765432;
   v_DECIMAL2    := 987654321054321;
   v_FLOAT2      := 3.402823466E+38;
   v_REAL2       := 3.402823466E+38;
   v_DOUBLE2     := 1.7976931348623157E+307;
   v_DATE2       := '9999-12-31';
   v_TIME2       := TIME '23:59:59';
   v_TIMESTAMP2  := '2038-01-19 03:14:07';
   v_DATETIME2   := '9999-12-31 23:59:59.999';
   v_CHAR2       := '1234567890abcdef';
   v_VARCHAR2    := '1234567890abcdef';

   dbms_output.put_line('v_SHORT2     ' || v_SHORT2    );
   dbms_output.put_line('v_SMALLINT2  ' || v_SMALLINT2 );
   dbms_output.put_line('v_INTEGER2   ' || v_INTEGER2  );
   dbms_output.put_line('v_INT2       ' || v_INT2      );
   dbms_output.put_line('v_BIGINT2    ' || v_BIGINT2   );
   dbms_output.put_line('v_NUMERIC2   ' || v_NUMERIC2  );
   dbms_output.put_line('v_DECIMAL2   ' || v_DECIMAL2  );
   dbms_output.put_line('v_FLOAT2     ' || v_FLOAT2    );
   dbms_output.put_line('v_REAL2      ' || v_REAL2     );
   dbms_output.put_line('v_DOUBLE2    ' || v_DOUBLE2   );
   dbms_output.put_line('v_DATE2      ' || v_DATE2     );
   dbms_output.put_line('v_TIME2      ' || v_TIME2     );
   dbms_output.put_line('v_TIMESTAMP2 ' || v_TIMESTAMP2);
   dbms_output.put_line('v_DATETIME2  ' || v_DATETIME2 );
   dbms_output.put_line('v_CHAR2      ' || v_CHAR2     );
   dbms_output.put_line('v_VARCHAR2   ' || v_VARCHAR2  );
end;
call type_support();


drop procedure type_support;

drop view  type_support ;

--+ server-message off
