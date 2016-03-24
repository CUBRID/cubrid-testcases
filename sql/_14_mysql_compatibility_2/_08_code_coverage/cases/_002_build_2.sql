--+ holdcas on;
-- code coverage addon for pt_is_const_expr_node() in parse_tree_cl.c

create table t (i int, j int, s string);
insert into t values (1,2,'vlad'), (3,4,'arad'), (5,6,NULL) ;

select * from t where s < insert (s,1,1,'e');
select * from t where substring_index(s,'a',1) > 'e';

-- type checking, pt_upd_domain_info, case PT_SPACE, case PT_TYPE_BIGINT
select space(12345678901234) from t;


-- query graph, cost of ELT function: get_expr_fcode_rank()
--select * from t where elt(2,i,j) = '4';
select * from t where elt(1,elt(2,i,j)+'a') = '4a';

-- check_att_chg_allowed()
alter table t change column i will_be_rejected double;

drop table t;


-- type checking, pt_character_length_for_node, cover

create table t1 (m monetary, bi bigint, si smallint, t time, dt datetime, n0 numeric(1,0), n numeric, vnc nchar varying, c varchar(10));
insert into t1 values (1,2,3, '11:21', '2010-01-01', 6, 7, N'vlad', 'tralala');
select elt(6,m,bi,si,t,dt,n0,n, vnc, NULL) from t1;
select elt(1,c, vnc) from t1;

$varchar, $abecedar
select elt(9,m,bi,si,t,dt,n0,n, NULL, ?) from t1;

$float, $23.1
select cast(elt(9,m,bi,si,t,dt,n0,n, NULL, ?) as integer) from t1;

select elt(6,m,bi,si,t,dt,n0,n, vnc, NULL, N'qwerty') from t1;

drop table t1;




-- LIKE wildcard match backtracking
drop table if exists tbl;
create table tbl (c varchar(22));
insert tbl values ('aaabaaabaaab');
insert tbl values ('___%___%___%');
select * from tbl where c like 'a%a%b%a%a%b';
select * from tbl where c like 'x_%x_%x%%x_%x_%x%' escape 'x';
drop table tbl;



-- prm_get_next_param_value
-- set system parameters ' default_week_format = 3  ;  compat_mode =  invalid_compat_mode';
set system parameters 'default_week_format';
set system parameters 'default_week_format ';
set system parameters 'default_week_format =';
set system parameters 'default_week_format = ';
set system parameters 'default_week_format = "3';
set system parameters 'default_week_format="\3';
set system parameters 'default_week_format="\\3';
-- set system parameters ' default_week_format = 3  ;  compat_mode ';
-- sysprm_prm_change_should_clear_cache 
set system parameters 'dwf=0';

-- back to defaults
set system parameters 'default_week_format=0';
set system parameters 'compat_mode=cubrid';





create table t (d date, dt datetime, t time, ts timestamp, i int, s string);
insert into t values ('2010-08-27', '2010-08-27 09:00', '11:21', '2007-12-04 23:00', 734395, '1983-07-23 10:23');
insert into t values ('2010-08-27', '2010-08-27 09:00', '11:21', '2007-12-04 23:00', 2000, 'invalid date string here');
insert into t values (null, null, null, null, null, null);


set system parameters 'return_null_on_function_errors = yes';
select dayofyear(d), dayofyear(dt), dayofyear(ts), dayofyear(s) from t order by 1,2,3,4;
select dayofweek(d), dayofweek(dt), dayofweek(ts), dayofweek(s) from t order by 1,2,3,4;
select quarter(d), quarter(dt), quarter(ts), quarter(s) from t order by 1,2,3,4;
select to_days(d), to_days(dt), to_days(ts), to_days(s) from t order by 1,2,3,4;
select from_days(i) from t order by 1;
select makedate(i,10) from t order by 1;

$varchar, $invalid_date
select time_to_sec(?) as rez;

$smallint, $204
select makedate(2010,?);



set system parameters 'return_null_on_function_errors = no';
select dayofyear(d), dayofyear(dt), dayofyear(ts), dayofyear(s) from t;
select dayofweek(d), dayofweek(dt), dayofweek(ts), dayofweek(s) from t;
select quarter(d), quarter(dt), quarter(ts), quarter(s) from t;
select to_days(d), to_days(dt), to_days(ts), to_days(s) from t;
select from_days(i) from t order by 1;
select makedate(i,10) from t;

$varchar, $invalid_date
select time_to_sec(?) as rez;




drop table t;





-- fetch.c, getch_peek_arith, case T_WEEK, fetching the right arg
select week('2010-12-12', 'invalid');
-- same for T_MAKETIME
select maketime(1,'invalid',3);
select maketime(1,2,'invalid');


commit;
--+ holdcas off;
