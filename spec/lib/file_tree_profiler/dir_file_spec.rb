require 'spec_helper'

describe FileTreeProfiler::DirFile do
  let(:parent_mock) do
    mock('parent').tap do |mock|
      mock.stub(:path).and_return(example_folder)
    end
  end

  context :empty do
    let(:data_file) { described_class.new(parent_mock, 'empty') }
    subject { data_file }

    its(:checksum) { should == described_class::EMPTY_CHECKSUM }
    its(:name) { should == 'empty' }
    its(:empty?) { should be_true }
  end

  context :not_empty do
    let(:data_file) { described_class.new(parent_mock, 'a') }
    subject { data_file }

    its(:checksum) { should == 'b4a6462b066f2cb768021e156cb72343' }
    its(:name) { should == 'a' }
    its(:empty?) { should be_false }
  end
end
