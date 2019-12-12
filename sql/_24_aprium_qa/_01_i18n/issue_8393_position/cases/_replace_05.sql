--+ holdcas on;
set names iso88591;
drop table if exists t;
create table t (i int, s char(20) collate iso88591_en_ci);

insert into t values (1,'Ca_ca__Ec_Ea');
insert into t values (2,'__cE_C _a_AC_Ch_');
insert into t values (3,'hcE_ca_A_C_E');
insert into t values (4,'Ec_aC_E_C');
insert into t values (5,'Ec_A_aC_E_C');

select i,s, replace (s,'Ca','Xy') from t order by 1;
select i,s, replace (s,'ca','xy') from t order by 1;
select i,s, replace (s,'C','X') from t order by 1;
select i,s, replace (s,'C ','X=') from t order by 1;
select i,s, replace (s,'A','X') from t order by 1;
select i,s, replace (s,'AC','XY') from t order by 1;
select i,s, replace (s,'Ec','Xy') from t order by 1;
select i,s, replace (s,'ce','xy') from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
