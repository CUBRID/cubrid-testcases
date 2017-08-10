create table range_test(id int,
			parentid int, text varchar(32)
		        )	
	PARTITION BY RANGE (id) 
	(
	PARTITION p0 VALUES LESS THAN (3),
	PARTITION p1 VALUES LESS THAN (5),
	PARTITION p2 VALUES LESS THAN (7),
	PARTITION p3 VALUES LESS THAN maxvalue );


insert into range_test values(1,null,'A');
insert into range_test values(2,null,'B');
insert into range_test values(3,1,'AA');
insert into range_test values(4,1,'AB');
insert into range_test values(5,2,'BA');
insert into range_test values(6,2,'BB');
insert into range_test values(7,6,'BBA');
insert into range_test values(8,7,'CBA');


select id,parentid,text
        from range_test
        start with text='A'
        connect by -parentid=prior (-id) or parentid=prior(-id)
        order by id;

select id,parentid,text
        from range_test
        start with text='A'
        connect by -parentid=prior (-id) or prior(-id)=parentid
        order by id;

select id,parentid,text,level
        from range_test
        start with text='A'
        connect by parentid=prior id and 9999>prior id
        order by id;

select id,parentid,text
        from range_test
        where text<>'B' and length(text)=1
        start with text='A'
        connect by nocycle -parentid=prior (-id) or 9999>prior id
        order by id;

select id,parentid,text
        from range_test
        start with text='A'
        connect by prior (-id)=-parentid
        order by id;

select id,parentid,text
        from range_test
        start with text='A'
        connect by prior (-id)=999 or 999=prior(-id)
        order by id;

drop table range_test;


