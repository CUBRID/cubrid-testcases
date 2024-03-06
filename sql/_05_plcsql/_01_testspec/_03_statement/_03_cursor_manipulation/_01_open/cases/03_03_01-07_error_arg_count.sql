--+ server-message on

-- When opening a cursor using parameters, check whether an error occurs if the number of parameters does not match.

drop table if exists plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');


CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    OPEN my_cursor(param_name, param_name );
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;


CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    OPEN my_cursor(  );
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;


drop table plcsql_tbl;




--+ server-message off
