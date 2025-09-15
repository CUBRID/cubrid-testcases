--+ server-message on
-- Verified for CBRD-26153
-- Bug fix: Symentic error when use reference the column name for keyword is a keyword in static SQL

CREATE TABLE keyword
(
    [select] CHAR(1), [order] CHAR(1), [group] CHAR(1), [having] CHAR(1),
    [limit] CHAR(1), [offset] CHAR(1), [union] CHAR(1), [intersect] CHAR(1),
    [except] CHAR(1), [into] CHAR(1), [desc] CHAR(1), [asc] CHAR(1),
    [null] CHAR(1), [first] CHAR(1), [last] CHAR(1), [random] CHAR(1),
    [all] CHAR(1), [distinct] CHAR(1), [exists] CHAR(1), [not] CHAR(1),
    [in] CHAR(1), [between] CHAR(1), [like] CHAR(1), [insert] CHAR(1),
    [delete] CHAR(1), [update] CHAR(1), [create] CHAR(1), [drop] CHAR(1),
    [alter] CHAR(1), [grant] CHAR(1), [revoke] CHAR(1), [rename] CHAR(1),
    [truncate] CHAR(1), [comment] CHAR(1), [set] CHAR(1), [execute] CHAR(1),
    [prepare] CHAR(1), [deallocate] CHAR(1), [open] CHAR(1), [close] CHAR(1),
    [fetch] CHAR(1), [immediate] CHAR(1), [commit] CHAR(1), [rollback] CHAR(1),
    [savepoint] CHAR(1), [constraints] CHAR(1), [by] CHAR(1), [using] CHAR(1),
    [with] CHAR(1), [as] CHAR(1), [is] CHAR(1)
);

CREATE OR REPLACE PROCEDURE keyword_test AS
    CURSOR c IS
        SELECT
            '0' as [select],
            '1' as [order],
            '2' as [group],
            '3' as [having],
            '4' as [limit],
            '5' as [offset],
            '6' as [union],
            '7' as [intersect],
            '8' as [except],
            '9' as [into],
            '0' as [desc],
            '1' as [asc],
            '2' as [null],
            '3' as [first],
            '4' as [last],
            '5' as [random],
            '6' as [all],
            '7' as [distinct],
            '8' as [exists],
            '9' as [not],
            '0' as [in],
            '1' as [between],
            '2' as [like],
            '3' as [insert],
            '4' as [delete],
            '5' as [update],
            '6' as [create],
            '7' as [drop],
            '8' as [alter],
            '9' as [grant],
            '0' as [revoke],
            '1' as [rename],
            '2' as [truncate],
            '3' as [comment],
            '4' as [set],
            '5' as [execute],
            '6' as [prepare],
            '7' as [deallocate],
            '8' as [open],
            '9' as [close],
            '0' as [fetch],
            '1' as [immediate],
            '2' as [commit],
            '3' as [rollback],
            '4' as [savepoint],
            '5' as [constraints],
            '6' as [by],
            '7' as [using],
            '8' as [with],
            '9' as [as],
            '0' as [is]
        FROM
            dual;
BEGIN
    FOR rec IN c LOOP
        INSERT INTO keyword
        (
            [select], [order], [group], [having],
            [limit], [offset], [union], [intersect],
            [except], [into], [desc], [asc],
            [null], [first], [last], [random],
            [all], [distinct], [exists], [not],
            [in], [between], [like], [insert],
            [delete], [update], [create], [drop],
            [alter], [grant], [revoke], [rename],
            [truncate], [comment], [set], [execute],
            [prepare], [deallocate], [open], [close],
            [fetch], [immediate], [commit], [rollback],
            [savepoint], [constraints], [by], [using],
            [with], [as], [is]
        )
        VALUES
        (
            rec.[select], rec.[order], rec.[group], rec.[having],
            rec.[limit], rec.[offset], rec.[union], rec.[intersect],
            rec.[except], rec.[into], rec.[desc], rec.[asc],
            rec.[null], rec.[first], rec.[last], rec.[random],
            rec.[all], rec.[distinct], rec.[exists], rec.[not],
            rec.[in], rec.[between], rec.[like], rec.[insert],
            rec.[delete], rec.[update], rec.[create], rec.[drop],
            rec.[alter], rec.[grant], rec.[revoke], rec.[rename],
            rec.[truncate], rec.[comment], rec.[set], rec.[execute],
            rec.[prepare], rec.[deallocate], rec.[open], rec.[close],
            rec.[fetch], rec.[immediate], rec.[commit], rec.[rollback],
            rec.[savepoint], rec.[constraints], rec.[by], rec.[using],
            rec.[with], rec.[as], rec.[is]
        );
    END LOOP;
END;

call keyword_test();

select * from keyword;

drop procedure keyword_test;
drop table keyword;



evaluate('test reserved1');
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
    [datetime] CHAR(1), [db_user] CHAR(1), [dec] CHAR(1), [decimal] CHAR(1),
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
            '8' AS [cast], '9' AS [catalog], '0' AS [char_length], --'1' AS [character],
            '2' AS [character_length], '3' AS [check], '4' AS [class], '5' AS [close],
            '6' AS [coalesce], '7' AS [collate], '8' AS [collation], '9' AS [column],
            '0' AS [comment], '1' AS [commit], '2' AS [connect], '3' AS [connection],
            '4' AS [constraints], '5' AS [contained], '6' AS [continue], '7' AS [convert],
            '8' AS [corresponding], '9' AS [create], '0' AS [cube], '1' AS [current_date],
            '2' AS [current_time], '3' AS [current_timestamp], '4' AS [current_user], '5' AS [cursor],
            '6' AS [cycle], '7' AS [data], '8' AS [database], '9' AS [date],
            '0' AS [datetime], '1' AS [db_user], '2' AS [dec], '3' AS [decimal],
            '4' AS [declare], '5' AS [deallocate], '6' AS [default], '7' AS [deferrable],
            '8' AS [deferred], '9' AS [delete], '0' AS [derived], '1' AS [desc],
            '2' AS [diagnostics], '3' AS [distinct], '4' AS [domain], '5' AS [double],
            '6' AS [drop], '7' AS [each], '8' AS [else], '9' AS [elsif],
            '0' AS [end], '1' AS [escaped], '2' AS [every], '3' AS [except],
            '4' AS [exception], '5' AS [execute], '6' AS [exists], '7' AS [ext]
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
            [cast], [catalog], [char_length], --[character],
            [character_length], [check], [class], [close],
            [coalesce], [collate], [collation], [column],
            [comment], [commit], [connect], [connection],
            [constraints], [contained], [continue], [convert],
            [corresponding], [create], [cube], [current_date],
            [current_time], [current_timestamp], [current_user], [cursor],
            [cycle], [data], [database], [date],
            [datetime], [db_user], [dec], [decimal],
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
            rec.[cast], rec.[catalog], rec.[char_length], --rec.[character],
            rec.[character_length], rec.[check], rec.[class], rec.[close],
            rec.[coalesce], rec.[collate], rec.[collation], rec.[column],
            rec.[comment], rec.[commit], rec.[connect], rec.[connection],
            rec.[constraints], rec.[contained], rec.[continue], rec.[convert],
            rec.[corresponding], rec.[create], rec.[cube], rec.[current_date],
            rec.[current_time], rec.[current_timestamp], rec.[current_user], rec.[cursor],
            rec.[cycle], rec.[data], rec.[database], rec.[date],
            rec.[datetime], rec.[db_user], rec.[dec], rec.[decimal],
            rec.[declare], rec.[deallocate], rec.[default], rec.[deferrable],
            rec.[deferred], rec.[delete], rec.[derived], rec.[desc],
            rec.[diagnostics], rec.[distinct], rec.[domain], rec.[double],
            rec.[drop], rec.[each], rec.[else], rec.[elsif],
            rec.[end], rec.[escaped], rec.[every], rec.[except],
            rec.[exception], rec.[execute], rec.[exists], rec.[ext]
        );
    END LOOP;
END;

call reserved_test1();

select * from reserved1;

drop procedure reserved_test1;
drop table reserved1;



evaluate('test reserved2');
CREATE TABLE reserved2
(
    [external] CHAR(1), [fetch] CHAR(1), [field] CHAR(1), [first] CHAR(1),
    [for] CHAR(1), [foreign] CHAR(1), [found] CHAR(1), [from] CHAR(1),
    [full] CHAR(1), [function] CHAR(1), [general] CHAR(1), [get] CHAR(1),
    [global] CHAR(1), [go] CHAR(1), [goto] CHAR(1), [grant] CHAR(1),
    [group] CHAR(1), [having] CHAR(1), [if] CHAR(1), [immediate] CHAR(1),
    [in] CHAR(1), [index] CHAR(1), [in_out] CHAR(1), [indicates] CHAR(1),
    [inherits] CHAR(1), [input] CHAR(1), [insert] CHAR(1), [instance] CHAR(1),
    [integer] CHAR(1), [intersect] CHAR(1), [into] CHAR(1), [isolation] CHAR(1),
    [is] CHAR(1), [join] CHAR(1), [key] CHAR(1), [language] CHAR(1),
    [last] CHAR(1), [leading] CHAR(1), [left] CHAR(1), [like] CHAR(1),
    [limit] CHAR(1), [list] CHAR(1), [lock] CHAR(1), [long] CHAR(1),
    [match] CHAR(1), [matched] CHAR(1), [max] CHAR(1), [members] CHAR(1),
    [method] CHAR(1), [min] CHAR(1), [minute] CHAR(1), [modifies] CHAR(1),
    [month] CHAR(1), [multiset] CHAR(1), [name] CHAR(1), [names] CHAR(1),
    [national] CHAR(1), [natural] CHAR(1), [nchar] CHAR(1), [nondeterm] CHAR(1),
    [non_empty] CHAR(1), [not] CHAR(1), [null] CHAR(1), [numeric] CHAR(1),
    [of] CHAR(1), [offset] CHAR(1), [on] CHAR(1), [only] CHAR(1),
    [open] CHAR(1), [or] CHAR(1), [order] CHAR(1), [outer] CHAR(1),
    [output] CHAR(1), [overlaps] CHAR(1), [parameter] CHAR(1), [partial] CHAR(1),
    [path] CHAR(1), [position] CHAR(1), [post] CHAR(1), [prepare] CHAR(1),
    [preserve] CHAR(1), [primary] CHAR(1), [print] CHAR(1), [procedure] CHAR(1),
    [properties] CHAR(1), [public] CHAR(1), [random] CHAR(1), [read] CHAR(1)
);

CREATE OR REPLACE PROCEDURE reserved_test2 AS
    CURSOR c IS
        SELECT
            '0' AS [external], '1' AS [fetch], '2' AS [field], '3' AS [first],
            '4' AS [for], '5' AS [foreign], '6' AS [found], '7' AS [from],
            '8' AS [full], '9' AS [function], '0' AS [general], '1' AS [get],
            '2' AS [global], '3' AS [go], '4' AS [goto], '5' AS [grant],
            '6' AS [group], '7' AS [having], '8' AS [if], '9' AS [immediate],
            '0' AS [in], '1' AS [index], '2' AS [in_out], '3' AS [indicates],
            '4' AS [inherits], '5' AS [input], '6' AS [insert], '7' AS [instance],
            '8' AS [integer], '9' AS [intersect], '0' AS [into], '1' AS [isolation],
            '2' AS [is], '3' AS [join], '4' AS [key], '5' AS [language],
            '6' AS [last], '7' AS [leading], '8' AS [left], '9' AS [like],
            '0' AS [limit], '1' AS [list], '2' AS [lock], '3' AS [long],
            '4' AS [match], '5' AS [matched], '6' AS [max], '7' AS [members],
            '8' AS [method], '9' AS [min], '0' AS [minute], '1' AS [modifies],
            '2' AS [month], '3' AS [multiset], '4' AS [name], '5' AS [names],
            '6' AS [national], '7' AS [natural], '8' AS [nchar], '9' AS [nondeterm],
            '0' AS [non_empty], '1' AS [not], '2' AS [null], '3' AS [numeric],
            '4' AS [of], '5' AS [offset], '6' AS [on], '7' AS [only],
            '8' AS [open], '9' AS [or], '0' AS [order], '1' AS [outer],
            '2' AS [output], '3' AS [overlaps], '4' AS [parameter], '5' AS [partial],
            '6' AS [path], '7' AS [position], '8' AS [post], '9' AS [prepare],
            '0' AS [preserve], '1' AS [primary], '2' AS [print], '3' AS [procedure],
            '4' AS [properties], '5' AS [public], '6' AS [random], '7' AS [read]
        FROM dual;
BEGIN
    FOR rec IN c LOOP
        INSERT INTO reserved2
        (
            [external], [fetch], [field], [first],
            [for], [foreign], [found], [from],
            [full], [function], [general], [get],
            [global], [go], [goto], [grant],
            [group], [having], [if], [immediate],
            [in], [index], [in_out], [indicates],
            [inherits], [input], [insert], [instance],
            [integer], [intersect], [into], [isolation],
            [is], [join], [key], [language],
            [last], [leading], [left], [like],
            [limit], [list], [lock], [long],
            [match], [matched], [max], [members],
            [method], [min], [minute], [modifies],
            [month], [multiset], [name], [names],
            [national], [natural], [nchar], [nondeterm],
            [non_empty], [not], [null], [numeric],
            [of], [offset], [on], [only],
            [open], [or], [order], [outer],
            [output], [overlaps], [parameter], [partial],
            [path], [position], [post], [prepare],
            [preserve], [primary], [print], [procedure],
            [properties], [public], [random], [read]
        )
        VALUES
        (
            rec.[external], rec.[fetch], rec.[field], rec.[first],
            rec.[for], rec.[foreign], rec.[found], rec.[from],
            rec.[full], rec.[function], rec.[general], rec.[get],
            rec.[global], rec.[go], rec.[goto], rec.[grant],
            rec.[group], rec.[having], rec.[if], rec.[immediate],
            rec.[in], rec.[index], rec.[in_out], rec.[indicates],
            rec.[inherits], rec.[input], rec.[insert], rec.[instance],
            rec.[integer], rec.[intersect], rec.[into], rec.[isolation],
            rec.[is], rec.[join], rec.[key], rec.[language],
            rec.[last], rec.[leading], rec.[left], rec.[like],
            rec.[limit], rec.[list], rec.[lock], rec.[long],
            rec.[match], rec.[matched], rec.[max], rec.[members],
            rec.[method], rec.[min], rec.[minute], rec.[modifies],
            rec.[month], rec.[multiset], rec.[name], rec.[names],
            rec.[national], rec.[natural], rec.[nchar], rec.[nondeterm],
            rec.[non_empty], rec.[not], rec.[null], rec.[numeric],
            rec.[of], rec.[offset], rec.[on], rec.[only],
            rec.[open], rec.[or], rec.[order], rec.[outer],
            rec.[output], rec.[overlaps], rec.[parameter], rec.[partial],
            rec.[path], rec.[position], rec.[post], rec.[prepare],
            rec.[preserve], rec.[primary], rec.[print], rec.[procedure],
            rec.[properties], rec.[public], rec.[random], rec.[read]
        );
    END LOOP;
END;

call reserved_test2();

select * from reserved2;

drop procedure reserved_test2;
drop table reserved2;



evaluate('test reserved3');
CREATE TABLE reserved3
(
    [real] CHAR(1), [recursive] CHAR(1), [ref] CHAR(1), [references] CHAR(1),
    [regr_avgx] CHAR(1), [regr_avgy] CHAR(1), [regr_count] CHAR(1), [regr_intercept] CHAR(1),
    [regr_r2] CHAR(1), [regr_slope] CHAR(1), [regr_sxx] CHAR(1), [regr_sxy] CHAR(1),
    [regr_syy] CHAR(1), [relative] CHAR(1), [rename] CHAR(1), [repeatable] CHAR(1),
    [replace] CHAR(1), [restrict] CHAR(1), [return] CHAR(1), [returns] CHAR(1),
    [revoke] CHAR(1), [right] CHAR(1), [role] CHAR(1), [rollback] CHAR(1),
    [row] CHAR(1), [savepoint] CHAR(1), [schema] CHAR(1), [scope] CHAR(1),
    [scroll] CHAR(1), [section] CHAR(1), [select] CHAR(1), [semi_anti] CHAR(1),
    [serial] CHAR(1), [session_user] CHAR(1), [set] CHAR(1), [shared] CHAR(1),
    [short] CHAR(1), [some] CHAR(1), [space] CHAR(1), [sql] CHAR(1),
    [sql_log] CHAR(1), [sqlerror] CHAR(1), [sqlstate] CHAR(1), [statement] CHAR(1),
    [string] CHAR(1), [sub] CHAR(1), [subclass] CHAR(1), [sum] CHAR(1),
    [sys_date] CHAR(1), [sysdatetime] CHAR(1), [sys_time] CHAR(1), [sys_timestamp] CHAR(1),
    [system_user] CHAR(1), [table] CHAR(1), [temporary] CHAR(1), [terminator] CHAR(1),
    [then] CHAR(1), [there] CHAR(1), [ties] CHAR(1), [time] CHAR(1),
    [timestamp] CHAR(1), [timezone_hour] CHAR(1), [timezone_minute] CHAR(1), [to] CHAR(1),
    [trailing] CHAR(1), [transaction] CHAR(1), [translate] CHAR(1), [translation] CHAR(1),
    [trim] CHAR(1), [truncate] CHAR(1), [union] CHAR(1), [unknown] CHAR(1),
    [update] CHAR(1), [updatable] CHAR(1), [using] CHAR(1), [user] CHAR(1),
    [values] CHAR(1), [varchar] CHAR(1), [varying] CHAR(1), [view] CHAR(1),
    [visible] CHAR(1), [when] CHAR(1), [whenever] CHAR(1), [where] CHAR(1),
    [while] CHAR(1), [with] CHAR(1), [work] CHAR(1), [xor] CHAR(1),
    [year] CHAR(1), [zone] CHAR(1)
);

CREATE OR REPLACE PROCEDURE reserved_test3 AS
    CURSOR c IS
        SELECT
            --'0' AS [real],
            '1' AS [recursive], '2' AS [ref], '3' AS [references],
            '4' AS [regr_avgx], '5' AS [regr_avgy], '6' AS [regr_count], '7' AS [regr_intercept],
            '8' AS [regr_r2], '9' AS [regr_slope], '0' AS [regr_sxx], '1' AS [regr_sxy],
            '2' AS [regr_syy], --'3' AS [relative],
            '4' AS [rename], '5' AS [repeatable],
            '6' AS [replace], '7' AS [restrict], '8' AS [return], '9' AS [returns],
            '0' AS [revoke], '1' AS [right], '2' AS [role], '3' AS [rollback],
            '4' AS [row], '5' AS [savepoint], '6' AS [schema], '7' AS [scope],
            '8' AS [scroll], '9' AS [section], '0' AS [select], '1' AS [semi_anti],
            '2' AS [serial], '3' AS [session_user], '4' AS [set], '5' AS [shared],
            '6' AS [short], --'7' AS [some],
            '8' AS [space], --'9' AS [sql],
            '0' AS [sql_log], --'1' AS [sqlerror],
            --'2' AS [sqlstate],
            '3' AS [statement],
            '4' AS [string], '5' AS [sub], '6' AS [subclass], '7' AS [sum],
            '8' AS [sys_date], '9' AS [sysdatetime], '0' AS [sys_time], '1' AS [sys_timestamp],
            '2' AS [system_user], '3' AS [table], '4' AS [temporary], '5' AS [terminator],
            '6' AS [then], '7' AS [there], '8' AS [ties], '9' AS [time],
            '0' AS [timestamp], '1' AS [timezone_hour], '2' AS [timezone_minute], '3' AS [to],
            '4' AS [trailing], '5' AS [transaction], '6' AS [translate], '7' AS [translation],
            '8' AS [trim], '9' AS [truncate], '0' AS [union], '1' AS [unknown],
            '2' AS [update], '3' AS [updatable], '4' AS [using], '5' AS [user],
            '6' AS [values], '7' AS [varchar], '8' AS [varying], '9' AS [view],
            '0' AS [visible], '1' AS [when], '2' AS [whenever], '3' AS [where],
            '4' AS [while], '5' AS [with], '6' AS [work], '7' AS [xor],
            '8' AS [year], '9' AS [zone]
        FROM dual;
BEGIN
    FOR rec IN c LOOP
        INSERT INTO reserved3
        (
            --[real],
            [recursive], [ref], [references],
            [regr_avgx], [regr_avgy], [regr_count], [regr_intercept],
            [regr_r2], [regr_slope], [regr_sxx], [regr_sxy],
            [regr_syy], --[relative],
            [rename], [repeatable],
            [replace], [restrict], [return], [returns],
            [revoke], [right], [role], [rollback],
            [row], [savepoint], [schema], [scope],
            [scroll], [section], [select], [semi_anti],
            [serial], [session_user], [set], [shared],
            [short], --[some],
            [space], --[sql],
            [sql_log], --[sqlerror],
            --[sqlstate],
            [statement],
            [string], [sub], [subclass], [sum],
            [sys_date], [sysdatetime], [sys_time], [sys_timestamp],
            [system_user], [table], [temporary], [terminator],
            [then], [there], [ties], [time],
            [timestamp], [timezone_hour], [timezone_minute], [to],
            [trailing], [transaction], [translate], [translation],
            [trim], [truncate], [union], [unknown],
            [update], [updatable], [using], [user],
            [values], [varchar], [varying], [view],
            [visible], [when], [whenever], [where],
            [while], [with], [work], [xor],
            [year], [zone]
        )
        VALUES
        (
            --rec.[real], 
            rec.[recursive], rec.[ref], rec.[references],
            rec.[regr_avgx], rec.[regr_avgy], rec.[regr_count], rec.[regr_intercept],
            rec.[regr_r2], rec.[regr_slope], rec.[regr_sxx], rec.[regr_sxy],
            rec.[regr_syy], --rec.[relative],
            rec.[rename], rec.[repeatable],
            rec.[replace], rec.[restrict], rec.[return], rec.[returns],
            rec.[revoke], rec.[right], rec.[role], rec.[rollback],
            rec.[row], rec.[savepoint], rec.[schema], rec.[scope],
            rec.[scroll], rec.[section], rec.[select], rec.[semi_anti],
            rec.[serial], rec.[session_user], rec.[set], rec.[shared],
            rec.[short], --rec.[some],
            rec.[space], --rec.[sql],
            rec.[sql_log], --rec.[sqlerror],
            --rec.[sqlstate],
            rec.[statement],
            rec.[string], rec.[sub], rec.[subclass], rec.[sum],
            rec.[sys_date], rec.[sysdatetime], rec.[sys_time], rec.[sys_timestamp],
            rec.[system_user], rec.[table], rec.[temporary], rec.[terminator],
            rec.[then], rec.[there], rec.[ties], rec.[time],
            rec.[timestamp], rec.[timezone_hour], rec.[timezone_minute], rec.[to],
            rec.[trailing], rec.[transaction], rec.[translate], rec.[translation],
            rec.[trim], rec.[truncate], rec.[union], rec.[unknown],
            rec.[update], rec.[updatable], rec.[using], rec.[user],
            rec.[values], rec.[varchar], rec.[varying], rec.[view],
            rec.[visible], rec.[when], rec.[whenever], rec.[where],
            rec.[while], rec.[with], rec.[work], rec.[xor],
            rec.[year], rec.[zone]
        );
    END LOOP;
END;

call reserved_test3();

select * from reserved3;

drop procedure reserved_test3;
drop table reserved3;



evaluate('test reserved4');
CREATE TABLE reserved4
(
    [year] CHAR(1), [zone] CHAR(1), [abs] CHAR(1), [addtime] CHAR(1),
    [any_value] CHAR(1), [ascii] CHAR(1), [avg] CHAR(1), [bit_and] CHAR(1),
    [bit_or] CHAR(1), [bit_xor] CHAR(1), [ceil] CHAR(1), [ceiling] CHAR(1),
    [count] CHAR(1), [date_add] CHAR(1), [date_sub] CHAR(1), [datediff] CHAR(1),
    [day] CHAR(1), [decode] CHAR(1), [degrees] CHAR(1), [exp] CHAR(1),
    [floor] CHAR(1), [from_days] CHAR(1), [hex] CHAR(1), [hour] CHAR(1),
    [inet_aton] CHAR(1), [inet_ntoa] CHAR(1), [instr] CHAR(1), [interval] CHAR(1),
    [is_null] CHAR(1), [last_insert_id] CHAR(1), [left] CHAR(1), [length] CHAR(1),
    [ln] CHAR(1), [locate] CHAR(1), [log] CHAR(1), [log10] CHAR(1),
    [lower] CHAR(1), [ltrim] CHAR(1), [max] CHAR(1), [mid] CHAR(1),
    [min] CHAR(1), [minute] CHAR(1), [month] CHAR(1), [now] CHAR(1),
    [nullif] CHAR(1), [oct] CHAR(1), [ord] CHAR(1), [power] CHAR(1),
    [quarter] CHAR(1), [radians] CHAR(1), [rand] CHAR(1), [repeat] CHAR(1),
    [replace] CHAR(1), [reverse] CHAR(1), [right] CHAR(1), [round] CHAR(1),
    [rtrim] CHAR(1), [sec_to_time] CHAR(1), [second] CHAR(1), [sign] CHAR(1)
);

CREATE OR REPLACE PROCEDURE reserved_test4 AS
    CURSOR c IS
        SELECT
            '0' AS [year], '1' AS [zone], '2' AS [abs], '3' AS [addtime],
            '4' AS [any_value], '5' AS [ascii], '6' AS [avg], '7' AS [bit_and],
            '8' AS [bit_or], '9' AS [bit_xor], '0' AS [ceil], '1' AS [ceiling],
            '2' AS [count], '3' AS [date_add], '4' AS [date_sub], '5' AS [datediff],
            '6' AS [day], '7' AS [decode], '8' AS [degrees], '9' AS [exp],
            '0' AS [floor], '1' AS [from_days], '2' AS [hex], '3' AS [hour],
            '4' AS [inet_aton], '5' AS [inet_ntoa], '6' AS [instr], '7' AS [interval],
            '8' AS [is_null], '9' AS [last_insert_id], '0' AS [left], '1' AS [length],
            '2' AS [ln], '3' AS [locate], '4' AS [log], '5' AS [log10],
            '6' AS [lower], '7' AS [ltrim], '8' AS [max], '9' AS [mid],
            '0' AS [min], '1' AS [minute], '2' AS [month], '3' AS [now],
            '4' AS [nullif], '5' AS [oct], '6' AS [ord], '7' AS [power],
            '8' AS [quarter], '9' AS [radians], '0' AS [rand], '1' AS [repeat],
            '2' AS [replace], '3' AS [reverse], '4' AS [right], '5' AS [round],
            '6' AS [rtrim], '7' AS [sec_to_time], '8' AS [second], '9' AS [sign]
        FROM dual;
BEGIN
    FOR rec IN c LOOP
        INSERT INTO reserved4
        (
            [year], [zone], [abs], [addtime],
            [any_value], [ascii], [avg], [bit_and],
            [bit_or], [bit_xor], [ceil], [ceiling],
            [count], [date_add], [date_sub], [datediff],
            [day], [decode], [degrees], [exp],
            [floor], [from_days], [hex], [hour],
            [inet_aton], [inet_ntoa], [instr], [interval],
            [is_null], [last_insert_id], [left], [length],
            [ln], [locate], [log], [log10],
            [lower], [ltrim], [max], [mid],
            [min], [minute], [month], [now],
            [nullif], [oct], [ord], [power],
            [quarter], [radians], [rand], [repeat],
            [replace], [reverse], [right], [round],
            [rtrim], [sec_to_time], [second], [sign]
        )
        VALUES
        (
            rec.[year], rec.[zone], rec.[abs], rec.[addtime],
            rec.[any_value], rec.[ascii], rec.[avg], rec.[bit_and],
            rec.[bit_or], rec.[bit_xor], rec.[ceil], rec.[ceiling],
            rec.[count], rec.[date_add], rec.[date_sub], rec.[datediff],
            rec.[day], rec.[decode], rec.[degrees], rec.[exp],
            rec.[floor], rec.[from_days], rec.[hex], rec.[hour],
            rec.[inet_aton], rec.[inet_ntoa], rec.[instr], rec.[interval],
            rec.[is_null], rec.[last_insert_id], rec.[left], rec.[length],
            rec.[ln], rec.[locate], rec.[log], rec.[log10],
            rec.[lower], rec.[ltrim], rec.[max], rec.[mid],
            rec.[min], rec.[minute], rec.[month], rec.[now],
            rec.[nullif], rec.[oct], rec.[ord], rec.[power],
            rec.[quarter], rec.[radians], rec.[rand], rec.[repeat],
            rec.[replace], rec.[reverse], rec.[right], rec.[round],
            rec.[rtrim], rec.[sec_to_time], rec.[second], rec.[sign]
        );
    END LOOP;
END;

call reserved_test4();

select * from reserved4;

drop procedure reserved_test4;
drop table reserved4;

--+ server-message off
