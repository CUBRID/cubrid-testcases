set names utf8;
drop table if exists t;

create table t(id smallint auto_increment, s enum('天','납','ê') collate utf8_gen_ai_ci);
insert into t(s) values(1),(2),(3);
create view v as select s from t where s collate utf8_de_exp > 'j';

select s from v where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs_uca;

WITH cte_R5La5QeiV AS
(
select s from v where s collate utf8_de_exp > 'j' order by s collate utf8_ko_cs_uca
)
select * from cte_R5La5QeiV;

select s from v where s collate utf8_de_exp > 'j' order by 1;
WITH cte_R5La5QeiV1 AS
(
select s from v where s collate utf8_de_exp > 'j' order by 1
)
select * from cte_R5La5QeiV1;

WITH cte AS
(
select s from v where s collate utf8_de_exp > 'j' order by s collate utf8_gen_ci
)
select * from cte;


WITH cte1 AS
(
select s from v where s collate utf8_de_exp > 'j' order by s collate utf8_gen_ci 
)
select * from cte1;


set names utf8;
drop table if exists t;
drop view v;

create table t(id smallint auto_increment, s enum('c','b','a'));
insert into t(s) values(1),(2),(3);
create view v as select s from t;
select id, s from t order by s collate iso88591_bin;
select * from (select s from t order by s collate iso88591_bin); 
WITH cte_R5La5QeiV AS
(
select s from t order by s collate iso88591_bin
)
select * from cte_R5La5QeiV;

set names iso88591;

drop view v;
drop table if exists t;

