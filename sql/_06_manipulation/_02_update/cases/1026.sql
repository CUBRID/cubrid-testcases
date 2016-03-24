--Test update with set attributes

create class t1 (col1 integer, col2 set varchar(10));
insert into t1 values( 101, {'xxx','yyy','zzzz'});
insert into t1 values( 102, {'aaa','yyy','zzzz'});
insert into t1 values( 103, {'bbb','yyy','zzzz'});
insert into t1 values( 104, {'ccc','yyy','zzzz'});
insert into t1 values( 105, {'ddd','yyy','zzzz'});
insert into t1 values( 106, {'eee','yyy','zzzz'});
insert into t1 values( 107, {'fff','yyy','zzzz'});
insert into t1 values( 108, {'zzz','yyy','zzzz'});
insert into t1 values( 109, {'ggg','yyy','zzzz'});


update t1 set col2 = col2 - {'zzzz'} 
where col1 < 105;

select * from t1 order by 1;

drop class t1;
