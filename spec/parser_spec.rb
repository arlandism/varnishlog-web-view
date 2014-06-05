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
    expect(transaction_zero[0][:details]).to eq("Rd ping")
    expect(transaction_zero[0][:transaction_number]).to eq(0)
  end

  shared_examples_for "a transaction retriever" do |transaction, tag, description, details, transaction_number|

    it "includes the tag" do
      expect(transaction[0][:tag]).to eq(tag)
    end

    it "includes the description" do
      expect(transaction[0][:description]).to eq(description)
    end

    it "includes the details" do
      expect(transaction[0][:details]).to eq(details)
    end

    it "includes the transaction number" do
      expect(transaction[0][:transaction_number]).to eq(transaction_number)
    end

  end

  describe "#filter_by_transaction" do

    # Taken from sample log file
    let (:tag) { "CLI" }
    let (:description) { "Communication betwen varnishd master and child process" }
    let (:details) { "Rd ping" }
    let (:transaction_number) { 0 }
    let (:matching_transactions) { 4 }

    it "returns only transactions matching the transaction number" do
      transaction_zero = parser.filter_by_transaction(transaction_number)
      expect(transaction_zero.count).to eq(matching_transactions)
      expect(transaction_zero[0][:transaction_number]).to eq(transaction_number)
    end

    it_should_behave_like "a transaction retriever", tag, description, details, transaction_number

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
