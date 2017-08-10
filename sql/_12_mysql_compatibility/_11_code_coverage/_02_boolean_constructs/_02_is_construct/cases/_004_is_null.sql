create table num_t(one int, zero int, null_c int, unk_c int);

insert into num_t values (1, 0, NULL, UNKNOWN);

select 1 from num_t where one IS NULL;
select 1 from num_t where zero IS NULL;
select 1 from num_t where null_c IS NULL;
select 1 from num_t where unk_c is null;

drop table num_t;
