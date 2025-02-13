#" Convert character vector of numeric values into a numeric vector

function to_numeric(x)
  proxy = parse(Int64, x)
  return(proxy)
end


function message(x)
  printstyled(x, color=:blue)
end


function listgptmodels()
  headers = ["Authorization" => "Bearer $api_key"]
  #model = "text-davinci-003"
  request_base  = HTTP.get("https://api.openai.com/v1/models", headers)
  if request_base.status == 200
    request_content = JSON.parse(String(request_base.body))
  end
  rr = DataFrame(request_content["data"][1])
  for r in request_content["data"]
    rr = vcat(rr, DataFrame(r))
  end

end

function gptmodelinfo(model)
  headers = ["Authorization" => "Bearer $api_key"]
  #model = "text-davinci-003"
  request_base = HTTP.get("https://api.openai.com/v1/models/$model", headers)
  if request_base.status == 200
    request_content = JSON.parse(String(request_base.body))
  end
  DataFrame(request_content)
end


function deletenothingkeys!(parameter_list)
    for key in keys(parameter_list)
      if isnothing(parameter_list[key] )
        delete!(parameter_list,key)
      end
    end
end

function check_api_exists(;verbose=false)
    isapi = @isdefined api_key
    if !isapi
      @warn "Use gpt_authenticate() to set your API key"
      throw("`api_key` is not defined in the global scope")
    else
      true
    end
end

function gptupload(file, purpose)
  headers = ["Authorization" => "Bearer $api_key"]
  thisurl = url.file_upload
  parameter_list = Dict(
    "purpose" => purpose,
    "file" => file
  )
  request_base =
  HTTP.request("POST", thisurl, form = JSON.json(parameter_list), headers = headers)
  if request_base.status == 200
    request_content = JSON.parse(String(request_base.body))
  end
  DataFrame(request_content)
end
