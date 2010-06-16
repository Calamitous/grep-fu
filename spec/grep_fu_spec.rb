require 'grep-fu'
require 'spec/spec_helper'

describe GrepFu do
  describe "#run!" do
    before(:each) do
      GrepFu.stub!(:puts)
    end

    describe "with no arguments provided" do
      it "should print the usage and exit if no arguments are provided" do
        GrepFu::Options.should_receive(:usage).and_return('Usage: etc.')
        GrepFu.should_receive(:puts).with('Usage: etc.')
        GrepFu.run!
      end

      it "should exit early if no arguments are provided" do
        GrepFu::Options.should_not_receive(:new)
        GrepFu.run!
      end
    end

    describe "with valid arguments" do
      before(:each) do
        @options = mock(GrepFu::Options, :verbose => false, :single_line => false)
        @find_command = "find me"
        GrepFu::Options.stub!(:new).and_return(@options)
        GrepFu::FindBuilder.stub!(:find_command).and_return(@find_command)
        GrepFu.stub!(:'`')
      end

      it "should create options from provided arguments" do
        GrepFu::Options.should_receive(:new).with('arguments!')
        GrepFu.run!('arguments!')
      end

      it "should build a find command from options" do
        GrepFu::FindBuilder.should_receive(:find_command).with(@options)
        GrepFu.run!('arguments!')
      end

      it "should display the results of the find" do
        GrepFu.should_receive(:'`').with(@find_command)
        GrepFu.run!(['stuff_to_find'])
      end

      it "should appropriately format results for single-line requests" do
        @options.stub!(:single_line).and_return(true)
        GrepFu.stub!(:'`').and_return("line one\nline two\nlast line\n")
        GrepFu.should_receive(:puts).with('line one line two last line')
        GrepFu.run!(['--single-line'])
      end

      it "should appropriately format results for verbose requests" do
        @options.stub!(:verbose).and_return(true)
        verbose_returns = [
          "app/views/mailer/new_notification.text.plain.erb:1:A new notification has arrived!",
          "README:45:                    although it's not clear who might have",
          "app/models/funge.rb:22:       Hugenot.new"
        ].join("\n")

        formatted_returns = [
          "app/views/mailer/new_notification.text.plain.erb:1:\n\tA new notification has arrived!",
          "README:45:\n\talthough it's not clear who might have",
          "app/models/funge.rb:22:\n\tHugenot.new"
        ]

        GrepFu.stub!(:'`').and_return(verbose_returns)
        GrepFu.should_receive(:puts).with(formatted_returns[0])
        GrepFu.should_receive(:puts).with(formatted_returns[1])
        GrepFu.should_receive(:puts).with(formatted_returns[2])
        GrepFu.run!(['not', '--verbose'])
      end
    end
  end
end
