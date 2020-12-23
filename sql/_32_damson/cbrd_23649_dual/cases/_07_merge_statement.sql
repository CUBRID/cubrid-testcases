drop table if exists score;
create table score (course_id int, student_id int, score int);

insert into score values (1, 1001, 49);
insert into score values (1, 1002, 50);
insert into score values (2, 1001, 80);
insert into score values (2, 1002, 90);

merge into score s using dual
on s.course_id = 1 and s.student_id = 1002
when matched then update set s.score = 30
when not matched then insert(s.course_id, s.student_id, s.score) values (1, 1002, 30);

select * from score;

drop score;
