require 'spec_helper'

describe FileTreeProfiler do
  let(:profile) { described_class.profile(example_folder) }

  it 'profiles' do
    profile.should be_instance_of(described_class::Profile)
  end

  it 'raises error on profiling data file' do
    path = example_folder('a', 'a.txt')
    lambda { described_class.profile(path) }.should \
      raise_error(ArgumentError, "Not a directory - #{path}")
  end

  it 'csv' do
    described_class.csv(profile, 'test')
  end

  context :profile do
    subject { profile }
    its(:size) {should == 10}
    its(:root) {should be_instance_of(described_class::DirFile)}

    context :root do
      subject { profile.root }

      its(:checksum) { should_not == described_class::DirFile::EMPTY_CHECKSUM }
      its(:checksum) { should be_instance_of(String) }
      its(:name) { should == File.basename(example_folder) }
      its(:path) { should include(example_folder) }

      it 'has child folders' do
        subject.children.map(&:name).should == %w[ a b empty ]
      end

    end
  end

end
