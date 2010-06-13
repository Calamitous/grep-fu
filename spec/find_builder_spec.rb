require 'grep-fu/find_builder'
require 'spec/spec_helper'

describe GrepFu::FindBuilder do
	it "should create command-line options for pruning path" do
		silence_warnings { GrepFu::FindBuilder::PRUNE_PATHS = ['/pruney'] }
		GrepFu::FindBuilder.delicious_prunes.should == "-path '*/pruney' -prune -o"
	end

	it "should create command-line options for multiple pruning paths" do
		silence_warnings { GrepFu::FindBuilder::PRUNE_PATHS = ['/pruney', '/apply'] }
		GrepFu::FindBuilder.delicious_prunes.should == "-path '*/pruney' -prune -o -path '*/apply' -prune -o"
	end
end

