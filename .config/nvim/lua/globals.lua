function P(...)
	local args = table.pack(...)
	for i = 1, args.n, 1 do
		print(vim.inspect(args[i]))
	end
end
