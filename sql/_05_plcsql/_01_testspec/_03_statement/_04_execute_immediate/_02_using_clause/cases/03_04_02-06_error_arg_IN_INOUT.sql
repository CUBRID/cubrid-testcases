--+ server-message on

-- Check if an error occurs when IN and OUT parameters are used abnormally.

drop table IF EXISTS plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

CREATE OR REPLACE PROCEDURE t(param IN varchar, out_id INOUT integer, out_name IN OUT varchar)
AS
--     var_01 string := param;
     r_id integer ;
     r_name string ;
BEGIN
    EXECUTE IMMEDIATE 'select id, name  from plcsql_tbl where name = ? ' INTO out_id, param USING out_name ;
    put_line('id: ' || out_id || ' name: ' || out_name);
END;

select '1', '2' into :a, :b ;
call t('name1', :a, :b);
select :a, :b from dual;


drop procedure t;
drop table plcsql_tbl;

--+ server-message off
