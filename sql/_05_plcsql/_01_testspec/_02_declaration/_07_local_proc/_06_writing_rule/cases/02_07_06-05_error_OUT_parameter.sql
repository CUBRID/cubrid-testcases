--+ server-message on

-- Use the parameter variable passed as IN in the local procedure as an INTO variable in the select query.

drop table if exists plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');


CREATE OR REPLACE PROCEDURE t()
AS
    procedure local_t(param_name OUT VARCHAR) as
        CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
            WHERE name = a;
        
        target_id INT;
        target_name STRING;
        target_temp STRING;
    begin
        OPEN my_cursor(param_name );
        LOOP
            FETCH my_cursor INTO param_name, target_name;
            EXIT WHEN my_cursor%NOTFOUND;
            put_line('id: ' || param_name || ' name: ' || target_name);
        END LOOP;
        CLOSE my_cursor;
    end;
BEGIN
    local_t('name1');
END;

drop table plcsql_tbl;


--+ server-message off
