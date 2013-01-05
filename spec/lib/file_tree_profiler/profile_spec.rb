require 'spec_helper'

describe FileTreeProfiler::Profile do
  let(:profile) { described_class.new(example_folder('a')) }
  subject { profile }
  
  its(:checksum) { should == 'f3a9e0021f70623bb7e17ed325373d6d' }
  its(:size) { should == 5 }

  its(:root) { should be_instance_of(FileTreeProfiler::DirFile) }

  context :root do
    subject { profile.root }

    its(:name) { should == 'a' }
    its(:checksum) { should == profile.checksum }
    its(:size) { should == profile.size }
  end
end
