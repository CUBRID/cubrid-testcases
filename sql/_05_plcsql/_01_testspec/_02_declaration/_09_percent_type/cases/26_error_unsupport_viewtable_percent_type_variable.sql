--+ server-message on

-- Verification for CBRD-24707 ( Support API for %TYPE )
-- normal: %type unsupport variable

-- create table & view
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


-- %type, unsupported, variable
EVALUATE 'TIMESTAMPLTZ #1';
create or replace procedure type_unsupport as
   v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type;
begin 
   v_TIMESTAMPLTZ   := timestampltz'1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

EVALUATE 'TIMESTAMPLTZ #2';
create or replace procedure type_unsupport as
   v_TIMESTAMPLTZ       type_unsupport.T_TIMESTAMPLTZ%type;
begin 
   v_TIMESTAMPLTZ   := '1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPLTZ ' || v_TIMESTAMPLTZ);
end;

EVALUATE 'TIMESTAMPTZ #1';
create or replace procedure type_unsupport as
   v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type;
begin 
   v_TIMESTAMPTZ    := timestamptz'1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;

EVALUATE 'TIMESTAMPTZ #2';
create or replace procedure type_unsupport as
   v_TIMESTAMPTZ       type_unsupport.T_TIMESTAMPTZ%type;
begin 
   v_TIMESTAMPTZ    := '1970-01-01 09:00:01';
   dbms_output.put_line('v_TIMESTAMPTZ  ' || v_TIMESTAMPTZ );
end;

EVALUATE 'DATETIMELTZ #1';
create or replace procedure type_unsupport as
   v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type;
begin 
   v_DATETIMELTZ    := datetimeltz'0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;

EVALUATE 'DATETIMELTZ #2';
create or replace procedure type_unsupport as
   v_DATETIMELTZ        type_unsupport.T_DATETIMELTZ%type;
begin 
   v_DATETIMELTZ    := '0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMELTZ  ' || v_DATETIMELTZ );
end;

EVALUATE 'DATETIMETZ #1';
create or replace procedure type_unsupport as
   v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type;
begin 
   v_DATETIMETZ     := datetimetz'0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;

EVALUATE 'DATETIMETZ #2';
create or replace procedure type_unsupport as
   v_DATETIMETZ         type_unsupport.T_DATETIMETZ%type;
begin 
   v_DATETIMETZ     := '0001-01-01 09:00:01.000';
   dbms_output.put_line('v_DATETIMETZ   ' || v_DATETIMETZ  );
end;

EVALUATE 'BIT #1';
create or replace procedure type_unsupport as
   v_BIT                type_unsupport.T_BIT%type;
begin 
   v_BIT            := B'1';
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;

EVALUATE 'BIT #2';
create or replace procedure type_unsupport as
   v_BIT                type_unsupport.T_BIT%type;
begin 
   v_BIT            := '1';
   dbms_output.put_line('v_BIT          ' || v_BIT         );
end;

EVALUATE 'BIT VARYING #1';
create or replace procedure type_unsupport as
   v_BITVARYING         type_unsupport.T_BITVARYING%type;
begin 
   v_BITVARYING     := 0xcf;
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;

EVALUATE 'BIT VARYING #2';
create or replace procedure type_unsupport as
   v_BITVARYING         type_unsupport.T_BITVARYING%type;
begin 
   v_BITVARYING     := '0xcf';
   dbms_output.put_line('v_BITVARYING   ' || v_BITVARYING  );
end;

EVALUATE 'JSON';
create or replace procedure type_unsupport as
   v_JSON               type_unsupport.T_JSON%type;
begin 
   v_JSON           := '{"key1": "value1", "key2": "value2"}';
   dbms_output.put_line('v_JSON         ' || v_JSON        );
end;

EVALUATE 'ENUM';
create or replace procedure type_unsupport as
   v_ENUM               dba.type_unsupport.T_ENUM%type;
begin 
   v_ENUM           := 'medium';
   dbms_output.put_line('v_ENUM         ' || v_ENUM        );
end;

EVALUATE 'BLOB #1';
create or replace procedure type_unsupport as
   v_BLOB               dba.type_unsupport.T_BLOB%type;
begin 
   v_BLOB           := BIT_TO_BLOB(X'000100') ;
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;

EVALUATE 'BLOB #2';
create or replace procedure type_unsupport as
   v_BLOB               dba.type_unsupport.T_BLOB%type;
begin 
   v_BLOB           := BIT_TO_BLOB('000100') ;
   dbms_output.put_line('v_BLOB         ' || v_BLOB        );
end;

EVALUATE 'CLOB';
create or replace procedure type_unsupport as
   v_CLOB               dba.type_unsupport.T_CLOB%type;
begin 
   v_CLOB           := CHAR_TO_CLOB('This is a Cat');
   dbms_output.put_line('v_CLOB         ' || v_CLOB        );
end;

EVALUATE 'SET';
create or replace procedure type_unsupport as
   v_SET                dba.type_unsupport.T_SET%type;
begin 
   v_SET            := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_SET          ' || v_SET         );
end;

EVALUATE 'MULTISET';
create or replace procedure type_unsupport as
   v_MULTISET           dba.type_unsupport.T_MULTISET%type;
begin 
   v_MULTISET       := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_MULTISET     ' || v_MULTISET    );
end;

EVALUATE 'SEQUENCE';
create or replace procedure type_unsupport as
   v_SEQUENCE           dba.type_unsupport.T_SEQUENCE%type;
begin 
   v_SEQUENCE       := '{''c'',''c'',''c'',''b'',''b'',''a''}';
   dbms_output.put_line('v_SEQUENCE     ' || v_SEQUENCE    );
end;

EVALUATE 'LIST';
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

