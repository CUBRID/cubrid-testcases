--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s string collate utf8_de_exp_ai_ci);

insert into t values (1,'Ae,oE,Ue ,ß');
insert into t values (2,'AE,OE,UE,SS');
insert into t values (3,'Äx,ö,ü,ss');
insert into t values (4,'ä,Ö,Ü,ß ');

select i, s, find_in_set ('ae',s) from t order by 1;
select i, s, find_in_set ('aex',s) from t order by 1;
select i, s, find_in_set ('ä',s) from t order by 1;

select i, s, find_in_set ('Oe',s) from t order by 1;
select i, s, find_in_set ('Ö',s) from t order by 1;

select i, s, find_in_set ('ue',s) from t order by 1;
select i, s, find_in_set ('ü ',s) from t order by 1;


select i, s, find_in_set ('ß',s) from t order by 1;

select i, s, find_in_set ('SS ',s) from t order by 1;
select i, s, find_in_set ('Ss',s) from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
