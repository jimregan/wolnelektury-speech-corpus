-- Barely modified version of
-- https://en.wiktionary.org/wiki/Module:pl-IPA
-- (so, CC-BY-SA)
-- supposed to run as a filter, but after certain amounts of input
-- it goes crazy and multiplies the stress marks, so I usually
-- either cut the input into pieces, or pipe a word at a time
local export = {}

local letters2phones = {
	["a"] = {
		["u"  ] = { "a", "w" },
		[false] = "a",
	},
	["ą"] = {
		["ł"  ] = { "ɔ", "w" },
		[false] = "ɔ̃",
	},
	["b"] = {
		["i"  ] = {
			["a"  ] = { "bʲ", "a" },
			["ą"  ] = { "bʲ", "ɔ̃" },
			["e"  ] = { "bʲ", "ɛ" },
			["ę"  ] = { "bʲ", "ɛ̃" },
			["i"  ] = { "bʲ", "j", "i" },
			["o"  ] = { "bʲ", "ɔ" },
			["ó"  ] = { "bʲ", "u" },
			["u"  ] = { "bʲ", "u" },
			[false] = { "bʲ", "i" }
			},
		[false] = "b"
	},
	["c"] = {
		["i"  ] = {
			["ą"  ] = { "t͡ɕ", "ɔ̃" },
			["a"  ] = { "t͡ɕ", "a" },
			["e"  ] = { "t͡ɕ", "ɛ" },
			["ę"  ] = { "t͡ɕ", "ɛ̃" },
			["o"  ] = { "t͡ɕ", "ɔ" },
			["ó"  ] = { "t͡ɕ", "u" },
			["u"  ] = { "t͡ɕ", "u" },
			["y"  ] = { "t͡ɕ", "ɨ" },
			[false] = { "t͡ɕ", "i" }
		},
		["h"  ] = {
		["i" ] = {
			["a"  ] = { "xʲ", "j", "a" },
			["ą"  ] = { "xʲ", "j", "ɔ̃" },
			["e"  ] = { "xʲ", "j", "ɛ" },
			["ę"  ] = { "xʲ", "j", "ɛ̃" },
			["i"  ] = { "xʲ", "j", "i" },
			["o"  ] = { "xʲ", "j", "ɔ" },
			["ó"  ] = { "xʲ", "j", "u" },
			["u"  ] = { "xʲ", "j", "u" },
			[false] = { "xʲ", "i" }
			},
		[false] = "x"
                },
		["z"  ] = "t͡ʂ",
		[false] = "t͡s"
	},
	["ć"] = "t͡ɕ",
	["d"] = {
		["z"  ] = {
			["i"  ] = {
				["ą"  ] = { "d͡ʑ", "ɔ̃" },
				["a"  ] = { "d͡ʑ", "a" },
				["e"  ] = { "d͡ʑ", "ɛ" },
				["ę"  ] = { "d͡ʑ", "ɛ̃" },
				["o"  ] = { "d͡ʑ", "ɔ" },
				["ó"  ] = { "d͡ʑ", "u" },
				["u"  ] = { "d͡ʑ", "u" },
				["y"  ] = { "d͡ʑ", "ɨ" },
				[false] = { "d͡ʑ", "i" }
			},
			[false] = "d͡z"
		},
		["ż"  ] = "d͡ʐ",
		["ź"  ] = "d͡ʑ",
		[false] = "d"
	},
	["e"] = {
		["u"  ] = { "ɛ", "w" },
		["e"  ] = { "ɛ", "ʔ", "ɛ" }, -- reedukacja, reewaluacja, etc.
		[false] = "ɛ",
	},
	["ę"] = {
		["l"  ] = { "ɛ", "l" },
		["ł"  ] = { "ɛ", "w" },
		[false] = "ɛ̃",
	},
	["f"] = {
		["i"  ] = {
			["a"  ] = { "fʲ", "a" },
			["ą"  ] = { "fʲ", "ɔ̃" },
			["e"  ] = { "fʲ", "ɛ" },
			["ę"  ] = { "fʲ", "ɛ̃" },
			["i"  ] = { "fʲ", "j", "i" },
			["o"  ] = { "fʲ", "ɔ" },
			["ó"  ] = { "fʲ", "u" },
			["u"  ] = { "fʲ", "u" },
			[false] = { "fʲ", "i" }
			},
		[false] = "f"
	},
	["g"] = {
		["i" ] = {
			["a"  ] = { "ɡʲ", "j", "a" },
			["ą"  ] = { "ɡʲ", "ɔ̃" }, -- only forms of "giąć"
			["e"  ] = { "ɡʲ", "ɛ" },
			["ę"  ] = { "ɡʲ", "ɛ̃" }, -- only forms of "giąć" and "giętki"
			["i"  ] = { "ɡʲ", "j", "i" },
			["o"  ] = { "ɡʲ", "j", "ɔ" },
			["ó"  ] = { "ɡʲ", "j", "u" },
			["u"  ] = { "ɡʲ", "j", "u" },
			[false] = { "ɡʲ", "i" }
			},
		[false] = "ɡ"
	},
	["h"] = {
		["i" ] = {
			["a"  ] = { "xʲ", "j", "a" },
			["ą"  ] = { "xʲ", "j", "ɔ̃" },
			["e"  ] = { "xʲ", "j", "ɛ" },
			["ę"  ] = { "xʲ", "j", "ɛ̃" },
			["i"  ] = { "xʲ", "j", "i" },
			["o"  ] = { "xʲ", "j", "ɔ" },
			["ó"  ] = { "xʲ", "j", "u" },
			["u"  ] = { "xʲ", "j", "u" },
			[false] = { "xʲ", "i" }
			},
		[false] = "x"
        },
	["i"] = "i",
	["j"] = "j",
	["k"] = {
		["i" ] = {
			["a"  ] = { "kʲ", "j", "a" },
			["ą"  ] = { "kʲ", "j", "ɔ̃" },
			["e"  ] = { "kʲ", "ɛ" },
			["ę"  ] = { "kʲ", "j", "ɛ̃" },
			["i"  ] = { "kʲ", "j", "i" },
			["o"  ] = { "kʲ", "j", "ɔ" },
			["ó"  ] = { "kʲ", "j", "u" },
			["u"  ] = { "kʲ", "j", "u" },
			[false] = { "kʲ", "i" }
			},
		[false] = "k"
	},
	["l"] = {
		["i" ] = {
			["a"  ] = { "lʲ", "a" },
			["ą"  ] = { "lʲ", "ɔ̃" },
			["e"  ] = { "lʲ", "ɛ" },
			["ę"  ] = { "lʲ", "ɛ̃" },
			["i"  ] = { "lʲ", "j", "i" },
			["o"  ] = { "lʲ", "ɔ" },
			["ó"  ] = { "lʲ", "u" },
			["u"  ] = { "lʲ", "u" },
			[false] = { "lʲ", "i" }
			},
		[false] = "l"
        },
	["ł"] = "w",
	["m"] = {
		["i"  ] = {
			["a"  ] = { "mʲ", "a" },
			["ą"  ] = { "mʲ", "ɔ̃" },
			["e"  ] = { "mʲ", "ɛ" },
			["ę"  ] = { "mʲ", "ɛ̃" },
			["i"  ] = { "mʲ", "j", "i" },
			["o"  ] = { "mʲ", "ɔ" },
			["ó"  ] = { "mʲ", "u" },
			["u"  ] = { "mʲ", "u" },
			[false] = { "mʲ", "i" }
			},
		[false] = "m"
	},
	["n"] = {
		["i"  ] = {
			["ą"  ] = { "ɲ", "ɔ̃" },
			["a"  ] = { "ɲ", "a" },
			["e"  ] = { "ɲ", "ɛ" },
			["ę"  ] = { "ɲ", "ɛ̃" },
			["i"  ] = { "ɲ", "j", "i" },
			["o"  ] = { "ɲ", "ɔ" },
			["ó"  ] = { "ɲ", "u" },
			["u"  ] = { "ɲ", "u" },
			[false] = { "ɲ", "i" }
		},
		
		-- "bank", "bankowy", "bankowość" is [baŋk], [baŋˈkɔ.vɨ], [baŋˈko.voɕt͡ɕ]
		-- but "wybranka", "łapanka" and "zapinka" would be rather [vɨˈbran.ka], [waˈpan.ka] and [zaˈpin.ka].
		-- looks like "bank" and related should be manually transcribed.
		-- although [bank], etc. is not incorrect, even if somewhat posh. (In the regions where [nk] and [ŋk] can be distinguished, it's actually [baŋk] that is posh).
		
		-- ["g"  ] = { "ŋ", "ɡ" },
		-- ["k"  ] = { "ŋ", "k" },
		[false] = "n"
	},
	["ń"] = "ɲ",
	["o"] = {
		["o"  ] = { "ɔ", "ʔ", "ɔ" }, -- żaroodporny, ognioodporny, etc.
		[false] = "ɔ" ,
	},
	["ó"] = "u",
	["p"] = {
		["i"  ] = {
			-- piątek, piasek, etc.
			["a"  ] = { "pʲ", "a" },
			["ą"  ] = { "pʲ", "ɔ̃" },
			["e"  ] = { "pʲ", "ɛ" },
			["ę"  ] = { "pʲ", "ɛ̃" },
			["i"  ] = { "pʲ", "j", "i" },
			["o"  ] = { "pʲ", "ɔ" },
			["ó"  ] = { "pʲ", "u" },
			["u"  ] = { "pʲ", "u" },
			[false] = { "pʲ", "i" }
			},
		[false] = "p"
	},
	["r"] = {
		["i" ] = {
			["a"  ] = { "rʲ", "j", "a" },
			["ą"  ] = { "rʲ", "j", "ɔ̃" },
			["e"  ] = { "rʲ", "j", "ɛ" },
			["ę"  ] = { "rʲ", "j", "ɛ̃" },
			["i"  ] = { "rʲ", "j", "i" },
			["o"  ] = { "rʲ", "j", "ɔ" },
			["ó"  ] = { "rʲ", "j", "u" },
			["u"  ] = { "rʲ", "j", "u" },
			[false] = { "rʲ", "i" }
			},
		["z"  ] = "ʐ",
		[false] = "r"
	},
	["q"] = {
		["u"  ] = { "k", "v" },
		[false] = false
	},
	["s"] = {
		["i"  ] = {
			["ą"  ] = { "ɕ", "ɔ̃" },
			["a"  ] = { "ɕ", "a" },
			["e"  ] = { "ɕ", "ɛ" },
			["ę"  ] = { "ɕ", "ɛ̃" },
			["o"  ] = { "ɕ", "ɔ" },
			["ó"  ] = { "ɕ", "u" },
			["u"  ] = { "ɕ", "u" },
			["y"  ] = { "ɕ", "ɨ" },
			[false] = { "ɕ", "i" }
		},
		["z"  ] = "ʂ",
		[false] = "s",
	},
	["ś"] = "ɕ",
	["t"] = "t",
	["u"] = "u",
	["v"] = {
		["i"  ] = {
			["a"  ] = { "vʲ", "a" },
			["ą"  ] = { "vʲ", "ɔ̃" },
			["e"  ] = { "vʲ", "ɛ" },
			["ę"  ] = { "vʲ", "ɛ̃" },
			["i"  ] = { "vʲ", "j", "i" },
			["o"  ] = { "vʲ", "ɔ" },
			["ó"  ] = { "vʲ", "u" },
			["u"  ] = { "vʲ", "u" },
			[false] = { "vʲ", "i" }
			},
		[false] = "v"
	},
	["w"] = {
		["i"  ] = {
			["a"  ] = { "vʲ", "a" },
			["ą"  ] = { "vʲ", "ɔ̃" },
			["e"  ] = { "vʲ", "ɛ" },
			["ę"  ] = { "vʲ", "ɛ̃" },
			["i"  ] = { "vʲ", "j", "i" },
			["o"  ] = { "vʲ", "ɔ" },
			["ó"  ] = { "vʲ", "u" },
			["u"  ] = { "vʲ", "u" },
			[false] = { "vʲ", "i" }
			},
		["j" ] = { "vʲ", "j" }, -- e.g. wjazd,
		[false] = "v"
	},
	["x"] = { "k", "s" },
	["y"] = "ɨ",
	["z"] = {
		["i"  ] = {
			["ą"  ] = { "ʑ", "ɔ̃" },
			["a"  ] = { "ʑ", "a" },
			["e"  ] = { "ʑ", "ɛ" },
			["ę"  ] = { "ʑ", "ɛ̃" },
			["o"  ] = { "ʑ", "ɔ" },
			["ó"  ] = { "ʑ", "u" },
			["u"  ] = { "ʑ", "u" },
			[false] = { "ʑ", "i" }
		},
		[false] = "z"
	},
	["ź"] = "ʑ",
	["ż"] = "ʐ",
	["-"] = {},
}

local valid_phone = {
	["a" ] = true, ["b" ] = true, ["bʲ"] = true, ["d" ] = true, ["d͡z"] = true, ["d͡ʑ"] = true,
	["d͡ʐ"] = true, ["ɛ" ] = true, ["ɛ̃" ] = true, ["f" ] = true, ["fʲ"] = true, ["ɡ" ] = true,
	["ɡʲ"] = true, ["i" ] = true, ["ɨ" ] = true, ["j" ] = true, ["k" ] = true, ["kʲ"] = true, 
	["l" ] = true, ["lʲ"] =true, ["m" ] = true, ["mʲ"] = true, ["n" ] = true, ["ŋ" ] = true,
 ["ɲ" ] = true, ["ɔ" ] = true, ["ɔ̃" ] = true, ["p" ] = true, ["pʲ"] = true, ["r" ] = true, ["rʲ"] = true,
["s" ] = true, ["ɕ" ] = true, ["ʂ" ] = true, ["t" ] = true, ["t͡s"] = true, ["t͡ɕ"] = true, ["t͡ʂ"] = true,
	["u" ] = true, ["v" ] = true, ["vʲ"] = true, ["w" ] = true, ["x" ] = true, ["xʲ"] = true, ["z" ] = true,
	["ʑ" ] = true, ["ʐ" ] = true, ["ʔ" ] = true
}

local sylmarks = {
	["."] = ".", ["'"] = "ˈ", [","] = "ˌ"
}

local vowel = {
	[ "a"] = true, [ "ɛ"] = true, [ "ɛ̃"] = true,
	[ "i"] = true, [ "ɨ"] = true, [ "ɔ"] = true,
	[ "ɔ̃"] = true, [ "u"] = true
}

local devoice = {
	["b" ] = "p" , ["d" ] = "t" , ["d͡z"] = "t͡s", ["d͡ʑ"] = "t͡ɕ",
	["d͡ʐ"] = "t͡ʂ", ["ɡ" ] = "k" , ["v" ] = "f" , ["vʲ"] = "fʲ",
	["z" ] = "s" , ["ʑ" ] = "ɕ" , ["ʐ" ] = "ʂ" ,

	-- non-devoicable
	["bʲ"] = "bʲ", ["ɡʲ"] = "ɡʲ", ["m" ] = "m" , ["mʲ"] = "mʲ",
	["n" ] = "n" , ["ɲ" ] = "ɲ" , ["ŋ" ] = "ŋ" , ["w" ] = "w" ,
	["l" ] = "l" , ["lʲ"] = "lʲ" , ["j" ] = "j" , ["r" ] = "r" , ["rʲ"] = "rʲ" ,
}

local denasalized = {
	[ "ɛ̃"] =  "ɛ",
	[ "ɔ̃"] =  "ɔ",
}

local nasal_map = {
	["p" ] = "m", ["pʲ"] = "m", ["b" ] = "m", ["bʲ"] = "m", -- zębu, klępa
	["k" ] = "ŋ", ["kʲ"] = "ŋ", ["ɡ" ] = "ŋ", ["ɡʲ"] = "ŋ", -- pąk, łęgowy
	["t" ] = "n", ["d" ] = "n", -- wątek, piątek, mądrość
	
	["t͡ɕ"] = "ɲ", ["d͡ʑ"] = "ɲ", -- pięć, pędziwiatr, łabędź
	-- gęsi, więzi
	["t͡ʂ"] = "n", ["d͡ʐ"] = "n", -- pączek, ?
	-- węszyć, mężny
	["t͡s"] = "n", ["d͡z"] = "n", -- wiedząc, pieniędzy
}

function export.convert_to_IPA(word)
	if type(word) == "table" then
		word = word.args[1]
	end

	-- convert letters to phones
	local phones = {}
	local l2ptab = letters2phones
	for ch in word:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		local value = l2ptab[ch]

		if value == nil then
			value = l2ptab[false]
			if value == false then
				return nil
			elseif type(value) == "table" then
				for _, phone in ipairs(value) do
					table.insert(phones, phone)
				end				
			else
				table.insert(phones, value)
			end
			l2ptab = letters2phones
			value = l2ptab[ch]
		end

		if type(value) == "table" then
			if value[false] == nil then
				for _, phone in ipairs(value) do
					table.insert(phones, phone)
				end
				l2ptab = letters2phones
			else
				l2ptab = value
			end
		elseif type(value) == "string" then
			table.insert(phones, value)
			l2ptab = letters2phones
		else
			table.insert(phones, ch)
		end
	end

	if l2ptab ~= letters2phones then
		table.insert(phones, l2ptab[false])
	end

	-- simplify nasals
	local new_phones = {}
	for i, phone in ipairs(phones) do
		local pnext = phones[i + 1]
		if denasalized[phone] then
			if phone == "ɛ̃" and (not pnext or not valid_phone[pnext]) then
				-- denasalize word-final ę
				table.insert(new_phones, denasalized[phone])
			elseif nasal_map[pnext] then
				table.insert(new_phones, denasalized[phone])
				table.insert(new_phones, nasal_map[pnext])
			else
				table.insert(new_phones, phone)
			end
		else
			table.insert(new_phones, phone)
		end
	end
	phones = new_phones

	-- devoice
	for i = #phones, 1, -1 do
		local pprev, pcurr, pnext = phones[i - 1], phones[i]
		local j = i
		repeat
			j = j + 1
			pnext = phones[j]
		until not pnext or not sylmarks[pnext]
		if devoice[pcurr] and not devoice[pnext] and not vowel[pnext] and not denasalized[pnext] then
			phones[i] = devoice[pcurr]
		end
		-- prz, trz, krz, tw, kw(i)
		if ((pcurr == "v") or (pcurr == "vʲ") or (pcurr == "ʐ")) and valid_phone[pprev] and not devoice[pprev] and not vowel[pprev] and not denasalized[pprev] then
			phones[i] = devoice[pcurr]
		end
	end
	
	-- collect syllables
	local words, curword, sylmarked, sylbuf = {}, nil, false
	for i, pcurr in ipairs(phones) do
		local ppprev, pprev, pnext = phones[i - 2], phones[i - 1], phones[i + 1]

		if valid_phone[pcurr] then
			if not curword then
				curword, sylbuf, had_vowl, sylmarked = {}, '', false, false
				table.insert(words, curword)
			end
			
			local same_syl = true
			
			if vowel[pcurr] then
				if had_vowl then
					same_syl = false
				end
				had_vowl = true
			elseif had_vowl then
				if vowel[pnext] then
					same_syl = false
				elseif not vowel[pprev] and not vowel[pnext] then
					same_syl = false
				elseif ((pcurr == "s") and ((pnext == "t") or (pnext == "p") or (pnext == "k")))
				or (pnext == "r") or (pnext == "f") or (pnext == "w")
				or ((pcurr == "ɡ") and (pnext == "ʐ"))
				or ((pcurr == "d") and ((pnext == "l") or (pnext == "w") or (pnext == "ɲ")))
				then
					-- these should belong to a common syllable
					same_syl = false
				end
			end
			
			if same_syl then
				sylbuf = sylbuf .. pcurr
			else
				table.insert(curword, sylbuf)
				sylbuf, had_vowl = pcurr, vowel[pcurr]
			end
		elseif (curword or valid_phone[pnext]) and sylmarks[pcurr] then
			if not curword then
				curword, sylbuf, had_vowl = {}, '', false
				table.insert(words, curword)
			end
			sylmarked = true
			if sylbuf then
				table.insert(curword, sylbuf)
				sylbuf = ''
			end
			table.insert(curword, sylmarks[pcurr])
		else
			if sylbuf then
				if #curword > 0 and not had_vowl then
					curword[#curword] = curword[#curword] .. sylbuf
				else
					table.insert(curword, sylbuf)
				end
				if sylmarked then
					words[#words] = table.concat(curword)
				end
			end
			curword, sylbuf = nil, nil
			table.insert(words, pcurr)
		end
	end
	if sylbuf then
		if #curword > 0 and not had_vowl then
			curword[#curword] = curword[#curword] .. sylbuf
		else
			table.insert(curword, sylbuf)
		end
		if sylmarked then
			words[#words] = table.concat(curword)
		end
	end

	-- mark syllable breaks and stress
	for i, word in ipairs(words) do
		if type(word) == "table" then
			-- unless already marked
			if not ((word[2] == ".") or (word[2] == "ˈ") or (word[2] == "ˌ")) then
				for j, syl in ipairs(word) do
					if j == (#word - 1) then
						word[j] = "ˈ" .. syl
					elseif j ~= 1 then
						word[j] = "." .. syl
					end
				end
			end
			words[i] = table.concat(word)
		end
	end

	return table.concat(words)
end

while true do
	local line = io.read()
	if not line then break end
	out = export.convert_to_IPA(line)
	print(string.format("%s\t%s", line, out))
end
