--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic prameter

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

-- BUG( normal : NUMERIC-0.100000000000000, BUG : NUMERIC-0.1 )
-- BUG( normal : DECIMAL-0, BUG : DECIMAL-0.1 )
call type_support(-32768, -32767, -2147483648, -2147483648,
-9223372036854775808, 0.1, 0.1, -3.402823466E+38, -3.402823466E+38, -1.7976931348623157E+308,
'0001-01-01', TIME '00:00:00', '1970-01-01 09:00:01', '0001-01-01 00:00:00.000',
'1234567890abcdef','1234567890abcdef');

-- BUG( normal : NUMERIC-9876543210987654321098.765432109876543, BUG : NUMERIC-9876543210987654321098.7654321098765432 )
call type_support(32767, 32767, 2147483647, 2147483647,
9223372036854775807, 9876543210987654321098.7654321098765432, 987654321054321, 3.402823466E+38, 3.402823466E+38, 3.402823466E+38,
'9999-12-31', TIME '23:59:59', '2038-01-19 03:14:07', '9999-12-31 23:59:59.999',
'1234567890abcdef','1234567890abcdef');




-- %type, IN parameter
EVALUATE '%type, IN parameter';
create or replace procedure type_support(
   v_SHORT     IN  type_support.T_SHORT%type,
   v_SMALLINT  IN  type_support.T_SMALLINT%type,
   v_INTEGER   IN  type_support.T_INTEGER%type,
   v_INT       IN  type_support.T_INT%type,
   v_BIGINT    IN  type_support.T_BIGINT%type,
   v_NUMERIC   IN  type_support.T_NUMERIC%type,
   v_DECIMAL   IN  type_support.T_DECIMAL%type,
   v_FLOAT     IN  type_support.T_FLOAT%type,
   v_REAL      IN  dba.type_support.T_REAL%type,
   v_DOUBLE    IN  dba.type_support.T_DOUBLE%type,
   v_DATE      IN  dba.type_support.T_DATE%type,
   v_TIME      IN  dba.type_support.T_TIME%type,
   v_TIMESTAMP IN  dba.type_support.T_TIMESTAMP%type,
   v_DATETIME  IN  dba.type_support.T_DATETIME%type,
   v_CHAR      IN  dba.type_support.T_CHAR%type,
   v_VARCHAR   IN  dba.type_support.T_VARCHAR%type
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

-- BUG( normal : NUMERIC-0.100000000000000, BUG : NUMERIC-0.1 )
-- BUG( normal : DECIMAL-0, BUG : DECIMAL-0.1 )
call type_support(-32768, -32767, -2147483648, -2147483648,
-9223372036854775808, 0.1, 0.1, -3.402823466E+38, -3.402823466E+38, -1.7976931348623157E+308,
'0001-01-01', TIME '00:00:00', '1970-01-01 09:00:01', '0001-01-01 00:00:00.000',
'1234567890abcdef','1234567890abcdef');

-- BUG( normal : NUMERIC-9876543210987654321098.765432109876543, BUG : NUMERIC-9876543210987654321098.7654321098765432 )
call type_support(32767, 32767, 2147483647, 2147483647,
9223372036854775807, 9876543210987654321098.7654321098765432, 987654321054321, 3.402823466E+38, 3.402823466E+38, 3.402823466E+38,
'9999-12-31', TIME '23:59:59', '2038-01-19 03:14:07', '9999-12-31 23:59:59.999',
'1234567890abcdef','1234567890abcdef');



-- %type, INOUT parameter
EVALUATE '%type, IN parameter';
create or replace procedure type_support(
   v_SHORT     INOUT  type_support.T_SHORT%type,
   v_SMALLINT  INOUT  type_support.T_SMALLINT%type,
   v_INTEGER   INOUT  type_support.T_INTEGER%type,
   v_INT       INOUT  type_support.T_INT%type,
   v_BIGINT    INOUT  type_support.T_BIGINT%type,
   v_NUMERIC   INOUT  type_support.T_NUMERIC%type,
   v_DECIMAL   INOUT  type_support.T_DECIMAL%type,
   v_FLOAT     INOUT  type_support.T_FLOAT%type,
   v_REAL      INOUT  dba.type_support.T_REAL%type,
   v_DOUBLE    INOUT  dba.type_support.T_DOUBLE%type,
   v_DATE      INOUT  dba.type_support.T_DATE%type,
   v_TIME      INOUT  dba.type_support.T_TIME%type,
   v_TIMESTAMP INOUT  dba.type_support.T_TIMESTAMP%type,
   v_DATETIME  INOUT  dba.type_support.T_DATETIME%type,
   v_CHAR      INOUT  dba.type_support.T_CHAR%type,
   v_VARCHAR   INOUT  dba.type_support.T_VARCHAR%type
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

-- BUG( normal : NUMERIC-0.100000000000000, BUG : NUMERIC-0.1 )
-- BUG( normal : DECIMAL-0, BUG : DECIMAL-0.1 )
call type_support(-32768, -32767, -2147483648, -2147483648,
-9223372036854775808, 0.1, 0.1, -3.402823466E+38, -3.402823466E+38, -1.7976931348623157E+308,
'0001-01-01', TIME '00:00:00', '1970-01-01 09:00:01', '0001-01-01 00:00:00.000',
'1234567890abcdef','1234567890abcdef');

-- BUG( normal : NUMERIC-9876543210987654321098.765432109876543, BUG : NUMERIC-9876543210987654321098.7654321098765432 )
call type_support(32767, 32767, 2147483647, 2147483647,
9223372036854775807, 9876543210987654321098.7654321098765432, 987654321054321, 3.402823466E+38, 3.402823466E+38, 3.402823466E+38,
'9999-12-31', TIME '23:59:59', '2038-01-19 03:14:07', '9999-12-31 23:59:59.999',
'1234567890abcdef','1234567890abcdef');




-- %type, OUT parameter
EVALUATE '%type, OUT parameter 1';
create or replace procedure type_support(
   v_SHORT     OUT  type_support.T_SHORT%type,
   v_SMALLINT  OUT  type_support.T_SMALLINT%type,
   v_INTEGER   OUT  type_support.T_INTEGER%type,
   v_INT       OUT  type_support.T_INT%type,
   v_BIGINT    OUT  type_support.T_BIGINT%type,
   v_NUMERIC   OUT  type_support.T_NUMERIC%type,
   v_DECIMAL   OUT  type_support.T_DECIMAL%type,
   v_FLOAT     OUT  type_support.T_FLOAT%type,
   v_REAL      OUT  dba.type_support.T_REAL%type,
   v_DOUBLE    OUT  dba.type_support.T_DOUBLE%type,
   v_DATE      OUT  dba.type_support.T_DATE%type,
   v_TIME      OUT  dba.type_support.T_TIME%type,
   v_TIMESTAMP OUT  dba.type_support.T_TIMESTAMP%type,
   v_DATETIME  OUT  dba.type_support.T_DATETIME%type,
   v_CHAR      OUT  dba.type_support.T_CHAR%type,
   v_VARCHAR   OUT  dba.type_support.T_VARCHAR%type
  ) as
begin 
   v_SHORT      := -32768;
   v_SMALLINT   := -32767;
   v_INTEGER    := -2147483648;
   v_INT        := -2147483648;
   v_BIGINT     := -9223372036854775808;
   v_NUMERIC    := 0.1;
   v_DECIMAL    := 0.1;
   v_FLOAT      := -3.402823466E+38;
   v_REAL       := -3.402823466E+38;
   v_DOUBLE     := -1.7976931348623157E+308;
   v_DATE       := '0001-01-01';
   v_TIME       := '00:00:00';
   v_TIMESTAMP  := '1970-01-01 09:00:01';
   v_DATETIME   := '0001-01-01 00:00:00.000';
   v_CHAR       := '1234567890abcdef';
   v_VARCHAR    := '1234567890abcdef';
end;

SELECT 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL
      INTO 
      :v_SHORT     , :v_SMALLINT  , :v_INTEGER   , :v_INT       , :v_BIGINT    , :v_NUMERIC   , :v_DECIMAL   , :v_FLOAT     , :v_REAL      , :v_DOUBLE    , :v_DATE      , :v_TIME      , :v_TIMESTAMP , :v_DATETIME  , :v_CHAR      , :v_VARCHAR 
FROM db_root;


call type_support(
   :v_SHORT     ,
   :v_SMALLINT  ,
   :v_INTEGER   ,
   :v_INT       ,
   :v_BIGINT    ,
   :v_NUMERIC   ,
   :v_DECIMAL   ,
   :v_FLOAT     ,
   :v_REAL      ,
   :v_DOUBLE    ,
   :v_DATE      ,
   :v_TIME      ,
   :v_TIMESTAMP ,
   :v_DATETIME  ,
   :v_CHAR      ,
   :v_VARCHAR   
);

-- BUG( normal : NUMERIC-0.100000000000000, BUG : NUMERIC-0.1 )
-- BUG( normal : DECIMAL-0, BUG : DECIMAL-0.1 )
select 
   :v_SHORT     ,
   :v_SMALLINT  ,
   :v_INTEGER   ,
   :v_INT       ,
   :v_BIGINT    ,
   :v_NUMERIC   ,
   :v_DECIMAL   ,
   :v_FLOAT     ,
   :v_REAL      ,
   :v_DOUBLE    ,
   :v_DATE      ,
   :v_TIME      ,
   :v_TIMESTAMP ,
   :v_DATETIME  ,
   :v_CHAR      ,
   :v_VARCHAR   
FROM db_root;



EVALUATE '%type, OUT parameter 2';
create or replace procedure type_support(
   v_SHORT     OUT  type_support.T_SHORT%type,
   v_SMALLINT  OUT  type_support.T_SMALLINT%type,
   v_INTEGER   OUT  type_support.T_INTEGER%type,
   v_INT       OUT  type_support.T_INT%type,
   v_BIGINT    OUT  type_support.T_BIGINT%type,
   v_NUMERIC   OUT  type_support.T_NUMERIC%type,
   v_DECIMAL   OUT  type_support.T_DECIMAL%type,
   v_FLOAT     OUT  type_support.T_FLOAT%type,
   v_REAL      OUT  dba.type_support.T_REAL%type,
   v_DOUBLE    OUT  dba.type_support.T_DOUBLE%type,
   v_DATE      OUT  dba.type_support.T_DATE%type,
   v_TIME      OUT  dba.type_support.T_TIME%type,
   v_TIMESTAMP OUT  dba.type_support.T_TIMESTAMP%type,
   v_DATETIME  OUT  dba.type_support.T_DATETIME%type,
   v_CHAR      OUT  dba.type_support.T_CHAR%type,
   v_VARCHAR   OUT  dba.type_support.T_VARCHAR%type
  ) as
begin 
   v_SHORT      := 32767;
   v_SMALLINT   := 32767;
   v_INTEGER    := 2147483647;
   v_INT        := 2147483647;
   v_BIGINT     := 9223372036854775807;
   v_NUMERIC    := 9876543210987654321098.7654321098765432;
   v_DECIMAL    := 987654321054321;
   v_FLOAT      := 3.402823466E+38;
   v_REAL       := 3.402823466E+38;
   v_DOUBLE     := 1.7976931348623157E+307;
   v_DATE       := '9999-12-31';
   v_TIME       := TIME '23:59:59';
   v_TIMESTAMP  := '2038-01-19 03:14:07';
   v_DATETIME   := '9999-12-31 23:59:59.999';
   v_CHAR       := '1234567890abcdef';
   v_VARCHAR    := '1234567890abcdef';

end;

SELECT 
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL
      INTO 
      :v_SHORT     , :v_SMALLINT  , :v_INTEGER   , :v_INT       , :v_BIGINT    , :v_NUMERIC   , :v_DECIMAL   , :v_FLOAT     , :v_REAL      , :v_DOUBLE    , :v_DATE      , :v_TIME      , :v_TIMESTAMP , :v_DATETIME  , :v_CHAR      , :v_VARCHAR 
FROM db_root;


call type_support(
   :v_SHORT     ,
   :v_SMALLINT  ,
   :v_INTEGER   ,
   :v_INT       ,
   :v_BIGINT    ,
   :v_NUMERIC   ,
   :v_DECIMAL   ,
   :v_FLOAT     ,
   :v_REAL      ,
   :v_DOUBLE    ,
   :v_DATE      ,
   :v_TIME      ,
   :v_TIMESTAMP ,
   :v_DATETIME  ,
   :v_CHAR      ,
   :v_VARCHAR   
);

-- BUG( normal : NUMERIC-9876543210987654321098.765432109876543, BUG : NUMERIC-9876543210987654321098.7654321098765432 )
select 
   :v_SHORT     ,
   :v_SMALLINT  ,
   :v_INTEGER   ,
   :v_INT       ,
   :v_BIGINT    ,
   :v_NUMERIC   ,
   :v_DECIMAL   ,
   :v_FLOAT     ,
   :v_REAL      ,
   :v_DOUBLE    ,
   :v_DATE      ,
   :v_TIME      ,
   :v_TIMESTAMP ,
   :v_DATETIME  ,
   :v_CHAR      ,
   :v_VARCHAR   
FROM db_root;



drop procedure type_support;

drop table  type_support ;

--+ server-message off

