require 'sequel'

module FileTreeProfiler
  module Export
    class SQL
      attr_reader :profile, :config, :root_id
      def initialize(profile, config)
        @profile = profile
        @config = config

        Sequel.connect(config) do |db|
          create_schema db
          @root_id = db[:roots].insert(:path => profile.root.path)
          profile db, profile.root
        end
      end

      def create_schema db
        db.create_table :roots do
          primary_key :id
          String :path, :unique => true
        end unless db.table_exists? :roots
        db.create_table :files do
          primary_key :id
          foreign_key :root_id
          String :type
          String :name
          String :path
          String :relative_path
          String :checksum
          Boolean :empty
          Integer :size
          index :type
          index [:root_id, :path], :unique => true
          index :checksum
        end unless db.table_exists? :files
      end

      def insert_file db, file
        db[:files].insert(
          :root_id => root_id,
          :type => (file.class == DirFile ? 'dir' : 'data'),
          :path => file.path,
          :relative_path => file.relative_path,
          :name => file.name,
          :checksum => file.checksum,
          :empty => file.empty?,
          :size => file.size)
      end

      def profile db, dir_file
        insert_file db, dir_file
        dir_file.children.each do |child|
          if child.class == DirFile
            profile db, child
          else
            insert_file db, child
          end
        end
      end
    end
  end
end
