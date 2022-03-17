drop table if exists foo;

create table foo (id int primary key, col string);
insert into foo values (1, 'aaa');
insert into foo values (2, null);

prepare s from 'select * from foo where ? in nvl(col, ?) order by id;';
execute s using 'a', '';

prepare s from 'select * from foo where ? in nvl(?,col) order by id;';
execute s using 'a', 'a';

prepare s from 'select * from foo where ? = nvl(col, ?) order by id;';
execute s using 'a', '';

prepare s from 'select * from foo where ? in nvl(col, ?) order by id;';
execute s using 'a', 'a';

prepare s from 'select * from foo where ? not in nvl(col, ?) order by id;';
execute s using 'a', '';

prepare s from 'select * from foo where ? in COALESCE(col, ?, ?) order by id;'; 
execute s using 'a', '', 'c';

prepare s from 'select * from foo where ? in DECODE(col,  col,id) order by id;';  
execute s using '';
 
prepare s from 'select * from foo where ? in GREATEST(?,?,?,?) order by id;';
execute s using '','','','',''; 

prepare s from 'select * from foo where ? in GREATEST(col,?,?,?); ';
execute s using '','','','';   
 
prepare s from 'select * from foo where ? in if( col = ?, ?,? ) order by id;';  
execute s using 'a', 'aaa', 'c','d';

prepare s from 'select * from foo where ? in ifnull(col, ?) order by id;';   
execute s using 'a', 'aaa';

prepare s from 'select * from foo where ? in (if( col = ?, ?,? ), ifnull(col, ?)) order by id;';  
execute s using 'a', 'aaa', 'c','d','';

prepare s from 'select * from foo where ? in ( ifnull(col, ?),if( col = ?, ?,? )) order by id;'; 
execute s using 'a', 'a', 'c','d','';  
 
prepare s from 'select * from foo where ? in NVL2( col, ?, ?) order by id;';
execute s using 'id', 'aaa', 'c','d';  

prepare s from 'select * from foo where ? in NVL2( ?, col, ?) order by id;';
execute s using 'id', 'col', 'c';

prepare s from 'select * from foo where ? in NVL2( ?, ?, col) order by id;';
execute s using 'id', 'col', 'c';

prepare s from 'select * from foo where ? in NULLIF( col, ?) order by id;';
execute s using 'id', 'c';


drop table if exists foo;
drop prepare s;

create table foo (id int primary key, col string);
insert into foo values (1, 'aaa');
insert into foo values (2, null);

prepare s from 'select * from foo where nvl(col, ?) in (?,?) order by id;';
execute s using 'a', '','';

prepare s from 'select * from foo where nvl(col, ?) in (?,nvl(col, ?)) order by id;';
execute s using 'a', '','';

prepare s from 'select * from foo where nvl(col, ?) not in (?,?) order by id;';
execute s using 'a', '','a';

prepare s from 'select * from foo where COALESCE(col, ?, ?) in (col,?,?) order by id;';
execute s using 'a', '', 'c','a';

prepare s from 'select * from foo where DECODE(col,col,id) in (?,?,col) order by id;';  
execute s using '','a';

prepare s from 'select * from foo where NVL2( ?, ?, col) in (?,?) order by id;';
execute s using 'id', 'col', 'c','';

prepare s from 'select * from foo where NULLIF( col, ?) in (?,?,col) order by id;';
execute s using 'id', 'a','c';

drop prepare s;
drop table if exists foo;



