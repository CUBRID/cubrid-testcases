set system parameters 'create_table_reuseoid=no';
-- tests a insert data into class syntax using function of '05/26/2008' 

create class xoo ( a int, c date );
create class yoo ( a int, b string, c xoo );
create class zoo ( a int, b string, c date, d yoo);
insert into yoo values(1, 'xxx', insert into xoo values(1, '05/26/2008'));             
insert into yoo values(2, 'xxx', (select xoo from xoo));                          
insert into zoo values(1, 'yyy', '12/28/2002', (select yoo from yoo where rownum  = 1));
insert into zoo values(1, 'yyy', '05/26/2008', (select yoo from yoo where rownum = 1));

select a from xoo;
select a,b from yoo;
select a,b, d from zoo;


drop xoo;
drop yoo;
drop zoo;
set system parameters 'create_table_reuseoid=yes';
