-- [er]create class with numberic using great length with point

create class t1 (
    c4 NUMERIC(4,4)
    );
    
insert into t1 VALUES (-11.111);

drop t1;