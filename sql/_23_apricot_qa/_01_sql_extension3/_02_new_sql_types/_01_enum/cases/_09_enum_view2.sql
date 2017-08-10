--create view with check option on the table with enum columns


create table vt(
	col1 int,
	col2 enum('aaa', 'bbb', 'ccc') primary key,
	col3 enum('ddd', 'eee', 'fff') unique,
	col4 enum('abc') not null,
	col5 enum('111', '222', '333') unique not null default 2,
	col6 enum('a', 'b', 'c', 'd', 'e', 'f'),
	index i(col6)
);


insert into vt values(1, 1, 2, 1, 3, 4);
insert into vt values(2, 2, 3, 1, 2, 6);


--TEST: create table using 'create table ... like' syntax.
create view cview as select * from vt where col6 < 'f' and col3 > 'ddd' with check option;

--TEST: check the schma
show columns in cview;
show index in cview;

--TEST: [er] check option error, insert data into the view.
insert into cview values(3, 3, 1, 1, 1, 5);
--TEST: [er] unique key violation error.
insert into cview values(3, 'ddd', 1, 1, 1, 5);


select * from cview order by 1;
select * from vt order by 1;


drop table vt;
drop view cview;
