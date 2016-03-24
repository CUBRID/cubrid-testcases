autocommit off;
create class inter ( numnum int);
        insert into inter values( 1 );
        insert into inter values( 1 );
        insert into inter values( 2 );
        insert into inter values( 3 );
        insert into inter values( 3 );
        select unique s from
        ( select ( multiset ( select numnum from inter ) 
                - multiset (select unique numnum from inter ))
        from inter ) as t1(r), table(r) as t2(s);
rollback;
