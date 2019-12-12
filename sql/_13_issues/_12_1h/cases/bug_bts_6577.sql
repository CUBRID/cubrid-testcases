-- successful result
SELECT elt(2, 1);
-- successful result
SELECT field(NULL, 'a', 'b', 'c');
-- will throw code exception when use above two together.
SELECT elt(2, 1), field(NULL, 'a', 'b', 'c');
