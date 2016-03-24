autocommit off;
create class other_node (a char(20));
insert into other_node values('aaaaaaaaaaaaaaaaaaaa') into :other_obj
create class node1 (
    a character(4) NOT NULL UNIQUE,
    b sequence(other_node),
    c sequence(other_node),
    d character(26));
insert into node1 (a, b, c, d) values
     ('1014', {:other_obj}, {:other_obj}, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
insert into node1 (a, b, c, d) values
    ('1015', {:other_obj}, {:other_obj}, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
insert into node1 (a, b, c, d) values
    ('1016', {:other_obj}, {:other_obj}, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
select node1 into :node1_obj from node1 where a = '1015';
select :node1_obj.a from class node1;
alter class node1 add attribute other_node_ptr other_node;
update node1 set other_node_ptr = :other_obj;    -- Updates disk representation
alter class node1 drop attribute d;
select node1 into :node1_obj from node1 where a = '1015';
select :node1_obj.a from class node1;
create class node2 (
    a character(4) NOT NULL UNIQUE,
    b sequence(other_node),
    c sequence(other_node),
    d numeric(20,4));
insert into node2 (a, b, c, d) values
    ('1014', {:other_obj}, {:other_obj}, 1.0);
insert into node2 (a, b, c, d) values
    ('1015', {:other_obj}, {:other_obj}, 2.0);
insert into node2 (a, b, c, d) values
    ('1016', {:other_obj}, {:other_obj}, 3.0);
select node2 into :node2_obj from node2 where a = '1015';
select :node2_obj.a from class node2;
alter class node2 add attribute other_node_ptr other_node;
update node2 set other_node_ptr = :other_obj;    -- Updates disk representation
alter class node2 drop attribute d;
select node2 into :node2_obj from node2 where a = '1015';
select :node2_obj.a from class node2;
create class node3 (
    a character(4) NOT NULL UNIQUE,
    b sequence(other_node),
    c sequence(other_node),
    d bit(20));
insert into node3 (a, b, c, d) values
    ('1014', {:other_obj}, {:other_obj}, B'10110111011101111011');
insert into node3 (a, b, c, d) values
    ('1015', {:other_obj}, {:other_obj}, B'10110111011101111011');
insert into node3 (a, b, c, d) values
    ('1016', {:other_obj}, {:other_obj}, B'10110111011101111011');
select node3 into :node3_obj from node3 where a = '1015';
select :node3_obj.a from class node3;
alter class node3 add attribute other_node_ptr other_node;
update node3 set other_node_ptr = :other_obj;    -- Updates disk representation
alter class node3 drop attribute d;
select node3 into :node3_obj from node3 where a = '1015';
select :node3_obj.a from class node3;
create class node4 (
    a character(4) NOT NULL UNIQUE,
    b sequence(other_node),
    c sequence(other_node),
    d nchar(26));
insert into node4 (a, b, c, d) values
    ('1014', {:other_obj}, {:other_obj}, N'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
insert into node4 (a, b, c, d) values
    ('1015', {:other_obj}, {:other_obj}, N'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
insert into node4 (a, b, c, d) values
    ('1016', {:other_obj}, {:other_obj}, N'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
select node4 into :node4_obj from node4 where a = '1015';
select :node4_obj.a from class node4;
alter class node4 add attribute other_node_ptr other_node;
update node4 set other_node_ptr = :other_obj;    -- Updates disk representation
alter class node4 drop attribute d;
select node4 into :node4_obj from node4 where a = '1015';
select :node4_obj.a from class node4;
rollback;
