--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s string collate utf8_de_exp_ai_ci);

insert into t values (1,'Ae_oE_Ue _ß_Ae_oE_Ue _ß');
insert into t values (2,'AE_OE_UE_SS_AE_OE_UE_SS');
insert into t values (3,'Äx_ö_ü_ss_Äx_ö_ü_ss');
insert into t values (4,'ä_Ö_Ü_ß ä_Ö_Ü_ß ');

select i,s,locate ('ae', s, 1) from t order by 1;
select i,s,locate ('AE',s, 4) from t order by 1;
select i,s,locate ('ä',s, 0) from t order by 1;
                   
select i,s,locate ('Oe',s, 1) from t order by 1;
select i,s,locate ('Ö',s, 2) from t order by 1;
                   
select i,s,locate ('ue',s, 1) from t order by 1;
select i,s,locate ('ü ',s, 8) from t order by 1;
                   
select i,s,locate ('ß',s, 1) from t order by 1;
select i,s,locate ('ß',s, 6) from t order by 1;
                   
select i,s,locate ('SS ',s, 1) from t order by 1;
select i,s,locate ('Ss',s, 6) from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
