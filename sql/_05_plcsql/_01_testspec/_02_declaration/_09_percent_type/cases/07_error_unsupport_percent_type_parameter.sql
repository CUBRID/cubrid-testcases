--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type unsupport parameter

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


-- %type, unsupported, procedure parameter
EVALUATE 'TIMESTAMPLTZ';
create or replace procedure type_unsupport(v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type) as
begin 
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

EVALUATE 'TIMESTAMPTZ';
create or replace procedure type_unsupport(v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type) as
begin 
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;


EVALUATE 'DATETIMELTZ';
create or replace procedure type_unsupport( v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type) as
begin 
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;


EVALUATE 'DATETIMETZ';
create or replace procedure type_unsupport( v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type ) as
begin 
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;


EVALUATE 'BIT';
create or replace procedure type_unsupport(  v_BIT                type_unsupport.T_BIT%type ) as
begin 
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;


EVALUATE 'BIT VARYING';
create or replace procedure type_unsupport(  v_BITVARYING         type_unsupport.T_BITVARYING%type ) as
begin 
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;


EVALUATE 'JSON';
create or replace procedure type_unsupport( v_JSON               type_unsupport.T_JSON%type ) as
begin 
   dbms_output.put_line('v_JSON         ' || v_JSON        );
end;


EVALUATE 'ENUM';
create or replace procedure type_unsupport( v_ENUM               dba.type_unsupport.T_ENUM%type ) as
begin 
   dbms_output.put_line('v_ENUM         ' || v_ENUM        );
end;


EVALUATE 'BLOB';
create or replace procedure type_unsupport(  v_BLOB               dba.type_unsupport.T_BLOB%type ) as
begin 
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;


EVALUATE 'CLOB';
create or replace procedure type_unsupport( v_CLOB               dba.type_unsupport.T_CLOB%type ) as
begin 
   dbms_output.put_line('v_CLOB         ' || v_CLOB        );
end;


EVALUATE 'SET';
create or replace procedure type_unsupport(  v_SET                dba.type_unsupport.T_SET%type ) as
begin 
   dbms_output.put_line('v_SET          ' || v_SET         );
end;


EVALUATE 'MULTISET';
create or replace procedure type_unsupport( v_MULTISET           dba.type_unsupport.T_MULTISET%type ) as
begin 
   dbms_output.put_line('v_MULTISET     ' || v_MULTISET    );
end;


EVALUATE 'SEQUENCE';
create or replace procedure type_unsupport( v_SEQUENCE           dba.type_unsupport.T_SEQUENCE%type ) as
begin 
   dbms_output.put_line('v_SEQUENCE     ' || v_SEQUENCE    );
end;


EVALUATE 'LIST';
create or replace procedure type_unsupport( v_LIST               dba.type_unsupport.T_LIST%type ) as
begin 
   dbms_output.put_line('v_LIST         ' || v_LIST        );
end;

drop procedure type_unsupport;

drop table type_unsupport;


--+ server-message off

