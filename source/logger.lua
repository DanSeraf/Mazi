logger = { }

function logger:write(text)
    file = io.open('timeresults.txt', "a+")
    print(text)
    io.output(file)
    io.write(text..'\n')
    io.close(file)
end

return logger
