create or replace view vx (a) as select 'aaa' from db_root;
select if(attr_name = 'a', 'OK', 'NOK') from db_attribute where class_name='vx';
select if(data_type = 'STRING', 'OK', 'NOK') from db_attribute where class_name='vx';
select if(prec = 3, 'OK', 'NOK') from db_attribute where class_name='vx';
select if(a = 'aaa', 'OK', 'NOK') from vx;

create or replace view vx as select 'aaa' a from db_root;
select if(attr_name = 'a', 'OK', 'NOK') from db_attribute where class_name='vx';
select if(data_type = 'STRING', 'OK', 'NOK') from db_attribute where class_name='vx';
select if(prec = 3, 'OK', 'NOK') from db_attribute where class_name='vx';
select if(a = 'aaa', 'OK', 'NOK') from vx;

create or replace view vx as select 1 + 1 a from db_root;
select if(attr_name = 'a', 'OK', 'NOK') from db_attribute where class_name='vx';
select if(data_type = 'INTEGER', 'OK', 'NOK') from db_attribute where class_name='vx';
select if(a = 2, 'OK', 'NOK') from vx;

create or replace view vx as select PI() [int] from db_root;
select if(attr_name = 'int', 'OK', 'NOK') from db_attribute where class_name='vx';
select if(data_type = 'DOUBLE', 'OK', 'NOK') from db_attribute where class_name='vx';
select if([int] = PI(), 'OK', 'NOK') from vx;

create table tbl1 (a int, b float, c bigint, d date, e timestamp, f datetime, g char(10), h varchar(30));
create or replace view vx as select * from tbl1;
select if(data_type = 'INTEGER', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(data_type = 'FLOAT', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'b';
select if(data_type = 'BIGINT', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'c';
select if(data_type = 'DATE', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'd';
select if(data_type = 'TIMESTAMP', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'e';
select if(data_type = 'DATETIME', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'f';
select if(data_type = 'CHAR', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'g';
select if(data_type = 'STRING', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'h';
select if(prec = 10, 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'g';
select if(prec = 30, 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'h';
drop table tbl1;

create table tbl1 (a int);
create table tbl2 (b double);

create or replace view vx (a tbl1) as select NULL a from (select tbl2 from tbl2 union all select tbl2 from tbl2) d_tbl;
select if(data_type = 'OBJECT', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(domain_class_name = 'tbl1', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';

create or replace view vx (a tbl1) as select tbl1 from tbl1 union all select tbl1 from tbl1;
select if(data_type = 'OBJECT', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(domain_class_name = 'tbl1', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';

create or replace view vx (a) as select tbl1 from tbl1 union all select tbl1 from tbl1;
select if(data_type = 'OBJECT', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(domain_class_name = 'tbl1', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';

create or replace view vx as select a from tbl1 union all select 2 from db_root;
select if(data_type = 'INTEGER', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';

create or replace view vx as select a from tbl1 union all select cast(2 as bigint) from db_root;
select if(data_type = 'BIGINT', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';

create or replace view vx as select a from tbl1 union all select cast(2 as numeric(10,2)) from db_root;
select if(data_type = 'NUMERIC', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(prec = 12, 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(scale = 2, 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';

create or replace view vx as select cast(2 as numeric(10,2)) as a from db_root;
select if(data_type = 'NUMERIC', 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(prec = 10, 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';
select if(scale = 2, 'OK', 'NOK') from db_attribute where class_name='vx' and attr_name = 'a';

create view vx (a tbl2) as select tbl1 from tbl1 union all select tbl1 from tbl1; 
create view vx (a tbl1) as select tbl1 from tbl1 union all select tbl2 from tbl2;

drop table tbl1;
drop table tbl2;
drop vx;