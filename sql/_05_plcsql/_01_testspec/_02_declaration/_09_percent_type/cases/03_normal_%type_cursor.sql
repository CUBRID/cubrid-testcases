--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic cursor

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
(-32768, -32767, -2147483648, -2147483648,
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

call type_support();


drop procedure type_support;

drop table  type_support ;

--+ server-message off

