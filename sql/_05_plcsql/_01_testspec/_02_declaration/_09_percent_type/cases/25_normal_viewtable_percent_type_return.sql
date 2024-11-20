--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic return

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

drop view  type_support ;

--+ server-message off

