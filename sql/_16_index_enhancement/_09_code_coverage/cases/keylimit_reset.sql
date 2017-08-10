--+ holdcas on;
create table T(id int, treeid int);

insert into T values(1, 1);
insert into T values(1, 2);
insert into T values(1, 3);
insert into T values(2, 1);
insert into T values(2, 2);
insert into T values(2, 3);

create index i_t_id_treeid on T(id, treeid);
create index i_t_id on T(id);

select a.id, b.id from t a,t b where a.id=1 and b.id=2 using index a.i_t_id keylimit 2,3, b.i_t_id keylimit 2,3;

select * from t a,t b where a.id=1 and b.id=2 using index a.i_t_id_treeid keylimit 2,3, b.i_t_id_treeid keylimit 2,3;

set system parameters 'compat_mode=oracle';

select a.id, b.id from t a,t b where a.id > 0 and b.id > 0 using index a.i_t_id keylimit 2,3, b.i_t_id keylimit 2,3;

select * from t a,t b where a.id > 0 and b.id > 0 using index a.i_t_id_treeid keylimit 2,3, b.i_t_id_treeid(+) keylimit 2,3;

set system parameters 'compat_mode=cubrid';


drop table T;
commit;
--+ holdcas off;
