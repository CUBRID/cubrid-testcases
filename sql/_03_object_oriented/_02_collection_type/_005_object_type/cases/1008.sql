-- [er]test udt using types int, smallint, float, double, monetary
create class t1(
	id int auto_increment primary key,
	col1 int,
	col2 smallint,
	col3 float,
	col4 double,
	col5 monetary
);

create class t2(
	a set of t1,
	b set(varchar(10)),
	c sequence varchar(10)
);

insert INTO t1 (col1, col2, col3, col4, col5) values (1, 1, 1, 1, 1);
insert INTO t1 (col1, col2, col3, col4, col5) values (2, 2, 2, 2, 2);

SELECT t1 into xx from t1 where id=1;
insert into t2 values ({xx},{'aaa'},{'vvv'});

select * FROM t1 order by 1;
SELECT * FROM t2;

drop t1;
drop t2;
