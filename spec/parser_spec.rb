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

end
