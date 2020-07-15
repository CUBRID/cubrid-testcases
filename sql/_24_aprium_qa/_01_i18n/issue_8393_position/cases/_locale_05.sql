--+ holdcas on;
set names iso88591;
drop table if exists t;
create table t (i int, s char(20) collate iso88591_en_ci);

insert into t values (1,'Ca_ca__Ec_EaCa_ca__E');
insert into t values (2,'__cE_C _a_AC_Ch___cE');
insert into t values (3,'hcE_ca_A_C_EhcE_ca_A');
insert into t values (4,'Ec_aC_E_CEc_aC_E_C  ');
insert into t values (5,'Ec_A_aC_E_CEc_A_aC_E');

select i,s, locate ('Ca',s,1) from t order by 1;
select i,s, locate ('Ca',s,11) from t order by 1;

select i,s, locate ('ca',s,1) from t order by 1;
select i,s, locate ('ca',s,5) from t order by 1;

select i,s, locate ('C',s,1) from t order by 1;

select i,s, locate ('C ',s,1) from t order by 1;

select i,s, locate ('A',s,1) from t order by 1;
select i,s, locate ('A',s,11) from t order by 1;

select i,s, locate ('AC',s,1) from t order by 1;
select i,s, locate ('AC',s,11) from t order by 1;

select i,s, locate ('Ec',s,1) from t order by 1;
select i,s, locate ('Ec',s,11) from t order by 1;

select i,s, locate ('ce',s,1) from t order by 1;
select i,s, locate ('ce',s,11) from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
