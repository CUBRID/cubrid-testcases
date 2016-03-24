CREATE TABLE foo(
a integer AUTO_INCREMENT,
b character varying(10)
);

insert into foo(b) values('aaa');
insert into foo(b) values('bbb');

alter table foo change b b varchar default '123', add column c short;

insert into foo(c) values(233);


select * from foo order by 1;


drop table foo;


