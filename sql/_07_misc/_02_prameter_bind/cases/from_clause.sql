--+ holdcas on;
--bind parameter in from cluase

create class xoo ( a int);
insert into xoo values(10);

$int, $11, $int ,$22;
select ? , x.a , y.a from xoo x, ( select ? as a from xoo ) y;

$int, $11, $int ,$22;
select ? , x.a , y.a from xoo x, ( select to_char(?) as a from xoo ) y;

$int, $11, $int ,$22;
select ? , x.a , y.a from xoo x, ( select decode(? , 22, 220, 330) as a from xoo ) y;

$int, $11, $varchar ,$22;
select ? , x.a , y.a from xoo x, ( select decode(? , 22, 220, 330) as a from xoo ) y;

$int, $11, $varchar ,$22, $varchar ,$22;
select ? , x.a , y.a from xoo x, ( select ? + ? as a from xoo ) y;

select 11 , x.a , y.a from xoo x, ( select '22' + '20' as a from xoo  where a = 10 ) y;

$int, $11, $varchar ,$22, $varchar, $20, $int, $10;
select ? , x.a , y.a from xoo x, ( select ? + ? as a from xoo  where a = ? ) y;

$int, $11, $varchar ,$22, $int, $20, $int, $10;
select ? , x.a , y.a from xoo x, ( select ? + ? as a from xoo  where a = ? ) y;

$int, $11, $varchar ,$22, $int, $20, $int, $10;

select ? , x.a , y.a from xoo x, ( select ? || ? as a from xoo  where a = ? ) y;

drop xoo;


set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';


create class xoo ( a int);
insert into xoo values(10);

$int, $11, $int ,$22;
select ? , x.a , y.a from xoo x, ( select ? as a from xoo ) y;

$int, $11, $int ,$22;
select ? , x.a , y.a from xoo x, ( select to_char(?) as a from xoo ) y;

$int, $11, $int ,$22;
select ? , x.a , y.a from xoo x, ( select decode(? , 22, 220, 330) as a from xoo ) y;

$int, $11, $varchar ,$22;
select ? , x.a , y.a from xoo x, ( select decode(? , 22, 220, 330) as a from xoo ) y;

$int, $11, $varchar ,$22, $varchar ,$22;
select ? , x.a , y.a from xoo x, ( select ? + ? as a from xoo ) y;

select 11 , x.a , y.a from xoo x, ( select '22' + '20' as a from xoo  where a = 10 ) y;

$int, $11, $varchar ,$22, $varchar, $20, $int, $10;
select ? , x.a , y.a from xoo x, ( select ? + ? as a from xoo  where a = ? ) y;

$int, $11, $varchar ,$22, $int, $20, $int, $10;
select ? , x.a , y.a from xoo x, ( select ? + ? as a from xoo  where a = ? ) y;

$int, $11, $varchar ,$22, $int, $20, $int, $10;

select ? , x.a , y.a from xoo x, ( select ? || ? as a from xoo  where a = ? ) y;

drop xoo;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

commit;
--+ holdcas off;
