--+ server-message on
-- verified the CBRD-25056
-- Support RECORD types and %ROWTYPE feature

drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_TIMESTAMPLTZ TIMESTAMPLTZ
);

evaluate '01. %rowtype, TIMESTAMPLTZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_TIMESTAMPTZ TIMESTAMPTZ
);

evaluate '02. %rowtype, TIMESTAMPTZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_DATETIMELTZ DATETIMELTZ
);

evaluate '03. %rowtype, DATETIMELTZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_DATETIMETZ DATETIMETZ
);

evaluate '04. %rowtype, DATETIMETZ';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_BIT BIT(8) default B'1'
);

evaluate '05. %rowtype, BIT(8)';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_BITVARYING BIT VARYING(64) default 0xaa
);

evaluate '06. %rowtype, BIT VARYING(64)';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_JSON JSON
);

evaluate '07. %rowtype, JSON';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_ENUM ENUM('x-small', 'small', 'medium', 'large', 'x-large')
);

evaluate '08. %rowtype, ENUM';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_BLOB BLOB
);

evaluate '09. %rowtype, BLOB';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_CLOB CLOB
);


evaluate '10. %rowtype, CLOB';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_SET SET default {'c','c','c','b','b','a'}
);

evaluate '11. %rowtype, SET';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_MULTISET MULTISET default {'c','c','c','b','b','a'}
);


evaluate '12. %rowtype, MULTISET';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_SEQUENCE SEQUENCE default {'c','c','c','b','b','a'}
);

evaluate '13. %rowtype, SEQUENCE';
create or replace procedure test_rowtype as
    r type_unsupport%ROWTYPE;
begin
    execute immediate 'select * from type_unsupport where ID=2' into r;
    dbms_output.put_line(r.id);
end;



drop table IF EXISTS type_unsupport ;
create table type_unsupport (
   ID INT AUTO_INCREMENT,
   T_LIST LIST default {'c','c','c','b','b','a'}
);

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
drop table type_unsupport ;

--+ server-message off
