--+ holdcas on;
set names utf8;
-- table name
create table テストテーブル(s1 char(200));

-- column
alter table テストテーブル add column i_の行1 int;

-- trigger
create trigger トリガ before update on テストテーブル execute update テストテーブル set i_の行1 = 0;

-- constraint
alter table テストテーブル add constraint i_の行1_i_u unique index (i_の行1);

desc テストテーブル;
show index in テストテーブル;

drop trigger トリガ;

alter table テストテーブル drop constraint i_の行1_i_u;

alter table テストテーブル drop column i_の行1;

drop table テストテーブル;



create table テーブル (の行 int);

alter table テーブル add column の行1 int;

create trigger トリガ before update on テーブル execute update テーブル set の行 = 0;

alter table テーブル add constraint 制約1 unique index (の行);
alter table テーブル add constraint 制約2 unique index (の行1);

desc テーブル;
show index in テーブル;

drop trigger トリガ;

alter table テーブル drop constraint 制約1;
alter table テーブル drop constraint 制約2;

alter table テーブル drop column の行;
alter table テーブル drop column の行1;
drop table テーブル;
set names iso88591;
commit;
--+ holdcas off;

