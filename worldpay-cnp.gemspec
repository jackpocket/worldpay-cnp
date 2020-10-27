require_relative 'lib/worldpay_cnp/version'

Gem::Specification.new do |spec|
  spec.name          = "worldpay_cnp"
  spec.version       = WorldpayCnp::VERSION
  spec.authors       = ["Javier Julio"]
  spec.email         = ["javier@jackpocket.com"]

  spec.summary       = "A Ruby interface to the Worldpay CNP API."
  spec.description   = "A Ruby interface to the Worldpay CNP API."
  spec.homepage      = "https://github.com/jackpocket/worldpay_cnp"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.add_dependency "http", '>= 4', '< 5'
  spec.add_dependency "nokogiri", '~> 1.0'

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
