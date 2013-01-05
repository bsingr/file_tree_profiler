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

  context :equals do
    let(:profile_a) { described_class.new(example_folder('equals', 'profile_a')) }
    let(:profile_b) { described_class.new(example_folder('equals', 'profile_b')) }
    subject { profile_a }
    its(:checksum) { should == profile_b.checksum }
  end

  context :differents do
    let(:profile_a) { described_class.new(example_folder('differents', 'profile_a')) }
    let(:profile_b) { described_class.new(example_folder('differents', 'profile_b')) }
    let(:profile_c) { described_class.new(example_folder('differents', 'profile_c')) }
    subject { profile_a }
    its(:checksum) { should_not == profile_b.checksum }
    its(:checksum) { should_not == profile_c.checksum }

    context :partially do
      specify { profile_a.root.children.first.name.should == profile_c.root.children.first.name }
      specify { profile_a.root.children.first.checksum.should == profile_c.root.children.first.checksum }
    end
  end
end
