lib.locale()

RegisterNetEvent('alv_lawyer:requestLawyer', function()
    local Data = {}
    local input = lib.inputDialog(locale('input_header'), {
        {type='input', label=locale('input_name'), description=locale('input_name_desc'), required=true},
        {type='checkbox', label=locale('input_self')},
        {type='input', label=locale('input_nameof'), description=locale('input_nameof_desc')},
        {type='input', label=locale('input_reason'), description=locale('input_reason_desc'), required = true},
        {type='number', label=locale('input_num'), description=locale('input_num_desc'), required=true}
    })

    if input then
        if input[1] then Data[#Data+1] = {label=locale('req_name'), description=input[1]} end
        if input[2] ~= nil then if input[2] then local forSelf = locale('yes') Data[#Data+1] = {label='For themself', description=forSelf} else local forSelf = locale('no') Data[#Data+1] = {label=locale('for_self'), description=forSelf, args={id='name'}} end end
        if input[3] ~= nil then if input[3] == '' then local forName = locale('n/a') Data[#Data+1] = {label=locale('for'), description=forName} else local forName = input[3] Data[#Data+1] = {label=locale('for'), description=forName, args={id='nameof'}} end end
        if input[4] then Data[#Data+1] = {label=locale('reason'), description=input[4], args={id='reason'}} end
        if input[5] then Data[#Data+1] = {label=locale('phone_number'), description=input[5], args={id='num'}} end
        Data[#Data+1] = {label=locale('close_request'), description=locale('close_desc'), args={id='close'}}
    end

    DebugPrint(json.encode(Requests, {indent=true}))

    lib.callback('alv_lawyer:sendRequest', cache.serverId, function(success)
        if success then Config.Notify(locale('lawyer_requested')) end
    end, Data)
end)

if Config.Command then
    RegisterCommand(Config.Command, function() TriggerEvent('alv_lawyer:requestLawyer') end)
end

RegisterCommand(Config.JobCommand, function()
    local allowed = lib.callback.await('alv_lawyer:job', false, 'check')
    local Data = {}

    if allowed then
        local requests = lib.callback.await('alv_lawyer:job', false, 'fetch')

        for k, v in pairs(requests) do
            for i, o in pairs(v) do
                if o.label == 'Request ID' then
                    Data[#Data+1] = {label='Request #'..o.description, args={id=o.description}}
                end
            end
        end

        lib.registerMenu({
            id='lawyer_menu', 
            title=locale('lawyer_menu'),
            position='bottom-right',
            options=Data
        }, function(selected, scroll, args)
            local specific = lib.callback.await('alv_lawyer:job', false, 'fetchById', args.id)

            lib.registerMenu({
                id='lawyer_menu_specific',
                title='Request #'..args.id,
                position='bottom-right',
                options=specific,
                onClose=function()
                    ExecuteCommand(Config.JobCommand)
                end
            }, function(selected, scroll, args)
                
            end)

            Wait(100)

            lib.showMenu('lawyer_menu_specific')
        end)

        Wait(100)

        if not lib.getOpenMenu() then
            lib.showMenu('lawyer_menu')
        end
    end
end)
