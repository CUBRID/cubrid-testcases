# medium rulebook

**Read [rules/test-perspectives.md](rules/test-perspectives.md) and [rules/writing-rules.md](rules/writing-rules.md) before you write or change a TC under `medium/`.** The first says what a TC checks; the second says how to write its files. Example: for a new TC, read the *test perspectives* and the "New TC" section of the *writing rules*; for a change, read the "Changing an existing TC" section as well.

A rule that holds for sql and medium TCs alike stands once, in the files under `sql/`, and the files under `medium/` link to it.

## Operational facts

The `tc/pr-<N>` branch and the Draft TC PR of an engine PR and the stop of Windows tests hold for medium TCs as they do for sql TCs: see [Operational facts](../sql/AGENTS.md#operational-facts) in `sql/AGENTS.md`.

This repo holds no list of excluded medium TCs. `medium/config/` holds only the patch files of the JDBC compatibility test, and CTP reads the excluded TCs from the file that `testcase_exclude_from_file` names in its `medium.conf`, by default `${CTP_HOME}/conf/exclusions.txt` outside this repo.

## The PR

The rules of [The PR](../sql/AGENTS.md#the-pr) in `sql/AGENTS.md` on the title of the Draft TC PR, on committing to `tc/pr-<N>` with a fix and a new TC in separate commits, on a TC PR to a release branch, on merging the base branch into `tc/pr-<N>` and into the engine PR, on a changed *answer file*, on closing the Draft TC PR of an engine PR that changes no TC of this repo, and on when to merge a TC PR hold for medium TCs as well.

**Leave `medium/files/mdb.tar.gz` unchanged, and create the data that a TC needs inside the TC.** Every TC under `medium/` runs on the database that CTP loads from this archive, and the JDBC compatibility test loads it too, so a change to it changes the output of all of them. How a TC rolls its data back is in [writing rules](rules/writing-rules.md#start-and-end-of-the-file). Example: a TC that needs a class with a set attribute creates it after `autocommit off;` and ends with `rollback;`, and the PR leaves `mdb.tar.gz` as it is.
