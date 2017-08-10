--test upper function with set type
create class tb(
	col1 varchar
);

insert into tb values('varchar1');
insert into tb values('varchar2');

select * from tb where col1 like '%VAR%';
select * from tb where upper(col1) like '%VAR%';

drop class tb;