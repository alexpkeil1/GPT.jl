"""
Retrieves text embeddings for character input from a vector from the GPT-3 API

travel_blog_data = gpt3_single_request(prompt_input = "Write a travel blog about a dog"s journey through the UK:", temperature = 0.8, n = 10, max_tokens = 200)[1]
"""
function gpt3_embeddings(
  input_var, 
  id_var,
  param_model = "text-similarity-ada-002"
)
  data_length = length(input_var)
  if isnothing(id_var)
    data_id = ["prompt_$i" for i in 1:data_length]
  else
    data_id = id_var
  end

  empty_list = [DataFrame() for i in 1:data_length]

  for i in 1:data_length
    println("Embedding: $i / $data_length")
    row_outcome = gpt3_single_embedding(model = param_model
                                      , input = input_var[i])
    empty_df = DataFrame(t(row_outcome))
    rename!(empty_df, ["dim_$i" for i in  1:length(row_outcome)])
    empty_df.id = data_id[i]
    empty_list[i] = empty_df
  end

  output_data = reduce(vcat,empty_list)
  return(output_data)
end
