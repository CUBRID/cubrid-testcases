drop table if exists tbl;

create table tbl(id int primary key, name char(5));
create user commenter comment'comment for user creation';
create user commenter2 comment='comment for user2 creation';
create user commenter3 groups adb comment'comment for commenter3 in root group';

grant select, insert update, delete on tbl to commenter, commenter2, commenter3;

alter user commenter comment'short comment testing for user commenter';
alter user commenter comment'new comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenterinew comment for user commenteri';

select name, comment from db_user order by 1,2;

drop user commenter;
drop user commenter3;
drop table if exists tbl;
