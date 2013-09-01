
Relational pagination (like frame, but easier)

SYNOPSIS

    #(signature)

DESCRIPTION

This command provides pagination over the input relation.

When page_index is positive (resp. striclty negative), this operator returns
`page_size` tuples whose ranking according to `ordering` (resp. reverse
ordering) is between `page_size * (page_index - 1)` and `page_size * page_index`
(excluded).

To be sound, this operator requires the ordering to include a candidate key
for the input relation. Alf will automatically extend the ordering you provide
to guarantee this, provided key inference is possible.

EXAMPLE

    # Take the first two suppliers ordered by name (then by id)
    !(alf page --page-size=2 suppliers -- name -- 1)

    # Take the next two suppliers
    !(alf page --page-size=2 suppliers -- name -- 2)

    # Take the last two suppliers
    !(alf page --page-size=2 suppliers -- name -- -1)

