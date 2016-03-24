-- [er]create class with numberic using great length 

create class t1 (
    c4 NUMERIC(4,4)
    );
    
insert into t1 VALUES (11111);

drop t1;