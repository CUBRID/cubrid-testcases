--+ holdcas on;
set names utf8;
create table source(c char(20) collate utf8_gen, v varchar(20) collate utf8_gen);
create table pattern(c char(20) collate utf8_gen, v varchar(20) collate utf8_gen);

insert into source values ('山水草木云', '雨水虹');
insert into source values ('雨水霜雪', '雨水虹');
insert into source values ('金木水木土', '雨水虹');
insert into source values ('山水草木云', '风雪山');
insert into source values ('雨水霜雪', '风雪山');
insert into source values ('金木水木土', '风雪山');
insert into source values ('山水草木云', '风雷电');
insert into source values ('雨水霜雪', '风雷电');
insert into source values ('金木水木土', '风雷电');
insert into source values ('山水草木云', '平行');
insert into source values ('雨水霜雪', '平行');
insert into source values ('金木水木土', '平行');
insert into source values ('山水雷电水汤泉水', '观看水风雪山');
insert into source values ('雨水霜雪', '观看水风雪山');
insert into source values ('金木水木土', '观看水风雪山');
insert into source values ('山水雷电水汤泉水', '清水白雪雾');
insert into source values ('雨水霜雪', '清水白雪雾');
insert into source values ('金木水木土', '清水白雪雾');
insert into source values ('雨水霜雪%', '清水白雪%雾');

insert into pattern values ('%木云', '%木云');
insert into pattern values ('%木水木土', '%木水木土');
insert into pattern values ('%雷电%', '%雷电%');
insert into pattern values ('%水%雪%', '%水%雪%');

select * from source,pattern where source.c like pattern.c order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v order by 1,2,3,4;
select * from source,pattern where source.v like pattern.c order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v order by 1,2,3,4;

select * from source,pattern where source.c like pattern.c escape '雪' order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v escape '雪' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.c escape '雪' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v escape '雪' order by 1,2,3,4;

select * from source,pattern where source.c like pattern.c escape '山' order by 1,2,3,4;
select * from source,pattern where source.c like pattern.v escape '山' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.c escape '山' order by 1,2,3,4;
select * from source,pattern where source.v like pattern.v escape '山' order by 1,2,3,4;

drop source;
drop pattern;
set names iso88591;
commit;
--+ holdcas off;
