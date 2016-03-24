--+ holdcas on;
--change a column to not null when there're already null values in this column

create table foo(a int, b char(20));

insert into foo values(null, null);

set system parameters 'add_column_update_hard_default=no';
alter table foo change a a int not null;
select * from foo;

set system parameters 'add_column_update_hard_default=yes';
alter table foo change b b char(20) not null;
select * from foo;

drop table foo;

--[er]
set system parameters 'add_column_update_hard_default=123';

set system parameters 'add_column_update_hard_default=no';


commit;
--+ holdcas off;
