create table num_t(zero int, one int, null_c int);

insert into num_t values (0, 1, NULL);

select 1 from num_t where zero=0 XOR zero=0;
select 1 from num_t where zero=0 XOR 1=zero;
select 1 from num_t where zero=0 XOR zero=NULL;
select 1 from num_t where zero=0 XOR 2=zero;
select 1 from num_t where zero=0 XOR 'a'=zero;
select 1 from num_t where one=0 XOR zero=0;
select 1 from num_t where one=0 XOR one=1;
select 1 from num_t where one=0 XOR null_c IS NULL;
select 1 from num_t where one=0 XOR 2=one;
select 1 from num_t where one=0 XOR 'a'=one;
select 1 from num_t where null_c=0 XOR zero IS NULL;
select 1 from num_t where null_c=0 XOR one IS NULL;
select 1 from num_t where null_c=0 XOR null_c IS NULL;
select 1 from num_t where null_c=0 XOR 2 IS NULL;
select 1 from num_t where null_c=0 XOR 'a' IS NULL;
select 1 from num_t where 2=zero XOR 0=one;
select 1 from num_t where 2=zero XOR 1=one;
select 1 from num_t where 2=zero XOR null_c IS NULL;
select 1 from num_t where 2=zero XOR 2=one;
select 1 from num_t where 2=zero XOR 'a'=one;
select 1 from num_t where 'a'=zero XOR 0=one;
select 1 from num_t where 'a'=zero XOR 1=one;
select 1 from num_t where 'a'=zero XOR null_c IS NULL;
select 1 from num_t where 'a'=zero XOR 2=one;
select 1 from num_t where 'a'=zero XOR 'a'=one;
select 1 from num_t where 'a'=zero XOR 'a'=one;
select 1 from num_t where 1234567890123456=zero XOR 1234567890=one;

drop table num_t;
