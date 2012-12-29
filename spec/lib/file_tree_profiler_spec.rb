require 'spec_helper'

describe FileTreeProfiler do
  it 'profiles' do
    described_class.profile(example_folder).should be_instance_of(described_class::Profile)
  end

  context :profile do
    let(:profile) { described_class.profile(example_folder) }
    subject { profile }
    its(:size) {should == 6}
    its(:root) {should be_instance_of(described_class::RootDirFile)}

    context :root do
      subject { profile.root }

      its(:checksum) { should_not == described_class::DirFile::EMPTY_CHECKSUM }
      its(:name) { should == File.basename(example_folder) }
      its(:path) { should include(example_folder) }
      
      it 'has no parent' do
        lambda { subject.parent}.should raise_error
      end

      it 'has child folders' do
        subject.children.map(&:name).should == %w[ a b ]
      end

    end
  end

end
