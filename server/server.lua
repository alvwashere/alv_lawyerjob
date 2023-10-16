Requests = {}

lib.callback.register('alv_lawyer:sendRequest', function(source, data)
    Data = data
    Data[#Data+1] = {label=locale('request_id'), description=#Requests+1, args={id=#Requests+1}}
    Requests[#Requests+1] = data
    return true
end)

lib.callback.register('alv_lawyer:job', function(source, type, data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if type == 'fetch' then
        return Requests
    elseif type == 'fetchById' then
        for k, v in pairs(Requests) do
            if k == data then
                return v
            end
        end
    elseif type == 'close' then

    elseif type == 'check' then
        if Config.LawyerJobs[xPlayer.getJob().name] then return true else return false end
    end
end)
