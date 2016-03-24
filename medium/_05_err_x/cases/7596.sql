autocommit off;
create class foo (a string);

create trigger t0  status active after insert on foo;

insert into foo values ('abc');

insert into foo values ('def');
rollback;
