set names utf8;

drop table if exists t1;
create table t1(id int,s string collate utf8_fr_exp_ab);
insert into t1 values(1,'xcôté'),(2,'xcôtê');
select * from t1 where s like '_côté';
select replace(s,'é','e') from t1 order by 1;
alter table t1 change column s s string collate utf8_de_exp;
select * from t1 where s like '_côté';

drop t1;
create table t1(id int,s string) collate utf8_fr_exp_ab;
insert into t1 values(1,'xcôté'),(2,'xcôtê'),(3,'xcôtée'),(4,'xcôtêe');
select * from t1 where s like '_côtée';
select replace(s,'é','e') from t1 order by 1;

alter table t1 change column s s string collate utf8_gen_ai_ci;
select * from t1 where s like '_côtée' collate utf8_fr_exp_ab;
select replace(s collate utf8_fr_exp_ab,'é' collate utf8_fr_exp_ab,'e' collate utf8_fr_exp_ab) from t1 order by 1;
select replace(s,'é','e') collate utf8_fr_exp_ab from t1 order by 1;

drop t1;
set names iso88591;
