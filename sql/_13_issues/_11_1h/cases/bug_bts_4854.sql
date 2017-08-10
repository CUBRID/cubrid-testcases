create table t (i int);

insert into t values (1);
insert into t values (2);
insert into t values (3);
create index i_t_i on t(i);

select min (i) + 1 from t where i>0  using index i_t_i order by i  limit 2;

select max (i) + 1 from t where i>0  using index i_t_i order by i  limit 2;

select sum (i) + 1 from t where i > 0 order by i limit 2;

select avg (i) + 1 from t where i > 0 order by i limit 2;

select stddev_pop (i) + 1 from t where i > 0 order by i limit 2;

select stddev_samp (i) + 1 from t where i > 0 order by i limit 2;

select variance (i) + 1 from t where i > 0 order by i limit 2;

select var_samp (i) + 1 from t where i > 0 order by i limit 2;

select var_pop (i) + 1 from t where i > 0 order by i limit 2;

select bit_and (i) + 1 from t where i > 0 order by i limit 2;

select bit_or (i) + 1 from t where i > 0 order by i limit 2;

select bit_xor (i) + 1 from t where i > 0 order by i limit 2;

select count(*) + 1 from t where i>0  using index i_t_i order by i  limit 2;

select count(i) + 1 from t where i>0  using index i_t_i order by i  limit 2;



select min (i) + 1 from t where i>0  using index i_t_i order by i  limit 2;

select max (i) + 1 from t where i>0  using index i_t_i order by i  limit 2;

select sum (i) + 1 from t where i > 0 order by i limit 2;

select avg (i) + 1 from t where i > 0 order by i limit 2;

select stddev_pop (i) + 1 from t where i > 0 order by i limit 2;

select stddev_samp (i) + 1 from t where i > 0 order by i limit 2;

select variance (i) + 1 from t where i > 0 order by i limit 2;

select var_samp (i) + 1 from t where i > 0 order by i limit 2;

select var_pop (i) + 1 from t where i > 0 order by i limit 2;

select bit_and (i) + 1 from t where i > 0 order by i limit 2;

select bit_or (i) + 1 from t where i > 0 order by i limit 2;

select bit_xor (i) + 1 from t where i > 0 order by i limit 2;

select count(*) + 1 from t where i>0  using index i_t_i order by i  limit 2;

select count(i) + 1 from t where i>0  using index i_t_i order by i  limit 2;

select repeat (concat ('result of min (i) + 1 is ', min (i) + 1, ' '), 3) from t where i>0  using index i_t_i order by i  limit 2;

select repeat (concat ('result of max (i) + 1 is ', max (i) + 1, ' '), 3) from t where i>0  using index i_t_i order by i  limit 2;

select repeat (concat ('result of sum (i) + 1 is ', sum (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of avg (i) + 1 is ', avg (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of stddev_pop (i) + 1 is ', stddev_pop (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of stddev_samp (i) + 1 is ', stddev_samp (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of variance (i) + 1 is ', variance (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of var_samp (i) + 1 is ', var_samp (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of var_pop (i) + 1 is ', var_pop (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of bit_and (i) + 1 is ', bit_and (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of bit_or (i) + 1 is ', bit_or (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of bit_xor (i) + 1 is ', bit_xor (i) + 1, ' '), 3) from t where i > 0 order by i limit 2;

select repeat (concat ('result of count(*) + 1 is ', count(*) + 1, ' '), 3) from t where i>0  using index i_t_i order by i  limit 2;

select repeat (concat ('result of count(i) + 1 is ', count(i) + 1, ' '), 3) from t where i>0  using index i_t_i order by i  limit 2;

drop table t;