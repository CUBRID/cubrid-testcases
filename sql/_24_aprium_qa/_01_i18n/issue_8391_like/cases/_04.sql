--+ holdcas on;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

set names utf8;
drop table if exists t;
create table t (i int, s char(10) collate utf8_gen_ai_ci);

insert into t values (1,'Áxx');
insert into t values (2,'áExx');
insert into t values (3,'xÁxx');
insert into t values (4,'xáExx');
insert into t values (5,'xÁ');
insert into t values (6,'xá');
insert into t values (7,'Á');
insert into t values (8,'xá%Exx');
insert into t values (9,'xa%Exx');
insert into t values (10,'xÅ%Exx');


select * from t where s like 'á%' order by 1;
select * from t where s like 'Á_%' order by 1;

select * from t where s like '_á%' order by 1;
select * from t where s like '_%á%' order by 1;

select * from t where s like '_Á_%' order by 1;
select * from t where s like '_Á%_' order by 1;

select * from t where s like '_Áá%_' escape 'Á' order by 1;

select * from t where s like 'x%Áá%x_%' escape 'Á' order by 1;

select * from t where s like 'x%Á%%_' escape 'Á' order by 1;

drop table t;
set names iso88591;

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

commit;
--+ holdcas off;
