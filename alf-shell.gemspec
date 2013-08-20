$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "alf/shell/version"
$version = Alf::Shell::Version.to_s

Gem::Specification.new do |s|
  s.name = "alf-shell"
  s.version = $version
  s.summary = "Bring Alf's relational algebra to the shell"
  s.description = "This project implements the `alf` commandline tool."
  s.homepage = "http://github.com/alf-tool/alf-shell"
  s.authors = ["Bernard Lambeau"]
  s.email  = ["blambeau at gmail.com"]
  s.require_paths = ['lib']
  here = File.expand_path(File.dirname(__FILE__))
  s.files = File.readlines(File.join(here, 'Manifest.txt')).
                 inject([]){|files, pattern| files + Dir[File.join(here, pattern.strip)]}.
                 collect{|x| x[(1+here.size)..-1]}
  s.bindir = "bin"
  s.executables = (Dir["bin/*"]).collect{|f| File.basename(f)}
  s.add_development_dependency("rake", "~> 10.1")
  s.add_development_dependency("rspec", "~> 2.14")
  s.add_development_dependency("highline", "~> 1.6")
  s.add_dependency("alf-core", "~> 0.14.0")
  s.add_dependency("quickl", "~> 0.4.3")
end
