/**
 *  This test case verifies CBRD-24707: Support API for %TYPE
 *
 *  A procedure parameter declared with the %type of a view column whose type
 *  PL/CSQL does not support must be refused when the procedure is created.
 *  The view type_unsupport selects all columns of the table unsupport.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a TIMESTAMPLTZ view column %type as a parameter type is refused as an unsupported argument type
 *    Case 2:  a TIMESTAMPTZ view column %type as a parameter type is refused as an unsupported argument type
 *    Case 3:  a DATETIMELTZ view column %type as a parameter type is refused as an unsupported argument type
 *    Case 4:  a DATETIMETZ view column %type as a parameter type is refused as an unsupported argument type
 *    Case 5:  a BIT view column %type as a parameter type is refused as an unsupported argument type
 *    Case 6:  a BIT VARYING view column %type as a parameter type is refused as an unsupported argument type
 *    Case 7:  a JSON view column %type as a parameter type is refused as an unsupported argument type
 *    Case 8:  an ENUM view column %type as a parameter type is refused as an unsupported argument type
 *    Case 9:  a BLOB view column %type as a parameter type is refused as an unsupported argument type
 *    Case 10: a CLOB view column %type as a parameter type is refused as an unsupported argument type
 *    Case 11: a SET view column %type as a parameter type fails to compile as an unsupported type
 *    Case 12: a MULTISET view column %type as a parameter type fails to compile as an unsupported type
 *    Case 13: a SEQUENCE view column %type as a parameter type fails to compile as an unsupported type
 *    Case 14: a LIST view column %type as a parameter type fails to compile as an unsupported type
 */

--+ server-message on


-- create table & view
drop view if exists type_unsupport;
drop table if exists unsupport;

create table unsupport (
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

create or replace view type_unsupport AS
   SELECT * FROM unsupport ;


evaluate 'Case 1: a TIMESTAMPLTZ view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport(v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type) as
begin 
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

evaluate 'Case 2: a TIMESTAMPTZ view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport(v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type) as
begin 
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;


evaluate 'Case 3: a DATETIMELTZ view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport( v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type) as
begin 
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;


evaluate 'Case 4: a DATETIMETZ view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport( v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type ) as
begin 
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;


evaluate 'Case 5: a BIT view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport(  v_BIT                type_unsupport.T_BIT%type ) as
begin 
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;


evaluate 'Case 6: a BIT VARYING view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport(  v_BITVARYING         type_unsupport.T_BITVARYING%type ) as
begin 
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;


evaluate 'Case 7: a JSON view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport( v_JSON               type_unsupport.T_JSON%type ) as
begin 
   dbms_output.put_line('v_JSON         ' || v_JSON        );
end;


evaluate 'Case 8: an ENUM view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport( v_ENUM               dba.type_unsupport.T_ENUM%type ) as
begin 
   dbms_output.put_line('v_ENUM         ' || v_ENUM        );
end;


evaluate 'Case 9: a BLOB view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport(  v_BLOB               dba.type_unsupport.T_BLOB%type ) as
begin 
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;


evaluate 'Case 10: a CLOB view column %type as a parameter type is refused as an unsupported argument type';
create or replace procedure type_unsupport( v_CLOB               dba.type_unsupport.T_CLOB%type ) as
begin 
   dbms_output.put_line('v_CLOB         ' || v_CLOB        );
end;


evaluate 'Case 11: a SET view column %type as a parameter type fails to compile as an unsupported type';
create or replace procedure type_unsupport(  v_SET                dba.type_unsupport.T_SET%type ) as
begin 
   dbms_output.put_line('v_SET          ' || v_SET         );
end;


evaluate 'Case 12: a MULTISET view column %type as a parameter type fails to compile as an unsupported type';
create or replace procedure type_unsupport( v_MULTISET           dba.type_unsupport.T_MULTISET%type ) as
begin 
   dbms_output.put_line('v_MULTISET     ' || v_MULTISET    );
end;


evaluate 'Case 13: a SEQUENCE view column %type as a parameter type fails to compile as an unsupported type';
create or replace procedure type_unsupport( v_SEQUENCE           dba.type_unsupport.T_SEQUENCE%type ) as
begin 
   dbms_output.put_line('v_SEQUENCE     ' || v_SEQUENCE    );
end;


evaluate 'Case 14: a LIST view column %type as a parameter type fails to compile as an unsupported type';
create or replace procedure type_unsupport( v_LIST               dba.type_unsupport.T_LIST%type ) as
begin 
   dbms_output.put_line('v_LIST         ' || v_LIST        );
end;

drop procedure type_unsupport;

drop table unsupport;
drop view type_unsupport;


--+ server-message off

