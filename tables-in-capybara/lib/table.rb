require 'capybara'

class Table
  attr_writer :headers
  attr_writer :rows

  def headers
    @headers ||= []
  end

  def rows
    @rows ||= []
  end

  def to_html
    row_format = "<tr><td>%s</td><td>%s</td><td>%s</td></tr>"
    content = rows.map { |row| row_format % row }.join
    header_content = "<tr><th>%s</th><th>%s</th><th>%s</th></tr>" % headers

    <<-HTML.gsub(/\s*\| /, '')
      | <table>
      |   <thead>#{header_content}</thead>
      |   <tbody>#{content}</tbody>
      | </table>
    HTML
  end

  def to_node
    Capybara::Node::Simple.new(to_html)
  end
end
