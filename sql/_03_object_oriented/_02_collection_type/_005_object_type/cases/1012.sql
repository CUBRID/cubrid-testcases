--+ holdcas on;
--test udt using types nchar, nchar varying, char, char varying, varchar
set system parameters 'create_table_reuseoid=no';

create class t1(
	id int auto_increment primary key,
	col1 nchar(10),
	col2 nchar varying(10),
	col3 char(10),
	col4 char varying(10),
	col5 varchar
);

create class t2(
	a set of t1,
	b set(varchar(10)),
	c sequence varchar(10)
);

insert INTO t1 (col1, col2, col3, col4, col5) values (n'nchar01', n'nchar01', 'char01', 'char01', 'varchar01');
insert INTO t1 (col1, col2, col3, col4, col5) values (n'nchar02', n'nchar02', 'char02', 'char02', 'varchar02');

SELECT t1 into xx from t1 where id=1;
insert into t2 values ({xx},{'aaa'},{'vvv'});

select * FROM t1 order by 1;
SELECT * FROM t2 order by 1;

drop t1;
drop t2;

set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
