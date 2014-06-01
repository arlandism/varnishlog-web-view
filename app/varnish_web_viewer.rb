$LOAD_PATH << "./lib" << "app"

require 'haml'
require 'sinatra'
require 'varnish_log_analyzer/parser'

get '/' do
  File.open("spec/fixtures/sample_log.txt", "r") do |log_file|
    @transactions = VarnishLogAnalyzer::Parser.new(log_file.read).classified_transactions
    haml :index
  end
end

get '/:transaction_number' do
  File.open("spec/fixtures/sample_log.txt") do |log_file|
      @transaction = VarnishLogAnalyzer::Parser.new(log_file.read)
        .filter_by_transaction(params[:transaction_number].to_i)
      haml :transaction
  end
end
