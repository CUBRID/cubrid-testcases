--+ server-message on

-- 

create or replace procedure p_var(i int) as 
[AND] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [AND];
    end if;
EXCEPTION    WHEN [AND] THEN 
              put_line('call exception:' || 'AND' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[AS] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [AS];
    end if;
EXCEPTION    WHEN [AS] THEN 
              put_line('call exception:' || 'AS' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[BEGIN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [BEGIN];
    end if;
EXCEPTION    WHEN [BEGIN] THEN 
              put_line('call exception:' || 'BEGIN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[BETWEEN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [BETWEEN];
    end if;
EXCEPTION    WHEN [BETWEEN] THEN 
              put_line('call exception:' || 'BETWEEN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[BIGINT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [BIGINT];
    end if;
EXCEPTION    WHEN [BIGINT] THEN 
              put_line('call exception:' || 'BIGINT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[BOOLEAN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [BOOLEAN];
    end if;
EXCEPTION    WHEN [BOOLEAN] THEN 
              put_line('call exception:' || 'BOOLEAN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[BY] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [BY];
    end if;
EXCEPTION    WHEN [BY] THEN 
              put_line('call exception:' || 'BY' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[CASE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [CASE];
    end if;
EXCEPTION    WHEN [CASE] THEN 
              put_line('call exception:' || 'CASE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[CHAR] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [CHAR];
    end if;
EXCEPTION    WHEN [CHAR] THEN 
              put_line('call exception:' || 'CHAR' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[CLOSE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [CLOSE];
    end if;
EXCEPTION    WHEN [CLOSE] THEN 
              put_line('call exception:' || 'CLOSE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[COMMIT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [COMMIT];
    end if;
EXCEPTION    WHEN [COMMIT] THEN 
              put_line('call exception:' || 'COMMIT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[CONSTANT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [CONSTANT];
    end if;
EXCEPTION    WHEN [CONSTANT] THEN 
              put_line('call exception:' || 'CONSTANT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[CONTINUE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [CONTINUE];
    end if;
EXCEPTION    WHEN [CONTINUE] THEN 
              put_line('call exception:' || 'CONTINUE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[CREATE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [CREATE];
    end if;
EXCEPTION    WHEN [CREATE] THEN 
              put_line('call exception:' || 'CREATE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[CURSOR] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [CURSOR];
    end if;
EXCEPTION    WHEN [CURSOR] THEN 
              put_line('call exception:' || 'CURSOR' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DATE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DATE];
    end if;
EXCEPTION    WHEN [DATE] THEN 
              put_line('call exception:' || 'DATE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DATETIME] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DATETIME];
    end if;
EXCEPTION    WHEN [DATETIME] THEN 
              put_line('call exception:' || 'DATETIME' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DATETIMELTZ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DATETIMELTZ];
    end if;
EXCEPTION    WHEN [DATETIMELTZ] THEN 
              put_line('call exception:' || 'DATETIMELTZ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DATETIMETZ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DATETIMETZ];
    end if;
EXCEPTION    WHEN [DATETIMETZ] THEN 
              put_line('call exception:' || 'DATETIMETZ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DEC] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DEC];
    end if;
EXCEPTION    WHEN [DEC] THEN 
              put_line('call exception:' || 'DEC' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DECIMAL] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DECIMAL];
    end if;
EXCEPTION    WHEN [DECIMAL] THEN 
              put_line('call exception:' || 'DECIMAL' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DECLARE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DECLARE];
    end if;
EXCEPTION    WHEN [DECLARE] THEN 
              put_line('call exception:' || 'DECLARE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DEFAULT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DEFAULT];
    end if;
EXCEPTION    WHEN [DEFAULT] THEN 
              put_line('call exception:' || 'DEFAULT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DIV] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DIV];
    end if;
EXCEPTION    WHEN [DIV] THEN 
              put_line('call exception:' || 'DIV' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[DOUBLE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [DOUBLE];
    end if;
EXCEPTION    WHEN [DOUBLE] THEN 
              put_line('call exception:' || 'DOUBLE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[ELSE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [ELSE];
    end if;
EXCEPTION    WHEN [ELSE] THEN 
              put_line('call exception:' || 'ELSE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[ELSIF] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [ELSIF];
    end if;
EXCEPTION    WHEN [ELSIF] THEN 
              put_line('call exception:' || 'ELSIF' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[END] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [END];
    end if;
EXCEPTION    WHEN [END] THEN 
              put_line('call exception:' || 'END' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[ESCAPE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [ESCAPE];
    end if;
EXCEPTION    WHEN [ESCAPE] THEN 
              put_line('call exception:' || 'ESCAPE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[EXCEPTION] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [EXCEPTION];
    end if;
EXCEPTION    WHEN [EXCEPTION] THEN 
              put_line('call exception:' || 'EXCEPTION' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[EXECUTE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [EXECUTE];
    end if;
EXCEPTION    WHEN [EXECUTE] THEN 
              put_line('call exception:' || 'EXECUTE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[EXIT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [EXIT];
    end if;
EXCEPTION    WHEN [EXIT] THEN 
              put_line('call exception:' || 'EXIT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[FALSE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [FALSE];
    end if;
EXCEPTION    WHEN [FALSE] THEN 
              put_line('call exception:' || 'FALSE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[FETCH] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [FETCH];
    end if;
EXCEPTION    WHEN [FETCH] THEN 
              put_line('call exception:' || 'FETCH' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[FLOAT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [FLOAT];
    end if;
EXCEPTION    WHEN [FLOAT] THEN 
              put_line('call exception:' || 'FLOAT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[FOR] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [FOR];
    end if;
EXCEPTION    WHEN [FOR] THEN 
              put_line('call exception:' || 'FOR' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[FUNCTION] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [FUNCTION];
    end if;
EXCEPTION    WHEN [FUNCTION] THEN 
              put_line('call exception:' || 'FUNCTION' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[IF] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [IF];
    end if;
EXCEPTION    WHEN [IF] THEN 
              put_line('call exception:' || 'IF' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[IMMEDIATE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [IMMEDIATE];
    end if;
EXCEPTION    WHEN [IMMEDIATE] THEN 
              put_line('call exception:' || 'IMMEDIATE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[IN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [IN];
    end if;
EXCEPTION    WHEN [IN] THEN 
              put_line('call exception:' || 'IN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[INT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [INT];
    end if;
EXCEPTION    WHEN [INT] THEN 
              put_line('call exception:' || 'INT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[INTEGER] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [INTEGER];
    end if;
EXCEPTION    WHEN [INTEGER] THEN 
              put_line('call exception:' || 'INTEGER' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[INTO] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [INTO];
    end if;
EXCEPTION    WHEN [INTO] THEN 
              put_line('call exception:' || 'INTO' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[IS] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [IS];
    end if;
EXCEPTION    WHEN [IS] THEN 
              put_line('call exception:' || 'IS' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[LIKE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [LIKE];
    end if;
EXCEPTION    WHEN [LIKE] THEN 
              put_line('call exception:' || 'LIKE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[LIST] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [LIST];
    end if;
EXCEPTION    WHEN [LIST] THEN 
              put_line('call exception:' || 'LIST' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[LOOP] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [LOOP];
    end if;
EXCEPTION    WHEN [LOOP] THEN 
              put_line('call exception:' || 'LOOP' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[MOD] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [MOD];
    end if;
EXCEPTION    WHEN [MOD] THEN 
              put_line('call exception:' || 'MOD' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[MULTISET] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [MULTISET];
    end if;
EXCEPTION    WHEN [MULTISET] THEN 
              put_line('call exception:' || 'MULTISET' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[NOT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [NOT];
    end if;
EXCEPTION    WHEN [NOT] THEN 
              put_line('call exception:' || 'NOT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[NULL] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [NULL];
    end if;
EXCEPTION    WHEN [NULL] THEN 
              put_line('call exception:' || 'NULL' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[NUMERIC] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [NUMERIC];
    end if;
EXCEPTION    WHEN [NUMERIC] THEN 
              put_line('call exception:' || 'NUMERIC' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[OPEN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [OPEN];
    end if;
EXCEPTION    WHEN [OPEN] THEN 
              put_line('call exception:' || 'OPEN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[OR] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [OR];
    end if;
EXCEPTION    WHEN [OR] THEN 
              put_line('call exception:' || 'OR' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[OUT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [OUT];
    end if;
EXCEPTION    WHEN [OUT] THEN 
              put_line('call exception:' || 'OUT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[PRAGMA] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [PRAGMA];
    end if;
EXCEPTION    WHEN [PRAGMA] THEN 
              put_line('call exception:' || 'PRAGMA' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[PROCEDURE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [PROCEDURE];
    end if;
EXCEPTION    WHEN [PROCEDURE] THEN 
              put_line('call exception:' || 'PROCEDURE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[RAISE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [RAISE];
    end if;
EXCEPTION    WHEN [RAISE] THEN 
              put_line('call exception:' || 'RAISE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[REAL] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [REAL];
    end if;
EXCEPTION    WHEN [REAL] THEN 
              put_line('call exception:' || 'REAL' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[REPLACE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [REPLACE];
    end if;
EXCEPTION    WHEN [REPLACE] THEN 
              put_line('call exception:' || 'REPLACE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[RETURN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [RETURN];
    end if;
EXCEPTION    WHEN [RETURN] THEN 
              put_line('call exception:' || 'RETURN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[REVERSE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [REVERSE];
    end if;
EXCEPTION    WHEN [REVERSE] THEN 
              put_line('call exception:' || 'REVERSE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[ROLLBACK] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [ROLLBACK];
    end if;
EXCEPTION    WHEN [ROLLBACK] THEN 
              put_line('call exception:' || 'ROLLBACK' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SEQUENCE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SEQUENCE];
    end if;
EXCEPTION    WHEN [SEQUENCE] THEN 
              put_line('call exception:' || 'SEQUENCE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SET] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SET];
    end if;
EXCEPTION    WHEN [SET] THEN 
              put_line('call exception:' || 'SET' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SETEQ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SETEQ];
    end if;
EXCEPTION    WHEN [SETEQ] THEN 
              put_line('call exception:' || 'SETEQ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SETNEQ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SETNEQ];
    end if;
EXCEPTION    WHEN [SETNEQ] THEN 
              put_line('call exception:' || 'SETNEQ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SHORT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SHORT];
    end if;
EXCEPTION    WHEN [SHORT] THEN 
              put_line('call exception:' || 'SHORT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SMALLINT] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SMALLINT];
    end if;
EXCEPTION    WHEN [SMALLINT] THEN 
              put_line('call exception:' || 'SMALLINT' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SQL] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SQL];
    end if;
EXCEPTION    WHEN [SQL] THEN 
              put_line('call exception:' || 'SQL' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[STRING] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [STRING];
    end if;
EXCEPTION    WHEN [STRING] THEN 
              put_line('call exception:' || 'STRING' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SUBSET] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SUBSET];
    end if;
EXCEPTION    WHEN [SUBSET] THEN 
              put_line('call exception:' || 'SUBSET' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SUBSETEQ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SUBSETEQ];
    end if;
EXCEPTION    WHEN [SUBSETEQ] THEN 
              put_line('call exception:' || 'SUBSETEQ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SUPERSET] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SUPERSET];
    end if;
EXCEPTION    WHEN [SUPERSET] THEN 
              put_line('call exception:' || 'SUPERSET' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SUPERSETEQ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SUPERSETEQ];
    end if;
EXCEPTION    WHEN [SUPERSETEQ] THEN 
              put_line('call exception:' || 'SUPERSETEQ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[SYS_REFCURSOR] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [SYS_REFCURSOR];
    end if;
EXCEPTION    WHEN [SYS_REFCURSOR] THEN 
              put_line('call exception:' || 'SYS_REFCURSOR' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[THEN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [THEN];
    end if;
EXCEPTION    WHEN [THEN] THEN 
              put_line('call exception:' || 'THEN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[TIME] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [TIME];
    end if;
EXCEPTION    WHEN [TIME] THEN 
              put_line('call exception:' || 'TIME' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[TIMESTAMP] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [TIMESTAMP];
    end if;
EXCEPTION    WHEN [TIMESTAMP] THEN 
              put_line('call exception:' || 'TIMESTAMP' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[TIMESTAMPLTZ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [TIMESTAMPLTZ];
    end if;
EXCEPTION    WHEN [TIMESTAMPLTZ] THEN 
              put_line('call exception:' || 'TIMESTAMPLTZ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[TIMESTAMPTZ] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [TIMESTAMPTZ];
    end if;
EXCEPTION    WHEN [TIMESTAMPTZ] THEN 
              put_line('call exception:' || 'TIMESTAMPTZ' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[TRUE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [TRUE];
    end if;
EXCEPTION    WHEN [TRUE] THEN 
              put_line('call exception:' || 'TRUE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[USING] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [USING];
    end if;
EXCEPTION    WHEN [USING] THEN 
              put_line('call exception:' || 'USING' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[VARCHAR] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [VARCHAR];
    end if;
EXCEPTION    WHEN [VARCHAR] THEN 
              put_line('call exception:' || 'VARCHAR' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[WHEN] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [WHEN];
    end if;
EXCEPTION    WHEN [WHEN] THEN 
              put_line('call exception:' || 'WHEN' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[WHILE] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [WHILE];
    end if;
EXCEPTION    WHEN [WHILE] THEN 
              put_line('call exception:' || 'WHILE' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[WORK] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [WORK];
    end if;
EXCEPTION    WHEN [WORK] THEN 
              put_line('call exception:' || 'WORK' );
end;
call p_var(123);

create or replace procedure p_var(i int) as 
[XOR] EXCEPTION; 
begin
    IF i > 0 THEN 
        RAISE [XOR];
    end if;
EXCEPTION    WHEN [XOR] THEN 
              put_line('call exception:' || 'XOR' );
end;
call p_var(123);

drop procedure p_var;

--+ server-message off

