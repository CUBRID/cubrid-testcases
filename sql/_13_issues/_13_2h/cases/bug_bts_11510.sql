--Test for 'INSERT INTO ... SELECT orderby_num() ...  
drop table if exists foo;

create table foo (rank int, id varchar(10), score int);
insert into foo values (1, 'B', 10);
insert into foo values (2, 'A', 1);
select orderby_num() as rank, id, score from (select 'A' as id, 1 as score union all select 'B' as id, 10 as score) foo order by score desc;

drop table if exists foo2;
create table foo2 (rank int, id varchar(10), score int);
insert into foo2 (rank, id, score) select orderby_num() as rank, id, score from (select 'A' as id, 1 as score union all select 'B' as id, 10 as score) foo order by score desc;
select * from foo2;

drop table foo;
drop table foo2;
