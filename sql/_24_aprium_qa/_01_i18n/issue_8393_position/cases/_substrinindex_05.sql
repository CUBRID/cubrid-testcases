--+ holdcas on;
set names iso88591;
drop table if exists t;
create table t (i int, s char(20) collate iso88591_en_ci);

insert into t values (1,'Ca_ca__Ec_EaCa_ca__E');
insert into t values (2,'__cE_C _a_AC_Ch___cE');
insert into t values (3,'hcE_ca_A_C_EhcE_ca_A');
insert into t values (4,'Ec_aC_E_CEc_aC_E_C');
insert into t values (5,'Ec_A_aC_E_CEc_A_aC_E');

select i,s, substring_index (s,'Ca',1) from t order by 1;
select i,s, substring_index (s,'Ca',-1) from t order by 1;

select i,s, substring_index (s,'ca',1) from t order by 1;
select i,s, substring_index (s,'ca',-1) from t order by 1;

select i,s, substring_index (s,'C',2) from t order by 1;
select i,s, substring_index (s,'C',-2) from t order by 1;

select i,s, substring_index (s,'C ',1) from t order by 1;
select i,s, substring_index (s,'C ',-1) from t order by 1;

select i,s, substring_index (s,'A',3) from t order by 1;
select i,s, substring_index (s,'A',-2) from t order by 1;

select i,s, substring_index (s,'AC',1) from t order by 1;
select i,s, substring_index (s,'AC',-1) from t order by 1;

select i,s, substring_index (s,'Ec',1) from t order by 1;
select i,s, substring_index (s,'Ec',-1) from t order by 1;

select i,s, substring_index (s,'ce',1) from t order by 1;
select i,s, substring_index (s,'ce',-1) from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
