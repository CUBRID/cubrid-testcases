--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s char(10) collate utf8_gen_ci);

insert into t values (1,'Áa_áa__Eá_');
insert into t values (2,'__áE_Á _a_');
insert into t values (3,'háE_áa_A_Á');
insert into t values (4,'Eá_aÁ_E_Á ');
insert into t values (5,'Eá_A_aÁ_E_');

select i, s, locate ('Áa', s, 1) from t order by 1;
select i, s, locate ('Áa', s, 2) from t order by 1;

select i, s, locate ('áa', s, 1) from t order by 1;
select i, s, locate ('áa', s, 4) from t order by 1;

select i, s, locate ('Á', s, 1) from t order by 1;
select i, s, locate ('Á', s, 10) from t order by 1;

select i, s, locate ('Á ', s, 1) from t order by 1;
select i, s, locate ('Á ', s, 4) from t order by 1;

select i, s, locate ('A', s, 1) from t order by 1;
select i, s, locate ('A', s, 8) from t order by 1;

select i, s, locate ('AÁ', s, 1) from t order by 1;

select i, s, locate ('Eá', s, 1) from t order by 1;
select i, s, locate ('Eá', s, 10) from t order by 1;

select i, s, locate ('áe', s, 1) from t order by 1;
select i, s, locate ('áe', s, 10) from t order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
