interpreter = {}

tokens = require("tokens")

loop = {}

function loop:size(length)
  if not self.array then
    self.array = {0}
  end

  -- print("setting to size", length)
  while #self.array > length do
    if self.ip == #self.array then
      table.remove(self.array, 0)
      self.ip = #self.array
    else
      table.remove(self.array, self.ip + 1)
    end
  end

  while #self.array < length do
    table.insert(self.array, self.ip, 0)
    self.ip = self.ip + 1
  end
  -- print("set to size", #self.array, "ip at", self.ip)
end

function loop:new(o)
  o = o or {}
  setmetatable(o, self)
  self.ip = 1
  self.__index = self
  return o
end

function loop:inc()
  -- print("incrementing", self.ip, #self.array)
  self.ip = (self.ip % #self.array) + 1
end

function loop:get()
  return self.array[self.ip]
end

function loop:set(value)
  self.array[self.ip] = value
end

interpreter.token_list = {}

interpreter.get_argument = function(n)
  local token = interpreter.token_list[interpreter.tp]
  -- print("get arg of token ", interpreter.tp)
  -- for i, val in ipairs(token.arguments) do
  --   print("-" .. val)
  -- end
  local value = token.arguments[n]
  if interpreter.loops[token.arguments[n]] then
    -- print(token.arguments[n])
    -- print(interpreter.loops[token.arguments[n]])
    value = interpreter.loops[token.arguments[n]]:get()
  end
  return value
end

function interpreter.run_command(token)
  -- print("current loop values:")
  -- print("loop", "X", "Y", "Z", "D")
  -- print("table", interpreter.loops.X, interpreter.loops.Y, interpreter.loops.Z, interpreter.loops.D)
  -- print("array", interpreter.loops.X.array, interpreter.loops.Y.array, interpreter.loops.Z.array, interpreter.loops.D.array)
  -- print("ip", interpreter.loops.X.ip, interpreter.loops.Y.ip, interpreter.loops.Z.ip, interpreter.loops.D.ip)
  -- print("array", #interpreter.loops.X.array, #interpreter.loops.Y.array, #interpreter.loops.Z.array, #interpreter.loops.D.array)
  -- print("value", interpreter.loops.X:get(), interpreter.loops.Y:get(), interpreter.loops.Z:get(), interpreter.loops.D:get())
  if token.name == "repeat" then
    local x = interpreter.get_argument(1)
    interpreter.inc_all()
    for i=1, x do
      for i, func in ipairs(token.calls) do
        interpreter.run_command(token.calls)
      end
    end

  elseif token.name == "add" then
    local x = interpreter.get_argument(2)
    local y = interpreter.get_argument(3)
    interpreter.loops[token.arguments[1]]:set(x + y)
    interpreter.inc_all()

  elseif token.name == "sub" then
    local x = interpreter.get_argument(2)
    local y = interpreter.get_argument(3)
    interpreter.loops[token.arguments[1]]:set(x - y)
    interpreter.inc_all()

  elseif token.name == "mul" then
    local x = interpreter.get_argument(2)
    local y = interpreter.get_argument(3)
    interpreter.loops[token.arguments[1]]:set(x * y)
    interpreter.inc_all()

  elseif token.name == "div" then
    local x = interpreter.get_argument(2)
    local y = interpreter.get_argument(3)
    interpreter.loops[token.arguments[1]]:set(x / y)
    interpreter.inc_all()

  elseif token.name == "and" then
    local x = interpreter.get_argument(2)
    local y = interpreter.get_argument(3)
    interpreter.loops[token.arguments[1]]:set(x & y)
    interpreter.inc_all()

  elseif token.name == "or" then
    local x = interpreter.get_argument(2)
    local y = interpreter.get_argument(3)
    interpreter.loops[token.arguments[1]]:set(x | y)
    interpreter.inc_all()

  elseif token.name == "xor" then
    local x = interpreter.get_argument(2)
    local y = interpreter.get_argument(3)
    interpreter.loops[token.arguments[1]]:set(x ^ y)
    interpreter.inc_all()

  elseif token.name == "mov" then
    local x = interpreter.get_argument(2)
    interpreter.loops[token.arguments[1]]:set(x)
    interpreter.inc_all()

  elseif token.name == "set" then
    local x = interpreter.get_argument(1)
    if x < 0 then
      error("Negative values for set not accepted")
    end
    interpreter.loops["D"]:size(2^x)
    interpreter.inc_all()

  elseif token.name == "in" then
    interpreter.loops[token.arguments[1]]:set(io.read(1) or -1)
    -- print(interpreter.loops[token.arguments[1]]:get())
    interpreter.inc_all()

  elseif token.name == "out" then
    local x = interpreter.get_argument(1)
    io.write(x)
    interpreter.inc_all()

  elseif token.name == "func_call" then
    for i, command in ipairs(interpreter.funcs[token.func_name].calls) do
      run_command(command)
    end

  end
end

interpreter.inc_all = function()
  interpreter.loops.X:inc()
  interpreter.loops.Y:inc()
  interpreter.loops.Z:inc()
  interpreter.loops.D:inc()
end

interpreter.def = function(token)
  interpreter.funcs = token.calls
end

function interpreter.interpret(code)
  interpreter.loops = {X=loop:new(), Y=loop:new(), Z=loop:new(), D=loop:new()}
  -- interpreter.loops = {X=loop:new(7), Y=loop:new(37), Z=loop:new(97), D=loop:new(1)}
  interpreter.loops.X:size(7)
  interpreter.loops.Y:size(37)
  interpreter.loops.Z:size(97)
  interpreter.loops.D:size(1)

  interpreter.token_list = tokens.tokenise(code)
  interpreter.tp = 1
  token = interpreter.token_list[interpreter.tp]

  interpreter.funcs = {}
  for i, command in ipairs(interpreter.token_list) do
    -- print(command.name .. #command.arguments)
    if command.name == "def" then
      interpreter.funcs = command
    end
  end

  while interpreter.tp <= #interpreter.token_list do
    -- print("command", token.name)
    if token.name ~= "def" then
      interpreter.run_command(token)
      interpreter.tp = interpreter.tp + 1
      token = interpreter.token_list[interpreter.tp]
    end
  end
end

return interpreter
