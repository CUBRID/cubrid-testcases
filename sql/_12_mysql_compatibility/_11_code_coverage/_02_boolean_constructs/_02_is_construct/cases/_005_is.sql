create table num_t(one int, zero int, null_c int, unk_c int);

insert into num_t values (1, 0, NULL, UNKNOWN);

select 1 from num_t where one IS TRUE;
select 1 from num_t where one IS FALSE;
select 1 from num_t where one IS UNKNOWN;
select 1 from num_t where zero IS TRUE;
select 1 from num_t where zero IS FALSE;
select 1 from num_t where zero IS UNKNOWN;
select 1 from num_t where null_c IS TRUE;
select 1 from num_t where null_c IS FALSE;
select 1 from num_t where null_c IS UNKNOWN;
select 1 from num_t where unk_c IS TRUE;
select 1 from num_t where unk_c IS FALSE;
select 1 from num_t where unk_c IS UNKNOWN;

select 1 from num_t where not(one IS TRUE);

drop table num_t;
