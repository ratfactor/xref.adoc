# Import the Xref and Environment classes in xrefs.rb
require_relative 'xrefs'

# What IS being tested:
#
#  * Correct handling of document name and location ID in xrefs (addressing).
#  * Relative "path segments" in document names.
#  * Proof-of-concept of xref addressing.
#
# What is NOT being tested:
#
#  * Any kind of AsciiDoc lexing or parsing (the xref links all have
#    labels, for example).
#  * Input validation - these tests are all syntactically and semantically
#    correct and the paths are correct.
#  * Filesystem handling (but that's kind of the whole point).
#  * Content output generation (HTML links are created as an example because
#    they are ubiquitous and HTML output can be one-to-one, one-to-many
#    and many-to-one in relation to the input source).
#
##############################################################################
#
# Let's start easy: no path segments ("/") and one-to-one exporting.
#
e1 = Environment.new
e1.test_source_document = 'qux.adoc'
e1.export_type = :one_to_one

=begin
# Inline macro xref syntax
Xref.new(e1,'xref:foo[Foo]').print
Xref.new(e1,'xref:bar#[Bar]').print
Xref.new(e1,'xref:bar.adoc[Bar]').print
Xref.new(e1,'xref:bar.adoc#[Bar]').print
Xref.new(e1,'xref:bar#foo[Foobar]').print
Xref.new(e1,'xref:bar.adoc#foo[Foobar]').print

# "Short" syntax <<,>>
Xref.new(e1,'<<foo,Foo>>').print
Xref.new(e1,'<<bar#,Bar>>').print
Xref.new(e1,'<<bar.adoc,Bar>>').print
Xref.new(e1,'<<bar.adoc#,Bar>>').print
Xref.new(e1,'<<bar#foo,Foobar>>').print
Xref.new(e1,'<<bar.adoc#foo,Foobar>>').print


##############################################################################
#
# Now let's try some relative paths from a document with one path segment.
#
e2 = Environment.new
e2.test_source_document = 'baz/qux.adoc'
e2.export_type = :one_to_one

# Some of these won't be very interesting in one-to-one export...
Xref.new(e2,'xref:../bar#[Bar]').print
Xref.new(e2,'<<../bar#,Bar>>').print
Xref.new(e2,'xref:bar2#[Bar2]').print
Xref.new(e2,'<<bar2#,Bar2>>').print

# This one "proves" that we understand that this puts us back in the same path
# path segment (source and destination are both in ../baz)
Xref.new(e2,'xref:../baz/bar3#[Bar3]').print
Xref.new(e2,'<<../baz/bar3#,Bar3>>').print

=end



e2 = Environment.new
e2.test_source_document = 'baz/qux.adoc'
e2.export_type = :one_to_one
Xref.new(e2,'xref:../baz/bar3#[Bar3]').print
Xref.new(e2,'xref:../bar4#[Bar4]').print
Xref.new(e2,'xref:bar5#[Bar5]').print
Xref.new(e2,'xref:boop/bar6#[Bar6]').print
Xref.new(e2,'xref:../baz/boop/bar7#[Bar7]').print
Xref.new(e2,'xref:../biz/boop/bar8#[Bar8]').print

e3 = Environment.new
e3.test_source_document = 'x/y/z/qux.adoc'
e3.export_type = :one_to_one
Xref.new(e3,'xref:bar#[Bar]').print
Xref.new(e3,'xref:../bar#[Bar]').print
Xref.new(e3,'xref:../../bar#[Bar]').print
Xref.new(e3,'xref:../../../bar#[Bar]').print
Xref.new(e3,'xref:../../../x/bar#[Bar]').print
Xref.new(e3,'xref:../../../x/y/bar#[Bar]').print
Xref.new(e3,'xref:../../../x/y/z/bar#[Bar]').print
Xref.new(e3,'xref:../../../x/b/z/bar#[Bar]').print
Xref.new(e3,'xref:../../../beef/chicken/pork/bar#[Bar]').print

e4 = Environment.new
e4.test_source_document = 'x/y/z/qux.adoc'
e4.export_type = :many_to_one
Xref.new(e4,'xref:bar#[Bar]').print
Xref.new(e4,'xref:../bar#[Bar]').print
Xref.new(e4,'xref:../../bar#[Bar]').print
Xref.new(e4,'xref:../../../bar#[Bar]').print
Xref.new(e4,'xref:../../../x/bar#[Bar]').print
Xref.new(e4,'xref:../../../x/y/bar#[Bar]').print
Xref.new(e4,'xref:../../../x/y/z/bar#[Bar]').print
Xref.new(e4,'xref:../../../x/b/z/bar#[Bar]').print
Xref.new(e4,'xref:../../../beef/chicken/pork/bar#[Bar]').print
