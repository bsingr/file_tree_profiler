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
        its(:size) { should == 11 }

        specify do
          subject.pairings.map{|k,v| k}.should == \
            ["/", "/foo", "/foo/bar.txt", "/foo/foo.txt", "/foo2", "/foo2/bar.txt", "/foo2/baz", "/foo2/baz/foo.txt", "/foo2/foo.txt", "/foo2/baz.txt", "/partially_different.txt"]
        end

        shared_examples_for :pairing do |relative_path, expected_status, expected_status_leaf|
          expected_status = {
            :equal => FileTreeProfiler::Merge::Pairing::EQUAL,
            :different => FileTreeProfiler::Merge::Pairing::DIFFERENT,
            :only_target => FileTreeProfiler::Merge::Pairing::ONLY_TARGET,
            :only_source => FileTreeProfiler::Merge::Pairing::ONLY_SOURCE
          }[expected_status] || raise("unknown status = '#{expected_status}'")
          context relative_path do
            subject { merge[relative_path] }
            its(:relative_path) { should == relative_path }
            its(:parent_relative_path) { should == ::File.dirname(relative_path) }
            its(:name) { should == ::File.basename(relative_path) }
            its(:class) { should == FileTreeProfiler::Merge::Pairing }
            its(:status) { should == expected_status }
            its(:status_leaf) { should == expected_status_leaf }
          end
        end

        include_examples :pairing, '/foo', :equal, true
        include_examples :pairing, '/foo/bar.txt', :equal, false
        include_examples :pairing, '/foo/foo.txt', :equal, false
        include_examples :pairing, '/partially_different.txt', :only_target, true
        include_examples :pairing, '/foo2/baz', :equal, true
        include_examples :pairing, '/foo2/baz/foo.txt', :equal, false
        include_examples :pairing, '/foo2/bar.txt', :only_source, true
        include_examples :pairing, '/foo2/baz.txt', :only_target, true
        include_examples :pairing, '/foo2/foo.txt', :different, false
      end
    end
  end
end
