-- D-316-2 / D-317-20: mixed comparison decisions must be observable before domain planning.
-- Future domain-planning commits change the observed-decision expectation to 0.
create table domain_counter_t (i int);
insert into domain_counter_t values (1), (2), (3);
set @collect_exec_stats=0;
set @collect_exec_stats=1;
$double, $1.5;
select /*+ NO_PARALLEL_SCAN */ count(*) as n from domain_counter_t where i > ? using index none;
set @collect_exec_stats=0;
select if(exec_stats('Num_domain_coerce_compare') > 0, 1, 0) as observed_decision;
-- Reading clears this individual counter; stopped collection prevents self-measurement.
select exec_stats('Num_domain_coerce_compare') as after_read;
select exec_stats('Num_domain_gate_convert') as gate_converts,
       exec_stats('Num_planned_convert') as planned_converts,
       exec_stats('Num_domain_bind_plan_mismatch') as bind_plan_mismatch;
drop table domain_counter_t;
