create table foo(id int) reuse_oid;

commit;

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);

create view v as select * from foo;

select * from foo order by 1;

select * from v order by 1;

insert into v values(4);

delete from v where id=2;

update v set id=10 where id=1;

drop view v;

drop table foo;
