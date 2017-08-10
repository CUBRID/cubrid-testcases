--create view on the table with enum columns


create table cview1(
	col1 int,
	col2 enum('aaa', 'bbb', 'ccc') primary key,
	col3 enum('ddd', 'eee', 'fff') unique,
	col4 enum('abc') not null,
	col5 enum('111', '222', '333') unique not null,
	col6 enum('a', 'b', 'c', 'd', 'e', 'f') default 'c',
	index i(col6)
);


insert into cview1 values(1, 1, 2, 1, 3, 4);
insert into cview1 values(2, 2, 3, 1, 2, 6);


--TEST: create view 
create view cview2 as select * from cview1 where col6 < 'f';

--TEST: check the schma
show columns in cview2;
show index in cview2;

--TEST: insert data into the view.
insert into cview2 values(3, 3, 1, 1, 1, 5);
--TEST: [er] unique key violation error.
insert into cview2 values(3, 3, 1, 1, 1, 5);


select * from cview2 order by 1;
select * from cview1 order by 1;


drop table cview1;
drop view cview2;
