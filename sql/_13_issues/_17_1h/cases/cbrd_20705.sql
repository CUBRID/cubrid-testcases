drop table if exists foo;

create table foo (id int primary key, col string);
insert into foo values (1, 'aaa');
insert into foo values (2, null);

prepare s from 'select * from foo where ? in nvl(col, ?);'
execute s using 'a', '';

prepare s from 'select * from foo where ? in nvl(?,col);'
execute s using 'a', 'a';

prepare s from 'select * from foo where ? = nvl(col, ?);'
execute s using 'a', '';

prepare s from 'select * from foo where ? in nvl(col, ?);'
execute s using 'a', 'a';

prepare s from 'select * from foo where ? not in nvl(col, ?);'
execute s using 'a', '';

prepare s from 'select * from foo where ? in COALESCE(col, ?, ?);' 
execute s using 'a', '', 'c';

prepare s from 'select * from foo where ? in DECODE(col,  col,id);'  
execute s using '';
 
prepare s from 'select * from foo where ? in GREATEST(?,?,?,?);'
execute s using '','','','',''; 

prepare s from 'select * from foo where ? in GREATEST(col,?,?,?); '
execute s using '','','','';   
 
prepare s from 'select * from foo where ? in if( col = ?, ?,? );'  
execute s using 'a', 'aaa', 'c','d';

prepare s from 'select * from foo where ? in ifnull(col, ?);'   
execute s using 'a', 'aaa';

prepare s from 'select * from foo where ? in (if( col = ?, ?,? ), ifnull(col, ?));'  
execute s using 'a', 'aaa', 'c','d','';

prepare s from 'select * from foo where ? in ( ifnull(col, ?),if( col = ?, ?,? ));'  
execute s using 'a', 'a', 'c','d','';  
 
prepare s from 'select * from foo where ? in NVL2( col, ?, ?);'
execute s using 'id', 'aaa', 'c','d';  

prepare s from 'select * from foo where ? in NVL2( ?, col, ?);'
execute s using 'id', 'col', 'c';

prepare s from 'select * from foo where ? in NVL2( ?, ?, col);'
execute s using 'id', 'col', 'c';

prepare s from 'select * from foo where ? in NULLIF( col, ?);'
execute s using 'id', 'c';


drop table if exists foo;
drop prepare s;

create table foo (id int primary key, col string);
insert into foo values (1, 'aaa');
insert into foo values (2, null);

prepare s from 'select * from foo where nvl(col, ?) in (?,?);'
execute s using 'a', '','';

prepare s from 'select * from foo where nvl(col, ?) in (?,nvl(col, ?));'
execute s using 'a', '','';

prepare s from 'select * from foo where nvl(col, ?) not in (?,?);'
execute s using 'a', '','a';

prepare s from 'select * from foo where COALESCE(col, ?, ?) in (col,?,?);'
execute s using 'a', '', 'c','a';

prepare s from 'select * from foo where DECODE(col,col,id) in (?,?,col);'  
execute s using '','a';

prepare s from 'select * from foo where NVL2( ?, ?, col) in (?,?);'
execute s using 'id', 'col', 'c','';

prepare s from 'select * from foo where NULLIF( col, ?) in (?,?,col);'
execute s using 'id', 'a','c';

drop prepare s;
drop table if exists foo;



