create table num_t(one int, zero int, null_c int, unk_c int);

insert into num_t values (1, 0, NULL, UNKNOWN);

select 1 from num_t where one IS NOT NULL;
select 1 from num_t where zero IS NOT NULL;
select 1 from db_root where null_c IS NOT NULL;
select 1 from db_root where unk_c IS NOT NULL;

drop table num_t;
