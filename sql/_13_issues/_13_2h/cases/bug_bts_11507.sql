--Test for group_concat ( ) with rollup
drop table if exists foo;

create table foo (col_1 varchar(100), col_2 int, col_3 int);
insert into foo values('alice',3,10);
insert into foo values('alice',5,10);
insert into foo values('george',4,10);
insert into foo values('george',3,10);
insert into foo values('mary',5,10);
insert into foo values('mary',2,10);
insert into foo values('john',6,10);
insert into foo values('john',5,10);

select newfoo.col_2, newfoo.col_3, group_concat(newfoo.col_1) from (select col_1,col_2,col_3 from foo order by 1) newfoo  group by newfoo.col_2, newfoo.col_3 with rollup;

drop table foo;
