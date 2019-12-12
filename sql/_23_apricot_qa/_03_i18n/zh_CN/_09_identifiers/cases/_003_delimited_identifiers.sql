--+ holdcas on;
set names utf8;
create table "测试表" ( `i_列1` int , [a_列2] int);

desc 测试表;

drop table `测试表`;
set names iso88591;
commit;
--+ holdcas off;