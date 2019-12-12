--+ holdcas on;
set names utf8;
Create table 가댁체힐你好(체힐 int,가댁 varchar(200) SHARED'가댁체힐你好', S#댁 varchar(200) default'hello가댁체힐你好');
insert into 가댁체힐你好(체힐)values(1),(2);
SELECT * FROM 가댁체힐你好 order by 1;
insert into 가댁체힐你好(체힐,가댁)values(3,'SS댁체힐你好');
insert into 가댁체힐你好(체힐)values(4),(5);
ALTER TABLE 가댁체힐你好 CHANGE S#댁  S#댁 varchar(200) default'가댁체힐你好'
SELECT * FROM 가댁체힐你好 order by 1;
insert into 가댁체힐你好(체힐)values(7);
SELECT * FROM 가댁체힐你好 order by 1;
drop table 가댁체힐你好;
set names iso88591;
commit;
--+ holdcas off;
