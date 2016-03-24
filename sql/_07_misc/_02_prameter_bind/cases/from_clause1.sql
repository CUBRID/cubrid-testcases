--bind parameter in from cluase
--+ holdcas on;
create class xoo ( a int, b string);
insert into xoo values(1, '11');
insert into xoo values(2, '22');
insert into xoo values(3, '33');

select x.aa, x.bb from ( select 100 aa , '222'||b bb from xoo where to_number('1') = a) x where x.aa=100;
$int , $100, $varchar, $222, $varchar, $1, $int , $100;
select x.aa, x.bb from ( select ? aa , ?||b bb from xoo where to_number(?) = a) x where x.aa=?;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select x.aa, x.bb from ( select 100 aa , '222'||b bb from xoo where to_number('1') = a) x where x.aa=100;
$int , $100, $varchar, $222, $varchar, $1, $int , $100;
select x.aa, x.bb from ( select ? aa , ?||b bb from xoo where to_number(?) = a) x where x.aa=?;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

$int, $1, $int , $3, $int , $0;
select x.a, x.b from ( select * from xoo order by a for orderby_num() between ?*1 and ? + ?) x;

$int, $1, $int ,$1, $int , $3, $int , $0;
select x.a, x.b from ( select * from xoo order by a for orderby_num() between ?*1+? and ? + ?) x;

$int, $0, $int, $1, $int ,$1, $int , $3, $int , $0;
select x.a from ( select a, count(*) from xoo group by a having count(*) > ?
                         order by a for orderby_num() between ?*1+? and ? + ? ) x;
         
select x.a from (select a , count(*) cnt from xoo group by a having count(*) > 0
                        order by a  for orderby_num() between 1+1 and 3) x;
                    
select x.a from (select a , count(*) cnt from xoo group by a 
                        order by a  for orderby_num() between 1+1 and 3) x;
                    
$int, $10, $int, $0, $int, $1, $int ,$1, $int , $3, $int , $0;                    
select x.a, orderby_num() + ? from ( select a, count(*) from xoo group by a having count(*) > ?
                                                     order by a for orderby_num() between ?*1+? and ? + ? ) x;
         
$int, $10, $int, $0, $int, $1, $int ,$1, $int , $3, $int , $0;                    
select x.a, rownum + ? from ( select a, count(*) from xoo group by a having count(*) > ?
                                            order by a for orderby_num() between ?*1+? and ? + ? ) x;
drop xoo;

commit;

--+ holdcas off;

