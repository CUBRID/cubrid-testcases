--[er]test decr function with types set, multiset, list
create class tb(
		col0 int auto_increment primary key,
		col1 set,
		col2 multiset,
		col3 list
);

insert into tb (col1, col2, col3) values({1,2,3}, {1,2,3}, {1,2,3});
insert into tb (col1, col2, col3) values({4,5,6}, {4,5,6}, {4,5,6});

select decr(col1) from tb where col0=1;
select decr(col2) from tb where col0=1;
select decr(col3) from tb where col0=1;

drop class tb;
