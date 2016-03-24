--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table foo(id int primary key) reuse_oid;

commit;

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);
insert into foo values(5);
insert into foo values(6);

select * from foo order by 1;
	
insert into foo values(7);
delete from foo where id=2;
delete from foo where id=3;
insert into foo values(8);

select * from foo order by 1;
	
insert into foo values(9);

select * from foo order by 1;

drop table foo;

create table foo(id int ) reuse_oid;

commit;

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);
insert into foo values(5);
insert into foo values(6);

select * from foo order by 1;
	
insert into foo values(7);
delete from foo where id=2;
delete from foo where id=3;
insert into foo values(8);

create index i_foo_id on foo ( id );

select * from foo order by 1;
	
insert into foo values(9);

select * from foo order by 1;

drop table foo;



create table foo(a int, b int) reuse_oid;
create unique index u_foo_a_b on foo(a,b);

commit;

insert into foo(a) values(1);
insert into foo(a) values(2);
insert into foo(a) values(3);
insert into foo(a) values(4);
insert into foo(a) values(5);
insert into foo(a) values(6);
update foo set b = a;

select * from foo order by 1;
	
insert into foo(a) values(7);
update foo set b = a;
delete from foo where a=2;
delete from foo where a=3;
insert into foo(a) values(8);
update foo set b = a;

select * from foo order by 1;
	
insert into foo(a) values(9);
update foo set b = a;
insert into foo select a+100, b+100 from foo order by a+10;

select /*+ USE_IDX */ * from foo where a > 0 order by 1;

drop table foo;
set  system parameters 'dont_reuse_heap_file=no';commit;
--+ holdcas off;
