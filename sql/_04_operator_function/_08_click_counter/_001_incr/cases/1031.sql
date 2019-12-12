--[er]test incr function with types float, double, monetary
create class tb(
		col0 int auto_increment primary key,
		col1 float,
		col2 DOUBLE,
		col3 MONETARY
);

insert into tb (col1, col2, col3) values(1, 1.11, 1.111);
insert into tb (col1, col2, col3) values(2, 2.22, 2.222);

select incr(col1) from tb where col0=1;
select incr(col1) from tb where col0=1;

select incr(col2) from tb where col0=1;
select incr(col2) from tb where col0=1;

select incr(col3) from tb where col0=1;
select incr(col3) from tb where col0=1;

drop class tb;
