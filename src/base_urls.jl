# The base URLs of the package
#

const url = NamedTuple([ 
  :completions=>"https://api.openai.com/v1/completions", 
  :embeddings=>"https://api.openai.com/v1/embeddings", 
  :generations=>"https://api.openai.com/v1/images/generations", 
  :edits=>"https://api.openai.com/v1/images/edits", 
  :fine_tune=>"https://api.openai.com/v1/fine-tunes"
  ])
  