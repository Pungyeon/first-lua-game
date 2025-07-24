area = {
    Collision = function(a, b)
        return a.x < b.x + b.width and
            a.x + a.width > b.x and
            a.y < b.y + b.height and
            a.y + a.height > b.y
    end,
    Contains = function(outer, inner)
        return inner.x >= outer.x and
            inner.y >= outer.y and
            inner.x + inner.width <= outer.x + outer.width and
            inner.y + inner.height <= outer.y + outer.height
    end
}

return area
