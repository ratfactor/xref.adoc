# Import the Xref and Environment classes in xrefs.rb
require_relative 'xrefs'

puts '<html><head><style>'
puts 'table { width: 100%; border-collapse: collapse; border: 2px solid #666; }'
puts 'thead { background-color: #3f87a6; color: #fff; }'
puts 'tbody { background-color: #e4f0f5; }'
puts 'td,th { border: 1px solid #555; padding: 5px 10px; }'
puts 'li { font-size: 120%; }'
puts 'code { background-color: #DDD; font-size: 120%; }'
puts '</style>'
puts '<body>'

e1 = Environment.new
e1.description = "Testing syntax combinations with simple, relative document names."
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
e2.description = "Testing deep 'path-like' name traversal."
e2.test_source_document = 'x/y/z/qux.adoc'
e2.export_type = :one_to_one
e2.print

Xref.printStart
Xref.new(e2,'xref:bar#[Bar]').print
Xref.new(e2,'xref:../bar#[Bar]').print
Xref.new(e2,'xref:../../bar#[Bar]').print
Xref.new(e2,'xref:../../../bar#[Bar]').print
Xref.new(e2,'xref:../../../x/bar#[Bar]').print
Xref.new(e2,'xref:../../../x/y/bar#[Bar]').print
Xref.new(e2,'xref:../../../x/y/z/bar#[Bar]').print
Xref.new(e2,'xref:../../../x/b/z/bar#[Bar]').print
Xref.new(e2,'xref:../../../a/b/c/bar#[Bar]').print
Xref.printEnd

e3 = Environment.new
e3.description = "Testing document and ID combinations with one-to-one exporting (one output file per document)."
e3.test_source_document = 'foo/qux.adoc'
e3.export_type = :one_to_one
e3.print

Xref.printStart
Xref.new(e3,'xref:foo[Foo]').print
Xref.new(e3,'xref:bar#[Bar]').print
Xref.new(e3,'xref:bar.adoc[Bar]').print
Xref.new(e3,'xref:../bar#[Bar]').print
Xref.new(e3,'xref:../bar#[Bar]').print
Xref.new(e3,'xref:bar#foo[Foobar]').print
Xref.new(e3,'xref:../bar#foo[Foobar]').print
Xref.printEnd

e4 = Environment.new
e4.description = "Testing document and ID combinations with many-to-one exporting (one big output file)."
e4.test_source_document = 'foo/qux.adoc'
e4.export_type = :many_to_one
e4.print

Xref.printStart
Xref.new(e4,'xref:foo[Foo]').print
Xref.new(e4,'xref:bar#[Bar]').print
Xref.new(e4,'xref:bar.adoc[Bar]').print
Xref.new(e4,'xref:../bar#[Bar]').print
Xref.new(e4,'xref:../bar#[Bar]').print
Xref.new(e4,'xref:bar#foo[Foobar]').print
Xref.new(e4,'xref:../bar#foo[Foobar]').print
Xref.printEnd

e5 = Environment.new
e5.description = "Testing document and ID combinations with one-to-many exporting (each document split by section into multiple output files)."
e5.test_source_document = 'foo/qux.adoc'
e5.export_type = :one_to_many
e5.target_section_name = 'section15'
e5.print

Xref.printStart
Xref.new(e5,'xref:foo[Foo]').print
Xref.new(e5,'xref:bar#[Bar]').print
Xref.new(e5,'xref:bar.adoc[Bar]').print
Xref.new(e5,'xref:../bar#[Bar]').print
Xref.new(e5,'xref:../bar#[Bar]').print
Xref.new(e5,'xref:bar#foo[Foobar]').print
Xref.new(e5,'xref:../bar#foo[Foobar]').print
Xref.printEnd

puts '</body><html>'
