local Custom = {
	["<steam id here>"] = {color = Color(79, 148, 205), text = "Coder"}, -- Example 1, use these comments to remember usernames
	["<another steam id"] = {color = Color(210, 10, 10), text = "Some Donator"}, -- Example 2
}
local Ranks = {
	["Owner"] = {color = Color(142, 202, 209), text = "Owner"},
	["superadmin"] = {color = Color(193, 83, 237), text = "S. Admin"},
	["admin"] = {color = Color(0, 57, 158), text = "Admin"},
	["mod"] = {color = Color(0, 141, 160), text = "Mod"},
	["Trial-Mod"] = {color = Color(0, 155, 127), text = "Trial Mod"},
	["VIPPlus"] = {color = Color(247, 28, 255), text = "VIP +"},
	["VIP"] = {color = Color(251, 145, 255), text = "VIP"},
	["trusted"] = {color = Color(42, 168, 0), text = "Trusted"},
	["regular"] = {color = Color(201, 201, 201), text = "Regular"},
}

function CustomRanks( pnl )
	pnl:AddColumn( "Rank", function( ply, label )
		local custom = Custom[ply:SteamID()]
		local rank = Ranks[ply:GetUserGroup()]
		if custom then
			label:SetTextColor( custom.color )
			return custom.text
		elseif rank then
			label:SetTextColor( rank.color )
			return rank.text
		else
			return ""
		end
	end, 60 )
end

function PlayerChatTags( ply, txt, teamchat, dead )
	if IsValid( ply ) and ply:IsPlayer() then
		local rank = Ranks[ply:GetUserGroup()]
		local teamcolour = team.GetColor(ply:Team())
		local teamtext = "(TEAM) "
		local detecttag = ""
		
		if ply:IsDetective() then
			teamtext = "(DETECTIVE) "
			detecttag = "[D] "
		elseif ply:IsTraitor() then
			teamtext = "(TRAITOR) "
		end
		
		if rank then
			if !dead then
				if !teamchat then
					chat.AddText( rank.color, "[", rank.text, "] ", Color( 0,0,255 ), detecttag, teamcolour, ply:Nick(), color_white, ": ", txt )
				else
					chat.AddText( rank.color, "[", rank.text, "] ", teamcolour, teamtext, ply:Nick(), color_white, ": ", txt )
				end
			else
				if !teamchat then
					chat.AddText( Color( 255,0,0 ), "*DEAD* ", rank.color, "[", rank.text, "] ",teamcolour, ply:Nick(), color_white, ": ", txt )
				else
					chat.AddText( Color( 255,0,0 ), "*DEAD* ", teamcolour, "(TEAM) ", rank.color, "[", rank.text, "] ", teamcolour, ply:Nick(), color_white, ": ", txt )
				end
			end
		else
			if !dead then
				if !teamchat then
					chat.AddText( Color( 0,0,255 ), detecttag, teamcolour, ply:Nick(), color_white, ": ", txt )
				else
					chat.AddText( teamcolour, teamtext, ply:Nick(), color_white, ": ", txt )
				end
			else
				if !teamchat then
					chat.AddText( Color( 255,0,0 ), "*DEAD* ", teamcolour, ply:Nick(), color_white, ": ", txt )
				else
					chat.AddText( Color( 255,0,0 ), "*DEAD* ", teamcolour, "(TEAM) ", ply:Nick(), color_white, ": ", txt )
				end
			end
		end
		return true
	elseif !IsValid(ply) and !ply:IsPlayer() then
		chat.AddText( Color( 0, 255, 0 ), "Console", color_white, ": ", txt )
		return true
	end
end

hook.Add( "TTTScoreboardColumns", "CustomRanksTTT", CustomRanks )
hook.Add( "OnPlayerChat", "ChatTags", PlayerChatTags )