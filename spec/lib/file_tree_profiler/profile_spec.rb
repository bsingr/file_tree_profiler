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

      context :merge do
        let(:merge) { FileTreeProfiler::Merge.new(profile_a, profile_c) }
        subject { merge }
        its(:size) { should == 5 }

        specify do
          subject.files.map{|k,v| k}.should == \
            ["/", "/foo", "/foo/bar.txt", "/foo/foo.txt", "/partially_different.txt"]
        end

        context '/foo' do
          subject { merge['/foo'] }
          its(:class) { should == FileTreeProfiler::Merge::Files }
          its(:name) { should == 'foo'}
          its(:relative_path) { should == '/foo' }
          its(:parent_relative_path) { should == '/' }
          its(:status) { should == FileTreeProfiler::Merge::Files::EQUAL }
          its(:status_leaf) { should == true }
        end
        context '/foo/bar.txt' do
          subject { merge['/foo/bar.txt'] }
          its(:class) { should == FileTreeProfiler::Merge::Files }
          its(:name) { should == 'bar.txt'}
          its(:relative_path) { should == '/foo/bar.txt' }
          its(:parent_relative_path) { should == '/foo' }
          its(:status) { should == FileTreeProfiler::Merge::Files::EQUAL }
          its(:status_leaf) { should == false }
        end 
        context '/foo/foo.txt' do
          subject { merge['/foo/foo.txt'] }
          its(:class) { should == FileTreeProfiler::Merge::Files }
          its(:name) { should == 'foo.txt'}
          its(:relative_path) { should == '/foo/foo.txt' }
          its(:parent_relative_path) { should == '/foo' }
          its(:status) { should == FileTreeProfiler::Merge::Files::EQUAL }
          its(:status_leaf) { should == false }
        end 
        context '/partially_different.txt' do
          subject { merge['/partially_different.txt'] }
          its(:class) { should == FileTreeProfiler::Merge::Files }
          its(:name) { should == 'partially_different.txt'}
          its(:relative_path) { should == '/partially_different.txt' }
          its(:parent_relative_path) { should == '/' }
          its(:status) { should == FileTreeProfiler::Merge::Files::ONLY_TARGET }
          its(:status_leaf) { should == true }
        end
      end
    end
  end
end
