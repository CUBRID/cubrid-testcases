create table emp (store_id int not null )
partition by range (store_id) (
	partition p1 values less than (10 ),
	partition p2 values less than (20 )
);

create trigger tr2 after insert on emp execute update emp set store_id = store_id + 10 where store_id = obj.store_id;

insert into emp values(5);
insert into emp values(-10);

select * from emp order by 1;
select * from emp__p__p1 order by 1;
select * from emp__p__p2 order by 1;

drop table emp;
