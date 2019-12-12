set names utf8;
drop table if exists t;
create table t (i int, s string collate utf8_fr_exp_ab);
insert into t values (1,'cote ');
insert into t values (2,'coté');
insert into t values (3,'côte ');
insert into t values (4,'côté');

select * from t order by s;
select * from t order by cast (s as string collate utf8_not_exist);
drop table t;

set names iso88591;