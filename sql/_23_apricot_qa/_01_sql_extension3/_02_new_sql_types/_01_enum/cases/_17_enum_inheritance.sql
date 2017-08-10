--test inheritance with enum columns


create table sup(
	col1 int,
	col2 enum('aaa', 'bbb', 'ccc') primary key,
	col3 enum('ddd', 'eee', 'fff') unique,
	col4 enum('abc') not null,
	col5 enum('111', '222', '333') unique not null,
	col6 enum('a', 'b', 'c', 'd', 'e', 'f'),
	index i(col6)
);


show columns in sup;

insert into sup values(1, 1, 2, 1, 3, 4);
insert into sup values(2, 2, 3, 1, 2, 6);
insert into sup values(3, 3, 1, 1, 1, 5);


--TEST: create table using 'create table ... like' syntax.
create table sub under sup(col7 char(10), col8 enum('A', 'B', 'C'));

update statistics on all classes;
--TEST: check the schma
show columns in sub;
show index in sub;

--TEST: [er] unique violation error, insert data into the new table.
insert into sub values(1, 1, 2, 1, 3, 4, 'a', 3);
insert into sub values(2, 2, 3, 1, 2, 6, 'b', 2);
insert into sub values(3, 3, 1, 1, 1, 5, 'c', 1);

alter table sup drop primary key;
drop unique index u_sup_col3 on sup;
drop unique index u_sup_col5 on sup;

--TEST: insert values into the sub table after dropping unique indexes.
insert into sub values(1, 1, 2, 1, 3, 4, 'a', 3);
insert into sub values(2, 2, 3, 1, 2, 6, 'b', 2);
insert into sub values(3, 3, 1, 1, 1, 5, 'c', 1);


select * from sub order by 1;


drop table sup, sub;
