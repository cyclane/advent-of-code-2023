---@alias Pipes PipePart[][]
---@alias Pos {y: integer, x: integer}

---@class PipePart
---@field p Pipes
---@field s string
---@field pos Pos
PipePart = {p = {}, s = ".", pos = {y = -1, x = -1}}

---@param o PipePart | nil
---@param p Pipes
---@param s string
---@param pos Pos
---@return PipePart
function PipePart:new(o, p, s, pos)
    self.__index = self
    ---@param a PipePart
    ---@param b PipePart
    ---@return boolean
    self.__eq = function (a, b)
        return a.s == b.s and a.pos.y == b.pos.y and a.pos.x == b.pos.x
    end

    o = o or {}
    setmetatable(o, self)
    o.p = p
    o.s = s
    o.pos = pos
    return o
end

-- Assume "S" pipes are unambiguous

---@param c boolean Check if connected
function PipePart:left(c)
    if self.s == "S" or self.s == "-" or self.s == "J" or self.s == "7" then
        local lp = self.p[self.pos.y][self.pos.x-1]
        if not c or lp ~= nil and lp:right(false) == self then
            return lp
        end
    end
end

---@param c boolean Check if connected
function PipePart:top(c)
    if self.s == "S" or self.s == "|" or self.s == "J" or self.s == "L" then
        local tp = self.p[self.pos.y-1][self.pos.x]
        if not c or tp ~= nil and tp:bottom(false) == self then
            return tp
        end
    end
end

---@param c boolean Check if connected
function PipePart:right(c)
    if self.s == "S" or self.s == "-" or self.s == "L" or self.s == "F" then
        local rp = self.p[self.pos.y][self.pos.x+1]
        if not c or rp ~= nil and rp:left(false) == self then
            return rp
        end
    end
end

---@param c boolean Check if connected
function PipePart:bottom(c)
    if self.s == "S" or self.s == "|" or self.s == "F" or self.s == "7" then
        local bp = self.p[self.pos.y+1][self.pos.x]
        if not c or bp ~= nil and bp:top(false) == self then
            return bp
        end
    end
end

---@return fun(): (PipePart | nil)
function PipePart:next()
    local nexts = {
        self:left(true),
        self:top(true),
        self:right(true),
        self:bottom(true)
    }
    local idx = 0
    return function()
        repeat
            idx = idx + 1
        until idx > 4 or nexts[idx] ~= nil
        return nexts[idx]
    end
end

---@return fun(): (PipePart | nil)
function PipePart:iterate()
    local last = nil
    local cur = self
    return function ()
        if self == cur and last ~= nil then
            return nil
        end
        for n in cur:next() do
            if n ~= last then
                last = cur
                cur = n
                return last
            end
        end
    end
end

function main()
    -- Parse input
    ---@type string[]
    local lines = {}
    for line in io.lines("input.txt") do
        lines[#lines + 1] = line
    end
    ---@type Pipes
    local pipes = {}
    ---@type PipePart
    local starting = nil
    for y, line in ipairs(lines) do
        pipes[y] = {}
        for x = 1, #line do
            local s = line:sub(x, x)
            local part = PipePart:new(nil, pipes, s, {y=y, x=x})
            pipes[y][x] = part
            if s == "S" then
                starting = part
            end
        end
    end

    -- Part 1
    local length = 0
    local last = nil
    for p in starting:iterate() do
        length = length + 1
        last = p
    end
    print("Part 1:", length // 2)

    -- Part 2
    local area = 0
    for p in starting:iterate() do
        area = area + (p.pos.y + last.pos.y) * (p.pos.x - last.pos.x)
        last = p
    end
    area = math.abs(area // 2)
    print("Part 2:", area - length // 2 + 1) -- Think about this (it is right)
end

main()