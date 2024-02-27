--+ server-message on

-- When processing value and ? (question mark) binding, check whether Korean characters and calculation formulas are processed properly.

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
    EXECUTE IMMEDIATE 'insert into plcsql_tbl ( id, name ) values ( ?, ? ) ' USING 5, param||'파라미터 + 한글 바인딩 테스트' ;
    EXECUTE IMMEDIATE 'select id, name from plcsql_tbl where id =?' USING 5 INTO r_id, r_name;
    put_line('id: ' || r_id || ' name: ' || r_name);
    
END;

call t('name1');

drop procedure t;
drop table plcsql_tbl;

--+ server-message off
