--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
/* test for partial indexes on partitioned tables */
create table part
    (
	id	    integer unique,
	textlabel   varchar(255),
	description varchar(4096)
    )

    partition by range (id)
	(
	    partition p1 values less than (10),
	    partition p2 values less than (20),
	    partition p3 values less than (30),
	    partition p4 values less than MAXVALUE
	);
--Test
create index idx_part on part(id, textlabel) where textlabel like '%$_%' escape '$' or textlabel like '%3%';

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

--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+);
--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+)
    difference
select /*+ recompile */ * from part
    where textlabel like '%$_%' escape '$' or textlabel like '%3%' or textlabel like '%-%' or textlabel like '%~%';


--Test values should all be outside the index --
create table orig_part as select /*+ recompile */ * from part where id > -1 using index idx_part(+);
select * from orig_part order by id;
drop table orig_part;

insert into part (id, textlabel) values (4, 'a12'), (13, 'ea2'), (20, 'm  '), (102, '***');

--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+);
--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+)
    difference
select /*+ recompile */ * from part
    where textlabel like '%$_%' escape '$' or textlabel like '%3%' or textlabel like '%-%' or textlabel like '%~%';
--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+) difference select /*+ recompile */ * from orig_part;


--Test values should all be inside the index --
insert into part(id, textlabel) values (5, 'a_1'), (12, 'e33'), (24, 'm-.'), (111, 'xz~');
select /*+ recompile */ * from part where id > -1 using index idx_part(+);
--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+)
    difference
select /*+ recompile */ * from part
    where textlabel like '%$_%' escape '$' or textlabel like '%3%' or textlabel like '%-%' or textlabel like '%~%';


--Test bring a value from outside the index into the index --
update part set textlabel='a0_' where textlabel='a00';
update part set textlabel='3a0' where textlabel='ea0';
update part set textlabel='..m' where textlabel='m  ';
update part set textlabel='**~' where textlabel='***';

select /*+ recompile */ * from part where id > -1 using index idx_part(+);
--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+)
    difference
select /*+ recompile */ * from part
    where textlabel like '%$_%' escape '$' or textlabel like '%3%' or textlabel like '%-%' or textlabel like '%~%';

--Test take values from the index out of it --
update part set textlabel='a99' where id = 2;
update part set textlabel='eaa' where id = 15;
update part set textlabel='...' where id = 23;
update part set textlabel='xxx' where id = 110;

select /*+ recompile */ * from part where id > -1 using index idx_part(+);
--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+)
    difference
select /*+ recompile */ * from part
    where textlabel like '%$_%' escape '$' or textlabel like '%3%' or textlabel like '%-%' or textlabel like '%~%';

--Test bring values from outside the index into the index --
replace part(id, textlabel)
values
    (3, 'a__'), (16, '3e3'), (21, '-m-'), (110, '~xx');
select /*+ recompile */ * from part where id > -1 using index idx_part(+);
--Test
select /*+ recompile */ * from part where id > -1 using index idx_part(+)
    difference
select /*+ recompile */ * from part
    where textlabel like '%$_%' escape '$' or textlabel like '%3%' or textlabel like '%-%' or textlabel like '%~%';
drop table part;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
