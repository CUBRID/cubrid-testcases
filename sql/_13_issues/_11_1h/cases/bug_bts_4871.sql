--+ holdcas on;

set system parameters 'alter_table_change_type_strict=yes';
create table coo(col1 varchar(50));
insert into coo values('8237923123123242347439281078412122');
select * from coo;

alter table coo change col1 col1 bigint;

set system parameters 'alter_table_change_type_strict=no';
alter table coo change col1 col1 bigint;
select * from coo;


drop table coo;

commit;

--+ holdcas off;

