/**
 *  This test case verifies CBRD-25111: a PL/CSQL reserved word cannot be used as an exception name.
 *
 *  Each case creates a procedure that declares an exception named after one reserved word,
 *  and the create fails.
 *
 *  Coverage:
 *    Case 1:   reserved word AND as an exception name fails to compile
 *    Case 2:   reserved word AS as an exception name fails to compile
 *    Case 3:   reserved word BETWEEN as an exception name fails to compile
 *    Case 4:   reserved word BIGINT as an exception name fails to compile
 *    Case 5:   reserved word BOOLEAN as an exception name fails to compile
 *    Case 6:   reserved word BY as an exception name fails to compile
 *    Case 7:   reserved word CHAR as an exception name fails to compile
 *    Case 8:   reserved word CLOSE as an exception name fails to compile
 *    Case 9:   reserved word COMMIT as an exception name fails to compile
 *    Case 10:  reserved word CONSTANT as an exception name fails to compile
 *    Case 11:  reserved word CONTINUE as an exception name fails to compile
 *    Case 12:  reserved word CREATE as an exception name fails to compile
 *    Case 13:  reserved word CURSOR as an exception name fails to compile
 *    Case 14:  reserved word DATE as an exception name fails to compile
 *    Case 15:  reserved word DATETIME as an exception name fails to compile
 *    Case 16:  reserved word DATETIMELTZ as an exception name fails to compile
 *    Case 17:  reserved word DATETIMETZ as an exception name fails to compile
 *    Case 18:  reserved word DEC as an exception name fails to compile
 *    Case 19:  reserved word DECIMAL as an exception name fails to compile
 *    Case 20:  reserved word DECLARE as an exception name fails to compile
 *    Case 21:  reserved word DEFAULT as an exception name fails to compile
 *    Case 22:  reserved word DIV as an exception name fails to compile
 *    Case 23:  reserved word DOUBLE as an exception name fails to compile
 *    Case 24:  reserved word ELSE as an exception name fails to compile
 *    Case 25:  reserved word ELSIF as an exception name fails to compile
 *    Case 26:  reserved word END as an exception name fails: END closes the routine early and the rest fails as separate statements
 *    Case 27:  reserved word ESCAPE as an exception name fails to compile
 *    Case 28:  reserved word EXCEPTION as an exception name fails to compile
 *    Case 29:  reserved word EXECUTE as an exception name fails to compile
 *    Case 30:  reserved word EXIT as an exception name fails to compile
 *    Case 31:  reserved word FALSE as an exception name fails to compile
 *    Case 32:  reserved word FETCH as an exception name fails to compile
 *    Case 33:  reserved word FLOAT as an exception name fails to compile
 *    Case 34:  reserved word FOR as an exception name fails to compile
 *    Case 35:  reserved word IMMEDIATE as an exception name fails to compile
 *    Case 36:  reserved word IN as an exception name fails to compile
 *    Case 37:  reserved word INT as an exception name fails to compile
 *    Case 38:  reserved word INTEGER as an exception name fails to compile
 *    Case 39:  reserved word INTO as an exception name fails to compile
 *    Case 40:  reserved word IS as an exception name fails to compile
 *    Case 41:  reserved word LIKE as an exception name fails to compile
 *    Case 42:  reserved word LIST as an exception name fails to compile
 *    Case 43:  reserved word MOD as an exception name fails to compile
 *    Case 44:  reserved word MULTISET as an exception name fails to compile
 *    Case 45:  reserved word NOT as an exception name fails to compile
 *    Case 46:  reserved word NULL as an exception name fails to compile
 *    Case 47:  reserved word NUMERIC as an exception name fails to compile
 *    Case 48:  reserved word OPEN as an exception name fails to compile
 *    Case 49:  reserved word OR as an exception name fails to compile
 *    Case 50:  reserved word OUT as an exception name fails to compile
 *    Case 51:  reserved word PRAGMA as an exception name fails to compile
 *    Case 52:  reserved word RAISE as an exception name fails to compile
 *    Case 53:  reserved word REAL as an exception name fails to compile
 *    Case 54:  reserved word REPLACE as an exception name fails to compile
 *    Case 55:  reserved word RETURN as an exception name fails to compile
 *    Case 56:  reserved word REVERSE as an exception name fails to compile
 *    Case 57:  reserved word ROLLBACK as an exception name fails to compile
 *    Case 58:  reserved word SEQUENCE as an exception name fails to compile
 *    Case 59:  reserved word SET as an exception name fails to compile
 *    Case 60:  reserved word SETEQ as an exception name fails to compile
 *    Case 61:  reserved word SETNEQ as an exception name fails to compile
 *    Case 62:  reserved word SHORT as an exception name fails to compile
 *    Case 63:  reserved word SMALLINT as an exception name fails to compile
 *    Case 64:  reserved word SQL as an exception name fails to compile
 *    Case 65:  reserved word STRING as an exception name fails to compile
 *    Case 66:  reserved word SUBSET as an exception name fails to compile
 *    Case 67:  reserved word SUBSETEQ as an exception name fails to compile
 *    Case 68:  reserved word SUPERSET as an exception name fails to compile
 *    Case 69:  reserved word SUPERSETEQ as an exception name fails to compile
 *    Case 70:  reserved word SYS_REFCURSOR as an exception name fails to compile
 *    Case 71:  reserved word THEN as an exception name fails to compile
 *    Case 72:  reserved word TIME as an exception name fails to compile
 *    Case 73:  reserved word TIMESTAMP as an exception name fails to compile
 *    Case 74:  reserved word TIMESTAMPLTZ as an exception name fails to compile
 *    Case 75:  reserved word TIMESTAMPTZ as an exception name fails to compile
 *    Case 76:  reserved word TRUE as an exception name fails to compile
 *    Case 77:  reserved word USING as an exception name fails to compile
 *    Case 78:  reserved word VARCHAR as an exception name fails to compile
 *    Case 79:  reserved word WHEN as an exception name fails to compile
 *    Case 80:  reserved word WHILE as an exception name fails to compile
 *    Case 81:  reserved word WORK as an exception name fails to compile
 *    Case 82:  reserved word XOR as an exception name fails to compile
 *    Case 83:  reserved word INSERT as an exception name fails to compile
 *    Case 84:  reserved word TRUNCATE as an exception name fails to compile
 *    Case 85:  reserved word AUTONOMOUS_TRANSACTION as an exception name fails to compile
 *    Case 86:  reserved word BEGIN as an exception name fails to compile
 */

--+ server-message on

evaluate 'Case 1: reserved word AND as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
AND EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE AND;
    end if;
EXCEPTION    WHEN AND THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 2: reserved word AS as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
AS EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE AS;
    end if;
EXCEPTION    WHEN AS THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 3: reserved word BETWEEN as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
BETWEEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BETWEEN;
    end if;
EXCEPTION    WHEN BETWEEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 4: reserved word BIGINT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
BIGINT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BIGINT;
    end if;
EXCEPTION    WHEN BIGINT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 5: reserved word BOOLEAN as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
BOOLEAN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BOOLEAN;
    end if;
EXCEPTION    WHEN BOOLEAN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 6: reserved word BY as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
BY EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE BY;
    end if;
EXCEPTION    WHEN BY THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 7: reserved word CHAR as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
CHAR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CHAR;
    end if;
EXCEPTION    WHEN CHAR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 8: reserved word CLOSE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
CLOSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CLOSE;
    end if;
EXCEPTION    WHEN CLOSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 9: reserved word COMMIT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
COMMIT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE COMMIT;
    end if;
EXCEPTION    WHEN COMMIT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 10: reserved word CONSTANT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
CONSTANT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CONSTANT;
    end if;
EXCEPTION    WHEN CONSTANT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 11: reserved word CONTINUE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
CONTINUE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CONTINUE;
    end if;
EXCEPTION    WHEN CONTINUE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 12: reserved word CREATE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
CREATE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CREATE;
    end if;
EXCEPTION    WHEN CREATE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 13: reserved word CURSOR as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
CURSOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE CURSOR;
    end if;
EXCEPTION    WHEN CURSOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 14: reserved word DATE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DATE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATE;
    end if;
EXCEPTION    WHEN DATE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 15: reserved word DATETIME as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DATETIME EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATETIME;
    end if;
EXCEPTION    WHEN DATETIME THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 16: reserved word DATETIMELTZ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DATETIMELTZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATETIMELTZ;
    end if;
EXCEPTION    WHEN DATETIMELTZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 17: reserved word DATETIMETZ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DATETIMETZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DATETIMETZ;
    end if;
EXCEPTION    WHEN DATETIMETZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 18: reserved word DEC as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DEC EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DEC;
    end if;
EXCEPTION    WHEN DEC THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 19: reserved word DECIMAL as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DECIMAL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DECIMAL;
    end if;
EXCEPTION    WHEN DECIMAL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 20: reserved word DECLARE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DECLARE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DECLARE;
    end if;
EXCEPTION    WHEN DECLARE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 21: reserved word DEFAULT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DEFAULT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DEFAULT;
    end if;
EXCEPTION    WHEN DEFAULT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 22: reserved word DIV as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DIV EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DIV;
    end if;
EXCEPTION    WHEN DIV THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 23: reserved word DOUBLE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
DOUBLE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE DOUBLE;
    end if;
EXCEPTION    WHEN DOUBLE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 24: reserved word ELSE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
ELSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ELSE;
    end if;
EXCEPTION    WHEN ELSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 25: reserved word ELSIF as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
ELSIF EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ELSIF;
    end if;
EXCEPTION    WHEN ELSIF THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 26: reserved word END as an exception name fails: END closes the routine early and the rest fails as separate statements; result = Error:-493';
create or replace procedure p_var(i int) as 
END EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE END;
    end if;
EXCEPTION    WHEN END THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 27: reserved word ESCAPE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
ESCAPE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ESCAPE;
    end if;
EXCEPTION    WHEN ESCAPE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 28: reserved word EXCEPTION as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
EXCEPTION EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE EXCEPTION;
    end if;
EXCEPTION    WHEN EXCEPTION THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 29: reserved word EXECUTE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
EXECUTE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE EXECUTE;
    end if;
EXCEPTION    WHEN EXECUTE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 30: reserved word EXIT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
EXIT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE EXIT;
    end if;
EXCEPTION    WHEN EXIT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 31: reserved word FALSE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
FALSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FALSE;
    end if;
EXCEPTION    WHEN FALSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 32: reserved word FETCH as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
FETCH EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FETCH;
    end if;
EXCEPTION    WHEN FETCH THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 33: reserved word FLOAT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
FLOAT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FLOAT;
    end if;
EXCEPTION    WHEN FLOAT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 34: reserved word FOR as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
FOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE FOR;
    end if;
EXCEPTION    WHEN FOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 35: reserved word IMMEDIATE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
IMMEDIATE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE IMMEDIATE;
    end if;
EXCEPTION    WHEN IMMEDIATE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 36: reserved word IN as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
IN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE IN;
    end if;
EXCEPTION    WHEN IN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 37: reserved word INT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
INT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE INT;
    end if;
EXCEPTION    WHEN INT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 38: reserved word INTEGER as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
INTEGER EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE INTEGER;
    end if;
EXCEPTION    WHEN INTEGER THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 39: reserved word INTO as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
INTO EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE INTO;
    end if;
EXCEPTION    WHEN INTO THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 40: reserved word IS as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
IS EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE IS;
    end if;
EXCEPTION    WHEN IS THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 41: reserved word LIKE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
LIKE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE LIKE;
    end if;
EXCEPTION    WHEN LIKE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 42: reserved word LIST as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
LIST EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE LIST;
    end if;
EXCEPTION    WHEN LIST THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 43: reserved word MOD as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
MOD EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE MOD;
    end if;
EXCEPTION    WHEN MOD THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 44: reserved word MULTISET as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
MULTISET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE MULTISET;
    end if;
EXCEPTION    WHEN MULTISET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 45: reserved word NOT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
NOT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE NOT;
    end if;
EXCEPTION    WHEN NOT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 46: reserved word NULL as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
NULL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE NULL;
    end if;
EXCEPTION    WHEN NULL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 47: reserved word NUMERIC as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
NUMERIC EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE NUMERIC;
    end if;
EXCEPTION    WHEN NUMERIC THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 48: reserved word OPEN as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
OPEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE OPEN;
    end if;
EXCEPTION    WHEN OPEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 49: reserved word OR as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
OR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE OR;
    end if;
EXCEPTION    WHEN OR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 50: reserved word OUT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
OUT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE OUT;
    end if;
EXCEPTION    WHEN OUT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 51: reserved word PRAGMA as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
PRAGMA EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE PRAGMA;
    end if;
EXCEPTION    WHEN PRAGMA THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 52: reserved word RAISE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
RAISE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE RAISE;
    end if;
EXCEPTION    WHEN RAISE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 53: reserved word REAL as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
REAL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE REAL;
    end if;
EXCEPTION    WHEN REAL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 54: reserved word REPLACE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
REPLACE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE REPLACE;
    end if;
EXCEPTION    WHEN REPLACE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 55: reserved word RETURN as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
RETURN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE RETURN;
    end if;
EXCEPTION    WHEN RETURN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 56: reserved word REVERSE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
REVERSE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE REVERSE;
    end if;
EXCEPTION    WHEN REVERSE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 57: reserved word ROLLBACK as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
ROLLBACK EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE ROLLBACK;
    end if;
EXCEPTION    WHEN ROLLBACK THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 58: reserved word SEQUENCE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SEQUENCE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SEQUENCE;
    end if;
EXCEPTION    WHEN SEQUENCE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 59: reserved word SET as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SET;
    end if;
EXCEPTION    WHEN SET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 60: reserved word SETEQ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SETEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SETEQ;
    end if;
EXCEPTION    WHEN SETEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 61: reserved word SETNEQ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SETNEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SETNEQ;
    end if;
EXCEPTION    WHEN SETNEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 62: reserved word SHORT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SHORT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SHORT;
    end if;
EXCEPTION    WHEN SHORT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 63: reserved word SMALLINT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SMALLINT EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SMALLINT;
    end if;
EXCEPTION    WHEN SMALLINT THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 64: reserved word SQL as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SQL EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SQL;
    end if;
EXCEPTION    WHEN SQL THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 65: reserved word STRING as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
STRING EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE STRING;
    end if;
EXCEPTION    WHEN STRING THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 66: reserved word SUBSET as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SUBSET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUBSET;
    end if;
EXCEPTION    WHEN SUBSET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 67: reserved word SUBSETEQ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SUBSETEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUBSETEQ;
    end if;
EXCEPTION    WHEN SUBSETEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 68: reserved word SUPERSET as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SUPERSET EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUPERSET;
    end if;
EXCEPTION    WHEN SUPERSET THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 69: reserved word SUPERSETEQ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SUPERSETEQ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SUPERSETEQ;
    end if;
EXCEPTION    WHEN SUPERSETEQ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 70: reserved word SYS_REFCURSOR as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
SYS_REFCURSOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE SYS_REFCURSOR;
    end if;
EXCEPTION    WHEN SYS_REFCURSOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 71: reserved word THEN as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
THEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE THEN;
    end if;
EXCEPTION    WHEN THEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 72: reserved word TIME as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
TIME EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIME;
    end if;
EXCEPTION    WHEN TIME THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 73: reserved word TIMESTAMP as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
TIMESTAMP EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIMESTAMP;
    end if;
EXCEPTION    WHEN TIMESTAMP THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 74: reserved word TIMESTAMPLTZ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
TIMESTAMPLTZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIMESTAMPLTZ;
    end if;
EXCEPTION    WHEN TIMESTAMPLTZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 75: reserved word TIMESTAMPTZ as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
TIMESTAMPTZ EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TIMESTAMPTZ;
    end if;
EXCEPTION    WHEN TIMESTAMPTZ THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 76: reserved word TRUE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
TRUE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE TRUE;
    end if;
EXCEPTION    WHEN TRUE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 77: reserved word USING as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
USING EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE USING;
    end if;
EXCEPTION    WHEN USING THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 78: reserved word VARCHAR as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
VARCHAR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE VARCHAR;
    end if;
EXCEPTION    WHEN VARCHAR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 79: reserved word WHEN as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
WHEN EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE WHEN;
    end if;
EXCEPTION    WHEN WHEN THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 80: reserved word WHILE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
WHILE EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE WHILE;
    end if;
EXCEPTION    WHEN WHILE THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 81: reserved word WORK as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
WORK EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE WORK;
    end if;
EXCEPTION    WHEN WORK THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 82: reserved word XOR as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as 
XOR EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE XOR;
    end if;
EXCEPTION    WHEN XOR THEN 
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 83: reserved word INSERT as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as
INSERT EXCEPTION;
begin
    IF i > 0 THEN
        RAISE INSERT;
    end if;
EXCEPTION    WHEN INSERT THEN
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 84: reserved word TRUNCATE as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as
TRUNCATE EXCEPTION;
begin
    IF i > 0 THEN
        RAISE TRUNCATE;
    end if;
EXCEPTION    WHEN TRUNCATE THEN
              DBMS_OUTPUT.put_line('call exception: ');
end;

evaluate 'Case 85: reserved word AUTONOMOUS_TRANSACTION as an exception name fails to compile; result = Error:-1360';
create or replace procedure p_var(i int) as
AUTONOMOUS_TRANSACTION EXCEPTION;
begin
    IF i > 0 THEN
        RAISE AUTONOMOUS_TRANSACTION;
    end if;
EXCEPTION    WHEN AUTONOMOUS_TRANSACTION THEN
              DBMS_OUTPUT.put_line('call exception: ');
end;

-- BEGIN opens a block, so the end lines after this create belong to its statement
evaluate 'Case 86: reserved word BEGIN as an exception name fails to compile; result = Error:-1360';
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



-- every case fails, so p_var does not exist and this drop fails unless a case created it by mistake
drop procedure p_var;


--+ server-message off

