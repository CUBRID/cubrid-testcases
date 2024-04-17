--+ server-message on

--Check whether an error occurs when assigning a value to an IN parameter with the INTO clause. 

drop table IF EXISTS plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

CREATE OR REPLACE PROCEDURE t(param varchar, r_id IN integer, r_name IN string)
AS
BEGIN
    EXECUTE IMMEDIATE 'select id, name  from plcsql_tbl where name = ? ' INTO r_id, r_name USING param   ;
    put_line('id: ' || r_id || ' name: ' || r_name);
END;

drop table plcsql_tbl;


--+ server-message off
