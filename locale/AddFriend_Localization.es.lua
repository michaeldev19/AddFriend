if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then return end

L = setmetatable(L or {}, {__index = L})

L["OP_Add_Friend"] = "Añadir amigo"
L["OP_Remove_Friend"] = "Eliminar amigo"
L["OP_Add_Guild"] = "Invitar a la hermandad"
L["OP_Remove_Guild"] = "Eliminar de la hermandad"
L["TT_Add_Friend"] = "Añade al jugador a tu lista de amigos"
L["TT_Remove_Friend"] = "Elimina al jugador de tu lista de amigos"
L["TT_Add_Guild"] = "Invita a este jugador a unirse a tu hermandad"
L["TT_Remove_Guild"] = "Elimina a este jugador de tu hermandad"
