/**
 *  This test case verifies CBRD-28189: the refusal of a USING value at an OUT parameter when the
 *  target is a Java stored procedure
 *
 *  A USING value of EXECUTE IMMEDIATE that goes to an OUT or IN OUT parameter of a CALL in the dynamic
 *  SQL is refused whatever language the target procedure is written in. The Java procedures here use
 *  SpTest5.ptestint2, a class that CTP loads, which adds 10 to its argument. A static call is the
 *  control and returns the value. Each case writes what it sees into t28189_log.
 *
 *  Coverage:
 *    Case 1:  EXECUTE IMMEDIATE with USING at an OUT parameter of a Java procedure is refused
 *    Case 2:  EXECUTE IMMEDIATE with USING at an IN OUT parameter of a Java procedure is refused
 *    Case 3:  a static call of the same Java procedures returns the values
 */

drop table if exists t28189_log;
create table t28189_log (seq int auto_increment primary key, tag varchar (20), v int, msg varchar (1000));
create or replace procedure t28189_jout (a OUT int) as language java name 'SpTest5.ptestint2(int[])';
create or replace procedure t28189_jinout (a IN OUT int) as language java name 'SpTest5.ptestint2(int[])';

evaluate 'Case 1: EXECUTE IMMEDIATE with USING at an OUT parameter of a Java procedure is refused';
create or replace procedure t28189_p1 as
    l_j int := 3;
    l_e varchar (1000);
begin
    execute immediate 'call t28189_jout(?)' using l_j;
    insert into t28189_log (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_log (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p1 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 2: EXECUTE IMMEDIATE with USING at an IN OUT parameter of a Java procedure is refused';
delete from t28189_log;
create or replace procedure t28189_p2 as
    l_j int := 3;
    l_e varchar (1000);
begin
    execute immediate 'call t28189_jinout(?)' using l_j;
    insert into t28189_log (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_log (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p2 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 3: a static call of the same Java procedures returns the values';
delete from t28189_log;
create or replace procedure t28189_p3 as
    l_j int;
begin
    l_j := 3;
    t28189_jout (l_j);
    insert into t28189_log (tag, v) values ('out', l_j);
    l_j := 3;
    t28189_jinout (l_j);
    insert into t28189_log (tag, v) values ('inout', l_j);
end;
call t28189_p3 ();
select tag, v from t28189_log order by seq;

drop procedure t28189_p1;
drop procedure t28189_p2;
drop procedure t28189_p3;
drop procedure t28189_jout;
drop procedure t28189_jinout;
drop table t28189_log;
