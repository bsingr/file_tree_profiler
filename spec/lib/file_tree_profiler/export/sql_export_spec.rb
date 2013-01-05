require 'spec_helper'

describe FileTreeProfiler::Export::SQL do
  before { File.unlink('rspec.sqlite3') if File.exists?('rspec.sqlite3') }

  it 'profiles' do
    profile = FileTreeProfiler.profile(example_folder)
    profile.size.should == 10
    described_class.new(profile, 'sqlite://rspec.sqlite3')
    db = Sequel.connect('sqlite://rspec.sqlite3')
    db[:files].count.should == 10
    db[:files].where(:type => 'dir').count.should == 5
    db[:files].where(:type => 'data').count.should == 5
    db[:roots].count.should == 1
  end
end
