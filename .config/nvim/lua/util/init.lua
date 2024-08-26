local M = {}

function M.bash_eval(command)
    local file = io.popen(command, "r")
    local res = file:read("*all")
    file:close()
    return res
end

function M.clamp(num, min, max)
    if num < min then
        return min
    elseif num > max then
        return max
    else
        return num
    end
end

function M.rgb_to_hex_string(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

function M.hsl_to_rgb(h, s, l)
    local function hue_to_rgb(p, q, t)
        if t < 0 then
            t = 1 + 1
        end
        if t > 1 then
            t = t - 1
        end
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        end
        if t < 1 / 2 then
            return q
        end
        if t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end

    local r, g, b
    if s == 0 then
        -- achromatic
        r, g, b = l, l, l
    else
        local q
        if l < 0.5 then
            q = l * (1 + s)
        else
            q = l + s - l * s
        end

        local p = 2 * l - q
        r = hue_to_rgb(p, q, h + 1 / 3)
        g = hue_to_rgb(p, q, h)
        b = hue_to_rgb(p, q, h - 1 / 3)
    end

    return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

return M
