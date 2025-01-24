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





evaluate '01. table + %rowtype';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    
begin
    execute immediate 'select * from plcsql_support_tbl where ID=2' into r;
    dbms_output.put_line(r.id);
    r.ID := 20;
    dbms_output.put_line(r.id);

end;

call test_rowtype();


evaluate '02. cursor + %rowtype';
create or replace procedure test_rowtype as
    CURSOR c IS SELECT * from plcsql_support_tbl where ID=1;
    p c%ROWTYPE;
begin
    open c;
    fetch c into p;
    dbms_output.put_line(p.ID);
    close c;
    
    p.ID := 10;
    dbms_output.put_line(p.ID);
end;

call test_rowtype();


evaluate '03. table + %rowtype, cursor + %rowtype';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    
    CURSOR c IS SELECT * from plcsql_support_tbl where ID=1;
    p c%ROWTYPE;
    
begin
    open c;
    fetch c into r;
    dbms_output.put_line(r.ID);
    close c;
    
    r.ID := 10;
    dbms_output.put_line(r.ID);

    execute immediate 'select * from plcsql_support_tbl where ID=2' into p;
    dbms_output.put_line(p.id);
    p.ID := 20;
    dbms_output.put_line(p.id);

end;

call test_rowtype();



drop table plcsql_support_tbl ;
drop procedure test_rowtype;

--+ server-message off
