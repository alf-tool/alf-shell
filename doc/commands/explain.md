
Show the logical and physical plans of a query

SYNOPSIS

    alf #(command_name) QUERY

DESCRIPTION

This command prints the logical and physical query plans for QUERY to
standard output. The logical plan is post-optimizer and allows checking that
the latter performs correctly. The physical plan provides information about
delegation to underlying database engines, e.g. involved SQL queries.
