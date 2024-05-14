require_relative 'lib/worldpay_cnp/version'

Gem::Specification.new do |spec|
  spec.name          = "worldpay_cnp"
  spec.version       = WorldpayCnp::VERSION
  spec.authors       = ["Javier Julio"]
  spec.email         = ["javier@jackpocket.com"]

  spec.summary       = "A modern Ruby interface to the Worldpay cnpAPI."
  spec.description   = "A modern and simple Ruby interface to the Worldpay cnpAPI."
  spec.homepage      = "https://github.com/jackpocket/worldpay-cnp"
  spec.license       = "MIT"

  spec.add_dependency "http", '>= 4', '< 6'
  spec.add_dependency "nokogiri", '~> 1.0'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
