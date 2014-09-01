require "rspec"
require "varnish_log_analyzer/parser"

describe VarnishLogAnalyzer::Parser do

  class MockLog

    attr_reader :read_from

    def initialize(contents)
      @contents = contents
    end

    def read
      @read_from = true
      @contents || "13 TxRequest b GET"
    end

  end

  let(:log) { MockLog.new(File.new("spec/fixtures/sample_log.txt").read) }
  let(:parser) { VarnishLogAnalyzer::Parser.new(log) }

  it "reads from the log" do
    parser.classified_transactions
    expect(log.read_from).to eq true
  end

  it "filters by transaction" do
    transaction_zero = parser.filter_by_transaction(0)
    expect(transaction_zero.count).to eq(4)
    expect(transaction_zero[0][:tag]).to eq("CLI")
    expect(transaction_zero[0][:description]).to eq("Communication between varnishd master and child process")
    expect(transaction_zero[0][:details]).to eq("Rd ping")
    expect(transaction_zero[0][:transaction_number]).to eq(0)
    expect(transaction_zero[0][:collaborator]).to eq("-")
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
