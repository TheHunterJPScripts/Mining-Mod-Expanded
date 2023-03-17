Point = {
    x = 0,
    y = 0
}

function Point:new(x, y)
    local o = {}
    o.x = x;
    o.y = y;

    setmetatable(o, self)
    self.__index = self
    return o
end
