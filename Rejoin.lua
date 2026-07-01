local PACKAGE_NAME = "com.roblox.client"  
local CHECK_INTERVAL = 10                  
local PRIVATE_SERVER_URL = "ISI_DISINI_LINK_PRIVATE_SERVER_KAMU" 
local LOG_FILE = "/sdcard/download/rejoin_log.txt"

local function fstring(s)
    return tostring(s):gsub('"', '\\"')
end

local function run_as_root(command)
    local handle = io.popen("tsu -c \"" .. fstring(command) .. "\"")
    local result = handle:read("*a")
    handle:close()
    return result
end

local function log_message(text)
    print(text)
    local f = io.open(LOG_FILE, "a")
    if f then
        f:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. text .. "\n")
        f:close()
    end
end

local function is_roblox_running()
    local pid = run_as_root("pgrep -f " .. PACKAGE_NAME)
    if pid and pid:match("%d+") then
        return true
    else
        return false
    end
end

local function rejoin_game()
    log_message("[!] Roblox mati/crash. Memulai Rejoin ke server...")
    run_as_root("am force-stop " .. PACKAGE_NAME)
    os.execute("sleep 2")
    local launch_cmd = string.format("am start -a android.intent.action.VIEW -d \"%s\" -p %s", PRIVATE_SERVER_URL, PACKAGE_NAME)
    run_as_root(launch_cmd)
    log_message("[+] Perintah Rejoin berhasil dikirim!")
end

local function start_monitor()
    log_message("=========================================")
    log_message("     ROBLOX REJOINER OPTIMIZED ANDROID 10")
    log_message("=========================================")
    log_message("[*] Status: Monitoring Berjalan...")
    log_message("[*] Folder Log: " .. LOG_FILE)
    log_message("=========================================")

    while true do
        if not is_roblox_running() then
            rejoin_game()
            os.execute("sleep 20")
        end
        os.execute("sleep " .. tostring(CHECK_INTERVAL))
    end
end

start_monitor()
