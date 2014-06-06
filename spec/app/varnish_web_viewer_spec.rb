require 'rspec'
require 'rack/test'
require 'varnish_log_analyzer/tag_description'
require_relative '../../app/varnish_web_viewer'

describe VarnishWebViewer do

  include Rack::Test::Methods

  def app
    VarnishWebViewer.new
  end

  it "gets the tag description for a given tag" do
    expect(VarnishLogAnalyzer::TagDescription).to receive(:for).with("foo")
    get '/tag/foo'
  end
end
