local json = require "json"


-- Load URL paths from the file
function load_request_objects_from_file(file)
  local data = {}
  local content

  -- Check if the file exists
  -- Resource: http://stackoverflow.com/a/4991602/325852
  local f=io.open(file,"r")
  if f~=nil then
    content = f:read("*all")

    io.close(f)
  else
    -- Return the empty array
    return lines
  end

  -- Translate Lua value to/from JSON
  data = json.decode(content)


  return data
end

-- Load URL requests from file
requests = load_request_objects_from_file("req.json")

-- Check if at least one path was found in the file
if #requests <= 0 then
  print("multiplerequests: No requests found.")
  os.exit()
end

print("multiplerequests: Found " .. #requests .. " requests")
for i = 1, #requests do
  local request_object = requests[i]
  print(request_object.method, request_object.path, request_object.headers, request_object.body)
end

-- Initialize the requests array iterator
counter = 1


request = function()
  -- Get the next requests array element
  local request_object = requests[counter]

  -- Increment the counter
  counter = counter + 1

  -- If the counter is longer than the requests array length then reset it
  if counter > #requests then
    counter = 1
  end

  -- Return the request object with the current URL path
  return wrk.format(request_object.method, request_object.path, request_object.headers, request_object.body)
end

