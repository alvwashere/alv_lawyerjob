lib.locale()

RegisterNetEvent('alv_lawyer:requestLawyer', function()
    local Data = {}
    local input = lib.inputDialog(locale('input_header'), {
        {type='input', label=locale('input_name'), description=locale('input_name_desc'), required=true},
        {type='checkbox', label=locale('input_self')},
        {type='input', label=locale('input_nameof'), description=locale('input_nameof_desc')},
        {type='input', label='Enter reason for lawyer', description='Please provide a brief description of why you need an attorney', required = true},
        {type='number', label='Please enter your phone number', description='We will need your number to contact you.', required=true}
    })

    if input then
        if input[1] then Data[#Data+1] = {label='Requester Name', description=input[1]} end
        if input[2] ~= nil then if input[2] then local forSelf = 'Yes' Data[#Data+1] = {label='For themself', description=forSelf} else local forSelf = 'No' Data[#Data+1] = {label='For themself', description=forSelf} end end
        if input[3] ~= nil then if input[3] == '' then local forName = 'N/A' Data[#Data+1] = {label='For: ', description=forName} else local forName = input[3] Data[#Data+1] = {label='For: ', description=forName} end end
        if input[4] then Data[#Data+1] = {label='Reason', description=input[4]} end
        if input[5] then Data[#Data+1] = {label='Phone Number', description=input[5]} end
        Data[#Data+1] = {label='Close Request', description='This action cannot be undone.'}
    end

    DebugPrint(json.encode(Requests, {indent=true}))

    lib.callback('alv_lawyer:sendRequest', cache.serverId, function(success)
        if success then Config.Notify('You have sent a request for a lawyer.') end
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
            title='Lawyer Menu',
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
