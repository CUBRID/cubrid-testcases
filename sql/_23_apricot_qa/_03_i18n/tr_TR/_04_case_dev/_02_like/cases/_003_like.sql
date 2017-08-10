--+ holdcas on;
set names utf8;
create table source(c char(20) collate utf8_tr_cs_uca, v varchar(20) collate utf8_tr_cs_uca);
create table pattern(c char(20) collate utf8_tr_cs_uca, v varchar(20) collate utf8_tr_cs_uca);

insert into source values ('Çarşamba', 'Şubat');
insert into source values ('Salı', 'Şubat');
insert into source values ('Perşembe', 'Şubat');
insert into source values ('Çarşamba', 'Mayıs');
insert into source values ('Salı', 'Mayıs');
insert into source values ('Perşembe', 'Mayıs');
insert into source values ('Çarşamba', 'Ağustos');
insert into source values ('Salı', 'Ağustos');
insert into source values ('Perşembe', 'Ağustos');
insert into source values ('Çarşamba', 'Eylül');
insert into source values ('Salı', 'Eylül');
insert into source values ('Perşembe', 'Eylül');
insert into source values ('Çarşamba', 'Kasım');
insert into source values ('Salı', 'Kasım');
insert into source values ('Perşembe', 'Kasım');
insert into source values ('Çarşamba', 'Aralık');
insert into source values ('Salı', 'Aralık');
insert into source values ('Perşembe', 'Aralık');
insert into source values ('Salı%', 'Aralı%k');

insert into pattern values ('%şamba', '%şamba');
insert into pattern values ('%şembe', '%şembe');
insert into pattern values ('%rş%', '%rş%');
insert into pattern values ('%a%ı%', '%a%ı%');

select * from source,pattern where source.c like pattern.c order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v order by 1,2,3,4;
select * from source,pattern where source.v like pattern.c order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v order by 1,2,3,4;

select * from source,pattern where source.c like pattern.c escape 'ı' order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v escape 'ı' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.c escape 'ı' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v escape 'ı' order by 1,2,3,4;

select * from source,pattern where source.c like pattern.c escape 'Ç' order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v escape 'Ç' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.c escape 'Ç' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v escape 'Ç' order by 1,2,3,4;

drop source;
drop pattern;
set names iso88591;
commit;
--+ holdcas off;
