require 'spec_helper'

describe FileTreeProfiler::DirFile do
  let(:parent_mock) do
    mock('parent').tap do |mock|
      mock.stub(:path).and_return(example_folder)
    end
  end

  context :empty do
    let(:dir_file) { described_class.new(parent_mock, 'empty') }
    subject { dir_file }

    its(:checksum) { should == described_class::EMPTY_CHECKSUM }
    its(:name) { should == 'empty' }
    its(:empty?) { should be_true }
    its(:path) { should match(/#{File.join('example_folders', 'empty')}$/) }
    it_behaves_like :file_on_root_level
  end

  context :not_empty do
    let(:dir_file) { described_class.new(parent_mock, 'a') }
    subject { dir_file }

    its(:checksum) { should == 'f3a9e0021f70623bb7e17ed325373d6d' }
    its(:name) { should == 'a' }
    its(:empty?) { should be_false }
    its(:path) { should match(/#{File.join('example_folders', 'a')}$/) }
    it_behaves_like :file_on_root_level
  end

  context :dir_in_dir do
    let(:parent_dir_file) { described_class.new(parent_mock, 'a') }
    let(:child_dir_file) { described_class.new(parent_dir_file, 'sub_dir_a') }
    subject { child_dir_file }

    its(:checksum) { should == '4095b34983e72363b14f12a0b5feba73' }
    its(:name) { should == 'sub_dir_a' }
    its(:empty?) { should be_false }
    its(:path) { should match(/#{File.join('example_folders', 'a', 'sub_dir_a')}$/) }
    it_behaves_like :file_on_sub_level, '/sub_dir_a'
  end
end
