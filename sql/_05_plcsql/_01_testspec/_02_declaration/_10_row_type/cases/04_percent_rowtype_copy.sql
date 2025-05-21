--+ server-message on
-- verified the CBRD-25056
-- Support RECORD types and %ROWTYPE feature

create table plcsql_support_tbl (
ID INT,
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
T_VARCHAR VARCHAR(32),
T_VARCHAR_DATE VARCHAR(32),
T_VARCHAR_TIME VARCHAR(32),
T_VARCHAR_DATETIME VARCHAR(32),
T_VARCHAR_NUMBER VARCHAR(32)
);

insert into plcsql_support_tbl
(ID, T_SHORT, T_SMALLINT, T_INTEGER, T_INT, T_BIGINT, T_NUMERIC, T_DECIMAL, T_FLOAT, T_REAL, T_DOUBLE, 
T_DATE, T_TIME, T_TIMESTAMP, T_DATETIME, 
T_CHAR, T_VARCHAR, 
T_VARCHAR_DATE, T_VARCHAR_TIME, T_VARCHAR_DATETIME, T_VARCHAR_NUMBER
)
values
(1, -32767,-32767,-21474, -2147, -9223, 0.1, 0.1, -3.4028234, -3.402823, -1.7976931348623,
'0001-01-01', TIME'00:00:00', '1970-01-01 09:00:01', '0001-01-01 00:00:00.000',
'1234567890abcdef','1234567890abcdef', 
'09/01/2005', '05:05:05 pm', '09/01/2005 05:05:05 pm', '123' 
);

insert into plcsql_support_tbl
(ID, T_SHORT, T_SMALLINT, T_INTEGER, T_INT, T_BIGINT, T_NUMERIC, T_DECIMAL, T_FLOAT, T_REAL, T_DOUBLE, 
T_DATE, T_TIME, T_TIMESTAMP, T_DATETIME, 
T_CHAR, T_VARCHAR,
T_VARCHAR_DATE, T_VARCHAR_TIME, T_VARCHAR_DATETIME, T_VARCHAR_NUMBER
)
values
(2,32767, 32767, 21474, 2147, 9223, 987.432, 5432, 3.4028, 3.402823466, 3.402823,
'9999-12-31', TIME '23:59:59', '2038-01-19 03:14:07', '9999-12-31 23:59:59.999', 
'1234567890abcdef','1234567890abcdef',
'09/01/2019', '09:09:09 pm', '09/01/2019 09:09:09 pm', '567'
);



create table to_plcsql_support_tbl (
TO_ID INT,
TO_SHORT SHORT,
TO_SMALLINT SMALLINT,
TO_INTEGER INTEGER,
TO_INT INT,
TO_BIGINT BIGINT,
TO_NUMERIC NUMERIC(38,15),
TO_DECIMAL DECIMAL,
TO_FLOAT FLOAT,
TO_REAL REAL,
TO_DOUBLE DOUBLE,
TO_DATE DATE,
TO_TIME TIME,
TO_TIMESTAMP TIMESTAMP,
TO_DATETIME DATETIME,
TO_CHAR CHAR(32),
TO_VARCHAR VARCHAR(32),
TO_VARCHAR_DATE VARCHAR(32),
TO_VARCHAR_TIME VARCHAR(32),
TO_VARCHAR_DATETIME VARCHAR(32),
TO_VARCHAR_NUMBER VARCHAR(32)
);



evaluate '01. %rowtype copy( The column names are different. The column type is the same.)';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 to_plcsql_support_tbl%ROWTYPE;
    r3 to_plcsql_support_tbl%ROWTYPE;

begin
    r.ID                    := 5                          ; 
    r.T_SHORT               := 32767                      ;
    r.T_SMALLINT            := 32767                      ;
    r.T_INTEGER             := 21474                      ;
    r.T_INT                 := 2147                       ;
    r.T_BIGINT              := 9223                       ;
    r.T_NUMERIC             := 987.432                    ;
    r.T_DECIMAL             := 5432                       ;
    r.T_FLOAT               := 3.4028                     ;
    r.T_REAL                := 3.402823466                ;
    r.T_DOUBLE              := 3.402823                   ;
    r.T_DATE                := '9999-12-31'               ;
    r.T_TIME                := TIME '23:59:59'            ;
    r.T_TIMESTAMP           := '2038-01-19 03:14:07'      ;
    r.T_DATETIME            := '9999-12-31 23:59:59.999'  ;
    r.T_CHAR                := '1234567890abcdef'         ;
    r.T_VARCHAR             := '1234567890abcdef'         ;
    r.T_VARCHAR_DATE        := '09/01/2019'               ;
    r.T_VARCHAR_TIME        := '09:09:09 pm'              ;
    r.T_VARCHAR_DATETIME    := '09/01/2019 09:09:09 pm'   ;
    r.T_VARCHAR_NUMBER      := '567'                      ;

    r2 := r;
    
    INSERT INTO to_plcsql_support_tbl values r2;
    
    execute immediate 'select * from to_plcsql_support_tbl where TO_ID=5' into r3;
    dbms_output.put_line('TO_ID                => ' || r3.TO_ID                  );
    dbms_output.put_line('TO_SHORT             => ' || r3.TO_SHORT             );
    dbms_output.put_line('TO_SMALLINT          => ' || r3.TO_SMALLINT          );
    dbms_output.put_line('TO_INTEGER           => ' || r3.TO_INTEGER           );
    dbms_output.put_line('TO_INT               => ' || r3.TO_INT               );
    dbms_output.put_line('TO_BIGINT            => ' || r3.TO_BIGINT            );
    dbms_output.put_line('TO_NUMERIC           => ' || r3.TO_NUMERIC           );
    dbms_output.put_line('TO_DECIMAL           => ' || r3.TO_DECIMAL           );
    dbms_output.put_line('TO_FLOAT             => ' || r3.TO_FLOAT             );
    dbms_output.put_line('TO_REAL              => ' || r3.TO_REAL              );
    dbms_output.put_line('TO_DOUBLE            => ' || r3.TO_DOUBLE            );
    dbms_output.put_line('TO_DATE              => ' || r3.TO_DATE              );
    dbms_output.put_line('TO_TIME              => ' || r3.TO_TIME              );
    dbms_output.put_line('TO_TIMESTAMP         => ' || r3.TO_TIMESTAMP         );
    dbms_output.put_line('TO_DATETIME          => ' || r3.TO_DATETIME          );
    dbms_output.put_line('TO_CHAR              => ' || r3.TO_CHAR              );
    dbms_output.put_line('TO_VARCHAR           => ' || r3.TO_VARCHAR           );
    dbms_output.put_line('TO_VARCHAR_DATE      => ' || r3.TO_VARCHAR_DATE      );
    dbms_output.put_line('TO_VARCHAR_TIME      => ' || r3.TO_VARCHAR_TIME      );
    dbms_output.put_line('TO_VARCHAR_DATETIME  => ' || r3.TO_VARCHAR_DATETIME  );
    dbms_output.put_line('TO_VARCHAR_NUMBER    => ' || r3.TO_VARCHAR_NUMBER    );
end;

call test_rowtype();



evaluate '02. %rowtype copy( The column names are different. The column types are different.)';
create or replace procedure test_rowtype as
    from_r1 plcsql_support_tbl%ROWTYPE;
    from_r2 plcsql_support_tbl%ROWTYPE;
    from_r3 plcsql_support_tbl%ROWTYPE;
    
    to_r1 to_plcsql_support_tbl%ROWTYPE;
    to_r2 to_plcsql_support_tbl%ROWTYPE;

begin
    from_r1.ID                    := 6                          ; 
    from_r1.T_SHORT               := 32767                      ;
    from_r1.T_SMALLINT            := 32767                      ;
    from_r1.T_INTEGER             := 21474                      ;
    from_r1.T_INT                 := 2147                       ;
    from_r1.T_BIGINT              := 9223                       ;
    from_r1.T_NUMERIC             := 987.432                    ;
    from_r1.T_DECIMAL             := 5432                       ;
    from_r1.T_FLOAT               := 3.4028                     ;
    from_r1.T_REAL                := 3.402823466                ;
    from_r1.T_DOUBLE              := 3.402823                   ;
    from_r1.T_DATE                := '9999-12-31'               ;
    from_r1.T_TIME                := TIME '23:59:59'            ;
    from_r1.T_TIMESTAMP           := '2038-01-19 03:14:07'      ;
    from_r1.T_DATETIME            := '9999-12-31 23:59:59.999'  ;
    from_r1.T_CHAR                := '1234567890abcdef'         ;
    from_r1.T_VARCHAR             := '1234567890abcdef'         ;
    from_r1.T_VARCHAR_DATE        := '09/01/2019'               ;
    from_r1.T_VARCHAR_TIME        := '09:09:09 pm'              ;
    from_r1.T_VARCHAR_DATETIME    := '09/01/2019 09:09:09 pm'   ;
    from_r1.T_VARCHAR_NUMBER      := '567'                      ;

    to_r1 := from_r1;
    
    INSERT INTO to_plcsql_support_tbl values to_r1;
    
    execute immediate 'select * from to_plcsql_support_tbl where TO_ID=6' into from_r2;
    dbms_output.put_line('from_r2.ID                  => ' || from_r2.ID                );
    dbms_output.put_line('from_r2.T_SHORT             => ' || from_r2.T_SHORT             );
    dbms_output.put_line('from_r2.T_SMALLINT          => ' || from_r2.T_SMALLINT          );
    dbms_output.put_line('from_r2.T_INTEGER           => ' || from_r2.T_INTEGER           );
    dbms_output.put_line('from_r2.T_INT               => ' || from_r2.T_INT               );
    dbms_output.put_line('from_r2.T_BIGINT            => ' || from_r2.T_BIGINT            );
    dbms_output.put_line('from_r2.T_NUMERIC           => ' || from_r2.T_NUMERIC           );
    dbms_output.put_line('from_r2.T_DECIMAL           => ' || from_r2.T_DECIMAL           );
    dbms_output.put_line('from_r2.T_FLOAT             => ' || from_r2.T_FLOAT             );
    dbms_output.put_line('from_r2.T_REAL              => ' || from_r2.T_REAL              );
    dbms_output.put_line('from_r2.T_DOUBLE            => ' || from_r2.T_DOUBLE            );
    dbms_output.put_line('from_r2.T_DATE              => ' || from_r2.T_DATE              );
    dbms_output.put_line('from_r2.T_TIME              => ' || from_r2.T_TIME              );
    dbms_output.put_line('from_r2.T_TIMESTAMP         => ' || from_r2.T_TIMESTAMP         );
    dbms_output.put_line('from_r2.T_DATETIME          => ' || from_r2.T_DATETIME          );
    dbms_output.put_line('from_r2.T_CHAR              => ' || from_r2.T_CHAR              );
    dbms_output.put_line('from_r2.T_VARCHAR           => ' || from_r2.T_VARCHAR           );
    dbms_output.put_line('from_r2.T_VARCHAR_DATE      => ' || from_r2.T_VARCHAR_DATE      );
    dbms_output.put_line('from_r2.T_VARCHAR_TIME      => ' || from_r2.T_VARCHAR_TIME      );
    dbms_output.put_line('from_r2.T_VARCHAR_DATETIME  => ' || from_r2.T_VARCHAR_DATETIME  );
    dbms_output.put_line('from_r2.T_VARCHAR_NUMBER    => ' || from_r2.T_VARCHAR_NUMBER    );
    
    
    from_r3 := to_r1;
    
    dbms_output.put_line('from_r3.ID                => ' || from_r3.ID                );
    dbms_output.put_line('from_r3.T_SHORT             => ' || from_r3.T_SHORT             );
    dbms_output.put_line('from_r3.T_SMALLINT          => ' || from_r3.T_SMALLINT          );
    dbms_output.put_line('from_r3.T_INTEGER           => ' || from_r3.T_INTEGER           );
    dbms_output.put_line('from_r3.T_INT               => ' || from_r3.T_INT               );
    dbms_output.put_line('from_r3.T_BIGINT            => ' || from_r3.T_BIGINT            );
    dbms_output.put_line('from_r3.T_NUMERIC           => ' || from_r3.T_NUMERIC           );
    dbms_output.put_line('from_r3.T_DECIMAL           => ' || from_r3.T_DECIMAL           );
    dbms_output.put_line('from_r3.T_FLOAT             => ' || from_r3.T_FLOAT             );
    dbms_output.put_line('from_r3.T_REAL              => ' || from_r3.T_REAL              );
    dbms_output.put_line('from_r3.T_DOUBLE            => ' || from_r3.T_DOUBLE            );
    dbms_output.put_line('from_r3.T_DATE              => ' || from_r3.T_DATE              );
    dbms_output.put_line('from_r3.T_TIME              => ' || from_r3.T_TIME              );
    dbms_output.put_line('from_r3.T_TIMESTAMP         => ' || from_r3.T_TIMESTAMP         );
    dbms_output.put_line('from_r3.T_DATETIME          => ' || from_r3.T_DATETIME          );
    dbms_output.put_line('from_r3.T_CHAR              => ' || from_r3.T_CHAR              );
    dbms_output.put_line('from_r3.T_VARCHAR           => ' || from_r3.T_VARCHAR           );
    dbms_output.put_line('from_r3.T_VARCHAR_DATE      => ' || from_r3.T_VARCHAR_DATE      );
    dbms_output.put_line('from_r3.T_VARCHAR_TIME      => ' || from_r3.T_VARCHAR_TIME      );
    dbms_output.put_line('from_r3.T_VARCHAR_DATETIME  => ' || from_r3.T_VARCHAR_DATETIME  );
    dbms_output.put_line('from_r3.T_VARCHAR_NUMBER    => ' || from_r3.T_VARCHAR_NUMBER    );
    
end;

call test_rowtype();





drop table plcsql_support_tbl ;
drop table to_plcsql_support_tbl ;
drop procedure test_rowtype;

--+ server-message off
