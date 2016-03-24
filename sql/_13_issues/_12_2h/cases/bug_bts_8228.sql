drop table if exists foo;

create table foo(a enum('a', 'b', 'c'));
insert into foo values(1), ('b'), (3);

select elt(1, a) from foo order by elt(1, a);
select insert(a, 1, 2, 'aa') from foo  order by insert(a, 1, 2, 'aa');
select group_concat(a) from (select * from foo order by 1) foo;
select max(a) from foo order by max(a);
select min(a) from foo order by min(a);
    
drop table if exists foo;
