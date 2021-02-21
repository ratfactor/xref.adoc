class Xref
  def initialize(xref_string)

    # This xref link's properties
    @document = nil
    @id       = nil
    @label    = nil

    # Document and export properties
    @current_document = nil
    @export_as        = :one_to_one # :one_to_one, :one_to_many, :man_to_one

    # xref matching patterns
    long_no_separator   = /xref:([A-Za-z._-]+)\[([^\]]*)\]/
    long_with_separator = /xref:([A-Za-z._-]+)#([A-Za-z._-]*)\[([^\]]*)\]/
    short_no_separator   = /<<([A-Za-z._-]+),([^>]*)>>/
    short_with_separator = /<<([A-Za-z._-]+)#([A-Za-z._-]*),([^>]*)>>/

    # Inline macro with no '#' separator, might have ID or document name
    if m = xref_string.match(long_no_separator)

      # If it ends in '.adoc', it's a document name
      if docname = m[1].match(/(.*)\.adoc$/)
        @document = docname[1]
      else
        @id = m[1]
      end

      @label = m[2]

    # Inline macro with '#' separator
    elsif m = xref_string.match(long_with_separator)

      @document = m[1]

      # Strip '.adoc' from document name
      if docname = @document.match(/(.*)\.adoc$/)
        @document = docname[1]
      end

      # ID is optional in this form
      if m[2].length > 0
        @id = m[2]
      end

      @label = m[3]

    # Short <<>> syntax with no '#' separator
    elsif m = xref_string.match(short_no_separator)

      # If it ends in '.adoc', it's a document name
      if docname = m[1].match(/(.*)\.adoc$/)
        @document = docname[1]
      else
        @id = m[1]
      end

      @label = m[2]

    # Short <<>> syntax with with '#' separator
    elsif m = xref_string.match(short_with_separator)

      @document = m[1]

      # Strip '.adoc' from document name
      if docname = @document.match(/(.*)\.adoc$/)
        @document = docname[1]
      end

      # ID is optional in this form
      if m[2].length > 0
        @id = m[2]
      end

      @label = m[3]
    end
  end

  def print
    if @document and @id
      puts "<a href=\"#{@document}.html##{@id}\">#{@label}</a>"
    elsif @document
      puts "<a href=\"#{@document}.html\">#{@label}</a>"
    else
      puts "<a href=\"##{@id}\">#{@label}</a>"
    end
  end

  attr_reader :document, :id, :label
end


xref = Xref.new('xref:foo[Foo]').print
xref = Xref.new('xref:bar#[Bar]').print
xref = Xref.new('xref:bar.adoc[Bar]').print
xref = Xref.new('xref:bar.adoc#[Bar]').print
xref = Xref.new('xref:bar#foo[Foobar]').print
xref = Xref.new('xref:bar.adoc#foo[Foobar]').print

xref = Xref.new('<<foo,Foo>>').print
xref = Xref.new('<<bar#,Bar>>').print
xref = Xref.new('<<bar.adoc,Bar>>').print
xref = Xref.new('<<bar.adoc#,Bar>>').print
xref = Xref.new('<<bar#foo,Foobar>>').print
xref = Xref.new('<<bar.adoc#foo,Foobar>>').print


