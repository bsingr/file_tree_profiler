require 'spec_helper'

describe FileTreeProfiler::Profile do
  let(:profile) { described_class.new(example_folder('a')) }
  subject { profile }
  
  its(:checksum) { should == 'b4a6462b066f2cb768021e156cb72343' }
  its(:size) { should == 3 }

  its(:root) { should be_instance_of(FileTreeProfiler::DirFile) }

  context :root do
    subject { profile.root }

    its(:name) { should == 'a' }
    its(:checksum) { should == profile.checksum }
    its(:size) { should == profile.size }
  end
end
