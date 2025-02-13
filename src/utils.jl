#" Convert character vector of numeric values into a numeric vector

function to_numeric(x)
  proxy = parse(Int64, x)
  return(proxy)
end


function message(x)
  printstyled(x, color=:blue)
end


function listgptmodels(model)
  headers = ["Authorization" => "Bearer $api_key"]
  #model = "text-davinci-003"
  HTTP.get("https://api.openai.com/v1/models/$model", headers)
end

function deletenothingkeys!(parameter_list)
    for key in keys(parameter_list)
      if isnothing(parameter_list[key] )
        delete!(parameter_list,key)
      end
    end
end

function check_api_exists()
    isapi = @isdefined api_key
    if !isapi
      @warn "Use gpt_authenticate() to set your API key"
      throw("`api_key` is not defined in the global scope")
    end
end