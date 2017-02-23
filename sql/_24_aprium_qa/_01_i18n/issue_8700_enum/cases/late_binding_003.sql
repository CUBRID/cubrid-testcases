--use host vars in expressions
--+ holdcas on;

drop table if exists t1;
create table t1(e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') collate utf8_en_cs, e2 enum('02/23/2012', '12/21/2012') collate utf8_en_cs, e3 enum('11:12:09', '13:13:13') collate utf8_en_cs, e4 enum('123', '9876', '-34') collate utf8_en_cs);
show full columns from t1;

insert into t1 values(2, 1, 1, 2), (5, 2, 1, 1), (6, 2, 2, 3), (1, 1, 1, 2), (7, 1, 2, 3), (4, 2, 2, 2), (3, 1, 1, 1);

--operators
prepare x from 'select e1 + ?, ? + e1, e1 + ?, e1 * ?, e1 + ? from t1 where e1 < ? order by 1, 2, 3, 4, 5';
execute x using 1, 1, 1.1, 5, '-', 7;
drop prepare x;

--strings & numeric
prepare x from 'select repeat(e1, ?), substring(e1, ?, ?), concat(e1,?, e2, ?, e3), repeat(?, e1) from t1 order by 1, 2, 3, 4';
execute x using 2, 1, 3, ' * ', ' ~ ', '*';
drop prepare x;

--conditional expressions & session variables
prepare x from 'select * from t1 where e1 in (?, ?, ?, ?) order by 1, 2, 3, 4';
execute x using 1, 2, 4, 7;
select @v1:=cast(e1 as varchar collate iso88591_bin) from t1 where e1=2 order by 1;
execute x using 'Tuesday', 'Thursday', 'Sunday', @v1;
drop variable @v1;
drop prepare x;

drop table t1;

commit;
--+ holdcas off;
