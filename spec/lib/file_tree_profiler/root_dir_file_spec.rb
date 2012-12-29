require 'spec_helper'

describe FileTreeProfiler::RootDirFile do
  subject { described_class.new(example_folder('a')) }

  its(:size) { should == 2 }
  
end
