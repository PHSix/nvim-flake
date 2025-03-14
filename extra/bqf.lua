local cmd, fn, api = vim.cmd, vim.fn, vim.api
require("bqf").setup({
	func_map = {
		split = "<C-s>",
		vsplit = "<C-v>",
	},
})

-- local cmd = vim.cmd
-- local fn = vim.fn
-- local api = vim.api
-- https://github.com/neoclide/coc.nvim
-- if you use coc-fzf, you should disable its CocLocationsChange event
-- to make bqf work for <Plug>(coc-references)

-- vim.schedule(function()
--     cmd('au! CocFzfLocation User CocLocationsChange')
-- end)
vim.g.coc_enable_locationlist = 0
cmd([[
    aug Coc
        au!
        au User CocLocationsChange lua _G.jumpToLoc()
    aug END
  ]])

--   cmd([[
--   nnoremap <silent> <leader>qd <Cmd>lua _G.diagnostic()<CR>
-- ]])

-- just use `_G` prefix as a global function for a demo
-- please use module instead in reality
function _G.jumpToLoc(locs)
	locs = locs or vim.g.coc_jump_locations
	fn.setloclist(0, {}, " ", { title = "CocLocationList", items = locs })
	local winid = fn.getloclist(0, { winid = 0 }).winid
	if winid == 0 then
		cmd("bo lw")
	else
		api.nvim_set_current_win(winid)
	end

	vim.defer_fn(function()
		local bufnr = vim.api.nvim_get_current_buf()
		vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = bufnr })
	end, 10)
end

local function diagnostic()
	fn.CocActionAsync("diagnosticList", "", function(err, res)
		if err == vim.NIL then
			local items = {}
			for _, d in ipairs(res) do
				local text = ("[%s%s] %s"):format(
					(d.source == "" and "coc.nvim" or d.source),
					(d.code == vim.NIL and "" or " " .. d.code),
					d.message:match("([^\n]+)\n*")
				)
				local item = {
					filename = d.file,
					lnum = d.lnum,
					end_lnum = d.end_lnum,
					col = d.col,
					end_col = d.end_col,
					text = text,
					type = d.severity,
				}
				table.insert(items, item)
			end
			fn.setqflist({}, " ", { title = "CocDiagnosticList", items = items })

			cmd("bo cope")
		end
	end)
end

vim.keymap.set("n", "<leader>qd", diagnostic, { silent = true, noremap = true })
