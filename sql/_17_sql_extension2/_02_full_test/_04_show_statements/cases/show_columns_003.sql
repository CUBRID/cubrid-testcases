--test describe/desc

create table foo(a int, b string unique, c set(monetary) not null, d nchar(20), primary key(a, d));
insert into foo values(1, 'abc', {10, 20, 30}, n'def');

describe foo;

alter table foo change a a int after c;
desc foo;

alter table foo change d e nchar varying first;
desc foo;

alter table foo change b b string default 'aaa' after c;
desc foo;


drop table foo;
