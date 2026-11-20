/**
 *  This test case verifies CBRD-24707: Support API for %TYPE
 *
 *  A function return type declared with the %type of a table column whose type
 *  PL/CSQL does not support must be refused when the function is created.
 *  Cases 1 to 3 also call the function, which does not exist.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a TIMESTAMPLTZ column %type as a return type is refused and the function stays undefined
 *    Case 2:  a TIMESTAMPTZ column %type as a return type is refused and the function stays undefined
 *    Case 3:  a DATETIMELTZ column %type as a return type is refused and the function stays undefined
 *    Case 4:  a DATETIMETZ column %type as a return type is refused as an unsupported return type
 *    Case 5:  a BIT column %type as a return type is refused as an unsupported return type
 *    Case 6:  a BIT VARYING column %type as a return type is refused as an unsupported return type
 *    Case 7:  a JSON column %type as a return type is refused as an unsupported return type
 *    Case 8:  an ENUM column %type as a return type is refused as an unsupported return type
 *    Case 9:  a BLOB column %type as a return type is refused as an unsupported return type
 *    Case 10: a CLOB column %type as a return type is refused as an unsupported return type
 *    Case 11: a SET column %type as a return type fails to compile as an unsupported type
 *    Case 12: a MULTISET column %type as a return type fails to compile as an unsupported type
 *    Case 13: a SEQUENCE column %type as a return type fails to compile as an unsupported type
 *    Case 14: a LIST column %type as a return type fails to compile as an unsupported type
 */

--+ server-message on


-- create table
drop table if exists type_unsupport;

create table type_unsupport (
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


evaluate 'Case 1: a TIMESTAMPLTZ column %type as a return type is refused and the function stays undefined';
create or replace function type_unsupport_return() return type_unsupport.T_TIMESTAMPLTZ%type as
begin 
   return timestampltz'1970-01-01 09:00:01';
end;
select type_unsupport_return();


evaluate 'Case 2: a TIMESTAMPTZ column %type as a return type is refused and the function stays undefined';
create or replace function type_unsupport_return() return type_unsupport.T_TIMESTAMPTZ%type as
begin 
   return timestamptz'1970-01-01 09:00:01';
end;
select type_unsupport_return();


evaluate 'Case 3: a DATETIMELTZ column %type as a return type is refused and the function stays undefined';
create or replace function type_unsupport_return() return type_unsupport.T_DATETIMELTZ%type as
begin 
   return datetimeltz'0001-01-01 09:00:01.000';
end;
select type_unsupport_return();
drop function type_unsupport_return;


evaluate 'Case 4: a DATETIMETZ column %type as a return type is refused as an unsupported return type';
create or replace function type_unsupport_return() return type_unsupport.T_DATETIMETZ%type  as
begin 
   return datetimetz'0001-01-01 09:00:01.000';
end;


evaluate 'Case 5: a BIT column %type as a return type is refused as an unsupported return type';
create or replace function type_unsupport_return() return type_unsupport.T_BIT%type  as
begin 
   return B'1';
end;


evaluate 'Case 6: a BIT VARYING column %type as a return type is refused as an unsupported return type';
create or replace function type_unsupport_return() return type_unsupport.T_BITVARYING%type  as
begin 
   return 0xcf;
end;


evaluate 'Case 7: a JSON column %type as a return type is refused as an unsupported return type';
create or replace function type_unsupport_return() return type_unsupport.T_JSON%type  as
begin 
   return '{"key1": "value1", "key2": "value2"}';
end;


evaluate 'Case 8: an ENUM column %type as a return type is refused as an unsupported return type';
create or replace function type_unsupport_return() return dba.type_unsupport.T_ENUM%type  as
begin 
   return 'medium';
end;


evaluate 'Case 9: a BLOB column %type as a return type is refused as an unsupported return type';
create or replace function type_unsupport_return() return dba.type_unsupport.T_BLOB%type  as
begin 
   return BIT_TO_BLOB(X'000100') ;
end;


evaluate 'Case 10: a CLOB column %type as a return type is refused as an unsupported return type';
create or replace function type_unsupport_return() return dba.type_unsupport.T_CLOB%type  as
begin 
   return CHAR_TO_CLOB('This is a Cat');
end;


evaluate 'Case 11: a SET column %type as a return type fails to compile as an unsupported type';
create or replace function type_unsupport_return() return dba.type_unsupport.T_SET%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


evaluate 'Case 12: a MULTISET column %type as a return type fails to compile as an unsupported type';
create or replace function type_unsupport_return() return dba.type_unsupport.T_MULTISET%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


evaluate 'Case 13: a SEQUENCE column %type as a return type fails to compile as an unsupported type';
create or replace function type_unsupport_return() return dba.type_unsupport.T_SEQUENCE%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


evaluate 'Case 14: a LIST column %type as a return type fails to compile as an unsupported type';
create or replace function type_unsupport_return() return dba.type_unsupport.T_LIST%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


drop function type_unsupport_return;

drop table type_unsupport;


--+ server-message off

