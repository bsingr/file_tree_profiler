require 'spec_helper'

describe FileTreeProfiler::DataFile do
  let(:parent_mock) do
    mock('parent').tap do |mock|
      mock.stub(:path).and_return(example_folder('a'))
    end
  end

  context :empty do
    let(:data_file) { described_class.new(parent_mock, 'empty.txt') }
    subject { data_file }

    its(:checksum) { should == described_class::EMPTY_CHECKSUM }
    its(:name) { should == 'empty.txt' }
    its(:empty?) { should be_true }
  end

  context :not_empty do
    let(:data_file) { described_class.new(parent_mock, 'a.txt') }
    subject { data_file }

    its(:checksum) { should == 'a5e54d1fd7bb69a228ef0dcd2431367e' }
    its(:name) { should == 'a.txt' }
    its(:empty?) { should be_false }
  end
end
