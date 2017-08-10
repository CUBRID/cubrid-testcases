--[er]test decr function with types char, varchar, nchar 
create class tb(
		col0 int auto_increment primary key,
		col1 char(8),
		col2 varchar,
		col3 nchar(8)
);

insert into tb (col1, col2, col3) values('char1', 'varchar1', n'nchar1');
insert into tb (col1, col2, col3) values('char2', 'varchar2', n'nchar2');

select decr(col1) from tb where col0=1;
select decr(col2) from tb where col0=1;
select decr(col3) from tb where col0=1;

drop class tb;
