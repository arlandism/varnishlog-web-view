require "rspec"
require "varnish_log_analyzer/parser"

describe VarnishLogAnalyzer::Parser do

  let(:log_contents) { File.new("spec/fixtures/sample_log.txt").read }
  let(:parser) { VarnishLogAnalyzer::Parser.new(log_contents) }

  it "filters by transaction" do
    transaction_zero = parser.filter_by_transaction(0)
    expect(transaction_zero.count).to eq(4)
    expect(transaction_zero[0][:tag]).to eq("CLI")
    expect(transaction_zero[0][:description]).to eq("Communication between varnishd master and child process")
    expect(transaction_zero[0][:transaction_number]).to eq(0)
  end

  it "shows all transactions" do
    transactions = parser.classified_transactions
    expect(transactions.count).to eq(34)
    transaction_numbers = transactions.map do |transaction|
      transaction[:transaction_number]
    end
    expect(transaction_numbers.to_set).to eq(Set.new([0, 13, 14, 11]))
  end

end
