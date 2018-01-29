Gem::Specification.new do |s|
  s.name        = "sliding_puzzle"
  s.version     = "1.0.0"
  s.licenses    = ["MIT"]
  s.summary     = "Sliding Puzzle"
  s.description = "A Ruby gem for manipulating and solving sliding tile puzzles."
  s.author      = "Chris Patuzzo"
  s.email       = "chris@patuzzo.co.uk"
  s.homepage    = "https://github.com/tuzz/sliding_puzzle"
  s.files       = ["README.md"] + Dir["lib/**/*.*"]

  s.add_development_dependency "rspec", "3.7.0"
  s.add_development_dependency "pry", "~> 0.11.3"
end
