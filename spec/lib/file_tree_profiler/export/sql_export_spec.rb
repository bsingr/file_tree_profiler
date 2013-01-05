require 'spec_helper'

describe FileTreeProfiler::Export::SQL do
  let(:db_file) { 'rspec.sqlite3' }
  before { File.unlink(db_file) if File.exists?(db_file) }
  let(:expected_size) { 8 }

  it 'profiles' do
    profile = FileTreeProfiler.profile(example_folder('profile-level-folder'))
    profile.size.should == expected_size
    described_class.new(profile, 'sqlite://'+db_file)
    db = Sequel.connect('sqlite://'+db_file)
    db[:files].count.should == expected_size
    db[:files].where(:type => 'dir').count.should == 4
    db[:files].where(:type => 'data').count.should == 4
    db[:roots].count.should == 1
  end
end
