--+ server-message on

-- Normal execution when USING and INTO are used together
--Check if it runs normally when processing in INTO, USING order.

drop table IF EXISTS plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

CREATE OR REPLACE PROCEDURE t(param varchar)
AS
   r_id integer;
   r_name string;
BEGIN
    EXECUTE IMMEDIATE 'select id, name  from plcsql_tbl where name = ? ' USING param  INTO r_id, r_name ;
    put_line('id: ' || r_id || ' name: ' || r_name);
END;
call t('name1');


CREATE OR REPLACE PROCEDURE t(param varchar)
AS
   r_id integer;
   r_name string;
BEGIN
    EXECUTE IMMEDIATE 'select id, name  from plcsql_tbl where name = ? ' INTO r_id, r_name USING param   ;
    put_line('id: ' || r_id || ' name: ' || r_name);
END;
call t('name1');

drop table plcsql_tbl;
drop procedure t;



--+ server-message off
