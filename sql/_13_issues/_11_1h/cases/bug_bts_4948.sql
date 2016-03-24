--+ holdcas on;

create table foo(a char(30));
insert into foo values('3.40282346668343E+312');
select * from foo;

set system parameters 'alter_table_change_type_strict=yes';
alter table foo change a a numeric(30);

set system parameters 'alter_table_change_type_strict=no';
alter table foo change a a numeric(30);

select * from foo;

drop table foo;

commit;

--+ holdcas off;

