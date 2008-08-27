
begin
  require 'rubygems'
  require 'rake/gempackagetask'
rescue Exception
  nil
end

require 'rake/clean'
require 'rake/testtask'

PKG_VERSION = "0.1.14"

desc "Default Task"
task :default => :test_all

desc "Run all tests"
task :test_all => [:test_units]

Rake::TestTask.new("test_units") do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end

PKG_FILES = FileList[
  '[A-Z]*',
  'bin/**/*',
  'lib/**/*.rb',
  'plugins/**/*',
  'test/plugins/**/*',
  'test/**/*.rb'
]


if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  spec = Gem::Specification.new do |s|

    #### Basic information.

    s.name = 'ignite'
    s.version = PKG_VERSION
    s.summary = "start a new project with ignite"
    s.description = <<-EOF
      ignite will create the skeleton structure for a variety of projects
    EOF

    #### Dependencies and requirements.

    #s.requirements << ""

    #### Which files are to be included in this gem?  Everything!  (Except SVN directories.)

    s.files = PKG_FILES.to_a.delete_if {|f| f.include?('.svn')}

    #### C code extensions.

    #s.extensions << "ext/rmagic/extconf.rb"

    #### Load-time details: library and application (you will need one or both).

    s.require_path = 'lib'                         # Use these for libraries.

    s.bindir = "bin"                               # Use these for applications.
    s.executables = ["ignite"]
    s.default_executable = "ignite"

    #### Documentation and testing.
    s.rdoc_options << '--exclude' << '.'
    s.has_rdoc = false

#    s.has_rdoc = true
#    s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
#    s.rdoc_options <<
#      '--title' <<  'Rake -- Ruby Make' <<
#      '--main' << 'README' <<
#      '--line-numbers'

    #### Author and project details.

    s.author = "Inderjit Gill"
    s.email = "indy@chebz.com"
    s.homepage = "http://ignite.chebz.com"
#    s.rubyforge_project = "rake"
#     if ENV['CERT_DIR']
#       s.signing_key = File.join(ENV['CERT_DIR'], 'gem-private_key.pem')
#       s.cert_chain  = [File.join(ENV['CERT_DIR'], 'gem-public_cert.pem')]
#     end
  end

  package_task = Rake::GemPackageTask.new(spec) do |pkg|
#    pkg.need_zip = true
    pkg.need_tar = true
  end
end
