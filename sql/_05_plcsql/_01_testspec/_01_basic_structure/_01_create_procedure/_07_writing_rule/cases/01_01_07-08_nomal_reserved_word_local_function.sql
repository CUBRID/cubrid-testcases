--+ server-message on

-- 

create or replace procedure p_local() as 
    function [AND] return varchar as 
    begin 
        return 'AND'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [AND]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [AS] return varchar as 
    begin 
        return 'AS'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [AS]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [BEGIN] return varchar as 
    begin 
        return 'BEGIN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BEGIN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [BETWEEN] return varchar as 
    begin 
        return 'BETWEEN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BETWEEN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [BIGINT] return varchar as 
    begin 
        return 'BIGINT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BIGINT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [BOOLEAN] return varchar as 
    begin 
        return 'BOOLEAN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BOOLEAN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [BY] return varchar as 
    begin 
        return 'BY'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BY]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [CASE] return varchar as 
    begin 
        return 'CASE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CASE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [CHAR] return varchar as 
    begin 
        return 'CHAR'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CHAR]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [CLOSE] return varchar as 
    begin 
        return 'CLOSE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CLOSE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [COMMIT] return varchar as 
    begin 
        return 'COMMIT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [COMMIT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [CONSTANT] return varchar as 
    begin 
        return 'CONSTANT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CONSTANT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [CONTINUE] return varchar as 
    begin 
        return 'CONTINUE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CONTINUE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [CREATE] return varchar as 
    begin 
        return 'CREATE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CREATE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [CURSOR] return varchar as 
    begin 
        return 'CURSOR'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CURSOR]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DATE] return varchar as 
    begin 
        return 'DATE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DATETIME] return varchar as 
    begin 
        return 'DATETIME'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIME]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DATETIMELTZ] return varchar as 
    begin 
        return 'DATETIMELTZ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIMELTZ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DATETIMETZ] return varchar as 
    begin 
        return 'DATETIMETZ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIMETZ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DEC] return varchar as 
    begin 
        return 'DEC'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DEC]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DECIMAL] return varchar as 
    begin 
        return 'DECIMAL'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DECIMAL]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DECLARE] return varchar as 
    begin 
        return 'DECLARE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DECLARE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DEFAULT] return varchar as 
    begin 
        return 'DEFAULT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DEFAULT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DIV] return varchar as 
    begin 
        return 'DIV'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DIV]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [DOUBLE] return varchar as 
    begin 
        return 'DOUBLE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DOUBLE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [ELSE] return varchar as 
    begin 
        return 'ELSE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ELSE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [ELSIF] return varchar as 
    begin 
        return 'ELSIF'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ELSIF]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [END] return varchar as 
    begin 
        return 'END'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [END]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [ESCAPE] return varchar as 
    begin 
        return 'ESCAPE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ESCAPE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [EXCEPTION] return varchar as 
    begin 
        return 'EXCEPTION'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXCEPTION]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [EXECUTE] return varchar as 
    begin 
        return 'EXECUTE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXECUTE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [EXIT] return varchar as 
    begin 
        return 'EXIT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXIT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [FALSE] return varchar as 
    begin 
        return 'FALSE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FALSE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [FETCH] return varchar as 
    begin 
        return 'FETCH'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FETCH]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [FLOAT] return varchar as 
    begin 
        return 'FLOAT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FLOAT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [FOR] return varchar as 
    begin 
        return 'FOR'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FOR]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [FUNCTION] return varchar as 
    begin 
        return 'FUNCTION'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FUNCTION]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [IF] return varchar as 
    begin 
        return 'IF'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IF]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [IMMEDIATE] return varchar as 
    begin 
        return 'IMMEDIATE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IMMEDIATE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [IN] return varchar as 
    begin 
        return 'IN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [INT] return varchar as 
    begin 
        return 'INT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [INTEGER] return varchar as 
    begin 
        return 'INTEGER'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INTEGER]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [INTO] return varchar as 
    begin 
        return 'INTO'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INTO]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [IS] return varchar as 
    begin 
        return 'IS'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IS]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [LIKE] return varchar as 
    begin 
        return 'LIKE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [LIKE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [LIST] return varchar as 
    begin 
        return 'LIST'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [LIST]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [LOOP] return varchar as 
    begin 
        return 'LOOP'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [LOOP]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [MOD] return varchar as 
    begin 
        return 'MOD'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [MOD]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [MULTISET] return varchar as 
    begin 
        return 'MULTISET'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [MULTISET]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [NOT] return varchar as 
    begin 
        return 'NOT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NOT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [NULL] return varchar as 
    begin 
        return 'NULL'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NULL]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [NUMERIC] return varchar as 
    begin 
        return 'NUMERIC'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NUMERIC]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [OPEN] return varchar as 
    begin 
        return 'OPEN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OPEN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [OR] return varchar as 
    begin 
        return 'OR'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OR]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [OUT] return varchar as 
    begin 
        return 'OUT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OUT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [PRAGMA] return varchar as 
    begin 
        return 'PRAGMA'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [PRAGMA]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [PROCEDURE] return varchar as 
    begin 
        return 'PROCEDURE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [PROCEDURE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [RAISE] return varchar as 
    begin 
        return 'RAISE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [RAISE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [REAL] return varchar as 
    begin 
        return 'REAL'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REAL]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [REPLACE] return varchar as 
    begin 
        return 'REPLACE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REPLACE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [RETURN] return varchar as 
    begin 
        return 'RETURN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [RETURN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [REVERSE] return varchar as 
    begin 
        return 'REVERSE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REVERSE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [ROLLBACK] return varchar as 
    begin 
        return 'ROLLBACK'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ROLLBACK]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SEQUENCE] return varchar as 
    begin 
        return 'SEQUENCE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SEQUENCE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SET] return varchar as 
    begin 
        return 'SET'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SET]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SETEQ] return varchar as 
    begin 
        return 'SETEQ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SETEQ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SETNEQ] return varchar as 
    begin 
        return 'SETNEQ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SETNEQ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SHORT] return varchar as 
    begin 
        return 'SHORT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SHORT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SMALLINT] return varchar as 
    begin 
        return 'SMALLINT'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SMALLINT]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SQL] return varchar as 
    begin 
        return 'SQL'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SQL]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [STRING] return varchar as 
    begin 
        return 'STRING'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [STRING]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SUBSET] return varchar as 
    begin 
        return 'SUBSET'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUBSET]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SUBSETEQ] return varchar as 
    begin 
        return 'SUBSETEQ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUBSETEQ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SUPERSET] return varchar as 
    begin 
        return 'SUPERSET'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUPERSET]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SUPERSETEQ] return varchar as 
    begin 
        return 'SUPERSETEQ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUPERSETEQ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [SYS_REFCURSOR] return varchar as 
    begin 
        return 'SYS_REFCURSOR'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SYS_REFCURSOR]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [THEN] return varchar as 
    begin 
        return 'THEN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [THEN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [TIME] return varchar as 
    begin 
        return 'TIME'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIME]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [TIMESTAMP] return varchar as 
    begin 
        return 'TIMESTAMP'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMP]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [TIMESTAMPLTZ] return varchar as 
    begin 
        return 'TIMESTAMPLTZ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMPLTZ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [TIMESTAMPTZ] return varchar as 
    begin 
        return 'TIMESTAMPTZ'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMPTZ]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [TRUE] return varchar as 
    begin 
        return 'TRUE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TRUE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [USING] return varchar as 
    begin 
        return 'USING'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [USING]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [VARCHAR] return varchar as 
    begin 
        return 'VARCHAR'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [VARCHAR]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [WHEN] return varchar as 
    begin 
        return 'WHEN'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WHEN]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [WHILE] return varchar as 
    begin 
        return 'WHILE'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WHILE]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [WORK] return varchar as 
    begin 
        return 'WORK'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WORK]() ); 
end;
call p_local();

create or replace procedure p_local() as 
    function [XOR] return varchar as 
    begin 
        return 'XOR'; 
    end; 
begin
    dbms_output.put_line('call local function =' || [XOR]() ); 
end;
call p_local();

drop procedure p_local;

--+ server-message off
