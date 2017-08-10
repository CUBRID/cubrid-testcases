create table referenced_tbl (id int);

insert into referenced_tbl values (22);
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;
insert into referenced_tbl select * from referenced_tbl;

drop table referenced_tbl;

create table tree(id int, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,6,'BBA');
insert into tree values(8,null,'C');

create table tree2(id int,treeid int,text varchar(32));

insert into tree2 values(1,1,'-A-');
insert into tree2 values(2,2,'-B-');
insert into tree2 values(3,3,'-AA-');
insert into tree2 values(4,4,'-AB-');
insert into tree2 values(5,5,'-BA-');
insert into tree2 values(6,6,'-BB-');
insert into tree2 values(7,7,'-BBA-');
insert into tree2 values(8,null,'-C-');

select t.id,t.text,t2.text
    from tree t
        right join tree2 t2 on t.id=t2.treeid
    start with t.parentid is null and t.id in (1,2,8)
    connect by prior t.id=t.parentid;
    
drop tree, tree2;
