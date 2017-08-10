--+ holdcas on;
set system parameters 'add_column_update_hard_default = yes';

create table u (tick int auto_increment);

create table t (useless int);
insert into t values (1), (2), (3), (4);


create trigger trg before update on t execute insert into u values (NULL);

alter table t add column nn timestamp not null;
select * from t order by useless;

-- 4 rows affected, but not in table u, where there should still be 0 records
-- proving that the trigger didn't fire

select count(*) as mustbezero from u;

drop table t;
drop table u;


set system parameters 'add_column_update_hard_default = no';
commit;
--+ holdcas off;
