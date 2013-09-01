
Relational framing (aka offset/limit, yet sounder)

SYNOPSIS

    #(signature)

DESCRIPTION

This command provides the classical offset/limit over the input relation.

This operator skips tuples whose ranking according to `ordering` is between
`0` and `offset` exclusive (in other words, it skips `offset` tuples). In
addition, it returns maximum `limit` tuples.

To be sound, this operator requires the ordering to include a candidate key
for the input relation. Alf will automatically extend the ordering you provide
to guarantee this, provided key inference is possible.

EXAMPLE

    # Take the first two suppliers ordered by name (then by id)
    !(alf frame suppliers -- name -- 0 -- 2)

    # Take the next two suppliers
    !(alf frame suppliers -- name -- 2 -- 2)
