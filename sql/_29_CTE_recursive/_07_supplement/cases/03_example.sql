-- This testcase use modified PostgreSQL samples. See below for the license:
-- Portions Copyright (c) 1996-2017, The PostgreSQL Global Development Group
-- Portions Copyright (c) 1994, The Regents of the University of California
-- Permission to use, copy, modify, and distribute this software and its
--  documentation for any purpose, without fee, and without a written agreement is
--  hereby granted, provided that the above copyright notice and this paragraph
--  and the following two paragraphs appear in all copies.
-- IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
--  DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
--  LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
--  EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF
--  SUCH DAMAGE.
-- THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING,
--  BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--  A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS,
--  AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE,
--  SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
drop if exists supplytree;
CREATE TABLE supplyitem(si_id integer PRIMARY KEY, si_parentid integer, si_item varchar(100));

--load up the table (multirow constructor introduced in 8.2)
INSERT INTO supplyitem(si_id,si_parentid, si_item)
VALUES (1, NULL, 'Paper'),
(2,1, 'Recycled'),
(3,2, '20 lb'),
(4,2, '40 lb'),
(5,1, 'Non-Recycled'),
(6,5, '20 lb'),
(7,5, '40 lb'),
(8,5, 'Scraps');

--Recursive query (introduced in 8.4 returns fully qualified name)
WITH RECURSIVE supplytree AS
(SELECT si_id, si_item, si_parentid, CAST(si_item As varchar(1000)) As si_item_fullname
FROM supplyitem
WHERE si_parentid IS NULL
UNION ALL
SELECT si.si_id,si.si_item,
	si.si_parentid,
	CAST(sp.si_item_fullname || '->' || si.si_item As varchar(1000)) As si_item_fullname
FROM supplyitem As si
	INNER JOIN supplytree AS sp
	ON (si.si_parentid = sp.si_id)
)
SELECT si_id, si_item_fullname
FROM supplytree
ORDER BY si_item_fullname;
drop if exists supplyitem;
