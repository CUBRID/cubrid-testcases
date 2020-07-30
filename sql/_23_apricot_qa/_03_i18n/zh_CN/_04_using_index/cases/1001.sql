--+ holdcas on;
set names utf8;
drop table if exists test_cn;
CREATE TABLE test_cn ( 
  id     int    NOT NULL, 
  name      VARCHAR(50) collate utf8_gen);
  
insert into test_cn values (1,'菠菜萝卜红薯土豆番茄');
insert into test_cn values (2,'菠菜萝卜红薯土豆西红柿'); 
insert into test_cn values (3,'茼蒿芹菜菠菜辣椒');
insert into test_cn values (103,'茼蒿芹菜菠菜辣椒');
insert into test_cn values (203,'茼蒿芹菜菠菜莲蓬');
insert into test_cn values (303,'茼蒿芹菜菠菜莲蓬.茼蒿芹菜芹菜土豆紫薯芸豆茼蒿番茄');
insert into test_cn values (403,'茼蒿芹菜菠菜辣椒 莲蓬谢谢土豆紫薯紫薯茼蒿番茄');
insert into test_cn values (4,'茼蒿芹菜豆芽萝卜');
insert into test_cn values (104,'莲蓬芹菜豆芽萝卜');
insert into test_cn values (5,'茼蒿芹菜芹菜土豆紫薯芸豆茼蒿番茄'); 
insert into test_cn values (105,'莲蓬海苔海苔土豆紫薯紫薯茼蒿番茄');
insert into test_cn values (205,'莲蓬菠菜菠菜土豆紫薯紫薯茼蒿番茄'); 
insert into test_cn values (6,'甜菜萝卜开西红柿卷心菜番茄');
insert into test_cn values (106,'%甜菜萝卜开西红柿卷心菜番茄'); 
insert into test_cn values (7,'甜菜萝卜开西红柿卷心菜番茄');
insert into test_cn values (107,'_甜菜萝卜开西红柿卷心菜番茄');
insert into test_cn values (8,'莲蓬芹菜豆芽萝卜');
insert into test_cn values (9,'茼蒿红薯马铃薯卷心菜番茄');
insert into test_cn values (109,'?茼蒿红薯马铃薯卷心菜番茄');
insert into test_cn values (10,'茼蒿芹菜菠菜茄子');
insert into test_cn values (110,'*茼蒿芹菜菠菜茄子');
create index i_test_cn_name on test_cn (name);


select id,name from test_cn
where
   (name between '茼蒿芹菜菠菜莲蓬' and '茼蒿芹菜豆芽萝卜')
   or (name between '茼蒿芹菜菠菜辣椒' and '茼蒿芹菜豆芽萝卜')
   or (name > '茼蒿芹菜才' and name < '茼蒿芹菜豆芽萝卜')
using index i_test_cn_name(+) order by 2;



drop test_cn;
set names iso88591;
commit;
--+ holdcas off;

