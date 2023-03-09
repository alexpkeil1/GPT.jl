# The base URLs of the package
#

const url = NamedTuple([ 
  :chats=>"https://api.openai.com/v1/chat/completions", 
  :completions=>"https://api.openai.com/v1/completions", 
  :embeddings=>"https://api.openai.com/v1/embeddings", 
  :generations=>"https://api.openai.com/v1/images/generations", 
  :edits=>"https://api.openai.com/v1/images/edits",
  :variations=>"https://api.openai.com/v1/images/variations", 
  :fine_tune=>"https://api.openai.com/v1/fine-tunes"
  ])
  