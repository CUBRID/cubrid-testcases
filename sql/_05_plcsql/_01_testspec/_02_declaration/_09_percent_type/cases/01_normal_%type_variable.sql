--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic variable declarations

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

-- 
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


--BUG( normal : Data overflow on data type "float", BUG : -Infinity)
EVALUATE 'ERROR : Data overflow on data type "float".';
create or replace procedure type_support as
   v_FLOAT       type_support.T_FLOAT%type;
begin 
   v_FLOAT      := -3.402823466E+39;

   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;
call type_support();


--BUG( normal : Data overflow on data type "float", BUG : Infinity)
EVALUATE 'ERROR : Data overflow on data type "float".';
create or replace procedure type_support as
   v_FLOAT       type_support.T_FLOAT%type;
begin 
   v_FLOAT      := 3.402823466E+39;

   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;
call type_support();


--BUG( normal : 1.7976931348623157E+309 exceeds limit of double., BUG : -Infinity)
EVALUATE 'ERROR : 1.7976931348623157E+309 exceeds limit of double.';
create or replace procedure type_support as
   v_DOUBLE      type_support.T_DOUBLE%type;
begin 
   v_DOUBLE      := -1.7976931348623157E+309;

   dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE    );
end;
call type_support();


--BUG( normal : 1.7976931348623157E+309 exceeds limit of double., BUG : Infinity)
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


EVALUATE 'ERROR : invalid DATE string: 0001-01-01 00:00:00';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin 
   v_DATE      := date'0001-01-01 00:00:00';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;


EVALUATE 'ERROR : invalid DATE string: 0000-13-00';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin 
   v_DATE      := date'0000-13-00';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;


EVALUATE 'ERROR : invalid DATE string: 0001-01-32';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin 
   v_DATE      := date'0001-01-32';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;


EVALUATE 'ERROR : invalid DATE string: 202A-12-27';
create or replace procedure type_support as
   v_DATE        type_support.T_DATE%type;
begin 
   v_DATE      := date'202A-12-27';

   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;


EVALUATE 'ERROR : invalid TIME string: 24:30:21';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin 
   v_TIME      := TIME'24:30:21';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;

EVALUATE 'ERROR : invalid TIME string: 23:60:21';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin 
   v_TIME      := TIME'23:60:21';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;

EVALUATE 'ERROR : invalid TIME string: 3:59:60';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin 
   v_TIME      := TIME'23:59:60';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;


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


EVALUATE 'ERROR : invalid TIME string: 11:59:59 CM';
create or replace procedure type_support as
   v_TIME        type_support.T_TIME%type;
begin 
   v_TIME      := TIME'11:59:59 CM';

   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;


EVALUATE 'ERROR : invalid TIMESTAMP string: 1970-01-01 08:00:01';
create or replace procedure type_support as
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
begin 
   v_TIMESTAMP      := TIMESTAMP'1970-01-01 08:00:01';

   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;

EVALUATE 'ERROR : invalid TIMESTAMP string: 2038-01-20 03:14:07';
create or replace procedure type_support as
   v_TIMESTAMP   type_support.T_TIMESTAMP%type;
begin 
   v_TIMESTAMP      := TIMESTAMP'2038-01-20 03:14:07';

   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;


EVALUATE 'nomal';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin 
   v_DATETIME      := DATETIME'0000-00-00 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();


EVALUATE 'nomal';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin 
   v_DATETIME      := DATETIME'0000-00-00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();


EVALUATE 'nomal';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin 
   v_DATETIME      := DATETIME'00-00-00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();


EVALUATE 'ERROR : invalid DATETIME string: 0000-03-01 00:00:00';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin 
   v_DATETIME      := DATETIME'0000-03-01 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;

EVALUATE 'ERROR : invalid DATETIME string: 0001-13-01 00:00:00';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin 
   v_DATETIME      := DATETIME'0001-13-01 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;

EVALUATE 'ERROR : invalid DATETIME string: 0001-03-32 00:00:00';
create or replace procedure type_support as
   v_DATETIME    type_support.T_DATETIME%type;
begin 
   v_DATETIME      := DATETIME'0001-03-32 00:00:00';

   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;


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




drop procedure type_support;

drop table  type_support ;

--+ server-message off

