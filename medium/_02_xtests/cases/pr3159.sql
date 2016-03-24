autocommit off;
create class situation ( status char(1));
create class bug
(
 id string unique,
 history set situation
);
insert into bug(id,history) values
('93b-0021',{insert into situation(status) values ('e')});
create view entry_list
(id string)
as
select id from bug,table(history) as h(st) where st.status='e';
create view resolve_list
(id string)
as
select id from bug,table(history) as h(st) where st.status='r';
select e.id from entry_list e, resolve_list r
where e.id = r.id;
insert into bug(id,history) values
('93b-0022',{insert into situation(status) values ('r')});
select e.id from entry_list e, resolve_list r
where e.id = r.id;
insert into bug(id,history) values
('93b-0023',{insert into situation(status) values ('r'),
             insert into situation(status) values ('e')});
select e.id from entry_list e, resolve_list r
where e.id = r.id;
rollback;
