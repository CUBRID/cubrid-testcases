--+ holdcas on;
--test count function with a expression which used ||
create class tb(
		col1 varchar,
		col2 char(10),
		col3 int
);

insert into tb values('varchar01', 'char01', 3);
insert into tb values('varchar02', 'char02', 4);
insert into tb values('varchar03', 'char03', 5);

select count(col1||col2) from tb group by col1||col2;
set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';
select count(col1||col2) from tb group by col1||col2;
set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

drop class tb;
commit;
--+ holdcas off;
