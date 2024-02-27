--+ server-message on

-- Check whether it is possible to bind functions and calculation expressions to the ? (question mark) value in SQL syntax.

drop table IF EXISTS plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

CREATE OR REPLACE PROCEDURE t(param varchar)
AS
     r_id integer ;
     r_name string ;
BEGIN
    EXECUTE IMMEDIATE 'insert into plcsql_tbl ( id, name ) values ( ?, ? ) ' USING trunc(5)+trunc(5), param||to_char( to_date('1974-12-27','YYYY-MM-DD'), 'YYYY-MM-DD' ) ;
    EXECUTE IMMEDIATE 'select id, name from plcsql_tbl where id =?' USING trunc(5)+trunc(5) INTO r_id, r_name;
    put_line('id: ' || r_id || ' name: ' || r_name);
END;

call t('name1');

drop procedure t;
drop table plcsql_tbl;

--+ server-message off
