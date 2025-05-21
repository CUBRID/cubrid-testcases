--+ server-message on

-- Verification for CBRD-25111 


select 'AND' ;
create or replace procedure p_var(i int) as 
AND EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE AND;
    end if;
EXCEPTION    WHEN AND THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'AS' ;
create or replace procedure p_var(i int) as 
AS EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE AS;
    end if;
EXCEPTION    WHEN AS THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'BETWEEN' ;
create or replace procedure p_var(i int) as 
BETWEEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BETWEEN;
    end if;
EXCEPTION    WHEN BETWEEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'BIGINT' ;
create or replace procedure p_var(i int) as 
BIGINT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BIGINT;
    end if;
EXCEPTION    WHEN BIGINT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'BOOLEAN' ;
create or replace procedure p_var(i int) as 
BOOLEAN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BOOLEAN;
    end if;
EXCEPTION    WHEN BOOLEAN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'BY' ;
create or replace procedure p_var(i int) as 
BY EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BY;
    end if;
EXCEPTION    WHEN BY THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'CHAR' ;
create or replace procedure p_var(i int) as 
CHAR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CHAR;
    end if;
EXCEPTION    WHEN CHAR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'CLOSE' ;
create or replace procedure p_var(i int) as 
CLOSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CLOSE;
    end if;
EXCEPTION    WHEN CLOSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'COMMIT' ;
create or replace procedure p_var(i int) as 
COMMIT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE COMMIT;
    end if;
EXCEPTION    WHEN COMMIT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'CONSTANT' ;
create or replace procedure p_var(i int) as 
CONSTANT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CONSTANT;
    end if;
EXCEPTION    WHEN CONSTANT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'CONTINUE' ;
create or replace procedure p_var(i int) as 
CONTINUE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CONTINUE;
    end if;
EXCEPTION    WHEN CONTINUE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'CREATE' ;
create or replace procedure p_var(i int) as 
CREATE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CREATE;
    end if;
EXCEPTION    WHEN CREATE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'CURSOR' ;
create or replace procedure p_var(i int) as 
CURSOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CURSOR;
    end if;
EXCEPTION    WHEN CURSOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DATE' ;
create or replace procedure p_var(i int) as 
DATE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATE;
    end if;
EXCEPTION    WHEN DATE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DATETIME' ;
create or replace procedure p_var(i int) as 
DATETIME EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATETIME;
    end if;
EXCEPTION    WHEN DATETIME THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DATETIMELTZ' ;
create or replace procedure p_var(i int) as 
DATETIMELTZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATETIMELTZ;
    end if;
EXCEPTION    WHEN DATETIMELTZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DATETIMETZ' ;
create or replace procedure p_var(i int) as 
DATETIMETZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATETIMETZ;
    end if;
EXCEPTION    WHEN DATETIMETZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DEC' ;
create or replace procedure p_var(i int) as 
DEC EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DEC;
    end if;
EXCEPTION    WHEN DEC THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DECIMAL' ;
create or replace procedure p_var(i int) as 
DECIMAL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DECIMAL;
    end if;
EXCEPTION    WHEN DECIMAL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DECLARE' ;
create or replace procedure p_var(i int) as 
DECLARE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DECLARE;
    end if;
EXCEPTION    WHEN DECLARE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DEFAULT' ;
create or replace procedure p_var(i int) as 
DEFAULT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DEFAULT;
    end if;
EXCEPTION    WHEN DEFAULT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DIV' ;
create or replace procedure p_var(i int) as 
DIV EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DIV;
    end if;
EXCEPTION    WHEN DIV THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'DOUBLE' ;
create or replace procedure p_var(i int) as 
DOUBLE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DOUBLE;
    end if;
EXCEPTION    WHEN DOUBLE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'ELSE' ;
create or replace procedure p_var(i int) as 
ELSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ELSE;
    end if;
EXCEPTION    WHEN ELSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'ELSIF' ;
create or replace procedure p_var(i int) as 
ELSIF EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ELSIF;
    end if;
EXCEPTION    WHEN ELSIF THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'END' ;
create or replace procedure p_var(i int) as 
END EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE END;
    end if;
EXCEPTION    WHEN END THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'ESCAPE' ;
create or replace procedure p_var(i int) as 
ESCAPE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ESCAPE;
    end if;
EXCEPTION    WHEN ESCAPE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'EXCEPTION' ;
create or replace procedure p_var(i int) as 
EXCEPTION EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE EXCEPTION;
    end if;
EXCEPTION    WHEN EXCEPTION THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'EXECUTE' ;
create or replace procedure p_var(i int) as 
EXECUTE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE EXECUTE;
    end if;
EXCEPTION    WHEN EXECUTE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'EXIT' ;
create or replace procedure p_var(i int) as 
EXIT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE EXIT;
    end if;
EXCEPTION    WHEN EXIT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'FALSE' ;
create or replace procedure p_var(i int) as 
FALSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FALSE;
    end if;
EXCEPTION    WHEN FALSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'FETCH' ;
create or replace procedure p_var(i int) as 
FETCH EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FETCH;
    end if;
EXCEPTION    WHEN FETCH THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'FLOAT' ;
create or replace procedure p_var(i int) as 
FLOAT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FLOAT;
    end if;
EXCEPTION    WHEN FLOAT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'FOR' ;
create or replace procedure p_var(i int) as 
FOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FOR;
    end if;
EXCEPTION    WHEN FOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'IMMEDIATE' ;
create or replace procedure p_var(i int) as 
IMMEDIATE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE IMMEDIATE;
    end if;
EXCEPTION    WHEN IMMEDIATE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'IN' ;
create or replace procedure p_var(i int) as 
IN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE IN;
    end if;
EXCEPTION    WHEN IN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'INT' ;
create or replace procedure p_var(i int) as 
INT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE INT;
    end if;
EXCEPTION    WHEN INT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'INTEGER' ;
create or replace procedure p_var(i int) as 
INTEGER EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE INTEGER;
    end if;
EXCEPTION    WHEN INTEGER THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'INTO' ;
create or replace procedure p_var(i int) as 
INTO EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE INTO;
    end if;
EXCEPTION    WHEN INTO THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'IS' ;
create or replace procedure p_var(i int) as 
IS EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE IS;
    end if;
EXCEPTION    WHEN IS THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'LIKE' ;
create or replace procedure p_var(i int) as 
LIKE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE LIKE;
    end if;
EXCEPTION    WHEN LIKE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'LIST' ;
create or replace procedure p_var(i int) as 
LIST EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE LIST;
    end if;
EXCEPTION    WHEN LIST THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'MOD' ;
create or replace procedure p_var(i int) as 
MOD EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE MOD;
    end if;
EXCEPTION    WHEN MOD THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'MULTISET' ;
create or replace procedure p_var(i int) as 
MULTISET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE MULTISET;
    end if;
EXCEPTION    WHEN MULTISET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'NOT' ;
create or replace procedure p_var(i int) as 
NOT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE NOT;
    end if;
EXCEPTION    WHEN NOT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'NULL' ;
create or replace procedure p_var(i int) as 
NULL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE NULL;
    end if;
EXCEPTION    WHEN NULL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'NUMERIC' ;
create or replace procedure p_var(i int) as 
NUMERIC EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE NUMERIC;
    end if;
EXCEPTION    WHEN NUMERIC THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'OPEN' ;
create or replace procedure p_var(i int) as 
OPEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE OPEN;
    end if;
EXCEPTION    WHEN OPEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'OR' ;
create or replace procedure p_var(i int) as 
OR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE OR;
    end if;
EXCEPTION    WHEN OR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'OUT' ;
create or replace procedure p_var(i int) as 
OUT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE OUT;
    end if;
EXCEPTION    WHEN OUT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'PRAGMA' ;
create or replace procedure p_var(i int) as 
PRAGMA EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE PRAGMA;
    end if;
EXCEPTION    WHEN PRAGMA THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'RAISE' ;
create or replace procedure p_var(i int) as 
RAISE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE RAISE;
    end if;
EXCEPTION    WHEN RAISE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'REAL' ;
create or replace procedure p_var(i int) as 
REAL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE REAL;
    end if;
EXCEPTION    WHEN REAL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'REPLACE' ;
create or replace procedure p_var(i int) as 
REPLACE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE REPLACE;
    end if;
EXCEPTION    WHEN REPLACE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'RETURN' ;
create or replace procedure p_var(i int) as 
RETURN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE RETURN;
    end if;
EXCEPTION    WHEN RETURN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'REVERSE' ;
create or replace procedure p_var(i int) as 
REVERSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE REVERSE;
    end if;
EXCEPTION    WHEN REVERSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'ROLLBACK' ;
create or replace procedure p_var(i int) as 
ROLLBACK EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ROLLBACK;
    end if;
EXCEPTION    WHEN ROLLBACK THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SEQUENCE' ;
create or replace procedure p_var(i int) as 
SEQUENCE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SEQUENCE;
    end if;
EXCEPTION    WHEN SEQUENCE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SET' ;
create or replace procedure p_var(i int) as 
SET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SET;
    end if;
EXCEPTION    WHEN SET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SETEQ' ;
create or replace procedure p_var(i int) as 
SETEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SETEQ;
    end if;
EXCEPTION    WHEN SETEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SETNEQ' ;
create or replace procedure p_var(i int) as 
SETNEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SETNEQ;
    end if;
EXCEPTION    WHEN SETNEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SHORT' ;
create or replace procedure p_var(i int) as 
SHORT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SHORT;
    end if;
EXCEPTION    WHEN SHORT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SMALLINT' ;
create or replace procedure p_var(i int) as 
SMALLINT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SMALLINT;
    end if;
EXCEPTION    WHEN SMALLINT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SQL' ;
create or replace procedure p_var(i int) as 
SQL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SQL;
    end if;
EXCEPTION    WHEN SQL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'STRING' ;
create or replace procedure p_var(i int) as 
STRING EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE STRING;
    end if;
EXCEPTION    WHEN STRING THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SUBSET' ;
create or replace procedure p_var(i int) as 
SUBSET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUBSET;
    end if;
EXCEPTION    WHEN SUBSET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SUBSETEQ' ;
create or replace procedure p_var(i int) as 
SUBSETEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUBSETEQ;
    end if;
EXCEPTION    WHEN SUBSETEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SUPERSET' ;
create or replace procedure p_var(i int) as 
SUPERSET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUPERSET;
    end if;
EXCEPTION    WHEN SUPERSET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SUPERSETEQ' ;
create or replace procedure p_var(i int) as 
SUPERSETEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUPERSETEQ;
    end if;
EXCEPTION    WHEN SUPERSETEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'SYS_REFCURSOR' ;
create or replace procedure p_var(i int) as 
SYS_REFCURSOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SYS_REFCURSOR;
    end if;
EXCEPTION    WHEN SYS_REFCURSOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'THEN' ;
create or replace procedure p_var(i int) as 
THEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE THEN;
    end if;
EXCEPTION    WHEN THEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'TIME' ;
create or replace procedure p_var(i int) as 
TIME EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIME;
    end if;
EXCEPTION    WHEN TIME THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'TIMESTAMP' ;
create or replace procedure p_var(i int) as 
TIMESTAMP EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIMESTAMP;
    end if;
EXCEPTION    WHEN TIMESTAMP THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'TIMESTAMPLTZ' ;
create or replace procedure p_var(i int) as 
TIMESTAMPLTZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIMESTAMPLTZ;
    end if;
EXCEPTION    WHEN TIMESTAMPLTZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'TIMESTAMPTZ' ;
create or replace procedure p_var(i int) as 
TIMESTAMPTZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIMESTAMPTZ;
    end if;
EXCEPTION    WHEN TIMESTAMPTZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'TRUE' ;
create or replace procedure p_var(i int) as 
TRUE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TRUE;
    end if;
EXCEPTION    WHEN TRUE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'USING' ;
create or replace procedure p_var(i int) as 
USING EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE USING;
    end if;
EXCEPTION    WHEN USING THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'VARCHAR' ;
create or replace procedure p_var(i int) as 
VARCHAR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE VARCHAR;
    end if;
EXCEPTION    WHEN VARCHAR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'WHEN' ;
create or replace procedure p_var(i int) as 
WHEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE WHEN;
    end if;
EXCEPTION    WHEN WHEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'WHILE' ;
create or replace procedure p_var(i int) as 
WHILE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE WHILE;
    end if;
EXCEPTION    WHEN WHILE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'WORK' ;
create or replace procedure p_var(i int) as 
WORK EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE WORK;
    end if;
EXCEPTION    WHEN WORK THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'XOR' ;
create or replace procedure p_var(i int) as 
XOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE XOR;
    end if;
EXCEPTION    WHEN XOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'INSERT' ;
create or replace procedure p_var(i int) as
INSERT EXCEPTION;
begin
    IF i > 0 THEN
        RAISE INSERT;
    end if;
EXCEPTION    WHEN INSERT THEN
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'TRUNCATE' ;
create or replace procedure p_var(i int) as
TRUNCATE EXCEPTION;
begin
    IF i > 0 THEN
        RAISE TRUNCATE;
    end if;
EXCEPTION    WHEN TRUNCATE THEN
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'AUTONOMOUS_TRANSACTION' ;
create or replace procedure p_var(i int) as
AUTONOMOUS_TRANSACTION EXCEPTION;
begin
    IF i > 0 THEN
        RAISE AUTONOMOUS_TRANSACTION;
    end if;
EXCEPTION    WHEN AUTONOMOUS_TRANSACTION THEN
              DBMS_OUTPUT.put_line('call exception: ');
end;

select 'BEGIN' ;
create or replace procedure p_var(i int) as
BEGIN EXCEPTION;
begin
    IF i > 0 THEN
        RAISE BEGIN;
    end if;
EXCEPTION    WHEN BEGIN THEN
              DBMS_OUTPUT.put_line('call exception: ');
end;
end;
end;
end;



drop procedure p_var;


--+ server-message off

