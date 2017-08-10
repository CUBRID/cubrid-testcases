--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s string collate utf8_de_exp_ai_ci);

insert into t values (1,'Ae_oE_Ue _ß');
insert into t values (2,'AE_OE_UE_SS');
insert into t values (3,'Äx_ö_ü_ss');
insert into t values (4,'ä_Ö_Ü_ß ');

select i,s,replace (s, 'ae','xy') from t order by 1;
select i,s,replace (s, 'AE','XY') from t order by 1;
select i,s,replace (s, 'ä','x') from t order by 1;
       
select i,s,replace (s,'Oe','Xy') from t order by 1;
select i,s,replace (s,'Ö','X') from t order by 1;
       
select i,s,replace (s,'ue','xy') from t order by 1;
select i,s,replace (s,'ü ','x=') from t order by 1;
       
select i,s,replace (s,'ß','x') from t order by 1;
       
select i,s,replace (s,'SS ','XX') from t order by 1;
select i,s,replace (s,'Ss','Xx') from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
