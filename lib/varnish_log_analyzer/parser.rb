require 'varnish_log_analyzer/tag_description'

module VarnishLogAnalyzer
  class Parser

    def initialize(log_contents)
      @log = log_contents
    end

    def filter_by_transaction(transaction_number)
      classified_transactions.select do |transaction|
        transaction[:transaction_number] == transaction_number
      end
    end

    def classified_transactions
      @classified_transactions ||= raw_transactions.map { |trans| classify_transaction(trans)}
    end

    private

    def raw_transactions
      @raw_transactions ||= @log.split("\n")
    end

    def classify_transaction(transaction)
      tokens = transaction.split
      transaction_number = tokens[0].to_i
      tag = tokens[1]
      additional_info = tokens[3..-1].join(" ")
      {
        :transaction_number => transaction_number,
        :tag => tag,
        :description => find_description(tag),
        :details => additional_info
      }
    end

    def find_description(tag)
      TagDescription.for(tag)
    end
  end
end
