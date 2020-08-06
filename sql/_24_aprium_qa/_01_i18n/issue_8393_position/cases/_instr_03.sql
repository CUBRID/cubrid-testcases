--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s char(10) collate utf8_gen_ci);

insert into t values (1,'Áa_áa__Eá_');
insert into t values (2,'__áE_Á _a_');
insert into t values (3,'háE_áa_A_Á');
insert into t values (4,'Eá_aÁ_E_Á ');
insert into t values (5,'Eá_A_aÁ_E_');

select i, s, instr (s,'Áa', 1) from t order by 1;
select i, s, instr (s,'Áa', -1) from t order by 1;

select i, s, instr (s,'áa', 1) from t order by 1;
select i, s, instr (s,'áa', -1) from t order by 1;

select i, s, instr (s,'Á', 1) from t order by 1;
select i, s, instr (s,'Á', -1) from t order by 1;

select i, s, instr (s,'Á ', 1) from t order by 1;
select i, s, instr (s,'Á ', -1) from t order by 1;

select i, s, instr (s,'A', 1) from t order by 1;
select i, s, instr (s,'A', -1) from t order by 1;

select i, s, instr (s,'AÁ', 1) from t order by 1;
select i, s, instr (s,'AÁ', -1) from t order by 1;

select i, s, instr (s,'Eá', 1) from t order by 1;
select i, s, instr (s,'Eá', -1) from t order by 1;

select i, s, instr (s,'áe', 1) from t order by 1;
select i, s, instr (s,'áe', -1) from t order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
