## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'looper'
  s.version           = '0.0.1'
  s.date              = '2013-01-28'
  s.rubyforge_project = 'looper'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "looper lets you examine your current C repository."
  s.description = "TODO: to be written soon!"

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Huascar Sanchez"]
  s.email    = 'huascar.sanchez@gmail.com'
  s.homepage = 'https://github.com/hsanchez/looper'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## This sections is only necessary if you have C extensions.
  #s.require_paths << 'ext'
  #s.extensions = %w[ext/extconf.rb]

  ## If your gem includes any executables, list them here.
  s.executables = ["looper"]
  s.default_executable = 'looper'

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.markdown LICENSE.markdown]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('multi_json', "~> 1.5.0")
  s.add_dependency('json_pure', "~> 1.7.6")
  s.add_dependency('cast')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('mocha', "~> 0.13.2")
  s.add_development_dependency('rake', "~> 10.0.3")

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    bin/looper
    looper.gemspec
    lib/looper.rb
    lib/looper/color.rb
    lib/looper/command.rb
    lib/looper/config.rb
    lib/looper/core_ext/symbol.rb
    lib/looper/item.rb
    lib/looper/result.rb
    lib/looper/project.rb
    lib/looper/platform.rb
    lib/looper/storage.rb
    lib/looper/storage/base.rb
    lib/looper/storage/json.rb
    test/examples/config_json.json
    test/examples/test_json.json
    test/examples/urls.json
    test/helper.rb
    test/test_color.rb
  ]
  # TODO: add all tests above, e.g., (after test_color.rb) test/test_commands.rb
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end