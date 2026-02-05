--+ server-message on
-- Verified for CBRD-26306
-- Bug fix: Some reserved words had error when Insert clause on pl/csql

CREATE TABLE reserved1
(
    [absolute] CHAR(1), [action] CHAR(1), [add] CHAR(1), [after] CHAR(1),
    [all] CHAR(1), [alter] CHAR(1), [any] CHAR(1), [are] CHAR(1),
    [asc] CHAR(1), [as] CHAR(1), [assertion] CHAR(1), [at] CHAR(1),
    [attach] CHAR(1), [attribute] CHAR(1), [between] CHAR(1), [before] CHAR(1),
    [binary] CHAR(1), [bit] CHAR(1), [bit_length] CHAR(1), [blob] CHAR(1),
    [both] CHAR(1), [breadth] CHAR(1), [buffer] CHAR(1), [by] CHAR(1),
    [call] CHAR(1), [cascade] CHAR(1), [cascaded] CHAR(1), [case] CHAR(1),
    [cast] CHAR(1), [catalog] CHAR(1), [char_length] CHAR(1), [character] CHAR(1),
    [character_length] CHAR(1), [check] CHAR(1), [class] CHAR(1), [close] CHAR(1),
    [coalesce] CHAR(1), [collate] CHAR(1), [collation] CHAR(1), [column] CHAR(1),
    [comment] CHAR(1), [commit] CHAR(1), [connect] CHAR(1), [connection] CHAR(1),
    [constraints] CHAR(1), [contained] CHAR(1), [continue] CHAR(1), [convert] CHAR(1),
    [corresponding] CHAR(1), [create] CHAR(1), [cube] CHAR(1), [current_date] CHAR(1),
    [current_time] CHAR(1), [current_timestamp] CHAR(1), [current_user] CHAR(1), [cursor] CHAR(1),
    [cycle] CHAR(1), [data] CHAR(1), [database] CHAR(1), [date] CHAR(1),
    [datetime] CHAR(1), [dec] CHAR(1), [decimal] CHAR(1),
    [declare] CHAR(1), [deallocate] CHAR(1), [default] CHAR(1), [deferrable] CHAR(1),
    [deferred] CHAR(1), [delete] CHAR(1), [derived] CHAR(1), [desc] CHAR(1),
    [diagnostics] CHAR(1), [distinct] CHAR(1), [domain] CHAR(1), [double] CHAR(1),
    [drop] CHAR(1), [each] CHAR(1), [else] CHAR(1), [elsif] CHAR(1),
    [end] CHAR(1), [escaped] CHAR(1), [every] CHAR(1), [except] CHAR(1),
    [exception] CHAR(1), [execute] CHAR(1), [exists] CHAR(1), [ext] CHAR(1)
);

CREATE OR REPLACE PROCEDURE reserved_test1 AS
    CURSOR c IS
        SELECT
            '0' AS [absolute], '1' AS [action], '2' AS [add], '3' AS [after],
            '4' AS [all], '5' AS [alter], '6' AS [any], '7' AS [are],
            '8' AS [asc], '9' AS [as], '0' AS [assertion], '1' AS [at],
            '2' AS [attach], '3' AS [attribute], '4' AS [between], '5' AS [before],
            '6' AS [binary], '7' AS [bit], '8' AS [bit_length], '9' AS [blob],
            '0' AS [both], '1' AS [breadth], '2' AS [buffer], '3' AS [by],
            '4' AS [call], '5' AS [cascade], '6' AS [cascaded], '7' AS [case],
            '8' AS [cast], '9' AS [catalog], '0' AS [char_length], '1' AS [character],
            '2' AS [character_length], '3' AS [check], '4' AS [class], '5' AS [close],
            '6' AS [coalesce], '7' AS [collate], '8' AS [collation], '9' AS [column],
            '0' AS [comment], '1' AS [commit], '2' AS [connect], '3' AS [connection],
            '4' AS [constraints], '5' AS [contained], '6' AS [continue], '7' AS [convert],
            '8' AS [corresponding], '9' AS [create], '0' AS [cube], '1' AS [current_date],
            '2' AS [current_time], '3' AS [current_timestamp], '4' AS [current_user], '5' AS [cursor],
            '6' AS [cycle], '7' AS [data], '8' AS [database], '9' AS [date],
            '0' AS [datetime], '1' AS [dec], '2' AS [decimal],
            '3' AS [declare], '4' AS [deallocate], '5' AS [default], '6' AS [deferrable],
            '7' AS [deferred], '8' AS [delete], '9' AS [derived], '0' AS [desc],
            '1' AS [diagnostics], '2' AS [distinct], '3' AS [domain], '4' AS [double],
            '5' AS [drop], '6' AS [each], '7' AS [else], '8' AS [elsif],
            '9' AS [end], '0' AS [escaped], '1' AS [every], '2' AS [except],
            '3' AS [exception], '4' AS [execute], '5' AS [exists], '6' AS [ext]
        FROM dual;
BEGIN
    FOR rec IN c LOOP
        INSERT INTO reserved1
        (
            [absolute], [action], [add], [after],
            [all], [alter], [any], [are],
            [asc], [as], [assertion], [at],
            [attach], [attribute], [between], [before],
            [binary], [bit], [bit_length], [blob],
            [both], [breadth], [buffer], [by],
            [call], [cascade], [cascaded], [case],
            [cast], [catalog], [char_length], [character],
            [character_length], [check], [class], [close],
            [coalesce], [collate], [collation], [column],
            [comment], [commit], [connect], [connection],
            [constraints], [contained], [continue], [convert],
            [corresponding], [create], [cube], [current_date],
            [current_time], [current_timestamp], [current_user], [cursor],
            [cycle], [data], [database], [date],
            [datetime], [dec], [decimal],
            [declare], [deallocate], [default], [deferrable],
            [deferred], [delete], [derived], [desc],
            [diagnostics], [distinct], [domain], [double],
            [drop], [each], [else], [elsif],
            [end], [escaped], [every], [except],
            [exception], [execute], [exists], [ext]
        )
        VALUES
        (
            rec.[absolute], rec.[action], rec.[add], rec.[after],
            rec.[all], rec.[alter], rec.[any], rec.[are],
            rec.[asc], rec.[as], rec.[assertion], rec.[at],
            rec.[attach], rec.[attribute], rec.[between], rec.[before],
            rec.[binary], rec.[bit], rec.[bit_length], rec.[blob],
            rec.[both], rec.[breadth], rec.[buffer], rec.[by],
            rec.[call], rec.[cascade], rec.[cascaded], rec.[case],
            rec.[cast], rec.[catalog], rec.[char_length], rec.[character],
            rec.[character_length], rec.[check], rec.[class], rec.[close],
            rec.[coalesce], rec.[collate], rec.[collation], rec.[column],
            rec.[comment], rec.[commit], rec.[connect], rec.[connection],
            rec.[constraints], rec.[contained], rec.[continue], rec.[convert],
            rec.[corresponding], rec.[create], rec.[cube], rec.[current_date],
            rec.[current_time], rec.[current_timestamp], rec.[current_user], rec.[cursor],
            rec.[cycle], rec.[data], rec.[database], rec.[date],
            rec.[datetime], rec.[dec], rec.[decimal],
            rec.[declare], rec.[deallocate], rec.[default], rec.[deferrable],
            rec.[deferred], rec.[delete], rec.[derived], rec.[desc],
            rec.[diagnostics], rec.[distinct], rec.[domain], rec.[double],
            rec.[drop], rec.[each], rec.[else], rec.[elsif],
            rec.[end], rec.[escaped], rec.[every], rec.[except],
            rec.[exception], rec.[execute], rec.[exists], rec.[ext]
        );
    END LOOP;

    dbms_output.put_line('success procedure');
END;

CREATE OR REPLACE function reserved_test2() return string AS
    CURSOR c IS
        SELECT
            '0' AS [absolute], '1' AS [action], '2' AS [add], '3' AS [after],
            '4' AS [all], '5' AS [alter], '6' AS [any], '7' AS [are],
            '8' AS [asc], '9' AS [as], '0' AS [assertion], '1' AS [at],
            '2' AS [attach], '3' AS [attribute], '4' AS [between], '5' AS [before],
            '6' AS [binary], '7' AS [bit], '8' AS [bit_length], '9' AS [blob],
            '0' AS [both], '1' AS [breadth], '2' AS [buffer], '3' AS [by],
            '4' AS [call], '5' AS [cascade], '6' AS [cascaded], '7' AS [case],
            '8' AS [cast], '9' AS [catalog], '0' AS [char_length], '1' AS [character],
            '2' AS [character_length], '3' AS [check], '4' AS [class], '5' AS [close],
            '6' AS [coalesce], '7' AS [collate], '8' AS [collation], '9' AS [column],
            '0' AS [comment], '1' AS [commit], '2' AS [connect], '3' AS [connection],
            '4' AS [constraints], '5' AS [contained], '6' AS [continue], '7' AS [convert],
            '8' AS [corresponding], '9' AS [create], '0' AS [cube], '1' AS [current_date],
            '2' AS [current_time], '3' AS [current_timestamp], '4' AS [current_user], '5' AS [cursor],
            '6' AS [cycle], '7' AS [data], '8' AS [database], '9' AS [date],
            '0' AS [datetime], '1' AS [dec], '2' AS [decimal],
            '3' AS [declare], '4' AS [deallocate], '5' AS [default], '6' AS [deferrable],
            '7' AS [deferred], '8' AS [delete], '9' AS [derived], '0' AS [desc],
            '1' AS [diagnostics], '2' AS [distinct], '3' AS [domain], '4' AS [double],
            '5' AS [drop], '6' AS [each], '7' AS [else], '8' AS [elsif],
            '9' AS [end], '0' AS [escaped], '1' AS [every], '2' AS [except],
            '3' AS [exception], '4' AS [execute], '5' AS [exists], '6' AS [ext]
        FROM dual;
BEGIN
    FOR rec IN c LOOP
        INSERT INTO reserved1
        (
            [absolute], [action], [add], [after],
            [all], [alter], [any], [are],
            [asc], [as], [assertion], [at],
            [attach], [attribute], [between], [before],
            [binary], [bit], [bit_length], [blob],
            [both], [breadth], [buffer], [by],
            [call], [cascade], [cascaded], [case],
            [cast], [catalog], [char_length], [character],
            [character_length], [check], [class], [close],
            [coalesce], [collate], [collation], [column],
            [comment], [commit], [connect], [connection],
            [constraints], [contained], [continue], [convert],
            [corresponding], [create], [cube], [current_date],
            [current_time], [current_timestamp], [current_user], [cursor],
            [cycle], [data], [database], [date],
            [datetime], [dec], [decimal],
            [declare], [deallocate], [default], [deferrable],
            [deferred], [delete], [derived], [desc],
            [diagnostics], [distinct], [domain], [double],
            [drop], [each], [else], [elsif],
            [end], [escaped], [every], [except],
            [exception], [execute], [exists], [ext]
        )
        VALUES
        (
            rec.[absolute], rec.[action], rec.[add], rec.[after],
            rec.[all], rec.[alter], rec.[any], rec.[are],
            rec.[asc], rec.[as], rec.[assertion], rec.[at],
            rec.[attach], rec.[attribute], rec.[between], rec.[before],
            rec.[binary], rec.[bit], rec.[bit_length], rec.[blob],
            rec.[both], rec.[breadth], rec.[buffer], rec.[by],
            rec.[call], rec.[cascade], rec.[cascaded], rec.[case],
            rec.[cast], rec.[catalog], rec.[char_length], rec.[character],
            rec.[character_length], rec.[check], rec.[class], rec.[close],
            rec.[coalesce], rec.[collate], rec.[collation], rec.[column],
            rec.[comment], rec.[commit], rec.[connect], rec.[connection],
            rec.[constraints], rec.[contained], rec.[continue], rec.[convert],
            rec.[corresponding], rec.[create], rec.[cube], rec.[current_date],
            rec.[current_time], rec.[current_timestamp], rec.[current_user], rec.[cursor],
            rec.[cycle], rec.[data], rec.[database], rec.[date],
            rec.[datetime], rec.[dec], rec.[decimal],
            rec.[declare], rec.[deallocate], rec.[default], rec.[deferrable],
            rec.[deferred], rec.[delete], rec.[derived], rec.[desc],
            rec.[diagnostics], rec.[distinct], rec.[domain], rec.[double],
            rec.[drop], rec.[each], rec.[else], rec.[elsif],
            rec.[end], rec.[escaped], rec.[every], rec.[except],
            rec.[exception], rec.[execute], rec.[exists], rec.[ext]
        );
    END LOOP;

    return 'success function';
END;



call reserved_test1();
select reserved_test2() from dual;

drop procedure reserved_test1;
drop function reserved_test2;

select * from reserved1;

drop table reserved1;

--+ server-message off