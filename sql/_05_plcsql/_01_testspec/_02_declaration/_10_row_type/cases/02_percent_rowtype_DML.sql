--+ server-message on
-- verified the CBRD-25056, CBRD-25665
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


evaluate '01. INSERT + %rowtype';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    
begin
    r.ID                    := 3                          ; 
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

    INSERT INTO plcsql_support_tbl values r;
    
    execute immediate 'select * from plcsql_support_tbl where ID=3' into r2;
    dbms_output.put_line('ID                  => ' || r2.ID                  );
    dbms_output.put_line('T_SHORT             => ' || r2.T_SHORT             );
    dbms_output.put_line('T_SMALLINT          => ' || r2.T_SMALLINT          );
    dbms_output.put_line('T_INTEGER           => ' || r2.T_INTEGER           );
    dbms_output.put_line('T_INT               => ' || r2.T_INT               );
    dbms_output.put_line('T_BIGINT            => ' || r2.T_BIGINT            );
    dbms_output.put_line('T_NUMERIC           => ' || r2.T_NUMERIC           );
    dbms_output.put_line('T_DECIMAL           => ' || r2.T_DECIMAL           );
    dbms_output.put_line('T_FLOAT             => ' || r2.T_FLOAT             );
    dbms_output.put_line('T_REAL              => ' || r2.T_REAL              );
    dbms_output.put_line('T_DOUBLE            => ' || r2.T_DOUBLE            );
    dbms_output.put_line('T_DATE              => ' || r2.T_DATE              );
    dbms_output.put_line('T_TIME              => ' || r2.T_TIME              );
    dbms_output.put_line('T_TIMESTAMP         => ' || r2.T_TIMESTAMP         );
    dbms_output.put_line('T_DATETIME          => ' || r2.T_DATETIME          );
    dbms_output.put_line('T_CHAR              => ' || r2.T_CHAR              );
    dbms_output.put_line('T_VARCHAR           => ' || r2.T_VARCHAR           );
    dbms_output.put_line('T_VARCHAR_DATE      => ' || r2.T_VARCHAR_DATE      );
    dbms_output.put_line('T_VARCHAR_TIME      => ' || r2.T_VARCHAR_TIME      );
    dbms_output.put_line('T_VARCHAR_DATETIME  => ' || r2.T_VARCHAR_DATETIME  );
    dbms_output.put_line('T_VARCHAR_NUMBER    => ' || r2.T_VARCHAR_NUMBER    );
end;

call test_rowtype();


evaluate '02. UPDATE + %rowtype,  1row ';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    
begin
    r.ID                    := 3                          ; 
    r.T_SHORT               := 2767                      ;
    r.T_SMALLINT            := 2767                      ;
    r.T_INTEGER             := 1474                      ;
    r.T_INT                 := 147                       ;
    r.T_BIGINT              := 223                       ;
    r.T_NUMERIC             := 87.432                    ;
    r.T_DECIMAL             := 432                       ;
    r.T_FLOAT               := 3.028                     ;
    r.T_REAL                := 3.02823466                ;
    r.T_DOUBLE              := 3.02823                   ;
    r.T_DATE                := '0001-12-31'               ;
    r.T_TIME                := TIME '00:00:00'            ;
    r.T_TIMESTAMP           := '2037-01-19 03:14:07'      ;
    r.T_DATETIME            := '0001-12-31 23:59:59.999'  ;
    r.T_CHAR                := '234567890abcdef'         ;
    r.T_VARCHAR             := '234567890abcdef'         ;
    r.T_VARCHAR_DATE        := '08/01/2019'               ;
    r.T_VARCHAR_TIME        := '08:09:09 pm'              ;
    r.T_VARCHAR_DATETIME    := '08/01/2019 09:09:09 pm'   ;
    r.T_VARCHAR_NUMBER      := '67'                      ;

    UPDATE plcsql_support_tbl SET ROW = r WHERE ID=3;
    
    execute immediate 'select * from plcsql_support_tbl where ID=3' into r2;
    dbms_output.put_line('ID                  => ' || r2.ID                  );
    dbms_output.put_line('T_SHORT             => ' || r2.T_SHORT             );
    dbms_output.put_line('T_SMALLINT          => ' || r2.T_SMALLINT          );
    dbms_output.put_line('T_INTEGER           => ' || r2.T_INTEGER           );
    dbms_output.put_line('T_INT               => ' || r2.T_INT               );
    dbms_output.put_line('T_BIGINT            => ' || r2.T_BIGINT            );
    dbms_output.put_line('T_NUMERIC           => ' || r2.T_NUMERIC           );
    dbms_output.put_line('T_DECIMAL           => ' || r2.T_DECIMAL           );
    dbms_output.put_line('T_FLOAT             => ' || r2.T_FLOAT             );
    dbms_output.put_line('T_REAL              => ' || r2.T_REAL              );
    dbms_output.put_line('T_DOUBLE            => ' || r2.T_DOUBLE            );
    dbms_output.put_line('T_DATE              => ' || r2.T_DATE              );
    dbms_output.put_line('T_TIME              => ' || r2.T_TIME              );
    dbms_output.put_line('T_TIMESTAMP         => ' || r2.T_TIMESTAMP         );
    dbms_output.put_line('T_DATETIME          => ' || r2.T_DATETIME          );
    dbms_output.put_line('T_CHAR              => ' || r2.T_CHAR              );
    dbms_output.put_line('T_VARCHAR           => ' || r2.T_VARCHAR           );
    dbms_output.put_line('T_VARCHAR_DATE      => ' || r2.T_VARCHAR_DATE      );
    dbms_output.put_line('T_VARCHAR_TIME      => ' || r2.T_VARCHAR_TIME      );
    dbms_output.put_line('T_VARCHAR_DATETIME  => ' || r2.T_VARCHAR_DATETIME  );
    dbms_output.put_line('T_VARCHAR_NUMBER    => ' || r2.T_VARCHAR_NUMBER    );
end;

call test_rowtype();


evaluate '03. UPDATE + %rowtype,  3row ';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    cnt int; 
begin
    r.ID                    := 3                          ; 
    r.T_SHORT               := 2767                      ;
    r.T_SMALLINT            := 2767                      ;
    r.T_INTEGER             := 1474                      ;
    r.T_INT                 := 147                       ;
    r.T_BIGINT              := 223                       ;
    r.T_NUMERIC             := 87.432                    ;
    r.T_DECIMAL             := 432                       ;
    r.T_FLOAT               := 3.028                     ;
    r.T_REAL                := 3.02823466                ;
    r.T_DOUBLE              := 3.02823                   ;
    r.T_DATE                := '0001-12-31'               ;
    r.T_TIME                := TIME '00:00:00'            ;
    r.T_TIMESTAMP           := '2037-01-19 03:14:07'      ;
    r.T_DATETIME            := '0001-12-31 23:59:59.999'  ;
    r.T_CHAR                := '234567890abcdef'         ;
    r.T_VARCHAR             := '234567890abcdef'         ;
    r.T_VARCHAR_DATE        := '08/01/2019'               ;
    r.T_VARCHAR_TIME        := '08:09:09 pm'              ;
    r.T_VARCHAR_DATETIME    := '08/01/2019 09:09:09 pm'   ;
    r.T_VARCHAR_NUMBER      := '67'                      ;

    UPDATE plcsql_support_tbl SET ROW = r;
    
    execute immediate 'select * from plcsql_support_tbl where ID=3 limit 1' into r2;
    dbms_output.put_line('ID                  => ' || r2.ID                  );
    dbms_output.put_line('T_SHORT             => ' || r2.T_SHORT             );
    dbms_output.put_line('T_SMALLINT          => ' || r2.T_SMALLINT          );
    dbms_output.put_line('T_INTEGER           => ' || r2.T_INTEGER           );
    dbms_output.put_line('T_INT               => ' || r2.T_INT               );
    dbms_output.put_line('T_BIGINT            => ' || r2.T_BIGINT            );
    dbms_output.put_line('T_NUMERIC           => ' || r2.T_NUMERIC           );
    dbms_output.put_line('T_DECIMAL           => ' || r2.T_DECIMAL           );
    dbms_output.put_line('T_FLOAT             => ' || r2.T_FLOAT             );
    dbms_output.put_line('T_REAL              => ' || r2.T_REAL              );
    dbms_output.put_line('T_DOUBLE            => ' || r2.T_DOUBLE            );
    dbms_output.put_line('T_DATE              => ' || r2.T_DATE              );
    dbms_output.put_line('T_TIME              => ' || r2.T_TIME              );
    dbms_output.put_line('T_TIMESTAMP         => ' || r2.T_TIMESTAMP         );
    dbms_output.put_line('T_DATETIME          => ' || r2.T_DATETIME          );
    dbms_output.put_line('T_CHAR              => ' || r2.T_CHAR              );
    dbms_output.put_line('T_VARCHAR           => ' || r2.T_VARCHAR           );
    dbms_output.put_line('T_VARCHAR_DATE      => ' || r2.T_VARCHAR_DATE      );
    dbms_output.put_line('T_VARCHAR_TIME      => ' || r2.T_VARCHAR_TIME      );
    dbms_output.put_line('T_VARCHAR_DATETIME  => ' || r2.T_VARCHAR_DATETIME  );
    dbms_output.put_line('T_VARCHAR_NUMBER    => ' || r2.T_VARCHAR_NUMBER    );

    execute immediate 'select count(*) cnt from plcsql_support_tbl where ID=3' into cnt;
    dbms_output.put_line('record count(*)    => ' || cnt                  );
end;

call test_rowtype();


evaluate '04. INSERT + %rowtype + column';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    
begin
    r.ID                    := 4                          ; 
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

    INSERT INTO plcsql_support_tbl 
      values(r.ID                ,
             r.T_SHORT           ,
             r.T_SMALLINT        ,
             r.T_INTEGER         ,
             r.T_INT             ,
             r.T_BIGINT          ,
             r.T_NUMERIC         ,
             r.T_DECIMAL         ,
             r.T_FLOAT           ,
             r.T_REAL            ,
             r.T_DOUBLE          ,
             r.T_DATE            ,
             r.T_TIME            ,
             r.T_TIMESTAMP       ,
             r.T_DATETIME        ,
             r.T_CHAR            ,
             r.T_VARCHAR         ,
             r.T_VARCHAR_DATE    ,
             r.T_VARCHAR_TIME    ,
             r.T_VARCHAR_DATETIME,
             r.T_VARCHAR_NUMBER   
            );
    
    execute immediate 'select * from plcsql_support_tbl where ID=4' 
        into r2.ID                ,
             r2.T_SHORT           ,
             r2.T_SMALLINT        ,
             r2.T_INTEGER         ,
             r2.T_INT             ,
             r2.T_BIGINT          ,
             r2.T_NUMERIC         ,
             r2.T_DECIMAL         ,
             r2.T_FLOAT           ,
             r2.T_REAL            ,
             r2.T_DOUBLE          ,
             r2.T_DATE            ,
             r2.T_TIME            ,
             r2.T_TIMESTAMP       ,
             r2.T_DATETIME        ,
             r2.T_CHAR            ,
             r2.T_VARCHAR         ,
             r2.T_VARCHAR_DATE    ,
             r2.T_VARCHAR_TIME    ,
             r2.T_VARCHAR_DATETIME,
             r2.T_VARCHAR_NUMBER   ;
    dbms_output.put_line('ID                  => ' || r2.ID                  );
    dbms_output.put_line('T_SHORT             => ' || r2.T_SHORT             );
    dbms_output.put_line('T_SMALLINT          => ' || r2.T_SMALLINT          );
    dbms_output.put_line('T_INTEGER           => ' || r2.T_INTEGER           );
    dbms_output.put_line('T_INT               => ' || r2.T_INT               );
    dbms_output.put_line('T_BIGINT            => ' || r2.T_BIGINT            );
    dbms_output.put_line('T_NUMERIC           => ' || r2.T_NUMERIC           );
    dbms_output.put_line('T_DECIMAL           => ' || r2.T_DECIMAL           );
    dbms_output.put_line('T_FLOAT             => ' || r2.T_FLOAT             );
    dbms_output.put_line('T_REAL              => ' || r2.T_REAL              );
    dbms_output.put_line('T_DOUBLE            => ' || r2.T_DOUBLE            );
    dbms_output.put_line('T_DATE              => ' || r2.T_DATE              );
    dbms_output.put_line('T_TIME              => ' || r2.T_TIME              );
    dbms_output.put_line('T_TIMESTAMP         => ' || r2.T_TIMESTAMP         );
    dbms_output.put_line('T_DATETIME          => ' || r2.T_DATETIME          );
    dbms_output.put_line('T_CHAR              => ' || r2.T_CHAR              );
    dbms_output.put_line('T_VARCHAR           => ' || r2.T_VARCHAR           );
    dbms_output.put_line('T_VARCHAR_DATE      => ' || r2.T_VARCHAR_DATE      );
    dbms_output.put_line('T_VARCHAR_TIME      => ' || r2.T_VARCHAR_TIME      );
    dbms_output.put_line('T_VARCHAR_DATETIME  => ' || r2.T_VARCHAR_DATETIME  );
    dbms_output.put_line('T_VARCHAR_NUMBER    => ' || r2.T_VARCHAR_NUMBER    );
end;

call test_rowtype();


evaluate '05. UPDATE + %rowtype + column,  1row ';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    
begin
    r.ID                    := 4                          ; 
    r.T_SHORT               := 2767                      ;
    r.T_SMALLINT            := 2767                      ;
    r.T_INTEGER             := 1474                      ;
    r.T_INT                 := 147                       ;
    r.T_BIGINT              := 223                       ;
    r.T_NUMERIC             := 87.432                    ;
    r.T_DECIMAL             := 432                       ;
    r.T_FLOAT               := 3.028                     ;
    r.T_REAL                := 3.02823466                ;
    r.T_DOUBLE              := 3.02823                   ;
    r.T_DATE                := '0001-12-31'               ;
    r.T_TIME                := TIME '00:00:00'            ;
    r.T_TIMESTAMP           := '2037-01-19 03:14:07'      ;
    r.T_DATETIME            := '0001-12-31 23:59:59.999'  ;
    r.T_CHAR                := '234567890abcdef'         ;
    r.T_VARCHAR             := '234567890abcdef'         ;
    r.T_VARCHAR_DATE        := '08/01/2019'               ;
    r.T_VARCHAR_TIME        := '08:09:09 pm'              ;
    r.T_VARCHAR_DATETIME    := '08/01/2019 09:09:09 pm'   ;
    r.T_VARCHAR_NUMBER      := '67'                      ;

    UPDATE plcsql_support_tbl 
      SET ID                 = r.ID                ,
          T_SHORT            = r.T_SHORT           ,
          T_SMALLINT         = r.T_SMALLINT        ,
          T_INTEGER          = r.T_INTEGER         ,
          T_INT              = r.T_INT             ,
          T_BIGINT           = r.T_BIGINT          ,
          T_NUMERIC          = r.T_NUMERIC         ,
          T_DECIMAL          = r.T_DECIMAL         ,
          T_FLOAT            = r.T_FLOAT           ,
          T_REAL             = r.T_REAL            ,
          T_DOUBLE           = r.T_DOUBLE          ,
          T_DATE             = r.T_DATE            ,
          T_TIME             = r.T_TIME            ,
          T_TIMESTAMP        = r.T_TIMESTAMP       ,
          T_DATETIME         = r.T_DATETIME        ,
          T_CHAR             = r.T_CHAR            ,
          T_VARCHAR          = r.T_VARCHAR         ,
          T_VARCHAR_DATE     = r.T_VARCHAR_DATE    ,
          T_VARCHAR_TIME     = r.T_VARCHAR_TIME    ,
          T_VARCHAR_DATETIME = r.T_VARCHAR_DATETIME,
          T_VARCHAR_NUMBER   = r.T_VARCHAR_NUMBER   
    WHERE ID=4;
    
    execute immediate 'select * from plcsql_support_tbl where ID=4' into r2;
    dbms_output.put_line('ID                  => ' || r2.ID                  );
    dbms_output.put_line('T_SHORT             => ' || r2.T_SHORT             );
    dbms_output.put_line('T_SMALLINT          => ' || r2.T_SMALLINT          );
    dbms_output.put_line('T_INTEGER           => ' || r2.T_INTEGER           );
    dbms_output.put_line('T_INT               => ' || r2.T_INT               );
    dbms_output.put_line('T_BIGINT            => ' || r2.T_BIGINT            );
    dbms_output.put_line('T_NUMERIC           => ' || r2.T_NUMERIC           );
    dbms_output.put_line('T_DECIMAL           => ' || r2.T_DECIMAL           );
    dbms_output.put_line('T_FLOAT             => ' || r2.T_FLOAT             );
    dbms_output.put_line('T_REAL              => ' || r2.T_REAL              );
    dbms_output.put_line('T_DOUBLE            => ' || r2.T_DOUBLE            );
    dbms_output.put_line('T_DATE              => ' || r2.T_DATE              );
    dbms_output.put_line('T_TIME              => ' || r2.T_TIME              );
    dbms_output.put_line('T_TIMESTAMP         => ' || r2.T_TIMESTAMP         );
    dbms_output.put_line('T_DATETIME          => ' || r2.T_DATETIME          );
    dbms_output.put_line('T_CHAR              => ' || r2.T_CHAR              );
    dbms_output.put_line('T_VARCHAR           => ' || r2.T_VARCHAR           );
    dbms_output.put_line('T_VARCHAR_DATE      => ' || r2.T_VARCHAR_DATE      );
    dbms_output.put_line('T_VARCHAR_TIME      => ' || r2.T_VARCHAR_TIME      );
    dbms_output.put_line('T_VARCHAR_DATETIME  => ' || r2.T_VARCHAR_DATETIME  );
    dbms_output.put_line('T_VARCHAR_NUMBER    => ' || r2.T_VARCHAR_NUMBER    );
end;

call test_rowtype();



drop table plcsql_support_tbl ;
drop procedure test_rowtype;

--+ server-message off
