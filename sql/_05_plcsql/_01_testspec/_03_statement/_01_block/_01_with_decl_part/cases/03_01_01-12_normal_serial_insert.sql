--+ server-message on

-- Scenario for declaring serial and entering data as nextvalue value

create table plcsql_insert( s_01 int, s_02 varchar(5) );
create serial plcsql_serial;

CREATE OR REPLACE PROCEDURE t()
AS
     cnt integer;
     s_01_min integer;
     s_01_max integer;
     s_02_min string;
     s_02_max string;
BEGIN
    FOR j IN 1 .. 3 LOOP
        insert into plcsql_insert( s_01, s_02 ) values(plcsql_serial.NEXT_VALUE, lpad( plcsql_serial.NEXT_VALUE, 5, '0' ) );
    END LOOP;

    FOR j IN 1 .. 3 LOOP
        insert into plcsql_insert( s_01, s_02 ) values(plcsql_serial.NEXT_VALUE, lpad( plcsql_serial.NEXT_VALUE, 5, '0' ) );
    END LOOP;
    
    select count(*), min(s_01), max(s_01), min(s_02), max(s_02) INTO cnt,s_01_min,s_01_max,s_02_min,s_02_max  from plcsql_insert ;    
    
    put_line('count = ' || cnt );
    put_line('s_01_min = ' || s_01_min );
    put_line('s_01_max = ' || s_01_max );
    put_line('s_02_min = ' || s_02_min );
    put_line('s_02_max = ' || s_02_max );

END;
call t();
drop table plcsql_insert;
drop serial plcsql_serial;
drop procedure t;


--+ server-message off
