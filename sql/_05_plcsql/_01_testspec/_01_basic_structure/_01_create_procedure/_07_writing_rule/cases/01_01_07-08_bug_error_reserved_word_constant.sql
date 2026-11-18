/**
 *  This test case verifies CBRD-25111: a PL/CSQL reserved word cannot be used as a constant name.
 *
 *  Each case creates a procedure that declares a constant named after one reserved word,
 *  and the create fails.
 *
 *  Coverage:
 *    Case 1:   reserved word AND as a constant name fails to compile
 *    Case 2:   reserved word AS as a constant name fails to compile
 *    Case 3:   reserved word BETWEEN as a constant name fails to compile
 *    Case 4:   reserved word BIGINT as a constant name fails to compile
 *    Case 5:   reserved word BOOLEAN as a constant name fails to compile
 *    Case 6:   reserved word BY as a constant name fails to compile
 *    Case 7:   reserved word CHAR as a constant name fails to compile
 *    Case 8:   reserved word CLOSE as a constant name fails to compile
 *    Case 9:   reserved word COMMIT as a constant name fails to compile
 *    Case 10:  reserved word CONSTANT as a constant name fails to compile
 *    Case 11:  reserved word CONTINUE as a constant name fails to compile
 *    Case 12:  reserved word CREATE as a constant name fails to compile
 *    Case 13:  reserved word CURSOR as a constant name fails to compile
 *    Case 14:  reserved word DATE as a constant name fails to compile
 *    Case 15:  reserved word DATETIME as a constant name fails to compile
 *    Case 16:  reserved word DATETIMELTZ as a constant name fails to compile
 *    Case 17:  reserved word DATETIMETZ as a constant name fails to compile
 *    Case 18:  reserved word DEC as a constant name fails to compile
 *    Case 19:  reserved word DECIMAL as a constant name fails to compile
 *    Case 20:  reserved word DECLARE as a constant name fails to compile
 *    Case 21:  reserved word DEFAULT as a constant name fails to compile
 *    Case 22:  reserved word DIV as a constant name fails to compile
 *    Case 23:  reserved word DOUBLE as a constant name fails to compile
 *    Case 24:  reserved word ELSE as a constant name fails to compile
 *    Case 25:  reserved word ELSIF as a constant name fails to compile
 *    Case 26:  reserved word END as a constant name fails: END closes the routine early and the rest fails as separate statements
 *    Case 27:  reserved word ESCAPE as a constant name fails to compile
 *    Case 28:  reserved word EXCEPTION as a constant name fails to compile
 *    Case 29:  reserved word EXECUTE as a constant name fails to compile
 *    Case 30:  reserved word EXIT as a constant name fails to compile
 *    Case 31:  reserved word FALSE as a constant name fails to compile
 *    Case 32:  reserved word FETCH as a constant name fails to compile
 *    Case 33:  reserved word FLOAT as a constant name fails to compile
 *    Case 34:  reserved word FOR as a constant name fails to compile
 *    Case 35:  reserved word IMMEDIATE as a constant name fails to compile
 *    Case 36:  reserved word IN as a constant name fails to compile
 *    Case 37:  reserved word INT as a constant name fails to compile
 *    Case 38:  reserved word INTEGER as a constant name fails to compile
 *    Case 39:  reserved word INTO as a constant name fails to compile
 *    Case 40:  reserved word IS as a constant name fails to compile
 *    Case 41:  reserved word LIKE as a constant name fails to compile
 *    Case 42:  reserved word LIST as a constant name fails to compile
 *    Case 43:  reserved word MOD as a constant name fails to compile
 *    Case 44:  reserved word MULTISET as a constant name fails to compile
 *    Case 45:  reserved word NOT as a constant name fails to compile
 *    Case 46:  reserved word NULL as a constant name fails to compile
 *    Case 47:  reserved word NUMERIC as a constant name fails to compile
 *    Case 48:  reserved word OPEN as a constant name fails to compile
 *    Case 49:  reserved word OR as a constant name fails to compile
 *    Case 50:  reserved word OUT as a constant name fails to compile
 *    Case 51:  reserved word PRAGMA as a constant name fails to compile
 *    Case 52:  reserved word RAISE as a constant name fails to compile
 *    Case 53:  reserved word REAL as a constant name fails to compile
 *    Case 54:  reserved word REPLACE as a constant name fails to compile
 *    Case 55:  reserved word RETURN as a constant name fails to compile
 *    Case 56:  reserved word REVERSE as a constant name fails to compile
 *    Case 57:  reserved word ROLLBACK as a constant name fails to compile
 *    Case 58:  reserved word SEQUENCE as a constant name fails to compile
 *    Case 59:  reserved word SET as a constant name fails to compile
 *    Case 60:  reserved word SETEQ as a constant name fails to compile
 *    Case 61:  reserved word SETNEQ as a constant name fails to compile
 *    Case 62:  reserved word SHORT as a constant name fails to compile
 *    Case 63:  reserved word SMALLINT as a constant name fails to compile
 *    Case 64:  reserved word SQL as a constant name fails to compile
 *    Case 65:  reserved word STRING as a constant name fails to compile
 *    Case 66:  reserved word SUBSET as a constant name fails to compile
 *    Case 67:  reserved word SUBSETEQ as a constant name fails to compile
 *    Case 68:  reserved word SUPERSET as a constant name fails to compile
 *    Case 69:  reserved word SUPERSETEQ as a constant name fails to compile
 *    Case 70:  reserved word SYS_REFCURSOR as a constant name fails to compile
 *    Case 71:  reserved word THEN as a constant name fails to compile
 *    Case 72:  reserved word TIME as a constant name fails to compile
 *    Case 73:  reserved word TIMESTAMP as a constant name fails to compile
 *    Case 74:  reserved word TIMESTAMPLTZ as a constant name fails to compile
 *    Case 75:  reserved word TIMESTAMPTZ as a constant name fails to compile
 *    Case 76:  reserved word TRUE as a constant name fails to compile
 *    Case 77:  reserved word USING as a constant name fails to compile
 *    Case 78:  reserved word VARCHAR as a constant name fails to compile
 *    Case 79:  reserved word WHEN as a constant name fails to compile
 *    Case 80:  reserved word WHILE as a constant name fails to compile
 *    Case 81:  reserved word WORK as a constant name fails to compile
 *    Case 82:  reserved word XOR as a constant name fails to compile
 *    Case 83:  reserved word INSERT as a constant name fails to compile
 *    Case 84:  reserved word TRUNCATE as a constant name fails to compile
 *    Case 85:  reserved word AUTONOMOUS_TRANSACTION as a constant name fails to compile
 *    Case 86:  reserved word BEGIN as a constant name fails to compile
 */

--+ server-message on

evaluate 'Case 1: reserved word AND as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
AND CONSTANT varchar := 'AND'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 2: reserved word AS as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
AS CONSTANT varchar := 'AS'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 3: reserved word BETWEEN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BETWEEN CONSTANT varchar := 'BETWEEN'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 4: reserved word BIGINT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BIGINT CONSTANT varchar := 'BIGINT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 5: reserved word BOOLEAN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BOOLEAN CONSTANT varchar := 'BOOLEAN'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 6: reserved word BY as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BY CONSTANT varchar := 'BY'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 7: reserved word CHAR as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CHAR CONSTANT varchar := 'CHAR'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 8: reserved word CLOSE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CLOSE CONSTANT varchar := 'CLOSE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 9: reserved word COMMIT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
COMMIT CONSTANT varchar := 'COMMIT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 10: reserved word CONSTANT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CONSTANT CONSTANT varchar := 'CONSTANT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 11: reserved word CONTINUE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CONTINUE CONSTANT varchar := 'CONTINUE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 12: reserved word CREATE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CREATE CONSTANT varchar := 'CREATE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 13: reserved word CURSOR as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CURSOR CONSTANT varchar := 'CURSOR'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 14: reserved word DATE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATE CONSTANT varchar := 'DATE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 15: reserved word DATETIME as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATETIME CONSTANT varchar := 'DATETIME'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 16: reserved word DATETIMELTZ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATETIMELTZ CONSTANT varchar := 'DATETIMELTZ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 17: reserved word DATETIMETZ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATETIMETZ CONSTANT varchar := 'DATETIMETZ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 18: reserved word DEC as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DEC CONSTANT varchar := 'DEC'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 19: reserved word DECIMAL as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DECIMAL CONSTANT varchar := 'DECIMAL'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 20: reserved word DECLARE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DECLARE CONSTANT varchar := 'DECLARE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 21: reserved word DEFAULT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DEFAULT CONSTANT varchar := 'DEFAULT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 22: reserved word DIV as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DIV CONSTANT varchar := 'DIV'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 23: reserved word DOUBLE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DOUBLE CONSTANT varchar := 'DOUBLE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 24: reserved word ELSE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ELSE CONSTANT varchar := 'ELSE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 25: reserved word ELSIF as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ELSIF CONSTANT varchar := 'ELSIF'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 26: reserved word END as a constant name fails: END closes the routine early and the rest fails as separate statements; result = Error:-493';
create or replace procedure p_var() as 
END CONSTANT varchar := 'END'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 27: reserved word ESCAPE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ESCAPE CONSTANT varchar := 'ESCAPE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 28: reserved word EXCEPTION as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
EXCEPTION CONSTANT varchar := 'EXCEPTION'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 29: reserved word EXECUTE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
EXECUTE CONSTANT varchar := 'EXECUTE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 30: reserved word EXIT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
EXIT CONSTANT varchar := 'EXIT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 31: reserved word FALSE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FALSE CONSTANT varchar := 'FALSE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 32: reserved word FETCH as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FETCH CONSTANT varchar := 'FETCH'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 33: reserved word FLOAT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FLOAT CONSTANT varchar := 'FLOAT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 34: reserved word FOR as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FOR CONSTANT varchar := 'FOR'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 35: reserved word IMMEDIATE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
IMMEDIATE CONSTANT varchar := 'IMMEDIATE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 36: reserved word IN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
IN CONSTANT varchar := 'IN'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 37: reserved word INT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
INT CONSTANT varchar := 'INT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 38: reserved word INTEGER as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
INTEGER CONSTANT varchar := 'INTEGER'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 39: reserved word INTO as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
INTO CONSTANT varchar := 'INTO'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 40: reserved word IS as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
IS CONSTANT varchar := 'IS'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 41: reserved word LIKE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
LIKE CONSTANT varchar := 'LIKE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 42: reserved word LIST as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
LIST CONSTANT varchar := 'LIST'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 43: reserved word MOD as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
MOD CONSTANT varchar := 'MOD'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 44: reserved word MULTISET as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
MULTISET CONSTANT varchar := 'MULTISET'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 45: reserved word NOT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
NOT CONSTANT varchar := 'NOT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 46: reserved word NULL as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
NULL CONSTANT varchar := 'NULL'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 47: reserved word NUMERIC as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
NUMERIC CONSTANT varchar := 'NUMERIC'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 48: reserved word OPEN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
OPEN CONSTANT varchar := 'OPEN'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 49: reserved word OR as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
OR CONSTANT varchar := 'OR'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 50: reserved word OUT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
OUT CONSTANT varchar := 'OUT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 51: reserved word PRAGMA as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
PRAGMA CONSTANT varchar := 'PRAGMA'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 52: reserved word RAISE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
RAISE CONSTANT varchar := 'RAISE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 53: reserved word REAL as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
REAL CONSTANT varchar := 'REAL'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 54: reserved word REPLACE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
REPLACE CONSTANT varchar := 'REPLACE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 55: reserved word RETURN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
RETURN CONSTANT varchar := 'RETURN'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 56: reserved word REVERSE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
REVERSE CONSTANT varchar := 'REVERSE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 57: reserved word ROLLBACK as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ROLLBACK CONSTANT varchar := 'ROLLBACK'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 58: reserved word SEQUENCE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SEQUENCE CONSTANT varchar := 'SEQUENCE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 59: reserved word SET as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SET CONSTANT varchar := 'SET'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 60: reserved word SETEQ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SETEQ CONSTANT varchar := 'SETEQ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 61: reserved word SETNEQ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SETNEQ CONSTANT varchar := 'SETNEQ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 62: reserved word SHORT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SHORT CONSTANT varchar := 'SHORT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 63: reserved word SMALLINT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SMALLINT CONSTANT varchar := 'SMALLINT'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 64: reserved word SQL as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SQL CONSTANT varchar := 'SQL'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 65: reserved word STRING as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
STRING CONSTANT varchar := 'STRING'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 66: reserved word SUBSET as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUBSET CONSTANT varchar := 'SUBSET'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 67: reserved word SUBSETEQ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUBSETEQ CONSTANT varchar := 'SUBSETEQ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 68: reserved word SUPERSET as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUPERSET CONSTANT varchar := 'SUPERSET'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 69: reserved word SUPERSETEQ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUPERSETEQ CONSTANT varchar := 'SUPERSETEQ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 70: reserved word SYS_REFCURSOR as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SYS_REFCURSOR CONSTANT varchar := 'SYS_REFCURSOR'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 71: reserved word THEN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
THEN CONSTANT varchar := 'THEN'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 72: reserved word TIME as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIME CONSTANT varchar := 'TIME'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 73: reserved word TIMESTAMP as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIMESTAMP CONSTANT varchar := 'TIMESTAMP'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 74: reserved word TIMESTAMPLTZ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIMESTAMPLTZ CONSTANT varchar := 'TIMESTAMPLTZ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 75: reserved word TIMESTAMPTZ as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIMESTAMPTZ CONSTANT varchar := 'TIMESTAMPTZ'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 76: reserved word TRUE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TRUE CONSTANT varchar := 'TRUE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 77: reserved word USING as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
USING CONSTANT varchar := 'USING'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 78: reserved word VARCHAR as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
VARCHAR CONSTANT varchar := 'VARCHAR'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 79: reserved word WHEN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
WHEN CONSTANT varchar := 'WHEN'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 80: reserved word WHILE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
WHILE CONSTANT varchar := 'WHILE'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 81: reserved word WORK as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
WORK CONSTANT varchar := 'WORK'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 82: reserved word XOR as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
XOR CONSTANT varchar := 'XOR'; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 83: reserved word INSERT as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
INSERT CONSTANT varchar := 'INSERT';
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 84: reserved word TRUNCATE as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
TRUNCATE CONSTANT varchar := 'TRUNCATE';
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 85: reserved word AUTONOMOUS_TRANSACTION as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
AUTONOMOUS_TRANSACTION CONSTANT varchar := 'AUTONOMOUS_TRANSACTION';
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

-- BEGIN opens a block, so the end lines after this create belong to its statement
evaluate 'Case 86: reserved word BEGIN as a constant name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
BEGIN CONSTANT varchar := 'BEGIN';
begin
    dbms_output.put_line('Use of reserved word variables.');
end;
end;



-- every case fails, so p_var does not exist and this drop fails unless a case created it by mistake
drop procedure p_var ;

--+ server-message off

