--+ server-message on

-- "?" in sql statement Check whether an error is processed if the number of parameters in the USING statement is greater than the number.
drop table IF EXISTS plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

CREATE OR REPLACE PROCEDURE t(param varchar)
AS
     var_01 string := param;
     r_id integer ;
     r_name string ;
BEGIN
    EXECUTE IMMEDIATE 'select id, name  from plcsql_tbl where name = ? ' INTO r_id, r_name USING param, var_01 ;
    put_line('id: ' || r_id || ' name: ' || r_name);
END;

call t('name1');

drop procedure t;
drop table plcsql_tbl;

--+ server-message off
