--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type unsupport return

-- create table
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


-- %type, unsupported, return
EVALUATE 'TIMESTAMPLTZ';
create or replace function type_unsupport_return() return type_unsupport.T_TIMESTAMPLTZ%type as
begin 
   return timestampltz'1970-01-01 09:00:01';
end;
select type_unsupport_return();


EVALUATE 'TIMESTAMPTZ';
create or replace function type_unsupport_return() return type_unsupport.T_TIMESTAMPTZ%type as
begin 
   return timestamptz'1970-01-01 09:00:01';
end;
select type_unsupport_return();



EVALUATE 'DATETIMELTZ';
create or replace function type_unsupport_return() return type_unsupport.T_DATETIMELTZ%type as
begin 
   return datetimeltz'0001-01-01 09:00:01.000';
end;
select type_unsupport_return();
drop function type_unsupport_return;


EVALUATE 'DATETIMETZ';
create or replace function type_unsupport_return() return type_unsupport.T_DATETIMETZ%type  as
begin 
   return datetimetz'0001-01-01 09:00:01.000';
end;


EVALUATE 'BIT';
create or replace function type_unsupport_return() return type_unsupport.T_BIT%type  as
begin 
   return B'1';
end;


EVALUATE 'BIT VARYING';
create or replace function type_unsupport_return() return type_unsupport.T_BITVARYING%type  as
begin 
   return 0xcf;
end;


EVALUATE 'JSON';
create or replace function type_unsupport_return() return type_unsupport.T_JSON%type  as
begin 
   return '{"key1": "value1", "key2": "value2"}';
end;


EVALUATE 'ENUM';
create or replace function type_unsupport_return() return dba.type_unsupport.T_ENUM%type  as
begin 
   return 'medium';
end;


EVALUATE 'BLOB';
create or replace function type_unsupport_return() return dba.type_unsupport.T_BLOB%type  as
begin 
   return BIT_TO_BLOB(X'000100') ;
end;


EVALUATE 'CLOB';
create or replace function type_unsupport_return() return dba.type_unsupport.T_CLOB%type  as
begin 
   return CHAR_TO_CLOB('This is a Cat');
end;


EVALUATE 'SET';
create or replace function type_unsupport_return() return dba.type_unsupport.T_SET%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


EVALUATE 'MULTISET';
create or replace function type_unsupport_return() return dba.type_unsupport.T_MULTISET%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


EVALUATE 'SEQUENCE';
create or replace function type_unsupport_return() return dba.type_unsupport.T_SEQUENCE%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


EVALUATE 'LIST';
create or replace function type_unsupport_return() return dba.type_unsupport.T_LIST%type  as
begin 
   return '{''c'',''c'',''c'',''b'',''b'',''a''}';
end;


drop function type_unsupport_return;

drop table type_unsupport;


--+ server-message off

