/* Description
After merging the CBRD-24429 then the multiple foreign keys on a column attribute are not allowed.
This test case is verified by partition table.
*/
drop if exists t2;
drop if exists part_t1;
drop if exists t1;

create table t1(a char(1) primary key, b int);


-- foreign key table -> partition table
create table part_t1(
    a char(1) primary key,
    b int,
    constraint fk_a foreign key(a) references t1(a)
) partition by range(a) (
    PARTITION less_c VALUES LESS THAN ('c'),
    PARTITION char_else VALUES LESS THAN MAXVALUE
);

-- error
alter table part_t1 add constraint fk_a2 foreign key(a) references t1(a);


-- foreign key partition table -> table
create table t2(
    a char(1),
    b int,
    constraint fk_part_a foreign key(a) references part_t1(a)
);

-- error
alter table t2 add constraint fk_part_a2 foreign key(a) references part_t1(a);

drop t2;
drop part_t1;
drop t1;
