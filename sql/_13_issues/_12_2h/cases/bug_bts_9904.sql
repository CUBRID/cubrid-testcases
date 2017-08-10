set names utf8;
drop table if exists t;

create table t(c char(50) collate utf8_bin) partition by list(c) (
partition p0 values in(_utf8'金'),
partition p1 values in(_iso88591'金'),
partition p2 values in(_euckr'金'));

create table t(c char(50) collate utf8_ko_cs_uca) partition by list(c) (
partition p0 values in(_utf8'金'),
partition p1 values in(_iso88591'a'),
partition p2 values in(_euckr'가'));

create table t(c char(50) charset iso88591) partition by list(c) (
partition p0 values in(_utf8'金'),
partition p1 values in(_iso88591'a'),
partition p2 values in(_euckr'가'));

create table t(c char(50) charset euckr) partition by list(c) (
partition p0 values in(_utf8'金'),
partition p1 values in(_iso88591'a'),
partition p2 values in(_euckr'가'));

set names iso88591;
create table t(c char(50) charset utf8) partition by list(c) (
partition p0 values in('金'),
partition p1 values in('a'),
partition p2 values in('가'));
drop t;

set names utf8;
create table t(c char(50) charset utf8) partition by list(c) (
partition p0 values in('金' collate iso88591_bin),
partition p1 values in('a'),
partition p2 values in('가'));

create table t(c char(50) charset utf8) partition by list(c) (
partition p0 values in('金'),
partition p1 values in('a' charset euckr),
partition p2 values in('가'));

drop table if exists t;
set names iso88591;
