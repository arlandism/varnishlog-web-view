require 'rspec'
require 'varnish_log_analyzer/tag_description'

describe VarnishLogAnalyzer::TagDescription do

  it "returns an 'unavailable'-like message if it can't find a description" do
    unavailable_message = "No description available"
    expect(VarnishLogAnalyzer::TagDescription.for("foobar")).to eq(unavailable_message)
  end
end
