/**
 *  This test case verifies CBRD-24707: Support API for %TYPE
 *
 *  A %type reference with a typo or an inaccessible table must be refused when a
 *  variable, a constant, a parameter or a return type of a stored routine uses it.
 *  Each case tries the same four routines with a different mistake.
 *  Case 3 creates test_user1, tries the routines as that user and logs back in as dba.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a %type that names no table is refused
 *    Case 2:  a %type that names a table that does not exist is refused
 *    Case 3:  a user without SELECT on the table cannot use the %type of its columns
 *    Case 4:  a %type that names no column is refused
 *    Case 5:  a %type that names a column that does not exist is refused
 *    Case 6:  a data type written together with a %type is refused
 *    Case 7:  other symbols than % before type, such as #, @, &, $ and !, are refused
 */

--+ server-message on


-- create table & insert data
drop table if exists type_support;

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


evaluate 'Case 1: a %type that names no table is refused';
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


evaluate 'Case 2: a %type that names a table that does not exist is refused';
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


evaluate 'Case 3: a user without SELECT on the table cannot use the %type of its columns';
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


evaluate 'Case 4: a %type that names no column is refused';
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


evaluate 'Case 5: a %type that names a column that does not exist is refused';

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


evaluate 'Case 6: a data type written together with a %type is refused';
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


evaluate 'Case 7: other symbols than % before type, such as #, @, &, $ and !, are refused';
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


drop function type_support_return;

drop procedure type_support;

drop table  type_support ;

--+ server-message off

