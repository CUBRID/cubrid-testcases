--+ server-message on

-- Verification for CBRD-25111

select 'AND' ;
create or replace procedure p_local() as 
    function AND return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [AND]() ); 
end;

select 'AS' ;
create or replace procedure p_local() as 
    function AS return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [AS]() ); 
end;

select 'BETWEEN' ;
create or replace procedure p_local() as 
    function BETWEEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BETWEEN]() ); 
end;

select 'BIGINT' ;
create or replace procedure p_local() as 
    function BIGINT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BIGINT]() ); 
end;

select 'BOOLEAN' ;
create or replace procedure p_local() as 
    function BOOLEAN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BOOLEAN]() ); 
end;

select 'BY' ;
create or replace procedure p_local() as 
    function BY return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [BY]() ); 
end;

select 'CHAR' ;
create or replace procedure p_local() as 
    function CHAR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CHAR]() ); 
end;

select 'CLOSE' ;
create or replace procedure p_local() as 
    function CLOSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CLOSE]() ); 
end;

select 'COMMIT' ;
create or replace procedure p_local() as 
    function COMMIT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [COMMIT]() ); 
end;

select 'CONSTANT' ;
create or replace procedure p_local() as 
    function CONSTANT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CONSTANT]() ); 
end;

select 'CONTINUE' ;
create or replace procedure p_local() as 
    function CONTINUE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CONTINUE]() ); 
end;

select 'CREATE' ;
create or replace procedure p_local() as 
    function CREATE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CREATE]() ); 
end;

select 'CURSOR' ;
create or replace procedure p_local() as 
    function CURSOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [CURSOR]() ); 
end;

select 'DATE' ;
create or replace procedure p_local() as 
    function DATE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATE]() ); 
end;

select 'DATETIME' ;
create or replace procedure p_local() as 
    function DATETIME return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIME]() ); 
end;

select 'DATETIMELTZ' ;
create or replace procedure p_local() as 
    function DATETIMELTZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIMELTZ]() ); 
end;

select 'DATETIMETZ' ;
create or replace procedure p_local() as 
    function DATETIMETZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DATETIMETZ]() ); 
end;

select 'DEC' ;
create or replace procedure p_local() as 
    function DEC return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DEC]() ); 
end;

select 'DECIMAL' ;
create or replace procedure p_local() as 
    function DECIMAL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DECIMAL]() ); 
end;

select 'DECLARE' ;
create or replace procedure p_local() as 
    function DECLARE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DECLARE]() ); 
end;

select 'DEFAULT' ;
create or replace procedure p_local() as 
    function DEFAULT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DEFAULT]() ); 
end;

select 'DIV' ;
create or replace procedure p_local() as 
    function DIV return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DIV]() ); 
end;

select 'DOUBLE' ;
create or replace procedure p_local() as 
    function DOUBLE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [DOUBLE]() ); 
end;

select 'ELSE' ;
create or replace procedure p_local() as 
    function ELSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ELSE]() ); 
end;

select 'ELSIF' ;
create or replace procedure p_local() as 
    function ELSIF return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ELSIF]() ); 
end;

select 'END' ;
create or replace procedure p_local() as 
    function END return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [END]() ); 
end;

select 'ESCAPE' ;
create or replace procedure p_local() as 
    function ESCAPE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ESCAPE]() ); 
end;

select 'EXCEPTION' ;
create or replace procedure p_local() as 
    function EXCEPTION return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXCEPTION]() ); 
end;

select 'EXECUTE' ;
create or replace procedure p_local() as 
    function EXECUTE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXECUTE]() ); 
end;

select 'EXIT' ;
create or replace procedure p_local() as 
    function EXIT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [EXIT]() ); 
end;

select 'FALSE' ;
create or replace procedure p_local() as 
    function FALSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FALSE]() ); 
end;

select 'FETCH' ;
create or replace procedure p_local() as 
    function FETCH return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FETCH]() ); 
end;

select 'FLOAT' ;
create or replace procedure p_local() as 
    function FLOAT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FLOAT]() ); 
end;

select 'FOR' ;
create or replace procedure p_local() as 
    function FOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [FOR]() ); 
end;

select 'IMMEDIATE' ;
create or replace procedure p_local() as 
    function IMMEDIATE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IMMEDIATE]() ); 
end;

select 'IN' ;
create or replace procedure p_local() as 
    function IN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IN]() ); 
end;

select 'INT' ;
create or replace procedure p_local() as 
    function INT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INT]() ); 
end;

select 'INTEGER' ;
create or replace procedure p_local() as 
    function INTEGER return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INTEGER]() ); 
end;

select 'INTO' ;
create or replace procedure p_local() as 
    function INTO return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [INTO]() ); 
end;

select 'IS' ;
create or replace procedure p_local() as 
    function IS return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [IS]() ); 
end;

select 'LIKE' ;
create or replace procedure p_local() as 
    function LIKE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [LIKE]() ); 
end;

select 'LIST' ;
create or replace procedure p_local() as 
    function LIST return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [LIST]() ); 
end;

select 'MOD' ;
create or replace procedure p_local() as 
    function MOD return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [MOD]() ); 
end;

select 'MULTISET' ;
create or replace procedure p_local() as 
    function MULTISET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [MULTISET]() ); 
end;

select 'NOT' ;
create or replace procedure p_local() as 
    function NOT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NOT]() ); 
end;

select 'NULL' ;
create or replace procedure p_local() as 
    function NULL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NULL]() ); 
end;

select 'NUMERIC' ;
create or replace procedure p_local() as 
    function NUMERIC return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [NUMERIC]() ); 
end;

select 'OPEN' ;
create or replace procedure p_local() as 
    function OPEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OPEN]() ); 
end;

select 'OR' ;
create or replace procedure p_local() as 
    function OR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OR]() ); 
end;

select 'OUT' ;
create or replace procedure p_local() as 
    function OUT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [OUT]() ); 
end;

select 'PRAGMA' ;
create or replace procedure p_local() as 
    function PRAGMA return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [PRAGMA]() ); 
end;

select 'RAISE' ;
create or replace procedure p_local() as 
    function RAISE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [RAISE]() ); 
end;

select 'REAL' ;
create or replace procedure p_local() as 
    function REAL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REAL]() ); 
end;

select 'REPLACE' ;
create or replace procedure p_local() as 
    function REPLACE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REPLACE]() ); 
end;

select 'RETURN' ;
create or replace procedure p_local() as 
    function RETURN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [RETURN]() ); 
end;

select 'REVERSE' ;
create or replace procedure p_local() as 
    function REVERSE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [REVERSE]() ); 
end;

select 'ROLLBACK' ;
create or replace procedure p_local() as 
    function ROLLBACK return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [ROLLBACK]() ); 
end;

select 'SEQUENCE' ;
create or replace procedure p_local() as 
    function SEQUENCE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SEQUENCE]() ); 
end;

select 'SET' ;
create or replace procedure p_local() as 
    function SET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SET]() ); 
end;

select 'SETEQ' ;
create or replace procedure p_local() as 
    function SETEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SETEQ]() ); 
end;

select 'SETNEQ' ;
create or replace procedure p_local() as 
    function SETNEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SETNEQ]() ); 
end;

select 'SHORT' ;
create or replace procedure p_local() as 
    function SHORT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SHORT]() ); 
end;

select 'SMALLINT' ;
create or replace procedure p_local() as 
    function SMALLINT return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SMALLINT]() ); 
end;

select 'SQL' ;
create or replace procedure p_local() as 
    function SQL return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SQL]() ); 
end;

select 'STRING' ;
create or replace procedure p_local() as 
    function STRING return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [STRING]() ); 
end;

select 'SUBSET' ;
create or replace procedure p_local() as 
    function SUBSET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUBSET]() ); 
end;

select 'SUBSETEQ' ;
create or replace procedure p_local() as 
    function SUBSETEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUBSETEQ]() ); 
end;

select 'SUPERSET' ;
create or replace procedure p_local() as 
    function SUPERSET return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUPERSET]() ); 
end;

select 'SUPERSETEQ' ;
create or replace procedure p_local() as 
    function SUPERSETEQ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SUPERSETEQ]() ); 
end;

select 'SYS_REFCURSOR' ;
create or replace procedure p_local() as 
    function SYS_REFCURSOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [SYS_REFCURSOR]() ); 
end;

select 'THEN' ;
create or replace procedure p_local() as 
    function THEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [THEN]() ); 
end;

select 'TIME' ;
create or replace procedure p_local() as 
    function TIME return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIME]() ); 
end;

select 'TIMESTAMP' ;
create or replace procedure p_local() as 
    function TIMESTAMP return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMP]() ); 
end;

select 'TIMESTAMPLTZ' ;
create or replace procedure p_local() as 
    function TIMESTAMPLTZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMPLTZ]() ); 
end;

select 'TIMESTAMPTZ' ;
create or replace procedure p_local() as 
    function TIMESTAMPTZ return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TIMESTAMPTZ]() ); 
end;

select 'TRUE' ;
create or replace procedure p_local() as 
    function TRUE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [TRUE]() ); 
end;

select 'USING' ;
create or replace procedure p_local() as 
    function USING return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [USING]() ); 
end;

select 'VARCHAR' ;
create or replace procedure p_local() as 
    function VARCHAR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [VARCHAR]() ); 
end;

select 'WHEN' ;
create or replace procedure p_local() as 
    function WHEN return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WHEN]() ); 
end;

select 'WHILE' ;
create or replace procedure p_local() as 
    function WHILE return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WHILE]() ); 
end;

select 'WORK' ;
create or replace procedure p_local() as 
    function WORK return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [WORK]() ); 
end;

select 'XOR' ;
create or replace procedure p_local() as 
    function XOR return int as 
    begin 
        return 51; 
    end; 
begin
    dbms_output.put_line('call local function =' || [XOR]() ); 
end;

select 'INSERT' ;
create or replace procedure p_local() as
    function INSERT return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [INSERT]() );
end;

select 'TRUNCATE' ;
create or replace procedure p_local() as
    function TRUNCATE return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [TRUNCATE]() );
end;

select 'AUTONOMOUS_TRANSACTION' ;
create or replace procedure p_local() as
    function AUTONOMOUS_TRANSACTION return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [AUTONOMOUS_TRANSACTION]() );
end;

select 'BEGIN' ;
create or replace procedure p_local() as
    function BEGIN return int as
    begin
        return 51;
    end;
begin
    dbms_output.put_line('call local function =' || [BEGIN]() );
end;


drop procedure p_local;


--+ server-message off

