create class foo(a string, b integer, c date);

create index idx_a_pr on foo(a(1));
create index idx_b on foo(b);
create index idx_c on foo(c);

insert into foo values('ab',3,'2010-01-01');
insert into foo values('ac',2,'2010-01-03');
insert into foo values('ad',1,'2010-01-02');

select * from foo where a between 'a' and 'b' order by a;
select * from foo where a between 'a' and 'b' order by b;
select * from foo where a between 'a' and 'b' order by c;

drop class foo;
