require_relative 'lib/worldpay_cnp/version'

Gem::Specification.new do |spec|
  spec.name  = "worldpay_cnp"
  spec.version = WorldpayCnp::VERSION
  spec.authors = ["Javier Julio"]
  spec.email = ["javier@jackpocket.com"]

  spec.summary = "A modern Ruby interface to the Worldpay cnpAPI."
  spec.description = "A modern and simple Ruby interface to the Worldpay cnpAPI."
  spec.homepage = "https://github.com/jackpocket/worldpay-cnp"
  spec.license = "MIT"

  spec.add_dependency "http", '>= 4', '< 6'
  spec.add_dependency "nokogiri", '~> 1.0'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["README.md", "LICENSE*", "lib/**/*.rb"]
  spec.require_paths = ["lib"]
end
