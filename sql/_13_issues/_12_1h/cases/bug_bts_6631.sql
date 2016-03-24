--TEST: Implicitly inserting default value of SYSDATE into a timestamp column doesn't work.


create table foo(a int, b timestamp default SYSDATE, c timestamp default SYSDATE);

insert into foo values(1, default, default);
insert into foo(a) values(2);
insert into foo(a, b) values(3, default);
insert into foo(a, c) values(4, default);
insert into foo default;

select if(date(b)=date(c) and date(b)=SYSDATE, 'ok', 'nok') from foo;


drop table foo;
