require_relative 'lib/sinopac/funbiz/version'

Gem::Specification.new do |spec|
  spec.name          = "sinopac-funbiz"
  spec.version       = Sinopac::FunBiz::VERSION
  spec.authors       = ["eddie"]
  spec.email         = ["eddie@5xcampus.com"]

  spec.summary       = %q{API Wrapper for SinoPac FunBiz Payment}
  spec.description   = %q{API Wrapper for SinoPac FunBiz Payment}
  spec.homepage      = "https://kaochenlong.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
