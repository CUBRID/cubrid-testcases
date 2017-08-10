create table longcolumn(id int,col char(50),col1 varchar(50),col2 varchar(50),col3 char(50),col4 varchar(50),col5 char(50),
    col6 varchar(50),col7 char(50),col8 varchar(50),col9 char(50),col10 varchar(50),col11 char(50),col12 varchar(50),col13 char(50),
    col14 varchar(50),col15 char(50),col16 varchar(50),col17 char(50),col18 varchar(50),col19 char(50),col20 varchar(50),col21 char(50),
    col22 varchar(50),col23 char(50),col24 varchar(50),col25 char(50),col26 varchar(50),col27 char(50),col28 varchar(50),col29 char(50),col30 varchar(50));

insert into longcolumn select rownum,rownum+2,rownum-4,rownum+10,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30 from db_class a,db_class b,db_class c limit 10000;
create index i_longcolum_col on longcolumn(col);
create index i_longcolum_id on longcolumn(id);

create table normal(id int,col char(50));
insert into normal select rownum-9,rownum+20 from db_class a,db_class b,db_class c limit 1000;
select count(*) from longcolumn;
select max(normal.col) from longcolumn,normal where longcolumn.id=normal.id group by longcolumn.col4;
drop table longcolumn;
drop table normal;
