--CLIENT
create class t_tr(i int);

create class t (i int, j int);
create trigger tr before delete on t execute insert into t_tr values(obj.i);

insert into t values (1, 4);
insert into t values (2, 5);
insert into t values (3, 6);
insert into t values (4, 7);
insert into t values (5, 8);

delete t1 from (select * from t) t1 where i=1;
select * from t order by 1;
select * from t_tr order by 1;

delete t1 from (select * from t where j < 7) t1 where i < 6;
select * from t order by 1;
select * from t_tr order by 1;

drop class t;
drop class t_tr;
