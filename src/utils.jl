#" Convert character vector of numeric values into a numeric vector

function to_numeric(x)
    proxy = parse(Int64, x)
    return (proxy)
end


function message(x)
    printstyled(x, color = :blue)
end


function listgptmodels()
    headers = ["Authorization" => "Bearer $api_key"]
    #model = "text-davinci-003"
    request_base = HTTP.get("https://api.openai.com/v1/models", headers)
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    rr = DataFrame(request_content["data"][1])
    for r in request_content["data"]
        rr = vcat(rr, DataFrame(r))
    end
    rr
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
        if isnothing(parameter_list[key])
            delete!(parameter_list, key)
        end
    end
end

function check_api_exists(; verbose = false)
    isapi = @isdefined api_key
    if !isapi
        @warn "Use gpt_authenticate() to set your API key"
        throw("`api_key` is not defined in the global scope")
    else
        true
    end
end


"""
# 


# purpose: Use "assistants" for Assistants and Message files, "vision" for Assistants image file inputs, "batch" for Batch API, and "fine-tune" for Fine-tuning.
file = expanduser("~/temp/testcsv.csv")
gptupload(file, "assistants")
gptupload(file=file, purpose="assistants")

"""
function gptupload(;file="", purpose="", verbose = true)
    headers =
    #["Authorization" => "Bearer $api_key", "Content-Type" => "multipart/form-data"]
    ["Authorization" => "Bearer $api_key"]
    verbose ? println("Uploading file $file") : true
    thisurl = url.files
    parameter_list = Dict("purpose" => purpose, "file" => open(file, "r"))
    request_base = HTTP.request(
        "POST",
        thisurl,
        body = HTTP.Form(collect(parameter_list)),
        headers = headers,
    )
    #HTTP.request("POST", thisurl, body = JSON.json(parameter_list), headers = headers)
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    DataFrame(request_content)
end
gptupload(f,p; kwargs...) = gptupload(file=f, purpose=p; kwargs...)


"""
request_content = Dict("run" => 1)
exemptkeys = ["run"]
meta_output = Dict()
for (k, v) in request_content
    if all(k .!= exemptkeys)
        meta_output[k] = v
    end
end
meta_output

"""
function makemetadata(request_content, exemptkeys)
    if length(exemptkeys) == 0
        return (request_content)
    end
    meta_output = Dict()
    for (k, v) in request_content
        kstr = String(k)
        if all(kstr .!= exemptkeys)
            meta_output[kstr] = v
        end
    end
    meta_output
end

makemetadata(request_content) = makemetadata(request_content, [])

function maketools(tools)
    if !isnothing(tools)
        tooldict = []
        for t in tools
            tooldict = vcat(tooldict, Dict("type" => t))
        end
    else
        tooldict = tools
    end
    tooldict
end
