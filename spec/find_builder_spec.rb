require 'grep-fu/find_builder'
require 'spec/spec_helper'

describe GrepFu::FindBuilder do
  describe "#delicious_prunes" do
    it "should create command-line options for pruning path" do
      silence_warnings { GrepFu::FindBuilder::PRUNE_PATHS = ['/pruney'] }
      GrepFu::FindBuilder.delicious_prunes.should == "-path '*/pruney' -prune -o"
    end

    it "should create command-line options for multiple pruning paths" do
      silence_warnings { GrepFu::FindBuilder::PRUNE_PATHS = ['/pruney', '/apply'] }
      GrepFu::FindBuilder.delicious_prunes.should == "-path '*/pruney' -prune -o -path '*/apply' -prune -o"
    end
  end

  describe "#find_command" do
    before(:each) do
      GrepFu::FindBuilder.stub!(:delicious_prunes).and_return('prune_list')
      @options = mock(Object,
                      :file_path => 'path',
                      :to_s => 'str_opts',
                      :search_criteria => 'crits')
      @find_command = GrepFu::FindBuilder.find_command(@options)
    end

    it "should start with the find command" do
      @find_command.should =~ /^find\s/
    end

    it "should contain the file path" do
      @find_command.should =~ /\spath\s/
    end

    it "should contain all the pruned directories" do
      @find_command.should =~ /\sprune_list\s/
    end

    it "should contain a blob of bash muck" do
      @find_command.should =~ /\s.. -size -100000c -type f .. -print0 | xargs -0 grep\s/
    end

    it "should contain the options" do
      @find_command.should =~ /\sstr_opts\s/
    end

    it "should end with the quoted search criteria" do
      @find_command.should =~ /\s"crits"$/
    end

    it "should stitch together a long, long find command" do
      @find_command.should =~ /find path prune_list .. -size -100000c -type f .. -print0 | xargs -0 grep str_opts \"crits\"/
    end

  end

end

