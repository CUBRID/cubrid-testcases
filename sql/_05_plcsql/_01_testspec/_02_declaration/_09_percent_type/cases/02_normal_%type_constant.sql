--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type basic constant declarations

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



-- %type, constant
EVALUATE '%type, constant';
create or replace procedure type_support as
   v_SHORT      CONSTANT type_support.T_SHORT%type                := -32768;                      
   v_SMALLINT   CONSTANT type_support.T_SMALLINT%type             := -32767;                      
   v_INTEGER    CONSTANT type_support.T_INTEGER%type              := -2147483648;                 
   v_INT        CONSTANT type_support.T_INT%type                  := -2147483648;                 
   v_BIGINT     CONSTANT type_support.T_BIGINT%type               := -9223372036854775808;        
   v_NUMERIC    CONSTANT type_support.T_NUMERIC%type              := 0.1;                         
   v_DECIMAL    CONSTANT type_support.T_DECIMAL%type              := 0.1;                         
   v_FLOAT      CONSTANT type_support.T_FLOAT%type                := -3.402823466E+38;            
   v_REAL       CONSTANT type_support.T_REAL%type                 := -3.402823466E+38;            
   v_DOUBLE     CONSTANT type_support.T_DOUBLE%type           := -1.7976931348623157E+308;    
   v_DATE       CONSTANT type_support.T_DATE%type             := '0001-01-01';                
   v_TIME       CONSTANT type_support.T_TIME%type             := TIME '00:00:00';             
   v_TIMESTAMP  CONSTANT type_support.T_TIMESTAMP%type        := '1970-01-01 09:00:01';       
   v_DATETIME   CONSTANT type_support.T_DATETIME%type         := '0001-01-01 00:00:00.000';   
   v_CHAR       CONSTANT type_support.T_CHAR%type             := '1234567890abcdef';          
   v_VARCHAR    CONSTANT type_support.T_VARCHAR%type          := '1234567890abcdef';          
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
end;

call type_support();


-- %type, constant, user schema
EVALUATE '%type, constant, user schema';
create or replace procedure type_support as
   v_SHORT      CONSTANT dba.type_support.T_SHORT%type            := 32767;                                       
   v_SMALLINT   CONSTANT dba.type_support.T_SMALLINT%type         := 32767;                                       
   v_INTEGER    CONSTANT dba.type_support.T_INTEGER%type          := 2147483647;                                  
   v_INT        CONSTANT dba.type_support.T_INT%type              := 2147483647;                                  
   v_BIGINT     CONSTANT dba.type_support.T_BIGINT%type           := 9223372036854775807;                         
   v_NUMERIC    CONSTANT dba.type_support.T_NUMERIC%type          := 9876543210987654321098.7654321098765432;     
   v_DECIMAL    CONSTANT dba.type_support.T_DECIMAL%type          := 987654321054321;                             
   v_FLOAT      CONSTANT dba.type_support.T_FLOAT%type            := 3.402823466E+38;                             
   v_REAL       CONSTANT dba.type_support.T_REAL%type             := 3.402823466E+38;                             
   v_DOUBLE     CONSTANT dba.type_support.T_DOUBLE%type           := 1.7976931348623157E+307;                     
   v_DATE       CONSTANT dba.type_support.T_DATE%type             := '9999-12-31';                                
   v_TIME       CONSTANT dba.type_support.T_TIME%type             := TIME '23:59:59';                             
   v_TIMESTAMP  CONSTANT dba.type_support.T_TIMESTAMP%type        := '2038-01-19 03:14:07';                       
   v_DATETIME   CONSTANT dba.type_support.T_DATETIME%type         := '9999-12-31 23:59:59.999';                   
   v_CHAR       CONSTANT dba.type_support.T_CHAR%type             := '1234567890abcdef';                          
   v_VARCHAR    CONSTANT dba.type_support.T_VARCHAR%type          := '1234567890abcdef';                          
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
end;

call type_support();


-- %type, constant, variable %type 
EVALUATE '%type, constant, variable %type';
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

   v_SHORT2     CONSTANT v_SHORT%type            := 32767;                                    
   v_SMALLINT2  CONSTANT v_SMALLINT%type         := 32767;                                    
   v_INTEGER2   CONSTANT v_INTEGER%type          := 2147483647;                               
   v_INT2       CONSTANT v_INT%type              := 2147483647;                               
   v_BIGINT2    CONSTANT v_BIGINT%type           := 9223372036854775807;                      
   v_NUMERIC2   CONSTANT v_NUMERIC%type          := 9876543210987654321098.7654321098765432;  
   v_DECIMAL2   CONSTANT v_DECIMAL%type          := 987654321054321;                          
   v_FLOAT2     CONSTANT v_FLOAT%type            := 3.402823466E+38;                          
   v_REAL2      CONSTANT v_REAL%type             := 3.402823466E+38;                          
   v_DOUBLE2    CONSTANT v_DOUBLE%type           := 1.7976931348623157E+307;                  
   v_DATE2      CONSTANT v_DATE%type             := '9999-12-31';                             
   v_TIME2      CONSTANT v_TIME%type             := TIME '23:59:59';                          
   v_TIMESTAMP2 CONSTANT v_TIMESTAMP%type        := '2038-01-19 03:14:07';                    
   v_DATETIME2  CONSTANT v_DATETIME%type         := '9999-12-31 23:59:59.999'; 
   v_CHAR2      CONSTANT v_CHAR%type             := '1234567890abcdef';          
   v_VARCHAR2   CONSTANT v_VARCHAR%type          := '1234567890abcdef';          
   
begin 
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


-- %type, constant, variable%type, user schema
EVALUATE '%type, constant, variable%type, user schema';
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
   
   v_SHORT2     CONSTANT v_SHORT%type         := 32767;                                    
   v_SMALLINT2  CONSTANT v_SMALLINT%type      := 32767;                                    
   v_INTEGER2   CONSTANT v_INTEGER%type       := 2147483647;                               
   v_INT2       CONSTANT v_INT%type           := 2147483647;                               
   v_BIGINT2    CONSTANT v_BIGINT%type        := 9223372036854775807;                      
   v_NUMERIC2   CONSTANT v_NUMERIC%type       := 9876543210987654321098.7654321098765432;  
   v_DECIMAL2   CONSTANT v_DECIMAL%type       := 987654321054321;                          
   v_FLOAT2     CONSTANT v_FLOAT%type         := 3.402823466E+38;                          
   v_REAL2      CONSTANT v_REAL%type          := 3.402823466E+38;                          
   v_DOUBLE2    CONSTANT v_DOUBLE%type        := 1.7976931348623157E+307;                  
   v_DATE2      CONSTANT v_DATE%type          := '9999-12-31';                             
   v_TIME2      CONSTANT v_TIME%type          := TIME '23:59:59';                          
   v_TIMESTAMP2 CONSTANT v_TIMESTAMP%type     := '2038-01-19 03:14:07';                    
   v_DATETIME2  CONSTANT v_DATETIME%type      := '9999-12-31 23:59:59.999';                
   v_CHAR2      CONSTANT v_CHAR%type          := '1234567890abcdef';                       
   v_VARCHAR2   CONSTANT v_VARCHAR%type       := '1234567890abcdef';                       
   
begin 
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

drop table  type_support ;

--+ server-message off

