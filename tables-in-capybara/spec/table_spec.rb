require_relative './spec_helper'

describe Table do
  let(:table) do
    table = Table.new
    table.headers = ['Name', 'Age', 'Occupation']
    table.rows = [
      ['John Smith', 18, 'Software Development'],
      ['Jane Doe', 19, 'Engineering']
    ]

    table
  end

  describe '#to_node' do
    subject { table.to_node }

    it 'returns a Capybara node' do
      expect(subject.class).to be(Capybara::Node::Simple)
    end

    it 'can be queried' do
      # node#find should give back a single object or fail
      subject.find('td', text: 'Jane Doe')
      expect(subject.respond_to?(:find)).to be(true)

      # node#all should give back a list of matching objects
      expect(subject.respond_to?(:all)).to be(true)
      subject.all('thead th')
    end

    it 'can be converted into Hash objects' do
      headers = subject.all('thead th').map(&:text)
      rows = subject.all('tbody tr').map do |row|
        cells = row.all('td')

        Hash[headers.zip(cells.map(&:text))]
      end

      expect(rows).to include(a_hash_including('Occupation' => 'Software Development'))
    end
  end
end
