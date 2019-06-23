logger = { }

function logger:write(text)
    print(text)
    file = io.open('log.txt', 'a+')
    io.output(file)
    io.write(text..'\n')
    io.close(file)
end

return logger
