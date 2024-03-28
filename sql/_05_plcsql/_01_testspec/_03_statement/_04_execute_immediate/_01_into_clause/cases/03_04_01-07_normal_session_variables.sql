--+ server-message on

-- Check whether session variables and host variables are processed normally in PLCSQL.

drop table IF EXISTS plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

CREATE OR REPLACE PROCEDURE t(param varchar, r_id OUT integer, r_name OUT string)
AS
BEGIN
    EXECUTE IMMEDIATE 'select id, name  from plcsql_tbl where name = ? ' INTO r_id, r_name USING param   ;
    put_line('id: ' || r_id || ' name: ' || r_name);
END;

-- session variables : bug
-- bug
set @p1 = 0;
set @p2 = '';
call t('name1',@p1, @p2);
select @p1, @p2 from dual;

deallocate variable @p1, @p2;

drop table plcsql_tbl;
drop procedure t;


--+ server-message off
