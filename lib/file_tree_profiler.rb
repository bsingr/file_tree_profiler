require 'digest/md5'
require 'file_tree_profiler/version'
require 'file_tree_profiler/file'
require 'file_tree_profiler/data_file'
require 'file_tree_profiler/dir_file'
require 'file_tree_profiler/profile'
require 'file_tree_profiler/merge/pairing'
require 'file_tree_profiler/merge'
require 'file_tree_profiler/export/csv'
require 'file_tree_profiler/export/sql'

module FileTreeProfiler
  def self.profile path
    Profile.new path
  end

  def self.csv profile, basename
    Export::CSV.new profile, basename
  end

  def self.sql profile, config
    Export::SQL.new profile, config
  end
end
