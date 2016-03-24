autocommit off;
create class foo (x char(2));
insert into foo values('1');
insert into foo select x + '1' from foo where char_length(trim(x)) = 1;
insert into foo select trim(x) + '1' from foo where char_length(trim(x)) = 1;

rollback;