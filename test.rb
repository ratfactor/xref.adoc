# Import the Xref and Environment classes in xrefs.rb
require_relative 'xrefs'

puts '<html><head><style>'
puts 'table { width: 100%; } thead { background-color: silver }'
puts '</style>'
puts '<body>'

e1 = Environment.new
e1.description = "Testing all syntax combinations with simple, relative document names."
e1.test_source_document = 'qux.adoc'
e1.export_type = :one_to_one
e1.print

Xref.printStart
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
Xref.printEnd

e2 = Environment.new
e2.description = "Get ready for some pain!"
e2.test_source_document = 'baz/qux.adoc'
e2.export_type = :one_to_one
e2.print

Xref.printStart
# Some of these won't be very interesting in one-to-one export...
Xref.new(e2,'xref:../bar#[Bar]').print
Xref.new(e2,'<<../bar#,Bar>>').print
Xref.new(e2,'xref:bar2#[Bar2]').print
Xref.new(e2,'<<bar2#,Bar2>>').print
# This one "proves" that we understand that this puts us back in the same path
# path segment (source and destination are both in ../baz)
Xref.new(e2,'xref:../baz/bar3#[Bar3]').print
Xref.new(e2,'<<../baz/bar3#,Bar3>>').print
Xref.printEnd

e3 = Environment.new
e3.description = "Free-for-all path madness"
e3.test_source_document = 'x/y/z/qux.adoc'
e3.export_type = :one_to_one
e3.print

Xref.printStart
Xref.new(e3,'xref:bar#[Bar]').print
Xref.new(e3,'xref:../bar#[Bar]').print
Xref.new(e3,'xref:../../bar#[Bar]').print
Xref.new(e3,'xref:../../../bar#[Bar]').print
Xref.new(e3,'xref:../../../x/bar#[Bar]').print
Xref.new(e3,'xref:../../../x/y/bar#[Bar]').print
Xref.new(e3,'xref:../../../x/y/z/bar#[Bar]').print
Xref.new(e3,'xref:../../../x/b/z/bar#[Bar]').print
Xref.new(e3,'xref:../../../beef/chicken/pork/bar#[Bar]').print
Xref.printEnd

puts '</body><html>'
