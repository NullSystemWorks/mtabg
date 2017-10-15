function setGameWeather(w)
    if w then
        setWeather(w)
    end
end

addEvent("mtabg_onMatchStartChangeWeather",true)
addEventHandler("mtabg_onMatchStartChangeWeather",root,setGameWeather)
