drop table if exists part;
create table part   (
	id	    integer unique,
	textlabel   varchar(255),
	description varchar(4096)
) partition by range (id)(
	partition p1 values less than (10),
	partition p2 values less than (20),
	partition p3 values less than (30),
	partition p4 values less than MAXVALUE
);
create index idx_part on part(id, textlabel) where textlabel like '%$_%' invisible;
select status, index_name, class_name from db_index where class_name like 'part%' order by 1,2,3;

alter index  idx_part on part invisible;
select status, index_name, class_name from db_index where class_name like 'part%' order by 1,2,3;
alter index  idx_part on part__p__p1 visible;
select status, index_name, class_name from db_index where class_name like 'part%' order by 1,2,3;
alter index  idx_part on part visible;
select status, index_name, class_name from db_index where class_name like 'part%' order by 1,2,3;
alter index  idx_part on part__p__p2 visible;
select status, index_name, class_name from db_index where class_name like 'part%' order by 1,2,3;


insert into part(id, textlabel, description)
values
    -- p1 --
    (1, 'a00', 'from tex''s viewpoint, a single character from a font is a box;'),
    (2, 'a_0', 'the font designer has decided what the height, width, and depth of the character are'),
    (3, 'a11', 'tex uses these dimensions to paste boxes together'),

    -- p2 --
    (14, 'ea0', ' you needn''t bother to learn these measurements yourself'),
    (15, 'ea3', 'the character shape need not fit inside the boundaries of its box.'),
    (16, 'ea4', 'for example, some characters that are used to build up larger math symbols'),

    -- p3 --
    (21, 'm..', 'slanted letters frequently extend a little to the right of the box'),
    (22, 'm.-', 'a number is specified for each character, telling roughly how far that character extends...'),
    (23, 'm--', '(printers generally prefer white space to black space.)'),

    -- part --
    (100, 'xk~', 'plain tex has an output routine that takes care of ordinary jobs.'),
    (101, 'xy~', 'this format is suitable for preprints of technical papers, ...'),
    (110, 'xx~', 'in fact, \nopagenumbers is a special case of a much more general mechanism');

alter index  idx_part on part invisible;
select * from part__p__p2 where textlabel like '%$_%' order by id;
select * from part where textlabel like '%$_%' order by id;

select * from part where textlabel like '%\_%' escape '\' order by id;
drop table if exists part;
