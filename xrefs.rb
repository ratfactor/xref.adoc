class Environment
  # Describing the document environment and types of tests being run.
  attr_accessor :description

  # test_source_document is the document path FROM WHICH the
  # links are being tested, in other words it's the document
  # in which the links exist.
  attr_accessor :test_source_document

  # The type of export to perform:
  #     :one_to_one  - one output file is generated for every .adoc source document
  #     :one_to_many - multiple files are generated for every .adoc source document
  #     :many_to_one - one file is generated for ALL .adoc source documents
  attr_accessor :export_type

  def print
    # Prints a heading and list of properties for this test environment.
    puts "<h2>#{@description}</h2>"
    puts "<ul>"
    puts "<li>Source Document: <code>#{@test_source_document}</code>"
    puts "<li>Type of export: <code>#{@export_type}</code>"
    puts "</ul>"
  end
end

class Xref
  def initialize(env, xref_string)
    @env = env
    @raw = xref_string

    # This xref link's properties
    @document = nil
    @id       = nil
    @label    = nil

    # xref matching patterns
    long_no_separator   = /xref:([^\[#]+)\[([^\]]*)\]/
    long_with_separator = /xref:([^\[#]+)#([^\[]*)\[([^\]]*)\]/
    short_no_separator   = /<<([^,#]+),([^>]*)>>/
    short_with_separator = /<<([^,#]+)#([^,]*),([^>]*)>>/

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

    if(@document)
      @document = normalize_link_path(@document)
    end
  end

  def normalize_link_path(link_path)
    # Perform relative path traversal from the source document to the link
    rel_path = @env.test_source_document.split("/")

    # throw away last segment (foo.adoc)
    rel_path.pop 

    link_path.split("/").each do |seg|
      if seg.eql?('..')
        rel_path.pop
      else
        rel_path.push seg
      end
    end

    rel_path.join('/')
  end

  def make_relative_path(link)
    # Perform path comparison between the source document and the link to make
    # a relative path between the two.
    doc_path = @env.test_source_document.split("/")
    doc_path.pop #throw away last segment (foo.adoc)

    link_path = link.split("/")
    link_file = link_path.pop # store the last segment (foo.adoc)

    rel_path = []
    path_diverged = false

    # Starting at the front, compare the requested link path to the current
    # source document path.
    link_path.each do |seg|
      # If the document source path is empty, we're now going "down"
      if doc_path.empty?
        rel_path.push seg
        next
      end

      # If the document source segment exists but is different, prepend a
      # "../" segment to go "up" and add the link segment to the end.
      if not seg.eql?(doc_path.shift) or path_diverged
        rel_path.unshift '..'
        rel_path.push seg
        path_diverged = true # once the path is different, it stays different
      end

      # If the segments were equal, then we don't need to add anything to the path.
    end

    # For any remaining doc path segments, we need to go "up" a segment
    doc_path.each{ |seg| rel_path.unshift '..' }

    # Add "file" back
    rel_path.push link_file

    rel_path.join('/')
  end

  def self.printStart
    puts '<table><thead><tr>'
    puts '  <th>Xref</th>'
    puts '  <th>Target</th>'
    puts '  <th>Location ID</th>'
    puts '  <th>Output "Path"</th>'
    puts '  <th>Output Source</th>'
    puts '  <th>Output</th>'
    puts '</tr></thead><tbody>'
  end

  def self.printEnd
    puts '</tbody></table>'
  end

  def print
    if @document
      link = make_relative_path @document
    else
      link = ""
    end

    # Next: if @env.export_type == :many_to_one

    html_link = ""

    if @document and @id
      html_link = "<a href=\"#{link}.html##{@id}\">#{@label}</a>"
    elsif @document
      html_link = "<a href=\"#{link}.html\">#{@label}</a>"
    else
      html_link = "<a href=\"##{@id}\">#{@label}</a>"
    end
    # Prints a table row for this link nugget
    puts "<tr>"
    puts "  <td>#{htmlEntitiesLite(@raw)}</td>"
    puts "  <td>#{@document}</td>"
    puts "  <td>#{@id}</td>"
    puts "  <td>#{htmlEntitiesLite(link)}</td>"
    puts "  <td>#{htmlEntitiesLite(html_link)}</td>"
    puts "  <td>#{html_link}</td>"
    puts "</tr>"
  end

  def htmlEntitiesLite(str)
    str.gsub(/[<>]/, '<' => '&lt;', '>' => '&gt;')
  end

  attr_reader :document, :id, :label
end
