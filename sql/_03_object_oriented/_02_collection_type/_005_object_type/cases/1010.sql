--+ holdcas on;
--test udt using char, char varying type
set system parameters 'create_table_reuseoid=no';

create class t1(
	id int auto_increment primary key,
	col1 char(10),
	col2 char varying(10)
);

create class t2(
	a set of t1,
	b set(varchar(10)),
	c sequence varchar(10)
);

insert INTO t1 (col1) values ('char01');
insert INTO t1 (col1) values ('char02');

SELECT t1 into xx from t1 where id=1;
insert into t2 values ({xx},{'aaa'},{'vvv'});

select * FROM t1;
SELECT * FROM t2;

drop t1;
drop t2;

set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
