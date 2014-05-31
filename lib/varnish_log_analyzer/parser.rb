require 'varnish_log_analyzer/tag_description'

module VarnishLogAnalyzer
  class Parser

    def initialize(log_contents)
      @log = log_contents
    end

    def filter_by_transaction(transaction_number)
      classified_transactions.take(4)
    end

    private

    def classified_transactions
      transactions = @log.split("\n")
      @classified_transactions ||= transactions.map { |trans| classify_transaction(trans)}
    end

    def classify_transaction(transaction)
      tokens = transaction.split
      tag = tokens[1]
      {
        :tag => tag,
        :description => find_description(tag)
      }
    end

    def find_description(tag)
      TagDescription.for(tag)
    end
  end
end
