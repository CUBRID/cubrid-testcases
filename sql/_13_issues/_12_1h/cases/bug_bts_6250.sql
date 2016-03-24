create table foo (alias int, async1 int, completion int, dictionary int, exclude int, ldb int,
 oid int, operation int, operators int, others int, pendant int, preorder int, private int,
 protected int, proxy int, register int, structure int, sys_user int, test int, there int,
 type int, virtual int, visible int, wait int);

create table alias(alias int);
create table completion(completion int);
create table async1(async1 int);
create table dictionary(dictionary int);
create table exclude(exclude int);
create table ldb(ldb int);
create table oid(oid int);
create table operation(operation int);
create table operators(operators int);
create table others(others int);
create table pendant(pendant int);
create table preorder(preorder int);
create table private(private int);
create table protected(protected int);
create table proxy(proxy int);
create table register(register int);
create table structure(structure int);
create table sys_user(sys_user int);
create table test(test int);
create table there(there int);
create table type(type int);
create table virtual(virtual int);
create table visible(visible int);
create table wait(wait int);

insert into foo values(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24);

select * from foo;

drop foo;
drop alias;
drop completion;
drop async1;
drop dictionary;
drop exclude;
drop ldb;
drop oid;
drop operation;
drop operators;
drop others;
drop pendant;
drop preorder;
drop private;
drop protected;
drop proxy;
drop register;
drop structure;
drop sys_user;
drop test;
drop there;
drop type;
drop virtual;
drop visible;
drop wait;

