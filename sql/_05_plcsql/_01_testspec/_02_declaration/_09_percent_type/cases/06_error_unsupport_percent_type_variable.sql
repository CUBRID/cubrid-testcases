/**
 *  This test case verifies CBRD-24707: a PL/CSQL variable declared with %type
 *  on a column of a type that PL/CSQL does not support fails to compile.
 *
 *  Some cases assign a literal of the column type, which PL/CSQL does not parse,
 *  so the create fails on that literal before the type check.
 *
 *  Coverage:
 *    Case 1:   a TIMESTAMPLTZ %type variable assigned a timestampltz literal fails to compile on the literal
 *    Case 2:   a TIMESTAMPLTZ %type variable assigned a string fails: TIMESTAMPLTZ is not supported
 *    Case 3:   a TIMESTAMPTZ %type variable assigned a timestamptz literal fails to compile on the literal
 *    Case 4:   a TIMESTAMPTZ %type variable assigned a string fails: TIMESTAMPTZ is not supported
 *    Case 5:   a DATETIMELTZ %type variable assigned a datetimeltz literal fails to compile on the literal
 *    Case 6:   a DATETIMELTZ %type variable assigned a string fails: DATETIMELTZ is not supported
 *    Case 7:   a DATETIMETZ %type variable assigned a datetimetz literal fails to compile on the literal
 *    Case 8:   a DATETIMETZ %type variable assigned a string fails: DATETIMETZ is not supported
 *    Case 9:   a BIT %type variable assigned a bit string literal fails to compile on the literal
 *    Case 10:  a BIT %type variable assigned a string fails: BIT is not supported
 *    Case 11:  a BIT VARYING %type variable assigned a hexadecimal literal fails to compile on the literal
 *    Case 12:  a BIT VARYING %type variable assigned a string fails: BIT VARYING is not supported
 *    Case 13:  a JSON %type variable fails: JSON is not supported
 *    Case 14:  an ENUM %type variable fails: ENUM is not supported
 *    Case 15:  a BLOB %type variable assigned BIT_TO_BLOB of a bit string literal fails to compile on the literal
 *    Case 16:  a BLOB %type variable assigned a string fails: BLOB is not supported
 *    Case 17:  a CLOB %type variable fails: CLOB is not supported
 *    Case 18:  a SET %type variable fails: SET is not supported
 *    Case 19:  a MULTISET %type variable fails: MULTISET is not supported
 *    Case 20:  a SEQUENCE %type variable fails: SEQUENCE is not supported
 *    Case 21:  a LIST %type variable fails: LIST is not supported
 */

--+ server-message on

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


-- %type, unsupported, variable
evaluate 'Case 1: a TIMESTAMPLTZ %type variable assigned a timestampltz literal fails to compile on the literal; result = Error:-1360';
create or replace procedure type_unsupport as
   v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type;
begin 
   v_TIMESTAMPLTZ   := timestampltz'1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

evaluate 'Case 2: a TIMESTAMPLTZ %type variable assigned a string fails: TIMESTAMPLTZ is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type;
begin 
   v_TIMESTAMPLTZ   := '1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

evaluate 'Case 3: a TIMESTAMPTZ %type variable assigned a timestamptz literal fails to compile on the literal; result = Error:-1360';
create or replace procedure type_unsupport as
   v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type;
begin 
   v_TIMESTAMPTZ    := timestamptz'1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;

evaluate 'Case 4: a TIMESTAMPTZ %type variable assigned a string fails: TIMESTAMPTZ is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type;
begin 
   v_TIMESTAMPTZ    := '1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;

evaluate 'Case 5: a DATETIMELTZ %type variable assigned a datetimeltz literal fails to compile on the literal; result = Error:-1360';
create or replace procedure type_unsupport as
   v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type;
begin 
   v_DATETIMELTZ    := datetimeltz'0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;

evaluate 'Case 6: a DATETIMELTZ %type variable assigned a string fails: DATETIMELTZ is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type;
begin 
   v_DATETIMELTZ    := '0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;

evaluate 'Case 7: a DATETIMETZ %type variable assigned a datetimetz literal fails to compile on the literal; result = Error:-1360';
create or replace procedure type_unsupport as
   v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type;
begin 
   v_DATETIMETZ     := datetimetz'0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;

evaluate 'Case 8: a DATETIMETZ %type variable assigned a string fails: DATETIMETZ is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type;
begin 
   v_DATETIMETZ     := '0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;

evaluate 'Case 9: a BIT %type variable assigned a bit string literal fails to compile on the literal; result = Error:-1360';
create or replace procedure type_unsupport as
   v_BIT                type_unsupport.T_BIT%type;
begin 
   v_BIT            := B'1';
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;

evaluate 'Case 10: a BIT %type variable assigned a string fails: BIT is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_BIT                type_unsupport.T_BIT%type;
begin 
   v_BIT            := '1';
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;

evaluate 'Case 11: a BIT VARYING %type variable assigned a hexadecimal literal fails to compile on the literal; result = Error:-1360';
create or replace procedure type_unsupport as
   v_BITVARYING         type_unsupport.T_BITVARYING%type;
begin 
   v_BITVARYING     := 0xcf;
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;

evaluate 'Case 12: a BIT VARYING %type variable assigned a string fails: BIT VARYING is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_BITVARYING         type_unsupport.T_BITVARYING%type;
begin 
   v_BITVARYING     := '0xcf';
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;

evaluate 'Case 13: a JSON %type variable fails: JSON is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_JSON               type_unsupport.T_JSON%type;
begin 
   v_JSON           := '{"key1": "value1", "key2": "value2"}';
   dbms_output.put_line('v_JSON         ' || v_JSON        );
end;

evaluate 'Case 14: an ENUM %type variable fails: ENUM is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_ENUM               dba.type_unsupport.T_ENUM%type;
begin 
   v_ENUM           := 'medium';
   dbms_output.put_line('v_ENUM         ' || v_ENUM        );
end;

evaluate 'Case 15: a BLOB %type variable assigned BIT_TO_BLOB of a bit string literal fails to compile on the literal; result = Error:-1360';
create or replace procedure type_unsupport as
   v_BLOB               dba.type_unsupport.T_BLOB%type;
begin 
   v_BLOB           := BIT_TO_BLOB(X'000100') ;
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;

evaluate 'Case 16: a BLOB %type variable assigned a string fails: BLOB is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_BLOB               dba.type_unsupport.T_BLOB%type;
begin 
   v_BLOB           := BIT_TO_BLOB('000100') ;
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;

evaluate 'Case 17: a CLOB %type variable fails: CLOB is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_CLOB               dba.type_unsupport.T_CLOB%type;
begin 
   v_CLOB           := CHAR_TO_CLOB('This is a Cat');
   dbms_output.put_line('v_CLOB         ' || v_CLOB        );
end;

evaluate 'Case 18: a SET %type variable fails: SET is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_SET                dba.type_unsupport.T_SET%type;
begin 
   v_SET            := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_SET          ' || v_SET         );
end;

evaluate 'Case 19: a MULTISET %type variable fails: MULTISET is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_MULTISET           dba.type_unsupport.T_MULTISET%type;
begin 
   v_MULTISET       := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_MULTISET     ' || v_MULTISET    );
end;

evaluate 'Case 20: a SEQUENCE %type variable fails: SEQUENCE is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_SEQUENCE           dba.type_unsupport.T_SEQUENCE%type;
begin 
   v_SEQUENCE       := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_SEQUENCE     ' || v_SEQUENCE    );
end;

evaluate 'Case 21: a LIST %type variable fails: LIST is not supported; result = Error:-1360';
create or replace procedure type_unsupport as
   v_LIST               dba.type_unsupport.T_LIST%type;
begin 
   v_LIST           := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_LIST         ' || v_LIST        );
end;

-- every case fails, so the procedure type_unsupport does not exist and this drop fails unless a case created it by mistake
drop procedure type_unsupport;

drop table type_unsupport;


--+ server-message off

