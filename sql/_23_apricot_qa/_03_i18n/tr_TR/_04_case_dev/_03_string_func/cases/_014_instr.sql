--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20)  collate utf8_tr_cs);
insert into test_tr values (1,'Gülen');
insert into test_tr values (2,'Ğüler'); 
insert into test_tr values (3,'İzgi');
insert into test_tr values (103,'Izgi');
insert into test_tr values (203,'İzgı');
insert into test_tr values (303,'İzgı.iZZETtin');
insert into test_tr values (403,'İzgi İxxettin');
insert into test_tr values (4,'İzgü');
insert into test_tr values (104,'İzğü');
insert into test_tr values (5,'İzzettin'); 
insert into test_tr values (105,'İwwettin');
insert into test_tr values (205,'İqqettin'); 
insert into test_tr values (6,'SevINÇ');
insert into test_tr values (106,'%Sevinç'); 
insert into test_tr values (7,'Şükran');
insert into test_tr values (107,'_şÜKran');
insert into test_tr values (8,'İzğü');
insert into test_tr values (9,'İlhan');
insert into test_tr values (109,'?İlhan');
insert into test_tr values (10,'İzgÖ');
insert into test_tr values (110,'*İzgö');

select id, name, instr (name,'ü',1) from test_tr order by 1;

select id, name, instr (name,'u',1) from test_tr order by 1;

select id, name, instr (name,'gı.i',2) from test_tr order by 1;

select id, name, instr (name,'şÜ') from test_tr order by 1;

drop table test_tr;


select instr ('Gülen','e',1);

select instr ('Gülen','e',2);

select instr ('Gülen','e',3);

select instr ('İzgı.iZZETtin','gı.i',1);

select instr ('İzgı.iZZETtin','gı.i',2);

select instr ('İzgı.iZZETtin','gı.i',3);

select instr ('İzgı.iZZETtin','gı.i',4);

select instr ('Gülen','ü',-1);

select instr ('Gülen','ü',-4);

select instr ('Gülen','ü',-5);

select instr ('İzgı.iZZETtin','gı.i',-1);

select instr ('İzgı.iZZETtin','gı.i',-8);

select instr ('İzgı.iZZETtin','gı.i',-9);
set names iso88591;
commit;
--+ holdcas off;


