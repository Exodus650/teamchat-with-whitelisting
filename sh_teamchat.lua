--[[-------------------------------------------------------------------------
DarkRP chat module with team whitelisting, created by Exodus650 :D
---------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------
					CONFIG SECTION
---------------------------------------------------------------------------]]
local teamChatConfig = {
  -- The teams that are allowed to send and view messages.
  teamWhitelist = {TEAM_CP, TEAM_MAYOR},
  -- The prefix before the sent message (but after the sending player's name).
  chatPrefix = {"[TEAMCHAT]"},
  -- The color of the text in the message (Originally yellow).
  textColor = {Color(255, 255, 0, 255)},
  -- The error message if the players fails to provide text for the command.
  errorMessage = {"You need to provide text for your message."},
  -- The chat command for the message. (A "/" is added at the front automatically.)
  chatCommand = {"teamchat"},-- Please, do not use "/advert" as it is used for the new advert system in DarkRP.
  -- The F1 (help menu) description of the advert command.
  commandDescription = {"Message all players on your team."},
  -- The delay (in seconds) between players being able to advert.
  commandDelay = {3},

  -- DO NOT TOUCH THIS
  audience = {},
  }
  --[[-------------------------------------------------------------------------
  					END OF CONFIG
  ---------------------------------------------------------------------------]]
  DarkRP.declareChatCommand{ command = teamChatConfig.chatCommand, description = teamChatConfig.commandDescription, delay = teamChatConfig.commandDelay }

if CLIENT then return end
local function privateJobChat(ply, args)
  if args == "" then
    ply:SendLua(string.format([[notification.AddLegacy( "%s", NOTIFY_ERROR, 5 )
    surface.PlaySound( "buttons/button15.wav" )]], teamChatConfig.errorMessage))
  else
    if table.HasValue(teamChatConfig.teamWhitelist, ply:Team()) then -- checks if the players job is in the whitelist
      for k, v in pairs(player.GetAll()) do -- loops through all users
        if table.HasValue(teamChatConfig.teamWhitelist, v:Team()) then -- checks which users have jobs that are on the whitelist
        table.Insert(teamChatConfig.audience, v) -- stores those players in a table
        end
      end
    end

    for k, pl in pairs(teamChatConfig.audience) do -- loops through the players we stored previously
      local playerColor = team.GetColor(ply:Team()) -- grabs the players job color and stores it as a variable
      DarkRP.talkToPerson(pl, playerColor, teamChatConfig.chatPrefix .. " " .. ply:Nick(), teamChatConfig.textColor, args, ply) -- send our chat message to the users we grabbed previously
    end
  end
end

DarkRP.defineChatCommand(teamChatConfig.chatCommand, privateJobChat) -- creates a chat command that calls our function
