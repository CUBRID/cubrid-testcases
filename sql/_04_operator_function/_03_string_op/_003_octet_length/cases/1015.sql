--+ holdcas on;
--test octet_length with varchar, int and operator ||
create class tb(
	col1 varchar,
	col2 int
);

insert into tb values('varchar', 10);

select octet_length(col1||col2) from tb;
set system parameters 'compat_mode=mysql';
select octet_length(concat(col1,col2)) from tb;
set system parameters 'compat_mode=cubrid';
 
drop class tb;
commit;
--+ holdcas off;
