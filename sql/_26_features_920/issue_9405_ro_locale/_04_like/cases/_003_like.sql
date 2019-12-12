--+ holdcas on;
set names utf8;
create table source(c char(20) collate utf8_ro_cs, v varchar(20) collate utf8_ro_cs);
create table pattern(c char(20) collate utf8_ro_cs, v varchar(20) collate utf8_ro_cs);

insert into source values ('Âarşamba', 'Şubat');
insert into source values ('Salî', 'Şubat');
insert into source values ('Perşembe', 'Şubat');
insert into source values ('Âarşamba', 'Mayîs');
insert into source values ('Salî', 'Mayîs');
insert into source values ('Perşembe', 'Mayîs');
insert into source values ('Âarşamba', 'AŢustos');
insert into source values ('Salî', 'AŢustos');
insert into source values ('Perşembe', 'AŢustos');
insert into source values ('Âarşamba', 'Eylăl');
insert into source values ('Salî', 'Eylăl');
insert into source values ('Perşembe', 'Eylăl');
insert into source values ('Âarşamba', 'Kasîm');
insert into source values ('Salî', 'Kasîm');
insert into source values ('Perşembe', 'Kasîm');
insert into source values ('Âarşamba', 'Aralîk');
insert into source values ('Salî', 'Aralîk');
insert into source values ('Perşembe', 'Aralîk');
insert into source values ('Salî%', 'Aralî%k');

insert into pattern values ('%şamba', '%şamba');
insert into pattern values ('%şembe', '%şembe');
insert into pattern values ('%rş%', '%rş%');
insert into pattern values ('%a%î%', '%a%î%');

select * from source,pattern where source.c like trim(pattern.c) order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v order by 1,2,3,4;
select * from source,pattern where source.v like trim(pattern.c) order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v order by 1,2,3,4;

select * from source,pattern where source.c like trim(pattern.c) escape 'î' order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v escape 'î' order by 1,2,3,4;
select * from source,pattern where source.v like trim(pattern.c) escape 'î' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v escape 'î' order by 1,2,3,4;

select * from source,pattern where source.c like trim(pattern.c) escape 'Â' order by 1,2,3,4;
select * from source,pattern where source.c like trim(pattern.v) escape 'Â' order by 1,2,3,4;
select * from source,pattern where source.v like trim(pattern.c) escape 'Â' order by 1,2,3,4;
select * from source,pattern where source.v like trim(pattern.v) escape 'Â' order by 1,2,3,4;

drop source;
drop pattern;
set names iso88591;
commit;
--+ holdcas off;
