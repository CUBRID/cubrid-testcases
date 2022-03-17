set system parameters 'create_table_reuseoid=no';

create table foo(id int) REUSE_OID;

create table goo under foo (x int);

create table xoo ( a int, b foo);

drop goo;
drop table foo;

create table foo(id int);
create table goo under foo ( a int ) reuse_oid;

drop foo, goo;

create table ooo ( a int primary key) reuse_oid;
create table koo under ooo;
create table poo ( a koo);

drop koo; 
drop ooo;
drop poo;

set system parameters 'create_table_reuseoid=yes';
