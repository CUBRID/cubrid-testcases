/**
 *  This test case verifies CBRD-25111: a PL/CSQL reserved word cannot be used as a local function name.
 *
 *  Each case creates a procedure that declares a local function named after one reserved word,
 *  and the create fails.
 *
 *  Coverage:
 *    Case 1:   reserved word AND as a local function name fails to compile
 *    Case 2:   reserved word AS as a local function name fails to compile
 *    Case 3:   reserved word BETWEEN as a local function name fails to compile
 *    Case 4:   reserved word BIGINT as a local function name fails to compile
 *    Case 5:   reserved word BOOLEAN as a local function name fails to compile
 *    Case 6:   reserved word BY as a local function name fails to compile
 *    Case 7:   reserved word CHAR as a local function name fails to compile
 *    Case 8:   reserved word CLOSE as a local function name fails to compile
 *    Case 9:   reserved word COMMIT as a local function name fails to compile
 *    Case 10:  reserved word CONSTANT as a local function name fails to compile
 *    Case 11:  reserved word CONTINUE as a local function name fails to compile
 *    Case 12:  reserved word CREATE as a local function name fails to compile
 *    Case 13:  reserved word CURSOR as a local function name fails to compile
 *    Case 14:  reserved word DATE as a local function name fails to compile
 *    Case 15:  reserved word DATETIME as a local function name fails to compile
 *    Case 16:  reserved word DATETIMELTZ as a local function name fails to compile
 *    Case 17:  reserved word DATETIMETZ as a local function name fails to compile
 *    Case 18:  reserved word DEC as a local function name fails to compile
 *    Case 19:  reserved word DECIMAL as a local function name fails to compile
 *    Case 20:  reserved word DECLARE as a local function name fails to compile
 *    Case 21:  reserved word DEFAULT as a local function name fails to compile
 *    Case 22:  reserved word DIV as a local function name fails to compile
 *    Case 23:  reserved word DOUBLE as a local function name fails to compile
 *    Case 24:  reserved word ELSE as a local function name fails to compile
 *    Case 25:  reserved word ELSIF as a local function name fails to compile
 *    Case 26:  reserved word END as a local function name fails: END closes the routine early and the rest fails as separate statements
 *    Case 27:  reserved word ESCAPE as a local function name fails to compile
 *    Case 28:  reserved word EXCEPTION as a local function name fails to compile
 *    Case 29:  reserved word EXECUTE as a local function name fails to compile
 *    Case 30:  reserved word EXIT as a local function name fails to compile
 *    Case 31:  reserved word FALSE as a local function name fails to compile
 *    Case 32:  reserved word FETCH as a local function name fails to compile
 *    Case 33:  reserved word FLOAT as a local function name fails to compile
 *    Case 34:  reserved word FOR as a local function name fails to compile
 *    Case 35:  reserved word IMMEDIATE as a local function name fails to compile
 *    Case 36:  reserved word IN as a local function name fails to compile
 *    Case 37:  reserved word INT as a local function name fails to compile
 *    Case 38:  reserved word INTEGER as a local function name fails to compile
 *    Case 39:  reserved word INTO as a local function name fails to compile
 *    Case 40:  reserved word IS as a local function name fails to compile
 *    Case 41:  reserved word LIKE as a local function name fails to compile
 *    Case 42:  reserved word LIST as a local function name fails to compile
 *    Case 43:  reserved word MOD as a local function name fails to compile
 *    Case 44:  reserved word MULTISET as a local function name fails to compile
 *    Case 45:  reserved word NOT as a local function name fails to compile
 *    Case 46:  reserved word NULL as a local function name fails to compile
 *    Case 47:  reserved word NUMERIC as a local function name fails to compile
 *    Case 48:  reserved word OPEN as a local function name fails to compile
 *    Case 49:  reserved word OR as a local function name fails to compile
 *    Case 50:  reserved word OUT as a local function name fails to compile
 *    Case 51:  reserved word PRAGMA as a local function name fails to compile
 *    Case 52:  reserved word RAISE as a local function name fails to compile
 *    Case 53:  reserved word REAL as a local function name fails to compile
 *    Case 54:  reserved word REPLACE as a local function name fails to compile
 *    Case 55:  reserved word RETURN as a local function name fails to compile
 *    Case 56:  reserved word REVERSE as a local function name fails to compile
 *    Case 57:  reserved word ROLLBACK as a local function name fails to compile
 *    Case 58:  reserved word SEQUENCE as a local function name fails to compile
 *    Case 59:  reserved word SET as a local function name fails to compile
 *    Case 60:  reserved word SETEQ as a local function name fails to compile
 *    Case 61:  reserved word SETNEQ as a local function name fails to compile
 *    Case 62:  reserved word SHORT as a local function name fails to compile
 *    Case 63:  reserved word SMALLINT as a local function name fails to compile
 *    Case 64:  reserved word SQL as a local function name fails to compile
 *    Case 65:  reserved word STRING as a local function name fails to compile
 *    Case 66:  reserved word SUBSET as a local function name fails to compile
 *    Case 67:  reserved word SUBSETEQ as a local function name fails to compile
 *    Case 68:  reserved word SUPERSET as a local function name fails to compile
 *    Case 69:  reserved word SUPERSETEQ as a local function name fails to compile
 *    Case 70:  reserved word SYS_REFCURSOR as a local function name fails to compile
 *    Case 71:  reserved word THEN as a local function name fails to compile
 *    Case 72:  reserved word TIME as a local function name fails to compile
 *    Case 73:  reserved word TIMESTAMP as a local function name fails to compile
 *    Case 74:  reserved word TIMESTAMPLTZ as a local function name fails to compile
 *    Case 75:  reserved word TIMESTAMPTZ as a local function name fails to compile
 *    Case 76:  reserved word TRUE as a local function name fails to compile
 *    Case 77:  reserved word USING as a local function name fails to compile
 *    Case 78:  reserved word VARCHAR as a local function name fails to compile
 *    Case 79:  reserved word WHEN as a local function name fails to compile
 *    Case 80:  reserved word WHILE as a local function name fails to compile
 *    Case 81:  reserved word WORK as a local function name fails to compile
 *    Case 82:  reserved word XOR as a local function name fails to compile
 *    Case 83:  reserved word INSERT as a local function name fails to compile
 *    Case 84:  reserved word TRUNCATE as a local function name fails to compile
 *    Case 85:  reserved word AUTONOMOUS_TRANSACTION as a local function name fails to compile
 *    Case 86:  reserved word BEGIN as a local function name fails
 */

--+ server-message on

evaluate 'Case 1: reserved word AND as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function AND return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [AND]() ); 
end;

evaluate 'Case 2: reserved word AS as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function AS return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [AS]() ); 
end;

evaluate 'Case 3: reserved word BETWEEN as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function BETWEEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BETWEEN]() ); 
end;

evaluate 'Case 4: reserved word BIGINT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function BIGINT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BIGINT]() ); 
end;

evaluate 'Case 5: reserved word BOOLEAN as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function BOOLEAN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BOOLEAN]() ); 
end;

evaluate 'Case 6: reserved word BY as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function BY return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BY]() ); 
end;

evaluate 'Case 7: reserved word CHAR as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function CHAR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CHAR]() ); 
end;

evaluate 'Case 8: reserved word CLOSE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function CLOSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CLOSE]() ); 
end;

evaluate 'Case 9: reserved word COMMIT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function COMMIT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [COMMIT]() ); 
end;

evaluate 'Case 10: reserved word CONSTANT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function CONSTANT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CONSTANT]() ); 
end;

evaluate 'Case 11: reserved word CONTINUE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function CONTINUE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CONTINUE]() ); 
end;

evaluate 'Case 12: reserved word CREATE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function CREATE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CREATE]() ); 
end;

evaluate 'Case 13: reserved word CURSOR as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function CURSOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CURSOR]() ); 
end;

evaluate 'Case 14: reserved word DATE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DATE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATE]() ); 
end;

evaluate 'Case 15: reserved word DATETIME as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DATETIME return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIME]() ); 
end;

evaluate 'Case 16: reserved word DATETIMELTZ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DATETIMELTZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIMELTZ]() ); 
end;

evaluate 'Case 17: reserved word DATETIMETZ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DATETIMETZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIMETZ]() ); 
end;

evaluate 'Case 18: reserved word DEC as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DEC return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DEC]() ); 
end;

evaluate 'Case 19: reserved word DECIMAL as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DECIMAL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DECIMAL]() ); 
end;

evaluate 'Case 20: reserved word DECLARE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DECLARE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DECLARE]() ); 
end;

evaluate 'Case 21: reserved word DEFAULT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DEFAULT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DEFAULT]() ); 
end;

evaluate 'Case 22: reserved word DIV as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DIV return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DIV]() ); 
end;

evaluate 'Case 23: reserved word DOUBLE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function DOUBLE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DOUBLE]() ); 
end;

evaluate 'Case 24: reserved word ELSE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function ELSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ELSE]() ); 
end;

evaluate 'Case 25: reserved word ELSIF as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function ELSIF return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ELSIF]() ); 
end;

evaluate 'Case 26: reserved word END as a local function name fails: END closes the routine early and the rest fails as separate statements; result = Error:-493';
create or replace procedure p_local() as 
    function END return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [END]() ); 
end;

evaluate 'Case 27: reserved word ESCAPE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function ESCAPE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ESCAPE]() ); 
end;

evaluate 'Case 28: reserved word EXCEPTION as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function EXCEPTION return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXCEPTION]() ); 
end;

evaluate 'Case 29: reserved word EXECUTE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function EXECUTE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXECUTE]() ); 
end;

evaluate 'Case 30: reserved word EXIT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function EXIT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXIT]() ); 
end;

evaluate 'Case 31: reserved word FALSE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function FALSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FALSE]() ); 
end;

evaluate 'Case 32: reserved word FETCH as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function FETCH return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FETCH]() ); 
end;

evaluate 'Case 33: reserved word FLOAT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function FLOAT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FLOAT]() ); 
end;

evaluate 'Case 34: reserved word FOR as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function FOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FOR]() ); 
end;

evaluate 'Case 35: reserved word IMMEDIATE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function IMMEDIATE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IMMEDIATE]() ); 
end;

evaluate 'Case 36: reserved word IN as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function IN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IN]() ); 
end;

evaluate 'Case 37: reserved word INT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function INT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INT]() ); 
end;

evaluate 'Case 38: reserved word INTEGER as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function INTEGER return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INTEGER]() ); 
end;

evaluate 'Case 39: reserved word INTO as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function INTO return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INTO]() ); 
end;

evaluate 'Case 40: reserved word IS as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function IS return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IS]() ); 
end;

evaluate 'Case 41: reserved word LIKE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function LIKE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [LIKE]() ); 
end;

evaluate 'Case 42: reserved word LIST as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function LIST return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [LIST]() ); 
end;

evaluate 'Case 43: reserved word MOD as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function MOD return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [MOD]() ); 
end;

evaluate 'Case 44: reserved word MULTISET as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function MULTISET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [MULTISET]() ); 
end;

evaluate 'Case 45: reserved word NOT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function NOT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NOT]() ); 
end;

evaluate 'Case 46: reserved word NULL as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function NULL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NULL]() ); 
end;

evaluate 'Case 47: reserved word NUMERIC as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function NUMERIC return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NUMERIC]() ); 
end;

evaluate 'Case 48: reserved word OPEN as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function OPEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OPEN]() ); 
end;

evaluate 'Case 49: reserved word OR as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function OR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OR]() ); 
end;

evaluate 'Case 50: reserved word OUT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function OUT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OUT]() ); 
end;

evaluate 'Case 51: reserved word PRAGMA as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function PRAGMA return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [PRAGMA]() ); 
end;

evaluate 'Case 52: reserved word RAISE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function RAISE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [RAISE]() ); 
end;

evaluate 'Case 53: reserved word REAL as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function REAL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REAL]() ); 
end;

evaluate 'Case 54: reserved word REPLACE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function REPLACE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REPLACE]() ); 
end;

evaluate 'Case 55: reserved word RETURN as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function RETURN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [RETURN]() ); 
end;

evaluate 'Case 56: reserved word REVERSE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function REVERSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REVERSE]() ); 
end;

evaluate 'Case 57: reserved word ROLLBACK as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function ROLLBACK return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ROLLBACK]() ); 
end;

evaluate 'Case 58: reserved word SEQUENCE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SEQUENCE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SEQUENCE]() ); 
end;

evaluate 'Case 59: reserved word SET as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SET]() ); 
end;

evaluate 'Case 60: reserved word SETEQ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SETEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SETEQ]() ); 
end;

evaluate 'Case 61: reserved word SETNEQ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SETNEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SETNEQ]() ); 
end;

evaluate 'Case 62: reserved word SHORT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SHORT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SHORT]() ); 
end;

evaluate 'Case 63: reserved word SMALLINT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SMALLINT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SMALLINT]() ); 
end;

evaluate 'Case 64: reserved word SQL as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SQL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SQL]() ); 
end;

evaluate 'Case 65: reserved word STRING as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function STRING return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [STRING]() ); 
end;

evaluate 'Case 66: reserved word SUBSET as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SUBSET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUBSET]() ); 
end;

evaluate 'Case 67: reserved word SUBSETEQ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SUBSETEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUBSETEQ]() ); 
end;

evaluate 'Case 68: reserved word SUPERSET as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SUPERSET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUPERSET]() ); 
end;

evaluate 'Case 69: reserved word SUPERSETEQ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SUPERSETEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUPERSETEQ]() ); 
end;

evaluate 'Case 70: reserved word SYS_REFCURSOR as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function SYS_REFCURSOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SYS_REFCURSOR]() ); 
end;

evaluate 'Case 71: reserved word THEN as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function THEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [THEN]() ); 
end;

evaluate 'Case 72: reserved word TIME as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function TIME return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIME]() ); 
end;

evaluate 'Case 73: reserved word TIMESTAMP as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function TIMESTAMP return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMP]() ); 
end;

evaluate 'Case 74: reserved word TIMESTAMPLTZ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function TIMESTAMPLTZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMPLTZ]() ); 
end;

evaluate 'Case 75: reserved word TIMESTAMPTZ as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function TIMESTAMPTZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMPTZ]() ); 
end;

evaluate 'Case 76: reserved word TRUE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function TRUE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TRUE]() ); 
end;

evaluate 'Case 77: reserved word USING as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function USING return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [USING]() ); 
end;

evaluate 'Case 78: reserved word VARCHAR as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function VARCHAR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [VARCHAR]() ); 
end;

evaluate 'Case 79: reserved word WHEN as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function WHEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WHEN]() ); 
end;

evaluate 'Case 80: reserved word WHILE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function WHILE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WHILE]() ); 
end;

evaluate 'Case 81: reserved word WORK as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function WORK return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WORK]() ); 
end;

evaluate 'Case 82: reserved word XOR as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    function XOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [XOR]() ); 
end;

evaluate 'Case 83: reserved word INSERT as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as
    function INSERT return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [INSERT]() );
end;

evaluate 'Case 84: reserved word TRUNCATE as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as
    function TRUNCATE return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [TRUNCATE]() );
end;

evaluate 'Case 85: reserved word AUTONOMOUS_TRANSACTION as a local function name fails to compile; result = Error:-1360';
create or replace procedure p_local() as
    function AUTONOMOUS_TRANSACTION return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [AUTONOMOUS_TRANSACTION]() );
end;

-- BEGIN opens a block, so the end lines after this create belong to its statement
evaluate 'Case 86: reserved word BEGIN as a local function name fails; result = Error:-493';
create or replace procedure p_local() as
    function BEGIN return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [BEGIN]() );
end;
end;
end;


-- every case fails, so p_local does not exist and this drop fails unless a case created it by mistake
drop procedure p_local;


--+ server-message off

