drop table if exists TC;
create table TC (
 A VARCHAR(6) NOT NULL ,
 B INT   NOT NULL );

insert into TC values ('200605',1);
insert into TC values ('200302',0);

SELECT DISTINCT A FROM TC START WITH B = 1 CONNECT BY B = 0 order by 1;

drop table if exists TC;