/**
 *  This test case verifies CBRD-25111: a PL/CSQL reserved word cannot be used as a local procedure name.
 *
 *  Each case creates a procedure that declares a local procedure named after one reserved word,
 *  and the create fails.
 *
 *  Coverage:
 *    Case 1:   reserved word AND as a local procedure name fails to compile
 *    Case 2:   reserved word AS as a local procedure name fails to compile
 *    Case 3:   reserved word BETWEEN as a local procedure name fails to compile
 *    Case 4:   reserved word BIGINT as a local procedure name fails to compile
 *    Case 5:   reserved word BOOLEAN as a local procedure name fails to compile
 *    Case 6:   reserved word BY as a local procedure name fails to compile
 *    Case 7:   reserved word CHAR as a local procedure name fails to compile
 *    Case 8:   reserved word CLOSE as a local procedure name fails to compile
 *    Case 9:   reserved word COMMIT as a local procedure name fails to compile
 *    Case 10:  reserved word CONSTANT as a local procedure name fails to compile
 *    Case 11:  reserved word CONTINUE as a local procedure name fails to compile
 *    Case 12:  reserved word CREATE as a local procedure name fails to compile
 *    Case 13:  reserved word CURSOR as a local procedure name fails to compile
 *    Case 14:  reserved word DATE as a local procedure name fails to compile
 *    Case 15:  reserved word DATETIME as a local procedure name fails to compile
 *    Case 16:  reserved word DATETIMELTZ as a local procedure name fails to compile
 *    Case 17:  reserved word DATETIMETZ as a local procedure name fails to compile
 *    Case 18:  reserved word DEC as a local procedure name fails to compile
 *    Case 19:  reserved word DECIMAL as a local procedure name fails to compile
 *    Case 20:  reserved word DECLARE as a local procedure name fails to compile
 *    Case 21:  reserved word DEFAULT as a local procedure name fails to compile
 *    Case 22:  reserved word DIV as a local procedure name fails to compile
 *    Case 23:  reserved word DOUBLE as a local procedure name fails to compile
 *    Case 24:  reserved word ELSE as a local procedure name fails to compile
 *    Case 25:  reserved word ELSIF as a local procedure name fails to compile
 *    Case 26:  reserved word END as a local procedure name fails: END closes the routine early and the rest fails as separate statements
 *    Case 27:  reserved word ESCAPE as a local procedure name fails to compile
 *    Case 28:  reserved word EXCEPTION as a local procedure name fails to compile
 *    Case 29:  reserved word EXECUTE as a local procedure name fails to compile
 *    Case 30:  reserved word EXIT as a local procedure name fails to compile
 *    Case 31:  reserved word FALSE as a local procedure name fails to compile
 *    Case 32:  reserved word FETCH as a local procedure name fails to compile
 *    Case 33:  reserved word FLOAT as a local procedure name fails to compile
 *    Case 34:  reserved word FOR as a local procedure name fails to compile
 *    Case 35:  reserved word IMMEDIATE as a local procedure name fails to compile
 *    Case 36:  reserved word IN as a local procedure name fails to compile
 *    Case 37:  reserved word INT as a local procedure name fails to compile
 *    Case 38:  reserved word INTEGER as a local procedure name fails to compile
 *    Case 39:  reserved word INTO as a local procedure name fails to compile
 *    Case 40:  reserved word IS as a local procedure name fails to compile
 *    Case 41:  reserved word LIKE as a local procedure name fails to compile
 *    Case 42:  reserved word LIST as a local procedure name fails to compile
 *    Case 43:  reserved word MOD as a local procedure name fails to compile
 *    Case 44:  reserved word MULTISET as a local procedure name fails to compile
 *    Case 45:  reserved word NOT as a local procedure name fails to compile
 *    Case 46:  reserved word NULL as a local procedure name fails to compile
 *    Case 47:  reserved word NUMERIC as a local procedure name fails to compile
 *    Case 48:  reserved word OPEN as a local procedure name fails to compile
 *    Case 49:  reserved word OR as a local procedure name fails to compile
 *    Case 50:  reserved word OUT as a local procedure name fails to compile
 *    Case 51:  reserved word PRAGMA as a local procedure name fails to compile
 *    Case 52:  reserved word RAISE as a local procedure name fails to compile
 *    Case 53:  reserved word REAL as a local procedure name fails to compile
 *    Case 54:  reserved word REPLACE as a local procedure name fails to compile
 *    Case 55:  reserved word RETURN as a local procedure name fails to compile
 *    Case 56:  reserved word REVERSE as a local procedure name fails to compile
 *    Case 57:  reserved word ROLLBACK as a local procedure name fails to compile
 *    Case 58:  reserved word SEQUENCE as a local procedure name fails to compile
 *    Case 59:  reserved word SET as a local procedure name fails to compile
 *    Case 60:  reserved word SETEQ as a local procedure name fails to compile
 *    Case 61:  reserved word SETNEQ as a local procedure name fails to compile
 *    Case 62:  reserved word SHORT as a local procedure name fails to compile
 *    Case 63:  reserved word SMALLINT as a local procedure name fails to compile
 *    Case 64:  reserved word SQL as a local procedure name fails to compile
 *    Case 65:  reserved word STRING as a local procedure name fails to compile
 *    Case 66:  reserved word SUBSET as a local procedure name fails to compile
 *    Case 67:  reserved word SUBSETEQ as a local procedure name fails to compile
 *    Case 68:  reserved word SUPERSET as a local procedure name fails to compile
 *    Case 69:  reserved word SUPERSETEQ as a local procedure name fails to compile
 *    Case 70:  reserved word SYS_REFCURSOR as a local procedure name fails to compile
 *    Case 71:  reserved word THEN as a local procedure name fails to compile
 *    Case 72:  reserved word TIME as a local procedure name fails to compile
 *    Case 73:  reserved word TIMESTAMP as a local procedure name fails to compile
 *    Case 74:  reserved word TIMESTAMPLTZ as a local procedure name fails to compile
 *    Case 75:  reserved word TIMESTAMPTZ as a local procedure name fails to compile
 *    Case 76:  reserved word TRUE as a local procedure name fails to compile
 *    Case 77:  reserved word USING as a local procedure name fails to compile
 *    Case 78:  reserved word VARCHAR as a local procedure name fails to compile
 *    Case 79:  reserved word WHEN as a local procedure name fails to compile
 *    Case 80:  reserved word WHILE as a local procedure name fails to compile
 *    Case 81:  reserved word WORK as a local procedure name fails to compile
 *    Case 82:  reserved word XOR as a local procedure name fails to compile
 *    Case 83:  reserved word INSERT as a local procedure name fails to compile
 *    Case 84:  reserved word TRUNCATE as a local procedure name fails to compile
 *    Case 85:  reserved word AUTONOMOUS_TRANSACTION as a local procedure name fails to compile
 *    Case 86:  reserved word BEGIN as a local procedure name fails
 */

--+ server-message on

evaluate 'Case 1: reserved word AND as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure AND as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    AND(); 
end;

evaluate 'Case 2: reserved word AS as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure AS as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    AS(); 
end;

evaluate 'Case 3: reserved word BETWEEN as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure BETWEEN as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    BETWEEN(); 
end;

evaluate 'Case 4: reserved word BIGINT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure BIGINT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    BIGINT(); 
end;

evaluate 'Case 5: reserved word BOOLEAN as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure BOOLEAN as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    BOOLEAN(); 
end;

evaluate 'Case 6: reserved word BY as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure BY as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    BY(); 
end;

evaluate 'Case 7: reserved word CHAR as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure CHAR as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    CHAR(); 
end;

evaluate 'Case 8: reserved word CLOSE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure CLOSE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    CLOSE(); 
end;

evaluate 'Case 9: reserved word COMMIT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure COMMIT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    COMMIT(); 
end;

evaluate 'Case 10: reserved word CONSTANT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure CONSTANT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    CONSTANT(); 
end;

evaluate 'Case 11: reserved word CONTINUE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure CONTINUE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    CONTINUE(); 
end;

evaluate 'Case 12: reserved word CREATE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure CREATE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    CREATE(); 
end;

evaluate 'Case 13: reserved word CURSOR as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure CURSOR as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    CURSOR(); 
end;

evaluate 'Case 14: reserved word DATE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DATE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DATE(); 
end;

evaluate 'Case 15: reserved word DATETIME as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DATETIME as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DATETIME(); 
end;

evaluate 'Case 16: reserved word DATETIMELTZ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DATETIMELTZ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DATETIMELTZ(); 
end;

evaluate 'Case 17: reserved word DATETIMETZ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DATETIMETZ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DATETIMETZ(); 
end;

evaluate 'Case 18: reserved word DEC as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DEC as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DEC(); 
end;

evaluate 'Case 19: reserved word DECIMAL as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DECIMAL as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DECIMAL(); 
end;

evaluate 'Case 20: reserved word DECLARE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DECLARE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DECLARE(); 
end;

evaluate 'Case 21: reserved word DEFAULT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DEFAULT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DEFAULT(); 
end;

evaluate 'Case 22: reserved word DIV as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DIV as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DIV(); 
end;

evaluate 'Case 23: reserved word DOUBLE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure DOUBLE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    DOUBLE(); 
end;

evaluate 'Case 24: reserved word ELSE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure ELSE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    ELSE(); 
end;

evaluate 'Case 25: reserved word ELSIF as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure ELSIF as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    ELSIF(); 
end;

evaluate 'Case 26: reserved word END as a local procedure name fails: END closes the routine early and the rest fails as separate statements; result = Error:-493';
create or replace procedure p_local() as 
    procedure END as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    END(); 
end;

evaluate 'Case 27: reserved word ESCAPE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure ESCAPE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    ESCAPE(); 
end;

evaluate 'Case 28: reserved word EXCEPTION as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure EXCEPTION as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    EXCEPTION(); 
end;

evaluate 'Case 29: reserved word EXECUTE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure EXECUTE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    EXECUTE(); 
end;

evaluate 'Case 30: reserved word EXIT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure EXIT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    EXIT(); 
end;

evaluate 'Case 31: reserved word FALSE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure FALSE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    FALSE(); 
end;

evaluate 'Case 32: reserved word FETCH as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure FETCH as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    FETCH(); 
end;

evaluate 'Case 33: reserved word FLOAT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure FLOAT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    FLOAT(); 
end;

evaluate 'Case 34: reserved word FOR as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure FOR as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    FOR(); 
end;

evaluate 'Case 35: reserved word IMMEDIATE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure IMMEDIATE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    IMMEDIATE(); 
end;

evaluate 'Case 36: reserved word IN as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure IN as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    IN(); 
end;

evaluate 'Case 37: reserved word INT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure INT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    INT(); 
end;

evaluate 'Case 38: reserved word INTEGER as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure INTEGER as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    INTEGER(); 
end;

evaluate 'Case 39: reserved word INTO as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure INTO as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    INTO(); 
end;

evaluate 'Case 40: reserved word IS as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure IS as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    IS(); 
end;

evaluate 'Case 41: reserved word LIKE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure LIKE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    LIKE(); 
end;

evaluate 'Case 42: reserved word LIST as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure LIST as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    LIST(); 
end;

evaluate 'Case 43: reserved word MOD as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure MOD as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    MOD(); 
end;

evaluate 'Case 44: reserved word MULTISET as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure MULTISET as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    MULTISET(); 
end;

evaluate 'Case 45: reserved word NOT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure NOT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    NOT(); 
end;

evaluate 'Case 46: reserved word NULL as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure NULL as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    NULL(); 
end;

evaluate 'Case 47: reserved word NUMERIC as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure NUMERIC as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    NUMERIC(); 
end;

evaluate 'Case 48: reserved word OPEN as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure OPEN as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    OPEN(); 
end;

evaluate 'Case 49: reserved word OR as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure OR as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    OR(); 
end;

evaluate 'Case 50: reserved word OUT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure OUT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    OUT(); 
end;

evaluate 'Case 51: reserved word PRAGMA as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure PRAGMA as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    PRAGMA(); 
end;

evaluate 'Case 52: reserved word RAISE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure RAISE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    RAISE(); 
end;

evaluate 'Case 53: reserved word REAL as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure REAL as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    REAL(); 
end;

evaluate 'Case 54: reserved word REPLACE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure REPLACE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    REPLACE(); 
end;

evaluate 'Case 55: reserved word RETURN as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure RETURN as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    RETURN(); 
end;

evaluate 'Case 56: reserved word REVERSE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure REVERSE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    REVERSE(); 
end;

evaluate 'Case 57: reserved word ROLLBACK as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure ROLLBACK as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    ROLLBACK(); 
end;

evaluate 'Case 58: reserved word SEQUENCE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SEQUENCE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SEQUENCE(); 
end;

evaluate 'Case 59: reserved word SET as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SET as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SET(); 
end;

evaluate 'Case 60: reserved word SETEQ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SETEQ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SETEQ(); 
end;

evaluate 'Case 61: reserved word SETNEQ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SETNEQ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SETNEQ(); 
end;

evaluate 'Case 62: reserved word SHORT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SHORT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SHORT(); 
end;

evaluate 'Case 63: reserved word SMALLINT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SMALLINT as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SMALLINT(); 
end;

evaluate 'Case 64: reserved word SQL as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SQL as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SQL(); 
end;

evaluate 'Case 65: reserved word STRING as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure STRING as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    STRING(); 
end;

evaluate 'Case 66: reserved word SUBSET as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SUBSET as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SUBSET(); 
end;

evaluate 'Case 67: reserved word SUBSETEQ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SUBSETEQ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SUBSETEQ(); 
end;

evaluate 'Case 68: reserved word SUPERSET as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SUPERSET as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SUPERSET(); 
end;

evaluate 'Case 69: reserved word SUPERSETEQ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SUPERSETEQ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SUPERSETEQ(); 
end;

evaluate 'Case 70: reserved word SYS_REFCURSOR as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure SYS_REFCURSOR as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    SYS_REFCURSOR(); 
end;

evaluate 'Case 71: reserved word THEN as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure THEN as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    THEN(); 
end;

evaluate 'Case 72: reserved word TIME as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure TIME as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    TIME(); 
end;

evaluate 'Case 73: reserved word TIMESTAMP as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure TIMESTAMP as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    TIMESTAMP(); 
end;

evaluate 'Case 74: reserved word TIMESTAMPLTZ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure TIMESTAMPLTZ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    TIMESTAMPLTZ(); 
end;

evaluate 'Case 75: reserved word TIMESTAMPTZ as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure TIMESTAMPTZ as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    TIMESTAMPTZ(); 
end;

evaluate 'Case 76: reserved word TRUE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure TRUE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    TRUE(); 
end;

evaluate 'Case 77: reserved word USING as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure USING as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    USING(); 
end;

evaluate 'Case 78: reserved word VARCHAR as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure VARCHAR as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    VARCHAR(); 
end;

evaluate 'Case 79: reserved word WHEN as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure WHEN as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    WHEN(); 
end;

evaluate 'Case 80: reserved word WHILE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure WHILE as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    WHILE(); 
end;

evaluate 'Case 81: reserved word WORK as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure WORK as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    WORK(); 
end;

evaluate 'Case 82: reserved word XOR as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as 
    procedure XOR as 
    begin 
        dbms_output.put_line('poo'); 
    end; 
begin
    XOR(); 
end;

evaluate 'Case 83: reserved word INSERT as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as
    procedure INSERT as
    begin
        dbms_output.put_line('poo');
    end;
begin
    INSERT();
end;

evaluate 'Case 84: reserved word TRUNCATE as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as
    procedure TRUNCATE as
    begin
        dbms_output.put_line('poo');
    end;
begin
    TRUNCATE();
end;

evaluate 'Case 85: reserved word AUTONOMOUS_TRANSACTION as a local procedure name fails to compile; result = Error:-1360';
create or replace procedure p_local() as
    procedure AUTONOMOUS_TRANSACTION as
    begin
        dbms_output.put_line('poo');
    end;
begin
    AUTONOMOUS_TRANSACTION();
end;

-- BEGIN opens a block, so the end lines after this create belong to its statement
evaluate 'Case 86: reserved word BEGIN as a local procedure name fails; result = Error:-493';
create or replace procedure p_local() as
    procedure BEGIN as
    begin
        dbms_output.put_line('poo');
    end;
begin
    BEGIN();
end;
end;
end;
end;




-- every case fails, so p_local does not exist and this drop fails unless a case created it by mistake
drop procedure p_local;


--+ server-message off

