--create table with enum type column, using create table ¡¦ like syntax.


create table clike1(
	col1 int,
	col2 enum('aaa', 'bbb', 'ccc') primary key,
	col3 enum('ddd', 'eee', 'fff') unique,
	col4 enum('abc') not null,
	col5 enum('111', '222', '333') unique not null,
	col6 enum('a', 'b', 'c', 'd', 'e', 'f'),
	index i1(col6)
);


show columns in clike1;

insert into clike1 values(1, 1, 2, 1, 3, 4);
insert into clike1 values(2, 2, 3, 1, 2, 6);
insert into clike1 values(3, 3, 1, 1, 1, 5);


--TEST: create table using 'create table ... like' syntax.
create table clike2 like clike1;

--TEST: check the schma
show columns in clike2;
show index in clike2;

--TEST: insert data into the new table.
insert into clike2 values(1, 1, 2, 1, 3, 4);
insert into clike2 values(2, 2, 3, 1, 2, 6);
insert into clike2 values(3, 3, 1, 1, 1, 5);


select * from clike2 order by 1;


drop table clike1, clike2;
