--TEST: [I18n] charset conversion is not performed when converting string to enum type


drop table if exists t1;

create table t1 (i int, e1 enum('A', 'B') collate utf8_bin, e2 enum('a', 'b') collate euckr_bin, e3 enum('A', 'b') collate iso88591_en_cs);

insert into t1(i, e1) values (1, _euckr'A'); 
insert into t1(i, e1) values (1, _iso88591'A'); 
insert into t1(i, e1) values (1, 'B' collate utf8_en_cs); 

insert into t1(i, e2) values (2, _utf8'a'); 
insert into t1(i, e2) values (2, _iso88591'b'); 
insert into t1(i, e2) values (2, 'a' collate utf8_en_cs); 

insert into t1(i, e3) values (3, _utf8'A'); 
insert into t1(i, e3) values (3, _euckr'b'); 
insert into t1(i, e3) values (3, 'b' collate iso88591_en_ci); 
insert into t1(i, e3) values (3, 'a'); 
insert into t1(i, e3) values (3, 'a' collate utf8_bin); 

insert into t1(i, e1) values(4, _euckr'1');
insert into t1(i, e1) values(4, _iso88591'2');
insert into t1(i, e3) values (4, '2' collate iso88591_en_ci);


select * from t1 order by 1, 2, 3, 4;


drop table t1;


