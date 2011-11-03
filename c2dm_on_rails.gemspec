Gem::Specification.new do |s|
  s.name = 'c2dm_on_rails'
  s.rubyforge_project = 'c2dm_on_rails'
  s.version = '0.4.2.asynchrony.3'
  s.date = Date.today

  s.homepage = 'http://github.com/asynchrony/c2dm_on_rails'
  s.authors = ['Julius de Bruijn', 'Asynchrony Solutions T1D Team']
  s.email = 't1d@asolutions.com'
  s.summary = 'Android push notifications on Rails. (Mongoid version)'
  s.description = 'Android push notifications on Rails. (Mongoid version)' +
          'Requires an account on Android Cloud to Device Messaging service (http://code.google.com/android/c2dm/)'

  s.rubygems_version = '1.8.6'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")  
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }  
  s.require_paths = ["lib"] 
  s.extra_rdoc_files = [
    "LICENSE",
    "CHANGELOG",
    "README.textile"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_dependency(%q<actionpack>, ["~> 3.0"])
      s.add_dependency(%q<mongoid>, ["~> 2.1.9"])
      s.add_dependency(%q<gdata>, [">= 1.1.1"])
    else
      s.add_dependency(%q<actionpack>, ["~> 3.0"])
      s.add_dependency(%q<mongoid>, ["~> 2.1.9"])
      s.add_dependency(%q<gdata>, [">= 1.1.1"])
    end
  else
    s.add_dependency(%q<actionpack>, ["~> 3.0"])
    s.add_dependency(%q<mongoid>, ["~> 2.1.9"])
    s.add_dependency(%q<gdata>, [">= 1.1.1"])
  end
end
