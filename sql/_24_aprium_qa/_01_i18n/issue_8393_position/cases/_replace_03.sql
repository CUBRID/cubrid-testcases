--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s char(10) collate utf8_gen_ci);

insert into t values (1,'Áa_áa__Eá_');
insert into t values (2,'__áE_Á _a_');
insert into t values (3,'háE_áa_A_Á');
insert into t values (4,'Eá_aÁ_E_Á');
insert into t values (5,'Eá_A_aÁ_E_');

select i, s, replace (s,'Áa', 'Xx') from t order by 1;
select i, s, replace (s,'áa', 'xx') from t order by 1;
select i, s, replace (s,'Á', 'X') from t order by 1;
select i, s, replace (s,'Á ', 'X+') from t order by 1;
select i, s, replace (s,'A', 'X') from t order by 1;
select i, s, replace (s,'AÁ', 'XX') from t order by 1;
select i, s, replace (s,'Eá', 'Xy') from t order by 1;
select i, s, replace (s,'áe', 'xy') from t order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
