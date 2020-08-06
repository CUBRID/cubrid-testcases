--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s char(20) collate utf8_en_ci);

insert into t values (1,'Áa_áa__Eá_EaÁa_áa__E');
insert into t values (2,'__áE_Á _a_AÁ_Áx___áE');
insert into t values (3,'xáE_áa_A_Á_ExáE_áa_A');
insert into t values (4,'Eá_aÁ_E_ÁEá_aÁ_E_Á  ');
insert into t values (5,'Eá_A_aÁ_E_ÁEá_A_aÁ_E');

select i,s, locate ('Áa',s,1) from t order by 1;
select i,s, locate ('Áa',s,11) from t order by 1;

select i,s, locate ('áa',s,1) from t order by 1;
select i,s, locate ('áa',s,11) from t order by 1;

select i,s, locate ('Á',s,1) from t order by 1;
select i,s, locate ('Á',s,11) from t order by 1;

select i,s, locate ('Á ',s,1) from t order by 1;
select i,s, locate ('Á ',s,11) from t order by 1;

select i,s, locate ('A',s,1) from t order by 1;
select i,s, locate ('A',s,11) from t order by 1;

select i,s, locate ('AÁ',s,1) from t order by 1;
select i,s, locate ('AÁ',s,11) from t order by 1;


select i,s, locate ('Eá',s,1) from t order by 1;
select i,s, locate ('Eá',s,11) from t order by 1;

select i,s, locate ('áe',s,1) from t order by 1;
select i,s, locate ('áe',s,11) from t order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
