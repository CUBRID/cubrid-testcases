--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table T(id int, treeid int);

insert into T values(1, 1);
insert into T values(1, 2);
insert into T values(1, 3);
insert into T values(2, 1);
insert into T values(2, 2);
insert into T values(2, 3);

create index i_t_id_treeid  on T(id, treeid);
select count(*) from T where id <> 1;

drop table T;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
