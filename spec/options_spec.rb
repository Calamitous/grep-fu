require 'grep-fu/options'
require 'spec/spec_helper'

describe GrepFu::Options do
  it "should instantiate correctly" do
    GrepFu::Options.new([])
  end

  it "should set the verbose option to true, if provided" do
    GrepFu::Options.new(['--verbose']).verbose.should be_true
  end

  it "should set the single-line option to true, if provided" do
    GrepFu::Options.new(['--single-line']).single_line.should be_true
  end

  it "should set the color option to true, if provided" do
    GrepFu::Options.new(['--color']).color.should be_true
  end

  it "should default to no color" do
    GrepFu::Options.new([]).color.should be_false
  end

  it "should allow color to be disabled from the command line" do
    GrepFu::Options.new(['--no_color']).color.should be_false
  end

  it "should change color default based on constant" do
    silence_warnings { GrepFu::Options::COLOR_ON_BY_DEFAULT = true }
    GrepFu::Options.new([]).color.should be_true
  end

  it "should allow color to be disabled from the command line when default is color=true" do
    silence_warnings { GrepFu::Options::COLOR_ON_BY_DEFAULT = true }
    GrepFu::Options.new(['--no-color']).color.should be_false
  end

  it "should set the search criteria to the last non-option flag in the list" do
    GrepFu::Options.new(%w{offer}).search_criteria.should == 'offer'
    GrepFu::Options.new(%w{a help --color}).search_criteria.should == 'help'
    GrepFu::Options.new(%w{lib/tasks unrake --verbose --color}).search_criteria.should == 'unrake'
  end

  it "should expand the file_path to one of the replacement variables, if found" do
    GrepFu::Options.new(%w{a value}).file_path.should == 'app'
    GrepFu::Options.new(%w{s hoozits}).file_path.should == 'spec'
    GrepFu::Options.new(%w{mig down --color}).file_path.should == 'db/migrate'
  end

  it "should accept an explicit find path, if provided" do
    GrepFu::Options.new(%w{lib/tasks value}).file_path.should == 'lib/tasks'
  end

end
