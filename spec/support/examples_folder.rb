def example_folder *parts
  root_parts = [File.dirname(__FILE__), '..', 'example_folders']
  if parts.empty?
    File.join(*root_parts)
  else
    File.join(*root_parts, *parts)
  end
end
