function string:startswith(prefix)
    return self:sub(1, prefix:len()) == prefix
end

function string:endswith(suffix)
    return suffix == "" or self:sub(-suffix:len()) == suffix
end

function string:rstrip(suffix)
    if self:endswith(suffix) then
        return self:sub(0, self:len() - suffix:len())
    else
        return self
    end
end
