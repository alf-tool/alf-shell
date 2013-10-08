
Relational allbut projection (inverse of project)

SYNOPSIS

    #(signature)

OPTIONS

    #(summarized_options)

DESCRIPTION

This operator projects away attributes whose names are specified in ATTRIBUTES.
This is the reverse operator of `project`. Unlike SQL, this operator **always**
removes duplicates in the result so that the output is a set of tuples, that
is, a relation.

EXAMPLE

    # What are all but supplier's id and name
    !(alf allbut suppliers -- sid name)

