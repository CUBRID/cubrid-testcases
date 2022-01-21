create table num_t(one int, zero int, null_c int, unk_c int);

insert into num_t values (1, 0, NULL, UNKNOWN);

select 1 from num_t where one<>0 IS TRUE;
select 1 from num_t where one<>0 IS FALSE;
select 1 from num_t where one<>0 IS UNKNOWN;
select 1 from num_t where zero<>0 IS TRUE;
select 1 from num_t where zero<>0 IS FALSE;
select 1 from num_t where zero<>0 IS UNKNOWN;
select 1 from num_t where null_c<>0 IS TRUE;
select 1 from num_t where null_c<>0 IS FALSE;
select 1 from num_t where null_c<>0 IS UNKNOWN;
select 1 from num_t where unk_c<>0 IS TRUE;
select 1 from num_t where unk_c<>0 IS FALSE;
select 1 from num_t where unk_c<>0 IS UNKNOWN;

select 1 from num_t where not(one<>0 IS TRUE);

drop table num_t;
