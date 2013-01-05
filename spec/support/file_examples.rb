  shared_examples_for :file_on_root_level do
    its(:relative_path) { should == '/' }
  end

  shared_examples_for :file_on_sub_level do |sub_path|
    its(:relative_path) { should == sub_path }
  end
  