drop table if exists vt, vt1, vt2, vt3, vt4, vt5, vt6, vt7, vt8, vt9;

-- Create table with VECTOR data type
create table vt1 (vec VECTOR);
create table vt2 (vec VECTOR (1024));

-- Create table with VECTOR data type which vector element type is described
create table vt3 (vec VECTOR (1024, float));
--create table vt4 (vec VECTOR (1024, short));
--create table vt5 (vec VECTOR (1024, double));

-- Create table with VECTOR data type which vector element type is described and primary key
create table vt6 (c int primary key, vec VECTOR (1024, float));
--create table vt7 (c int primary key, vec VECTOR (1024, short));
--create table vt8 (c int primary key, vec VECTOR (1024, double));

-- Create table with multiple VECTOR data types
create table vt9 (vec1 VECTOR (1024), vec2 VECTOR (1024, float));

drop table if exists vt, vt1, vt2, vt3, vt4, vt5, vt6, vt7, vt8, vt9;

-- Syntax error cases
create table vt (vec VECTOR ('abc'));
create table vt (vec VECTOR (abc));

create table vt (vec VECTOR (1024, abc));
create table vt (vec VECTOR (1024, 'abc'));
create table vt (vec VECTOR (1024, STRING));
create table vt (vec VECTOR (float, 1024));

create table vt (vec VECTOR(1024, ));
create table vt (vec VECTOR(, float));
create table vt vec VECTOR(1024, float);
create table vt (vec VECTOR 1024, float);
create table vt (vec VECTOR 1024 float);
create table vt (vec VECTOR(1024, float);
create table vt vec VECTOR(1024, float));
create table vt (vec VECTOR 1024, float));

--create table vt (vec VECTOR (-1, float));
--create table vt (vec VECTOR (0, float));
--create table vt (vec VECTOR (2001, float));

--create table vt (vec VECTOR (2000, float));

drop table if exists vt;

-- Restriction testcases for VECTOR data type
create table vt (v VECTOR(1024) primary key);
create table vt (vec VECTOR unique);
create table vt (vec VECTOR) partition by hash (vec) partitions 4;

drop table if exists vt;
