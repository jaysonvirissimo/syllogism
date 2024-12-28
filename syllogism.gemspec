require_relative "lib/syllogism/version"

Gem::Specification.new do |spec|
  spec.name = "syllogism"
  spec.version = Syllogism::VERSION
  spec.authors = ["Jayson Virissimo"]
  spec.email = ["jayson.virissimo@asu.edu"]

  spec.summary = "Proof checker for arguments in Aristotle's term logic"
  spec.description = "Proof checker for arguments in Aristotle's term logic"
  spec.homepage = "https://github.com/jaysonvirissimo/syllogism"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.1.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jaysonvirissimo/syllogism"
  spec.metadata["changelog_uri"] = "https://github.com/jaysonvirissimo/syllogism"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
