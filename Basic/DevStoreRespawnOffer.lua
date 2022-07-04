RandomOffer = {}
--[[

	RESPAWN OFFER 2.0
	    https://www.youtube.com/multiverseeditor
        UID: 2769323

	Descripcion: 
	    Este script le offrece un objeto al azar de tu tienda de objetos a los jugadores cuando reviven
		
    Instrucciones: 
        1.-Agrega los objetos a la tienda de desarrollador como lo haces normalmente.
        2.-Busca la id del objeto, abre este script y baja hasta la linea que dice: CONFIGURACION // SET UP
        3.- para agregar un objeto copia el siguiente texto sin comillas: "RandomOffer[Y] = XXXX"
        4.- Remplaza las XXXX con la ID de tu objeto, ejemplo la metralleta es 15000
        5.- Replaza la Y en [Y], con el numero siguiente, si es el primer objeto que agregas sera [1], si es el segundo sera [2], y asi consecutivamente 
        6.- Si por ejemplo estamos agregando el primer objeto, y es una metralleta RandomOffer[Y] = XXXX quedaria asi: RandomOffer[1] = 15000
        7.- Guarda el script y ejecuta el juego normalmente

    Mas scripts: https://github.com/YeyoCoreArt/YeyoScripts



---------------------------------]
-- CONFIGURACION // SET UP
---------------------------------]]
--Ejemplo
RandomOffer[1] = 15000 -- ID del objeto // Item ID 


---------------------------------------------------------------------------------
-- /!\ NO MODIFIQUES NADA DEBAJO DE ESTE TEXTO // DO NOT MODIFY AFTER THIS LINE
--------------------------------------------------------------------------------]]
function DevStoreRespawnOffer(e)
    local playerid = e.eventobjid
    local offereditem = math.random(1,#RandomOffer)
    local result = Player:openDevGoodsBuyDialog(playerid, RandomOffer[offereditem], "★ Lucky Start ★")
end
ScriptSupportEvent:registerEvent([=[Player.Revive]=], DevStoreRespawnOffer)
