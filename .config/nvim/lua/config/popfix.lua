local M = {}

-- https://github.com/hood/popui.nvim
-- slightly modified
local popfix = require("popfix")

local popup_reference = nil

local calculate_popup_width = function(entries)
	local result = 0

	for _, entry in pairs(entries) do
		if #entry > result then
			result = #entry
		end
	end

	return result + 5
end

local format_entries = function(entries, formatter)
	local format_item = formatter or tostring

	local results = {}

	for _, entry in pairs(entries) do
		table.insert(results, string.format("%s", format_item(entry)))
	end

	return results
end

local custom_ui_select = function(entries, stuff, on_user_choice)
	assert(entries ~= nil and not vim.tbl_isempty(entries), "No entries available.")

	assert(popup_reference == nil, "Busy in other LSP popup.")

	local commit_choice = function(choice_index)
		on_user_choice(entries[choice_index], choice_index)
	end

	local formatted_entries = format_entries(entries, stuff.format_item)

	popup_reference = popfix:new({
		width = calculate_popup_width(formatted_entries),
		height = #formatted_entries,
		close_on_bufleave = true,
		keymaps = {
			i = {
				["<Cr>"] = function(popup)
					popup:close(function(sel)
						commit_choice(sel)
					end)
					popup_reference = nil
				end,
			},
			n = {
				["<Cr>"] = function(popup)
					popup:close(function(sel)
						commit_choice(sel)
					end)
					popup_reference = nil
				end,
				["<C-o>"] = function(popup)
					popup:close()
					popup_reference = nil
				end,
				["<Esc>"] = function(popup)
					popup:close()
					popup_reference = nil
				end,
				["q"] = function(popup)
					popup:close()
					popup_reference = nil
				end,
			},
		},
		callbacks = {
			close = function()
				popup_reference = nil
			end,
		},
		mode = "cursor",
		list = {
			numbering = true,
			border = false,
			highlight = "PMenu",
			selection_highlight = "Underlined",
		},
		data = formatted_entries,
	})
end

function M.setup()
	vim.ui.select = custom_ui_select
end

return M
