begin
  require 'FileUtils'
rescue Exception

end

class Dir
  def self.list_files(dirname)
    files = []
    Dir.foreach(dirname) do |file| 
      files << file if FileTest.file?(File.join(dirname, file))
    end
    files
  end

  def self.list_directories(dirname)
    files = []
    Dir.foreach(dirname) do |file| 
      files << file unless FileTest.file?(File.join(dirname, file)) || file == "." || file == ".."
    end
    files
  end

  def self.ensure_exists path
    folders = path.split('/')

    check = '';
    if(path[0] == '/' && ENV['OS'] !~ /^Windows/)
      check = '/' 
    end

    folders.each do |d|
      begin
        check << d + '/'
        Dir.entries(check)
      rescue SystemCallError
        Dir.mkdir(check)
      end
    end
  end
end
