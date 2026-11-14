/**
 *  This test case verifies CBRD-24707: Support API for %TYPE
 *
 *  A local variable declared with the %type of a view column whose type PL/CSQL
 *  does not support must make the procedure fail to compile. For some types a first
 *  case assigns a literal of that type and a second case assigns a string.
 *  The view type_unsupport selects all columns of the table unsupport.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a variable of TIMESTAMPLTZ view column %type assigned a typed literal fails to compile
 *    Case 2:  a variable of TIMESTAMPLTZ view column %type fails to compile as an unsupported type
 *    Case 3:  a variable of TIMESTAMPTZ view column %type assigned a typed literal fails to compile
 *    Case 4:  a variable of TIMESTAMPTZ view column %type fails to compile as an unsupported type
 *    Case 5:  a variable of DATETIMELTZ view column %type assigned a typed literal fails to compile
 *    Case 6:  a variable of DATETIMELTZ view column %type fails to compile as an unsupported type
 *    Case 7:  a variable of DATETIMETZ view column %type assigned a typed literal fails to compile
 *    Case 8:  a variable of DATETIMETZ view column %type fails to compile as an unsupported type
 *    Case 9:  a variable of BIT view column %type assigned a typed literal fails to compile
 *    Case 10: a variable of BIT view column %type fails to compile as an unsupported type
 *    Case 11: a variable of BIT VARYING view column %type assigned a typed literal fails to compile
 *    Case 12: a variable of BIT VARYING view column %type fails to compile as an unsupported type
 *    Case 13: a variable of JSON view column %type fails to compile as an unsupported type
 *    Case 14: a variable of ENUM view column %type fails to compile as an unsupported type
 *    Case 15: a variable of BLOB view column %type assigned a typed literal fails to compile
 *    Case 16: a variable of BLOB view column %type fails to compile as an unsupported type
 *    Case 17: a variable of CLOB view column %type fails to compile as an unsupported type
 *    Case 18: a variable of SET view column %type fails to compile as an unsupported type
 *    Case 19: a variable of MULTISET view column %type fails to compile as an unsupported type
 *    Case 20: a variable of SEQUENCE view column %type fails to compile as an unsupported type
 *    Case 21: a variable of LIST view column %type fails to compile as an unsupported type
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


evaluate 'Case 1: a variable of TIMESTAMPLTZ view column %type assigned a typed literal fails to compile';
create or replace procedure type_unsupport as
   v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type;
begin 
   v_TIMESTAMPLTZ   := timestampltz'1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

evaluate 'Case 2: a variable of TIMESTAMPLTZ view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type;
begin 
   v_TIMESTAMPLTZ   := '1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

evaluate 'Case 3: a variable of TIMESTAMPTZ view column %type assigned a typed literal fails to compile';
create or replace procedure type_unsupport as
   v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type;
begin 
   v_TIMESTAMPTZ    := timestamptz'1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;

evaluate 'Case 4: a variable of TIMESTAMPTZ view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type;
begin 
   v_TIMESTAMPTZ    := '1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;

evaluate 'Case 5: a variable of DATETIMELTZ view column %type assigned a typed literal fails to compile';
create or replace procedure type_unsupport as
   v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type;
begin 
   v_DATETIMELTZ    := datetimeltz'0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;

evaluate 'Case 6: a variable of DATETIMELTZ view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type;
begin 
   v_DATETIMELTZ    := '0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;

evaluate 'Case 7: a variable of DATETIMETZ view column %type assigned a typed literal fails to compile';
create or replace procedure type_unsupport as
   v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type;
begin 
   v_DATETIMETZ     := datetimetz'0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;

evaluate 'Case 8: a variable of DATETIMETZ view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type;
begin 
   v_DATETIMETZ     := '0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;

evaluate 'Case 9: a variable of BIT view column %type assigned a typed literal fails to compile';
create or replace procedure type_unsupport as
   v_BIT                type_unsupport.T_BIT%type;
begin 
   v_BIT            := B'1';
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;

evaluate 'Case 10: a variable of BIT view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_BIT                type_unsupport.T_BIT%type;
begin 
   v_BIT            := '1';
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;

evaluate 'Case 11: a variable of BIT VARYING view column %type assigned a typed literal fails to compile';
create or replace procedure type_unsupport as
   v_BITVARYING         type_unsupport.T_BITVARYING%type;
begin 
   v_BITVARYING     := 0xcf;
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;

evaluate 'Case 12: a variable of BIT VARYING view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_BITVARYING         type_unsupport.T_BITVARYING%type;
begin 
   v_BITVARYING     := '0xcf';
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;

evaluate 'Case 13: a variable of JSON view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_JSON               type_unsupport.T_JSON%type;
begin 
   v_JSON           := '{"key1": "value1", "key2": "value2"}';
   dbms_output.put_line('v_JSON         ' || v_JSON        );
end;

evaluate 'Case 14: a variable of ENUM view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_ENUM               dba.type_unsupport.T_ENUM%type;
begin 
   v_ENUM           := 'medium';
   dbms_output.put_line('v_ENUM         ' || v_ENUM        );
end;

evaluate 'Case 15: a variable of BLOB view column %type assigned a typed literal fails to compile';
create or replace procedure type_unsupport as
   v_BLOB               dba.type_unsupport.T_BLOB%type;
begin 
   v_BLOB           := BIT_TO_BLOB(X'000100') ;
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;

evaluate 'Case 16: a variable of BLOB view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_BLOB               dba.type_unsupport.T_BLOB%type;
begin 
   v_BLOB           := BIT_TO_BLOB('000100') ;
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;

evaluate 'Case 17: a variable of CLOB view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_CLOB               dba.type_unsupport.T_CLOB%type;
begin 
   v_CLOB           := CHAR_TO_CLOB('This is a Cat');
   dbms_output.put_line('v_CLOB         ' || v_CLOB        );
end;

evaluate 'Case 18: a variable of SET view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_SET                dba.type_unsupport.T_SET%type;
begin 
   v_SET            := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_SET          ' || v_SET         );
end;

evaluate 'Case 19: a variable of MULTISET view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_MULTISET           dba.type_unsupport.T_MULTISET%type;
begin 
   v_MULTISET       := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_MULTISET     ' || v_MULTISET    );
end;

evaluate 'Case 20: a variable of SEQUENCE view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_SEQUENCE           dba.type_unsupport.T_SEQUENCE%type;
begin 
   v_SEQUENCE       := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_SEQUENCE     ' || v_SEQUENCE    );
end;

evaluate 'Case 21: a variable of LIST view column %type fails to compile as an unsupported type';
create or replace procedure type_unsupport as
   v_LIST               dba.type_unsupport.T_LIST%type;
begin 
   v_LIST           := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_LIST         ' || v_LIST        );
end;

drop procedure type_unsupport;

drop table unsupport;
drop view type_unsupport;


--+ server-message off

