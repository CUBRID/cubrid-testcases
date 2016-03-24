--test udt using nchar, nchar varying type
create class t1(
	id int auto_increment primary key,
	col1 nchar(10),
	col2 nchar varying(10)
);

create class t2(
	a set of t1,
	b set(varchar(10)),
	c sequence varchar(10)
);

insert INTO t1 (col1) values (n'nchar01');
insert INTO t1 (col1) values (n'nchar02');

SELECT t1 into xx from t1 where id=1;
insert into t2 values ({xx},{'aaa'},{'vvv'});

select * FROM t1;
SELECT * FROM t2;

drop t1;
drop t2;