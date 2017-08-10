--create index on enum column
set system parameters 'dont_reuse_heap_file=yes';

create table idx(
	col1 enum('a', 'b', 'c', 'd', 'e'),
	col2 enum('aa', 'bb', 'cc'),
	col3 enum('1', '2', '3'),
	col4 enum('11', '22', '33')
);

insert into idx values(1, 2, 1, 3);
insert into idx values(3, 1, 2, 1);
insert into idx values(2, 3, 3, 1);
insert into idx values(5, 2, 2, 2);


select * from idx order by col1;


--create unique index
create unique index idx1 on idx(col1);
--create reverse index
create reverse index idx2 on idx(col3);
--create multi-column index
create index idx3 on idx(col2, col4);


--TEST: test unique index on enum column
select * from idx where col1 < 'e' order by 1;
--TEST: test reverse index on enum column
select * from idx where col3 > 'a' and col2 < 'c' order by 1;
--TEST: test multi-column index on enum column
select * from idx where col2 < 'e' and col4 > '1' order by 1;


drop table idx;

set system parameters 'dont_reuse_heap_file=no';
