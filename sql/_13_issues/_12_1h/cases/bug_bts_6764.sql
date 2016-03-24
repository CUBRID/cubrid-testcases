--TEST: SYSTIMESTAMP default value cannot be deleted using 'alter ... change ...' statement


create table foo(a timestamp default SYSTIMESTAMP, b timestamp default '2000-1-1 12:12:12');
show columns in foo;

alter table foo change a a timestamp;
alter table foo change b b timestamp;

show columns in foo;

drop table foo;
