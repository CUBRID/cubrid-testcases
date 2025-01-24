--+ server-message on
-- verified the CBRD-25056, CBRD-25666
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



evaluate '01. Compare the initial values of %rowtype variables.';
create or replace procedure test_rowtype as
    r plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r;
    
    CURSOR c IS SELECT * from plcsql_support_tbl where ID=1;
    p c%ROWTYPE;
    
begin
    if (r IS                NOT NULL ) AND 
       (r.id                 IS NULL ) AND 
       (r.T_SHORT            IS NULL ) AND 
       (r.T_SMALLINT         IS NULL ) AND 
       (r.T_INTEGER          IS NULL ) AND  
       (r.T_INT              IS NULL ) AND  
       (r.T_BIGINT           IS NULL ) AND  
       (r.T_NUMERIC          IS NULL ) AND  
       (r.T_DECIMAL          IS NULL ) AND  
       (r.T_FLOAT            IS NULL ) AND  
       (r.T_REAL             IS NULL ) AND  
       (r.T_DOUBLE           IS NULL ) AND  
       (r.T_DATE             IS NULL ) AND  
       (r.T_TIME             IS NULL ) AND  
       (r.T_TIMESTAMP        IS NULL ) AND  
       (r.T_DATETIME         IS NULL ) AND  
       (r.T_CHAR             IS NULL ) AND  
       (r.T_VARCHAR          IS NULL ) AND  
       (r.T_VARCHAR_DATE     IS NULL ) AND  
       (r.T_VARCHAR_TIME     IS NULL ) AND  
       (r.T_VARCHAR_DATETIME IS NULL ) AND  
       (r.T_VARCHAR_NUMBER   IS NULL )
    then
       dbms_output.put_line('r is not null');
       dbms_output.put_line('r.* columns is null');
    else
       dbms_output.put_line('r rowtype bug');
    end if;


    if (r2 IS                NOT NULL ) AND
       (r2.id                 IS NULL ) AND
       (r2.T_SHORT            IS NULL ) AND
       (r2.T_SMALLINT         IS NULL ) AND
       (r2.T_INTEGER          IS NULL ) AND
       (r2.T_INT              IS NULL ) AND
       (r2.T_BIGINT           IS NULL ) AND
       (r2.T_NUMERIC          IS NULL ) AND
       (r2.T_DECIMAL          IS NULL ) AND
       (r2.T_FLOAT            IS NULL ) AND
       (r2.T_REAL             IS NULL ) AND
       (r2.T_DOUBLE           IS NULL ) AND
       (r2.T_DATE             IS NULL ) AND
       (r2.T_TIME             IS NULL ) AND
       (r2.T_TIMESTAMP        IS NULL ) AND
       (r2.T_DATETIME         IS NULL ) AND
       (r2.T_CHAR             IS NULL ) AND
       (r2.T_VARCHAR          IS NULL ) AND
       (r2.T_VARCHAR_DATE     IS NULL ) AND
       (r2.T_VARCHAR_TIME     IS NULL ) AND
       (r2.T_VARCHAR_DATETIME IS NULL ) AND
       (r2.T_VARCHAR_NUMBER   IS NULL )
    then
       dbms_output.put_line('r2 is not null');
       dbms_output.put_line('r2.* columns is null');
    else
       dbms_output.put_line('r2 rowtype bug');
    end if;


    if (r3 IS                NOT NULL ) AND
       (r3.id                 IS NULL ) AND
       (r3.T_SHORT            IS NULL ) AND
       (r3.T_SMALLINT         IS NULL ) AND
       (r3.T_INTEGER          IS NULL ) AND
       (r3.T_INT              IS NULL ) AND
       (r3.T_BIGINT           IS NULL ) AND
       (r3.T_NUMERIC          IS NULL ) AND
       (r3.T_DECIMAL          IS NULL ) AND
       (r3.T_FLOAT            IS NULL ) AND
       (r3.T_REAL             IS NULL ) AND
       (r3.T_DOUBLE           IS NULL ) AND
       (r3.T_DATE             IS NULL ) AND
       (r3.T_TIME             IS NULL ) AND
       (r3.T_TIMESTAMP        IS NULL ) AND
       (r3.T_DATETIME         IS NULL ) AND
       (r3.T_CHAR             IS NULL ) AND
       (r3.T_VARCHAR          IS NULL ) AND
       (r3.T_VARCHAR_DATE     IS NULL ) AND
       (r3.T_VARCHAR_TIME     IS NULL ) AND
       (r3.T_VARCHAR_DATETIME IS NULL ) AND
       (r3.T_VARCHAR_NUMBER   IS NULL )
    then
       dbms_output.put_line('r3 is not null');
       dbms_output.put_line('r3.* columns is null');
    else
       dbms_output.put_line('r3 rowtype bug');
    end if;

    
    open c;
    
    if (p IS                NOT NULL ) AND
       (p.id                 IS NULL ) AND
       (p.T_SHORT            IS NULL ) AND
       (p.T_SMALLINT         IS NULL ) AND
       (p.T_INTEGER          IS NULL ) AND
       (p.T_INT              IS NULL ) AND
       (p.T_BIGINT           IS NULL ) AND
       (p.T_NUMERIC          IS NULL ) AND
       (p.T_DECIMAL          IS NULL ) AND
       (p.T_FLOAT            IS NULL ) AND
       (p.T_REAL             IS NULL ) AND
       (p.T_DOUBLE           IS NULL ) AND
       (p.T_DATE             IS NULL ) AND
       (p.T_TIME             IS NULL ) AND
       (p.T_TIMESTAMP        IS NULL ) AND
       (p.T_DATETIME         IS NULL ) AND
       (p.T_CHAR             IS NULL ) AND
       (p.T_VARCHAR          IS NULL ) AND
       (p.T_VARCHAR_DATE     IS NULL ) AND
       (p.T_VARCHAR_TIME     IS NULL ) AND
       (p.T_VARCHAR_DATETIME IS NULL ) AND
       (p.T_VARCHAR_NUMBER   IS NULL )
    then
       dbms_output.put_line('p is not null');
       dbms_output.put_line('p.* columns is null');
    else
       dbms_output.put_line('p rowtype bug');
    end if;
    close c;
    
end;

call test_rowtype();




evaluate '02. compare %rowtype variables.';
create or replace procedure test_rowtype as
    r1 plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
    r3 plcsql_support_tbl%ROWTYPE := r1;
    
    ur1 dual%ROWTYPE;
    ur2 dual%ROWTYPE;
    
begin
    if (r1 = r2) AND (r1 = r3) then
       dbms_output.put_line('r1 = r2 = r3, OK');
    else
       dbms_output.put_line('r1 != r2 != r3, NOK');
    end if;

    if (r1 != r2) AND (r1 != r3) then
       dbms_output.put_line('r1 != r2 != r3, NOK');
    else
       dbms_output.put_line('r1 = r2 = r3, OK');
    end if;
    
end;

call test_rowtype();


evaluate '03. compile error - Compare rowtype variables with <=>.';
create or replace procedure test_rowtype as
    r1 plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
begin
    if (r1 <=> r2) then
       dbms_output.put_line('r1 <=> r2');
    end if;
end;

evaluate '04. compile error - Compare rowtype variables with <.';
create or replace procedure test_rowtype as
    r1 plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
begin
    if (r1 < r2) then
       dbms_output.put_line('r1 < r2');
    end if;
end;

evaluate '05. compile error - Compare rowtype variables with >.';
create or replace procedure test_rowtype as
    r1 plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
begin
    if (r1 > r2) then
       dbms_output.put_line('r1 > r2');
    end if;
end;

evaluate '06. compile error - Compare rowtype variables with <=.';
create or replace procedure test_rowtype as
    r1 plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
begin
    if (r1 <= r2) then
       dbms_output.put_line('r1 <= r2');
    end if;
end;

evaluate '07. compile error - Compare rowtype variables with >=.';
create or replace procedure test_rowtype as
    r1 plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
begin
    if (r1 >= r2) then
       dbms_output.put_line('r1 >= r2');
    end if;
end;

evaluate '08. compile error - Compare rowtype variables with in.';
create or replace procedure test_rowtype as
    r1 plcsql_support_tbl%ROWTYPE;
    r2 dba.plcsql_support_tbl%ROWTYPE;
begin
    if (r1 in r2) then
       dbms_output.put_line('r1 in r2');
    end if;
end;



drop table plcsql_support_tbl ;
drop procedure test_rowtype;

--+ server-message off
