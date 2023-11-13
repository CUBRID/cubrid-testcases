--+ server-message on

-- normal: using sql%rowcount with merge


-- source_table
CREATE TABLE source_table (a INT, b INT, c INT);
INSERT INTO source_table VALUES (1, 1, 1);
INSERT INTO source_table VALUES (1, 3, 2);
INSERT INTO source_table VALUES (2, 4, 5);
INSERT INTO source_table VALUES (3, 1, 3);

-- target_table
CREATE TABLE target_table (a INT, b INT, c INT);
INSERT INTO target_table VALUES (1, 1, 4);
INSERT INTO target_table VALUES (1, 2, 5);
INSERT INTO target_table VALUES (1, 3, 2);
INSERT INTO target_table VALUES (3, 1, 6);
INSERT INTO target_table VALUES (5, 5, 2);

create or replace procedure t(i int) as
    function helper(bi bigint) return varchar as
    begin
        return case when bi is null then 'null' else '' || bi end;
    end;

    cursor c is select * from target_table;
begin

    -- initial rows
    for r in c loop
        dbms_output.put_line('a=' || r.a || ' b=' || r.b || ' c=' || r.c);
    end loop;

    MERGE INTO target_table tt USING source_table st
    ON (st.a=tt.a AND st.b=tt.b)
    WHEN MATCHED THEN UPDATE SET tt.c=st.c
         DELETE WHERE tt.c = 1
    WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

    dbms_output.put_line('after merge:' || helper(sql%rowcount));

    -- final rows
    for r in c loop
        dbms_output.put_line('a=' || r.a || ' b=' || r.b || ' c=' || r.c);
    end loop;

end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;
drop table target_table, source_table;


--+ server-message off
