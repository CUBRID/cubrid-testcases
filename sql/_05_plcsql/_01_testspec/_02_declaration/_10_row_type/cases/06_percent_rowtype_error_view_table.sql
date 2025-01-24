--+ server-message on
-- verified the CBRD-25056
-- Support RECORD types and %ROWTYPE feature

-- create table, insert data
create table type_unsupport_tbl (
   ID INT AUTO_INCREMENT,
   T_TIMESTAMPLTZ TIMESTAMPLTZ,
   T_TIMESTAMPTZ TIMESTAMPTZ,
   T_DATETIMELTZ DATETIMELTZ,
   T_DATETIMETZ DATETIMETZ,
   T_BIT BIT(8) default B'1',
   T_BITVARYING BIT VARYING(64) default 0xaa,
   T_JSON JSON,
   T_ENUM ENUM('x-small', 'small', 'medium', 'large', 'x-large'),
   T_BLOB BLOB,
   T_CLOB CLOB,
   T_SET SET default {'c','c','c','b','b','a'},
   T_MULTISET MULTISET default {'c','c','c','b','b','a'},
   T_SEQUENCE SEQUENCE default {'c','c','c','b','b','a'},
   T_LIST LIST default {'c','c','c','b','b','a'}
);

insert into type_unsupport_tbl (ID) values(1);



create view type_unsupport  AS SELECT ID FROM type_unsupport_tbl;

evaluate '00. %rowtype, INT';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=1' into r;
    dbms_output.put_line(r.id);
end;
call test_rowtype();


drop view type_unsupport;
create view type_unsupport AS SELECT ID, T_TIMESTAMPTZ FROM type_unsupport_tbl;

evaluate '01. %rowtype, TIMESTAMPLTZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_TIMESTAMPTZ FROM type_unsupport_tbl;

evaluate '02. %rowtype, TIMESTAMPTZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_DATETIMELTZ FROM type_unsupport_tbl;

evaluate '03. %rowtype, DATETIMELTZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_DATETIMETZ FROM type_unsupport_tbl;

evaluate '04. %rowtype, DATETIMETZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_BIT FROM type_unsupport_tbl;

evaluate '05. %rowtype, BIT(8)';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_BITVARYING FROM type_unsupport_tbl;

evaluate '06. %rowtype, BIT VARYING(64)';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_JSON FROM type_unsupport_tbl;

evaluate '07. %rowtype, JSON';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_ENUM FROM type_unsupport_tbl;

evaluate '08. %rowtype, ENUM';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_BLOB FROM type_unsupport_tbl;

evaluate '09. %rowtype, BLOB';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_CLOB FROM type_unsupport_tbl;


evaluate '10. %rowtype, CLOB';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_SET FROM type_unsupport_tbl;

evaluate '11. %rowtype, SET';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_MULTISET FROM type_unsupport_tbl;

evaluate '12. %rowtype, MULTISET';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_SEQUENCE FROM type_unsupport_tbl;

evaluate '13. %rowtype, SEQUENCE';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop view type_unsupport ;
create view type_unsupport AS SELECT ID, T_LIST FROM type_unsupport_tbl;

evaluate '14. %rowtype, LIST';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



evaluate '15. dummy procedure';
create or replace procedure test_rowtype as
begin
    dbms_output.put_line('dummy procedure');
end;

drop procedure test_rowtype;


drop view type_unsupport ;
drop table type_unsupport_tbl ;

--+ server-message off
