/**
 *  This test case verifies CBRD-25111: a PL/CSQL reserved word cannot be used as a variable name.
 *
 *  Each case creates a procedure that declares a variable named after one reserved word,
 *  and the create fails.
 *
 *  Coverage:
 *    Case 1:   reserved word AND as a variable name fails to compile
 *    Case 2:   reserved word AS as a variable name fails to compile
 *    Case 3:   reserved word BETWEEN as a variable name fails to compile
 *    Case 4:   reserved word BIGINT as a variable name fails to compile
 *    Case 5:   reserved word BOOLEAN as a variable name fails to compile
 *    Case 6:   reserved word BY as a variable name fails to compile
 *    Case 7:   reserved word CHAR as a variable name fails to compile
 *    Case 8:   reserved word CLOSE as a variable name fails to compile
 *    Case 9:   reserved word COMMIT as a variable name fails to compile
 *    Case 10:  reserved word CONSTANT as a variable name fails to compile
 *    Case 11:  reserved word CONTINUE as a variable name fails to compile
 *    Case 12:  reserved word CREATE as a variable name fails to compile
 *    Case 13:  reserved word CURSOR as a variable name fails to compile
 *    Case 14:  reserved word DATE as a variable name fails to compile
 *    Case 15:  reserved word DATETIME as a variable name fails to compile
 *    Case 16:  reserved word DATETIMELTZ as a variable name fails to compile
 *    Case 17:  reserved word DATETIMETZ as a variable name fails to compile
 *    Case 18:  reserved word DEC as a variable name fails to compile
 *    Case 19:  reserved word DECIMAL as a variable name fails to compile
 *    Case 20:  reserved word DECLARE as a variable name fails to compile
 *    Case 21:  reserved word DEFAULT as a variable name fails to compile
 *    Case 22:  reserved word DIV as a variable name fails to compile
 *    Case 23:  reserved word DOUBLE as a variable name fails to compile
 *    Case 24:  reserved word ELSE as a variable name fails to compile
 *    Case 25:  reserved word ELSIF as a variable name fails to compile
 *    Case 26:  reserved word END as a variable name fails: END closes the routine early and the rest fails as separate statements
 *    Case 27:  reserved word ESCAPE as a variable name fails to compile
 *    Case 28:  reserved word EXCEPTION as a variable name fails to compile
 *    Case 29:  reserved word EXECUTE as a variable name fails to compile
 *    Case 30:  reserved word EXIT as a variable name fails to compile
 *    Case 31:  reserved word FALSE as a variable name fails to compile
 *    Case 32:  reserved word FETCH as a variable name fails to compile
 *    Case 33:  reserved word FLOAT as a variable name fails to compile
 *    Case 34:  reserved word FOR as a variable name fails to compile
 *    Case 35:  reserved word IMMEDIATE as a variable name fails to compile
 *    Case 36:  reserved word IN as a variable name fails to compile
 *    Case 37:  reserved word INT as a variable name fails to compile
 *    Case 38:  reserved word INTEGER as a variable name fails to compile
 *    Case 39:  reserved word INTO as a variable name fails to compile
 *    Case 40:  reserved word IS as a variable name fails to compile
 *    Case 41:  reserved word LIKE as a variable name fails to compile
 *    Case 42:  reserved word LIST as a variable name fails to compile
 *    Case 43:  reserved word MOD as a variable name fails to compile
 *    Case 44:  reserved word MULTISET as a variable name fails to compile
 *    Case 45:  reserved word NOT as a variable name fails to compile
 *    Case 46:  reserved word NULL as a variable name fails to compile
 *    Case 47:  reserved word NUMERIC as a variable name fails to compile
 *    Case 48:  reserved word OPEN as a variable name fails to compile
 *    Case 49:  reserved word OR as a variable name fails to compile
 *    Case 50:  reserved word OUT as a variable name fails to compile
 *    Case 51:  reserved word PRAGMA as a variable name fails to compile
 *    Case 52:  reserved word RAISE as a variable name fails to compile
 *    Case 53:  reserved word REAL as a variable name fails to compile
 *    Case 54:  reserved word REPLACE as a variable name fails to compile
 *    Case 55:  reserved word RETURN as a variable name fails to compile
 *    Case 56:  reserved word REVERSE as a variable name fails to compile
 *    Case 57:  reserved word ROLLBACK as a variable name fails to compile
 *    Case 58:  reserved word SEQUENCE as a variable name fails to compile
 *    Case 59:  reserved word SET as a variable name fails to compile
 *    Case 60:  reserved word SETEQ as a variable name fails to compile
 *    Case 61:  reserved word SETNEQ as a variable name fails to compile
 *    Case 62:  reserved word SHORT as a variable name fails to compile
 *    Case 63:  reserved word SMALLINT as a variable name fails to compile
 *    Case 64:  reserved word SQL as a variable name fails to compile
 *    Case 65:  reserved word STRING as a variable name fails to compile
 *    Case 66:  reserved word SUBSET as a variable name fails to compile
 *    Case 67:  reserved word SUBSETEQ as a variable name fails to compile
 *    Case 68:  reserved word SUPERSET as a variable name fails to compile
 *    Case 69:  reserved word SUPERSETEQ as a variable name fails to compile
 *    Case 70:  reserved word SYS_REFCURSOR as a variable name fails to compile
 *    Case 71:  reserved word THEN as a variable name fails to compile
 *    Case 72:  reserved word TIME as a variable name fails to compile
 *    Case 73:  reserved word TIMESTAMP as a variable name fails to compile
 *    Case 74:  reserved word TIMESTAMPLTZ as a variable name fails to compile
 *    Case 75:  reserved word TIMESTAMPTZ as a variable name fails to compile
 *    Case 76:  reserved word TRUE as a variable name fails to compile
 *    Case 77:  reserved word USING as a variable name fails to compile
 *    Case 78:  reserved word VARCHAR as a variable name fails to compile
 *    Case 79:  reserved word WHEN as a variable name fails to compile
 *    Case 80:  reserved word WHILE as a variable name fails to compile
 *    Case 81:  reserved word WORK as a variable name fails to compile
 *    Case 82:  reserved word XOR as a variable name fails to compile
 *    Case 83:  reserved word INSERT as a variable name fails to compile
 *    Case 84:  reserved word TRUNCATE as a variable name fails to compile
 *    Case 85:  reserved word AUTONOMOUS_TRANSACTION as a variable name fails to compile
 *    Case 86:  reserved word BEGIN as a variable name fails to compile
 */

--+ server-message on

evaluate 'Case 1: reserved word AND as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
AND varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 2: reserved word AS as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
AS varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 3: reserved word BETWEEN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BETWEEN varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 4: reserved word BIGINT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BIGINT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 5: reserved word BOOLEAN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BOOLEAN varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 6: reserved word BY as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
BY varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 7: reserved word CHAR as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CHAR varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 8: reserved word CLOSE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CLOSE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 9: reserved word COMMIT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
COMMIT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 10: reserved word CONSTANT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CONSTANT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 11: reserved word CONTINUE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CONTINUE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 12: reserved word CREATE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CREATE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 13: reserved word CURSOR as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
CURSOR varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 14: reserved word DATE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 15: reserved word DATETIME as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATETIME varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 16: reserved word DATETIMELTZ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATETIMELTZ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 17: reserved word DATETIMETZ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DATETIMETZ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 18: reserved word DEC as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DEC varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 19: reserved word DECIMAL as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DECIMAL varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 20: reserved word DECLARE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DECLARE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 21: reserved word DEFAULT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DEFAULT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 22: reserved word DIV as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DIV varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 23: reserved word DOUBLE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
DOUBLE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 24: reserved word ELSE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ELSE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 25: reserved word ELSIF as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ELSIF varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 26: reserved word END as a variable name fails: END closes the routine early and the rest fails as separate statements; result = Error:-493';
create or replace procedure p_var() as 
END varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 27: reserved word ESCAPE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ESCAPE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 28: reserved word EXCEPTION as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
EXCEPTION varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 29: reserved word EXECUTE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
EXECUTE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 30: reserved word EXIT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
EXIT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 31: reserved word FALSE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FALSE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 32: reserved word FETCH as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FETCH varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 33: reserved word FLOAT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FLOAT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 34: reserved word FOR as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
FOR varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 35: reserved word IMMEDIATE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
IMMEDIATE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 36: reserved word IN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
IN varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 37: reserved word INT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
INT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 38: reserved word INTEGER as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
INTEGER varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 39: reserved word INTO as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
INTO varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 40: reserved word IS as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
IS varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 41: reserved word LIKE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
LIKE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 42: reserved word LIST as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
LIST varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 43: reserved word MOD as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
MOD varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 44: reserved word MULTISET as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
MULTISET varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 45: reserved word NOT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
NOT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 46: reserved word NULL as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
NULL varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 47: reserved word NUMERIC as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
NUMERIC varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 48: reserved word OPEN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
OPEN varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 49: reserved word OR as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
OR varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 50: reserved word OUT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
OUT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 51: reserved word PRAGMA as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
PRAGMA varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 52: reserved word RAISE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
RAISE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 53: reserved word REAL as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
REAL varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 54: reserved word REPLACE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
REPLACE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 55: reserved word RETURN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
RETURN varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 56: reserved word REVERSE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
REVERSE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 57: reserved word ROLLBACK as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
ROLLBACK varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 58: reserved word SEQUENCE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SEQUENCE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 59: reserved word SET as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SET varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 60: reserved word SETEQ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SETEQ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 61: reserved word SETNEQ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SETNEQ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 62: reserved word SHORT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SHORT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 63: reserved word SMALLINT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SMALLINT varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 64: reserved word SQL as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SQL varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 65: reserved word STRING as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
STRING varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 66: reserved word SUBSET as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUBSET varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 67: reserved word SUBSETEQ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUBSETEQ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 68: reserved word SUPERSET as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUPERSET varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 69: reserved word SUPERSETEQ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SUPERSETEQ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 70: reserved word SYS_REFCURSOR as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
SYS_REFCURSOR varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 71: reserved word THEN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
THEN varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 72: reserved word TIME as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIME varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 73: reserved word TIMESTAMP as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIMESTAMP varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 74: reserved word TIMESTAMPLTZ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIMESTAMPLTZ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 75: reserved word TIMESTAMPTZ as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TIMESTAMPTZ varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 76: reserved word TRUE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
TRUE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 77: reserved word USING as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
USING varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 78: reserved word VARCHAR as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
VARCHAR varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 79: reserved word WHEN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
WHEN varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 80: reserved word WHILE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
WHILE varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 81: reserved word WORK as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
WORK varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 82: reserved word XOR as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as 
XOR varchar ; 
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 83: reserved word INSERT as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
INSERT varchar ;
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 84: reserved word TRUNCATE as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
TRUNCATE varchar ;
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

evaluate 'Case 85: reserved word AUTONOMOUS_TRANSACTION as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
AUTONOMOUS_TRANSACTION varchar ;
begin
    dbms_output.put_line('Use of reserved word variables.');
end;

-- BEGIN opens a block, so the end lines after this create belong to its statement
evaluate 'Case 86: reserved word BEGIN as a variable name fails to compile; result = Error:-1360';
create or replace procedure p_var() as
BEGIN varchar ;
begin
    dbms_output.put_line('Use of reserved word variables.');
end;
end;



-- every case fails, so p_var does not exist and this drop fails unless a case created it by mistake
drop procedure p_var;

--+ server-message off
