--TEST: "select LOCATE('0', REVERSE('22')) " doesn't work well with utf8 charset.

--TEST: Orginal Case
set names iso88591;
--note: good
select LOCATE('0', REVERSE('22')); 
select LOCATE('2', REVERSE('12')); 
select LOCATE('2', REVERSE('21')); 

set names utf8;
--test:fail and throw "ERROR: No error message available."
select LOCATE('0', REVERSE('22')); 
select LOCATE('2', REVERSE('12'));
select LOCATE('2', REVERSE('21'));

set names euckr;
select LOCATE('0', REVERSE('22'));
select LOCATE('2', REVERSE('12'));
select LOCATE('2', REVERSE('21'));


set names iso88591;

--TEST: CASE 1, between
create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('aa'),( 'ab'), ( 'aB');

insert into t2 values ('aa'),( 'ab'), ( 'aB');

select * from t1 where s1 between 'aa' and 'ac' order by 1;
select * from t1 where s1 not between 'aa' and 'ac' order by 1;

select * from t2 where s1 between 'aa' and 'ac' order by 1;
select * from t2 where s1 not between 'aa' and 'ac' order by 1;

drop t1;
drop t2;


--TEST: CASE 2, hierachy
create table list_test_char(id varchar collate utf8_en_cs,
                        parentid varchar collate utf8_en_ci, text varchar(32)
                        );

insert into list_test_char values('a',null,'A');
insert into list_test_char values('b',null,'B');
insert into list_test_char values('c','A','AA');
insert into list_test_char values('d','a','AB');
insert into list_test_char values('e','b','BA');
insert into list_test_char values('f','b','BB');
insert into list_test_char values('g','f','BBA');
insert into list_test_char values('h','g','CBA');


select *
        from list_test_char
        connect by prior id=parentid
        order by id;
		
select *
        from list_test_char
        connect by (prior id) collate utf8_en_cs = parentid
        order by id;
		

select id,parentid,text,connect_by_root id
        from list_test_char
		where connect_by_root id < 'D'		
        start with parentid is null
        connect by prior id=parentid
        order by id;	
		

select id,parentid,text,connect_by_root id
        from list_test_char
		where (connect_by_root id) collate utf8_en_ci < 'D'		
        start with parentid is null
        connect by prior id=parentid
        order by id;	

drop list_test_char;


--TEST: CASE 3, collation info
select collation (charset (_euckr'a'));
select collation (collation (_euckr'a'));


set names iso88591;
