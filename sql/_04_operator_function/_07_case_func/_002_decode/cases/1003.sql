--Test decode function with basic datetype:integer
create class t1 (name varchar(20), score integer, subject varchar(20));

insert into t1 values('Jerry', 99, 'Math');
insert into t1 values('Nancy', 89, 'English');
insert into t1 values('Tom',   75, 'CS');
insert into t1 values('Catty',   66, 'Cook');
insert into t1 values('Kitty', 50,   'Drawing');

select name, decode(substr(to_char(score),1,1),'9', 'A',
                 '8', 'B',
                 '7', 'C',
                 '6', 'D', 'E')as score, subject 
from t1 order by 1;
                 
drop class t1;                 
