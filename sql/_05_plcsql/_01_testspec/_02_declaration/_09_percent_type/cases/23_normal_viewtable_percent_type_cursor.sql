--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic cursor

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
EVALUATE '%type, cursor to variable, 1 record ';
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
                      
   CURSOR my_cursor IS
          SELECT T_SHORT, 
                 T_SMALLINT,
                 T_INTEGER,
                 T_INT,
                 T_BIGINT,
                 T_NUMERIC,
                 T_DECIMAL,
                 T_FLOAT,
                 T_REAL,
                 T_DOUBLE,
                 T_DATE,
                 T_TIME,
                 T_TIMESTAMP,
                 T_DATETIME,
                 T_CHAR,
                 T_VARCHAR
          FROM type_support
          WHERE ID = 1;

begin 
   
    OPEN my_cursor;
    LOOP
        FETCH my_cursor INTO v_SHORT, v_SMALLINT, v_INTEGER, v_INT, v_BIGINT, v_NUMERIC, v_DECIMAL, v_FLOAT, v_REAL, v_DOUBLE, v_DATE, v_TIME, v_TIMESTAMP, v_DATETIME, v_CHAR, v_VARCHAR ;
        EXIT WHEN my_cursor%NOTFOUND;
    END LOOP;
    CLOSE my_cursor;
    
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

--BUG(normal : "Normal execution" , BUG : "internal server error") CBRD-25606
call type_support();


-- %type, cursor to variable, 2 record 
EVALUATE '%type, cursor to variable, 2 record ';
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

   CURSOR my_cursor IS
          SELECT T_SHORT, 
                 T_SMALLINT,
                 T_INTEGER,
                 T_INT,
                 T_BIGINTte or replace procedure type_support as
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

   CURSOR my_cursor IS
          SELECT T_SHORT,
                 T_SMALLINT,
                 T_INTEGER,
                 T_INT,
                 T_BIGINT,
                 T_NUMERIC,
                 T_DECIMAL,
                 T_FLOAT,
                 T_REAL,
                 T_DOUBLE,
                 T_DATE,
                 T_TIME,
                 T_TIMESTAMP,
                 T_DATETIME,
                 T_CHAR,
                 T_VARCHAR
          FROM type_support
          ORDER BY ID;

begin

    OPEN my_cursor;
    LOOP
        FETCH my_cursor INTO v_SHORT, v_SMALLINT, v_INTEGER, v_INT, v_BIGINT, v_NUMERIC, v_DECIMAL, v_FLOAT, v_REAL, v_DOUBLE, v_DATE, v_TIME, v_TIMESTAMP, v_DATETIME, v_CHAR, v_VARCHAR ;
        EXIT WHEN my_cursor%NOTFOUND;
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

    END LOOP;
    CLOSE my_cursor;
end;

--BUG(normal : "Normal execution" , BUG : "Data overflow on data type "smallint"")
call type_support();


drop procedure type_support;

drop view  type_support ;

--+ server-message off

