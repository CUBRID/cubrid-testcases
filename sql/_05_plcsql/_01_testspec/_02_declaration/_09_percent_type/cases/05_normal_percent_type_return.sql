--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic return

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


-- %type, parmeter, return
EVALUATE 'T_SHORT';
create or replace function type_support_return( v_SHORT     type_support.T_SHORT%type         ) return  type_support.T_SHORT%type          as Begin   return v_SHORT    ;   end;    
select type_support_return(-32768 );       
select type_support_return(32767  );


EVALUATE 'T_SMALLINT';
create or replace function type_support_return( v_SMALLINT  type_support.T_SMALLINT%type      ) return  type_support.T_SMALLINT%type       as Begin   return v_SMALLINT ;   end;    
select type_support_return(-32768 );       
select type_support_return(32767  );


EVALUATE 'T_INTEGER';
create or replace function type_support_return( v_INTEGER   type_support.T_INTEGER%type       ) return  type_support.T_INTEGER%type        as Begin   return v_INTEGER  ;   end;    
select type_support_return(-2147483648 );       
select type_support_return(2147483647  );


EVALUATE 'T_INT';
create or replace function type_support_return( v_INT       type_support.T_INT%type           ) return  type_support.T_INT%type            as Begin   return v_INT      ;   end;    
select type_support_return(-2147483648 );       
select type_support_return(2147483647  );

EVALUATE 'T_BIGINT';
create or replace function type_support_return( v_BIGINT    type_support.T_BIGINT%type        ) return  type_support.T_BIGINT%type         as Begin   return v_BIGINT   ;   end;    
select type_support_return(-9223372036854775808 );       
select type_support_return(9223372036854775807  );


EVALUATE 'T_NUMERIC';
create or replace function type_support_return( v_NUMERIC   type_support.T_NUMERIC%type       ) return  type_support.T_NUMERIC%type        as Begin   return v_NUMERIC  ;   end;    
select type_support_return(0.1    );       
select type_support_return(9876543210987654321098.7654321098765432);


EVALUATE 'T_DECIMAL';
create or replace function type_support_return( v_DECIMAL   type_support.T_DECIMAL%type       ) return  type_support.T_DECIMAL%type        as Begin   return v_DECIMAL  ;   end;    
select type_support_return(0.1    );       
select type_support_return(987654321054321 );


EVALUATE 'T_FLOAT';
create or replace function type_support_return( v_FLOAT     type_support.T_FLOAT%type         ) return  type_support.T_FLOAT%type          as Begin   return v_FLOAT    ;   end;    
select type_support_return(-3.402823466E+38 );       
select type_support_return(3.402823466E+38  );


EVALUATE 'T_REAL';
create or replace function type_support_return( v_REAL      type_support.T_REAL%type          ) return  type_support.T_REAL%type           as Begin   return v_REAL     ;   end;    
select type_support_return(-3.402823466E+38 );       
select type_support_return(3.402823466E+38  );


EVALUATE 'T_DOUBLE';
create or replace function type_support_return( v_DOUBLE    dba.type_support.T_DOUBLE%type    ) return  dba.type_support.T_DOUBLE%type     as Begin   return v_DOUBLE   ;   end;    
select type_support_return(-1.7976931348623157E+308 );       
select type_support_return( 1.7976931348623157E+308 );


EVALUATE 'T_DATE';
create or replace function type_support_return( v_DATE      dba.type_support.T_DATE%type      ) return  dba.type_support.T_DATE%type       as Begin   return v_DATE     ;   end;    
select type_support_return('0001-01-01' );       
select type_support_return('9999-12-31' );


EVALUATE 'T_TIME';
create or replace function type_support_return( v_TIME      dba.type_support.T_TIME%type      ) return  dba.type_support.T_TIME%type       as Begin   return v_TIME     ;   end;    
select type_support_return(TIME '00:00:00' );       
select type_support_return(TIME '23:59:59' );
select type_support_return(TIME'11:59:59 PM');
select type_support_return(TIME'11:59:59 AM');


EVALUATE 'T_TIMESTAMP';
create or replace function type_support_return( v_TIMESTAMP dba.type_support.T_TIMESTAMP%type ) return  dba.type_support.T_TIMESTAMP%type  as Begin   return v_TIMESTAMP;   end;    
select type_support_return('1970-01-01 09:00:01' );       
select type_support_return('2038-01-19 03:14:07' );

EVALUATE 'T_DATETIME';
create or replace function type_support_return( v_DATETIME  dba.type_support.T_DATETIME%type  ) return  dba.type_support.T_DATETIME%type   as Begin   return v_DATETIME ;   end;    
select type_support_return('0001-01-01 00:00:00.000');       
select type_support_return('9999-12-31 23:59:59.999');

EVALUATE 'T_CHAR';
create or replace function type_support_return( v_CHAR      dba.type_support.T_CHAR%type      ) return  dba.type_support.T_CHAR%type       as Begin   return v_CHAR     ;   end;    
select type_support_return('1234567890abcdef' );       
select type_support_return('1234567890abcdef' );

EVALUATE 'T_VARCHAR';
create or replace function type_support_return( v_VARCHAR   dba.type_support.T_VARCHAR%type   ) return  dba.type_support.T_VARCHAR%type    as Begin   return v_VARCHAR  ;   end;    
select type_support_return('1234567890abcdef' );       
select type_support_return('1234567890abcdef' );


drop function type_support_return;

drop table  type_support ;

--+ server-message off

