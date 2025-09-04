--+ holdcas on;
set names utf8;
create table "テストテーブル" ( `i_の行1` int , [a_の行2] int);

desc テストテーブル;

drop table `テストテーブル`;
set names utf8;
commit;
--+ holdcas off;
