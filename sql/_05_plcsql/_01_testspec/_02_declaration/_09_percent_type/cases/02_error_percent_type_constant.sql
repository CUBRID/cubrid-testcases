--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- ERROR : %type basic constant declarations

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



EVALUATE 'ERROR : not fit in a SHORT: -32769';
create or replace procedure type_support as
   v_SHORT  CONSTANT     type_support.T_SHORT%type  := -32769;
begin 
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;
call type_support();


EVALUATE 'ERROR : not fit in a SHORT: 32768';
create or replace procedure type_support as
   v_SHORT  CONSTANT     type_support.T_SHORT%type  := 32768;
begin 
   dbms_output.put_line('v_SHORT     ' || v_SHORT    );
end;
call type_support();


EVALUATE 'ERROR : not fit in an INTEGER: -2147483649';
create or replace procedure type_support as
   v_INTEGER  CONSTANT   type_support.T_INTEGER%type := -2147483649;
begin 
   dbms_output.put_line('v_INTEGER    ' || v_INTEGER    );
end;
call type_support();

EVALUATE 'ERROR : not fit in an INTEGER: 2147483648';
create or replace procedure type_support as
   v_INTEGER  CONSTANT   type_support.T_INTEGER%type := 2147483648;
begin 
   dbms_output.put_line('v_INTEGER    ' || v_INTEGER    );
end;
call type_support();

EVALUATE 'ERROR : not fit in an BIGINT: -9223372036854775809';
create or replace procedure type_support as
   v_BIGINT  CONSTANT   type_support.T_BIGINT%type  := -9223372036854775809;
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT    );
end;
call type_support();

EVALUATE 'ERROR : not fit in an BIGINT: 9223372036854775808';
create or replace procedure type_support as
   v_BIGINT  CONSTANT   type_support.T_BIGINT%type  := 9223372036854775808;
begin 
   dbms_output.put_line('v_BIGINT    ' || v_BIGINT    );
end;
call type_support();

 
EVALUATE 'ERROR-NUMERIC(38,15) : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_NUMERIC  CONSTANT   type_support.T_NUMERIC%type := 123456789012345678901234;
begin 
   dbms_output.put_line('v_NUMERIC    ' || v_NUMERIC    );
end;
call type_support();


EVALUATE 'ERROR-NUMERIC(38,15) : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_NUMERIC  CONSTANT   type_support.T_NUMERIC%type := -123456789012345678901234;
begin 
   dbms_output.put_line('v_NUMERIC    ' || v_NUMERIC    );
end;
call type_support();


EVALUATE 'ERROR-DECIMAL : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_DECIMAL CONSTANT    type_support.T_DECIMAL%type := 1234567890123456;
begin 
   dbms_output.put_line('v_DECIMAL    ' || v_DECIMAL    );
end;
call type_support();


EVALUATE 'ERROR-DECIMAL : numeric value does not fit in the target type precision and scale';
create or replace procedure type_support as
   v_DECIMAL  CONSTANT   type_support.T_DECIMAL%type := -1234567890123456;
begin 
   dbms_output.put_line('v_DECIMAL    ' || v_DECIMAL    );
end;
call type_support();


-- error
EVALUATE 'ERROR : Data overflow on data type "float".';
create or replace procedure type_support as
   v_FLOAT  CONSTANT     type_support.T_FLOAT%type := -3.402823466E+39;
begin 
   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;
call type_support();


-- error
EVALUATE 'ERROR : Data overflow on data type "float".';
create or replace procedure type_support as
   v_FLOAT  CONSTANT     type_support.T_FLOAT%type := 3.402823466E+39;
begin 
   dbms_output.put_line('v_FLOAT    ' || v_FLOAT    );
end;
call type_support();


-- error
EVALUATE 'ERROR : 1.7976931348623157E+309 exceeds limit of double.';
create or replace procedure type_support as
   v_DOUBLE  CONSTANT    type_support.T_DOUBLE%type := -1.7976931348623157E+309;
begin 
   dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE    );
end;
call type_support();


-- error
EVALUATE 'ERROR : 1.7976931348623157E+309 exceeds limit of double.';
create or replace procedure type_support as
   v_DOUBLE  CONSTANT    type_support.T_DOUBLE%type := 1.7976931348623157E+309;
begin 
   dbms_output.put_line('v_DOUBLE    ' || v_DOUBLE    );
end;
call type_support();


EVALUATE 'normal';
create or replace procedure type_support as
   v_DATE  CONSTANT      type_support.T_DATE%type := date'0000-00-00';
begin 
   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 1: not in a DATE format';
create or replace procedure type_support as
   v_DATE  CONSTANT      type_support.T_DATE%type := '0001-01-01 00:00:00';
begin 
   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 2: not in a DATE format';
create or replace procedure type_support as
   v_DATE  CONSTANT      type_support.T_DATE%type := '0000-13-00';
begin 
   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 3: not in a DATE format';
create or replace procedure type_support as
   v_DATE  CONSTANT      type_support.T_DATE%type := '0001-01-32';
begin 
   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 4: not in a DATE format';
create or replace procedure type_support as
   v_DATE  CONSTANT      type_support.T_DATE%type := '202A-12-27';
begin 
   dbms_output.put_line('v_DATE    ' || v_DATE    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 1: not in a TIME format';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := '24:30:21';
begin 
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR 2: not in a TIME format';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := '23:60:21';
begin 
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 3: not in a TIME format';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := '23:59:60';
begin 
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'normal TIME 1';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := TIME'11:59:59 PM';
begin 
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();


EVALUATE 'normal TIME 2';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := '11:59:59 PM';
begin
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();


EVALUATE 'normal TIME 3';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := TIME'11:59:59 AM';
begin 
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'normal TIME 4';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := '11:59:59 AM';
begin
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : not in a TIME format';
create or replace procedure type_support as
   v_TIME  CONSTANT      type_support.T_TIME%type := '11:59:59 CM';
begin 
   dbms_output.put_line('v_TIME    ' || v_TIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : invalid TIMESTAMP string: 1970-01-01 08:00:01';
create or replace procedure type_support as
   v_TIMESTAMP CONSTANT  type_support.T_TIMESTAMP%type := TIMESTAMP'1970-01-01 08:00:01';
begin
   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;


EVALUATE 'ERROR : not int a TIMESTAMP format';
create or replace procedure type_support as
   v_TIMESTAMP CONSTANT  type_support.T_TIMESTAMP%type := '1970-01-01 08:00:01';
begin 
   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR : invalid TIMESTAMP string: 2038-01-20 03:14:07';
create or replace procedure type_support as
   v_TIMESTAMP CONSTANT  type_support.T_TIMESTAMP%type := TIMESTAMP'2038-01-20 03:14:07';
begin 
   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : not in a TIMESTAMP format';
create or replace procedure type_support as
   v_TIMESTAMP CONSTANT  type_support.T_TIMESTAMP%type := '2038-01-20 03:14:07';
begin
   dbms_output.put_line('v_TIMESTAMP    ' || v_TIMESTAMP    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR : Conversion error in timestamp format.';
create or replace procedure type_support as
    v_TIMESTAMP CONSTANT type_support.T_TIMESTAMP%type := TIMESTAMP('0000-01-01 08:00:01');
begin
    dbms_output.put_line('v_TIMESTAMP ' || v_TIMESTAMP );
end;
call type_support();


EVALUATE 'nomal 1';
create or replace procedure type_support as
   v_DATETIME  CONSTANT  type_support.T_DATETIME%type := DATETIME'0000-00-00 00:00:00';
begin 
   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();


EVALUATE 'nomal 2';
create or replace procedure type_support as
   v_DATETIME CONSTANT   type_support.T_DATETIME%type := DATETIME'0000-00-00';
begin 
   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();


EVALUATE 'nomal 3';
create or replace procedure type_support as
   v_DATETIME CONSTANT   type_support.T_DATETIME%type := DATETIME'00-00-00';
begin 
   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;


EVALUATE 'ERROR 1: not in a DATETIME format';
create or replace procedure type_support as
   v_DATETIME CONSTANT   type_support.T_DATETIME%type := '0000-03-01 00:00:00';
begin 
   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR 2: not in a DATETIME format';
create or replace procedure type_support as
   v_DATETIME CONSTANT   type_support.T_DATETIME%type := '0001-13-01 00:00:00';
begin 
   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR 3: not in a DATETIME format';
create or replace procedure type_support as
   v_DATETIME CONSTANT   type_support.T_DATETIME%type := '0001-03-32 00:00:00';
begin 
   dbms_output.put_line('v_DATETIME    ' || v_DATETIME    );
end;
call type_support();
drop procedure type_support;

EVALUATE 'ERROR : string does not fit in the target types length';
create or replace procedure type_support as
   v_CHAR  CONSTANT      type_support.T_CHAR%type := 'abcdefghijklmnopqrstuvwxyz1234567';
begin 
   dbms_output.put_line('v_CHAR    ' || v_CHAR    );
end;
call type_support();


EVALUATE 'ERROR : string does not fit in the target types length';
create or replace procedure type_support as
   v_VARCHAR CONSTANT    type_support.T_VARCHAR%type := 'abcdefghijklmnopqrstuvwxyz1234567';
begin 
   dbms_output.put_line('v_VARCHAR    ' || v_VARCHAR    );
end;
call type_support();

drop procedure type_support;

drop table  type_support ;

--+ server-message off

