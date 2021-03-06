# Defining custom error document so that all restrictions are routed to a HTML page which minimizes the resource impact:
ErrorDocument 403 /bots.html
ErrorDocument 404 /bots.html

# Disable directory indexing:
Options -Indexes 

# Twarting XSS attacks
Options +FollowSymLinks
RewriteEngine On
RewriteCond %{QUERY_STRING} base64_encode.*\(.*\) [OR]
RewriteCond %{QUERY_STRING} (\<|%3C).*script.*(\>|%3E) [NC,OR]
RewriteCond %{QUERY_STRING} (\<|%3C).*iframe.*(\>|%3E) [NC,OR]
RewriteCond %{QUERY_STRING} GLOBALS(=|\[|\%[0-9A-Z]{0,2}) [OR]
RewriteCond %{QUERY_STRING} _REQUEST(=|\[|\%[0-9A-Z]{0,2})
RewriteRule ^(.*)$ index_error.php [F,L]
RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)
RewriteRule .* - [F]


# block all queries from empty user-agents:
RewriteCond %{HTTP_USER_AGENT} ^$
RewriteRule ^(.*)$ - [F,L]

# block POST without valid referer (mitigates spambots) / this will cause issues with plugins that call home such as Jetpack or with some internal callbacks like those made by the "Limit Login Attempts" so it should be used with care on WP sites
#CHANGE EXAMPLE.COM WITH YOUR DOMAIN NAME
RewriteCond %{REQUEST_METHOD} POST
RewriteCond %{HTTP_REFERER} !(.*)example\.com(.*) [OR]
RewriteCond %{HTTP_USER_AGENT} ^-?$
RewriteRule ^(.*)$ - [F,L]

# block all queries made via proxies:
RewriteCond %{HTTP:VIA}                 !^$ [OR]
RewriteCond %{HTTP:FORWARDED}           !^$ [OR]
RewriteCond %{HTTP:USERAGENT_VIA}       !^$ [OR]
RewriteCond %{HTTP:X_FORWARDED_FOR}     !^$ [OR]
RewriteCond %{HTTP:PROXY_CONNECTION}    !^$ [OR]
RewriteCond %{HTTP:XPROXY_CONNECTION}   !^$ [OR]
RewriteCond %{HTTP:HTTP_PC_REMOTE_ADDR} !^$ [OR]
RewriteCond %{HTTP:HTTP_CLIENT_IP}      !^$
RewriteRule ^(.*)$ - [F]

# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress

# block malicious scans
<IfModule mod_rewrite.c>
	RewriteCond %{REQUEST_URI}  (mssqlil|register).php [NC,OR]
	RewriteCond %{REQUEST_URI}  (img|thumb|thumb_editor|thumbopen).php [NC,OR]
	RewriteCond %{QUERY_STRING} (img|thumb|thumb_editor|thumbopen).php [NC,OR]
	RewriteCond %{REQUEST_URI}  revslider [NC,OR]
	RewriteCond %{QUERY_STRING} revslider [NC]
	RewriteRule .* - [F,L]
</IfModule>

# block referer abusers
RewriteCond %{HTTP_REFERER} free-social-buttions\.com [NC,OR]
RewriteCond %{HTTP_REFERER} best-seo-offer\.com [NC,OR]
RewriteCond %{HTTP_REFERER} buttons-for-your-website\.com [NC,OR]
RewriteCond %{HTTP_REFERER} www1.free-social-buttons\.com [NC,OR]
RewriteCond %{HTTP_REFERER} www2.free-social-buttons\.com [NC,OR]
RewriteCond %{HTTP_REFERER} www3.free-social-buttons\.com [NC,OR]
RewriteCond %{HTTP_REFERER} 100dollars-seo.com\.com [NC,OR]
RewriteCond %{HTTP_REFERER} www4.free-social-buttons\.com
RewriteRule ^.* - [F,L]

# Block bad bots & scrapers using their user-agents
#
# blocking content harvesters and site copiers 
SetEnvIfNoCase User-Agent .*wget.* bad_bot
SetEnvIfNoCase User-Agent .*curl.* bad_bot
SetEnvIfNoCase User-Agent .*libwww-perl.* bad_bot
SetEnvIfNoCase User-Agent .*WinHttp.* bad_bot
SetEnvIfNoCase User-Agent .*okhttp.* bad_bot
SetEnvIfNoCase User-Agent .*python.* bad_bot
SetEnvIfNoCase User-Agent .*java.* bad_bot
SetEnvIfNoCase User-Agent .*WebReaper.* bad_bot
SetEnvIfNoCase User-Agent .*WebSauger.* bad_bot
SetEnvIfNoCase User-Agent ".*Website\ eXtractor.*" bad_bot
SetEnvIfNoCase User-Agent ".*Website\ Quester.*" bad_bot
SetEnvIfNoCase User-Agent .*Webster.* bad_bot
SetEnvIfNoCase User-Agent .*WebStripper.* bad_bot
SetEnvIfNoCase User-Agent .*WebWhacker.* bad_bot
SetEnvIfNoCase User-Agent .*WebZIP.* bad_bot
SetEnvIfNoCase User-Agent .*Whacker.* bad_bot
SetEnvIfNoCase User-Agent .*BatchFTP.* bad_bot
SetEnvIfNoCase User-Agent .*HTTrack.* bad_bot
SetEnvIfNoCase User-Agent .*Harvest.* bad_bot
SetEnvIfNoCase User-Agent .*Collector.* bad_bot
SetEnvIfNoCase User-Agent .*Copier.* bad_bot
SetEnvIfNoCase User-Agent .*Extractor.* bad_bot
SetEnvIfNoCase User-Agent .*lftp.* bad_bot
SetEnvIfNoCase User-Agent ".*libWeb\/clsHTTP.*" bad_bot
SetEnvIfNoCase User-Agent .*Mirror.* bad_bot
SetEnvIfNoCase User-Agent ".*Net\ Vampire.*" bad_bot
SetEnvIfNoCase User-Agent ".*Offline\ Explorer.*" bad_bot
SetEnvIfNoCase User-Agent ".*Offline\ Navigator.*" bad_bot
SetEnvIfNoCase User-Agent .*PageGrabber.* bad_bot
SetEnvIfNoCase User-Agent .*Sucker.* bad_bot
SetEnvIfNoCase User-Agent .*SuperHTTP.* bad_bot
SetEnvIfNoCase User-Agent .*Teleport.* bad_bot
SetEnvIfNoCase User-Agent .*Vacuum.* bad_bot
SetEnvIfNoCase User-Agent ".*Web\ Sucker.*" bad_bot
SetEnvIfNoCase User-Agent .*WebAuto.* bad_bot
SetEnvIfNoCase User-Agent .*WebBandit.* bad_bot
SetEnvIfNoCase User-Agent .*Webclipping.com.* bad_bot
SetEnvIfNoCase User-Agent .*WebCopier.* bad_bot
SetEnvIfNoCase User-Agent .*WebEnhancer.* bad_bot
SetEnvIfNoCase User-Agent .*WebFetch.* bad_bot
SetEnvIfNoCase User-Agent .*WebLeacher.* bad_bot
SetEnvIfNoCase User-Agent .*WWWOFFLE.* bad_bot
SetEnvIfNoCase User-Agent .*WWW-Collector-E.* bad_bot
SetEnvIfNoCase User-Agent .*Go-Ahead-Got-It.* bad_bot
SetEnvIfNoCase User-Agent .*gotit.* bad_bot
SetEnvIfNoCase User-Agent .*GrabNet.* bad_bot
SetEnvIfNoCase User-Agent .*lwp-trivial.* bad_bot
SetEnvIfNoCase User-Agent ".*LWP::Simple.*" bad_bot
SetEnvIfNoCase User-Agent .*Magnet.* bad_bot
SetEnvIfNoCase User-Agent .*Mag-Net.* bad_bot
SetEnvIfNoCase User-Agent .*moget.* bad_bot
SetEnvIfNoCase User-Agent ".*MIDown\ tool.*" bad_bot
SetEnvIfNoCase User-Agent .*NetSpider.* bad_bot
SetEnvIfNoCase User-Agent .*NetZIP.* bad_bot
SetEnvIfNoCase User-Agent .*Reaper.* bad_bot
SetEnvIfNoCase User-Agent .*Recorder.* bad_bot
SetEnvIfNoCase User-Agent .*ReGet.* bad_bot
SetEnvIfNoCase User-Agent .*RepoMonkey.* bad_bot
SetEnvIfNoCase User-Agent .*RMA.* bad_bot
SetEnvIfNoCase User-Agent .*Siphon.* bad_bot
SetEnvIfNoCase User-Agent .*SiteSnagger.* bad_bot
SetEnvIfNoCase User-Agent .*AppsViewer.* bad_bot # Google Apps used to steal!

# blocking vulnerability scanners
SetEnvIfNoCase User-Agent .*Acunetix.* bad_bot
SetEnvIfNoCase User-Agent .*FHscan.* bad_bot

# blocking aggressive chinese search engine
SetEnvIfNoCase User-Agent .*Baidu.* bad_bot
 
# blocking aggressive russian search engine
SetEnvIfNoCase User-Agent .*Yandex.* bad_bot

# blocking aggressive downloader scripts
SetEnvIfNoCase User-Agent ".*Download\ Demon.*" bad_bot
SetEnvIfNoCase User-Agent ".*Download\ Devil.*" bad_bot
SetEnvIfNoCase User-Agent ".*Download\ Wonder.*" bad_bot
SetEnvIfNoCase User-Agent ".*EirGrabber.*" bad_bot
SetEnvIfNoCase User-Agent .*EasyDL.* bad_bot
SetEnvIfNoCase User-Agent ".*Mass\ Downloader.*" bad_bot
SetEnvIfNoCase User-Agent .*RealDownload.* bad_bot
SetEnvIfNoCase User-Agent .*SmartDownload.* bad_bot

# blocking email harvesters
SetEnvIfNoCase User-Agent .*EmailCollector.* bad_bot
SetEnvIfNoCase User-Agent .*EmailSiphon.* bad_bot
SetEnvIfNoCase User-Agent .*EmailWolf.* bad_bot
SetEnvIfNoCase User-Agent .*WebEMailExtrac.* bad_bot
SetEnvIfNoCase User-Agent .*EmailSiphon.* bad_bot
SetEnvIfNoCase User-Agent .*Mail.* bad_bot

# blocking other crawlers, spiders and bots that are causing recursive queries
SetEnvIfNoCase User-Agent .*slurp.* bad_bot           # Yahoo Slurp
SetEnvIfNoCase User-Agent .*MJ12.* bad_bot            # Majestic SEO
SetEnvIfNoCase User-Agent .*FastProbe.* bad_bot       # FastProbe
SetEnvIfNoCase User-Agent .*spbot.* bad_bot           # spBot custom crawler used for internal search engine
SetEnvIfNoCase User-Agent .*dotbot.* bad_bot          # DotBot
SetEnvIfNoCase User-Agent .*semrush.* bad_bot         # SemRush
SetEnvIfNoCase User-Agent .*Daum.* bad_bot            # Daum
SetEnvIfNoCase User-Agent .*AOLBuild.* bad_bot        # AOL
SetEnvIfNoCase User-Agent .*duckduckgo.* bad_bot      # DuckDuckGo
SetEnvIfNoCase User-Agent .*teoma.* bad_bot           # Ask Jeeves
SetEnvIfNoCase User-Agent .*Aboundex.* bad_bot
SetEnvIfNoCase User-Agent .*80legs.* bad_bot
SetEnvIfNoCase User-Agent .*360Spider.* bad_bot
SetEnvIfNoCase User-Agent .*Cogentbot.* bad_bot
SetEnvIfNoCase User-Agent .*Alexibot.* bad_bot
SetEnvIfNoCase User-Agent .*asterias.* bad_bot
SetEnvIfNoCase User-Agent .*attach.* bad_bot
SetEnvIfNoCase User-Agent .*BackDoorBot.* bad_bot
SetEnvIfNoCase User-Agent .*BackWeb.* bad_bot
SetEnvIfNoCase User-Agent .*Bandit.* bad_bot
SetEnvIfNoCase User-Agent .*Bigfoot.* bad_bot
SetEnvIfNoCase User-Agent .*Black.Hole.* bad_bot
SetEnvIfNoCase User-Agent .*BlackWidow.* bad_bot
SetEnvIfNoCase User-Agent .*BlowFish.* bad_bot
SetEnvIfNoCase User-Agent .*BotALot.* bad_bot
SetEnvIfNoCase User-Agent .*Buddy.* bad_bot
SetEnvIfNoCase User-Agent .*BuiltBotTough.* bad_bot
SetEnvIfNoCase User-Agent .*Bullseye.* bad_bot
SetEnvIfNoCase User-Agent .*BunnySlippers.* bad_bot
SetEnvIfNoCase User-Agent .*Cegbfeieh.* bad_bot
SetEnvIfNoCase User-Agent .*CheeseBot.* bad_bot
SetEnvIfNoCase User-Agent .*CherryPicker.* bad_bot
SetEnvIfNoCase User-Agent .*ChinaClaw.* bad_bot
SetEnvIfNoCase User-Agent .*CopyRightCheck.* bad_bot
SetEnvIfNoCase User-Agent .*cosmos.* bad_bot
SetEnvIfNoCase User-Agent .*Crescent.* bad_bot
SetEnvIfNoCase User-Agent .*Custo.* bad_bot
SetEnvIfNoCase User-Agent .*AIBOT.* bad_bot
SetEnvIfNoCase User-Agent .*DISCo.* bad_bot
SetEnvIfNoCase User-Agent .*DIIbot.* bad_bot
SetEnvIfNoCase User-Agent .*DittoSpyder.* bad_bot
SetEnvIfNoCase User-Agent .*dragonfly.* bad_bot
SetEnvIfNoCase User-Agent .*Drip.* bad_bot
SetEnvIfNoCase User-Agent .*eCatch.* bad_bot
SetEnvIfNoCase User-Agent .*ebingbong.* bad_bot
SetEnvIfNoCase User-Agent .*EroCrawler.* bad_bot
SetEnvIfNoCase User-Agent .*EyeNetIE.* bad_bot
SetEnvIfNoCase User-Agent .*Foobot.* bad_bot
SetEnvIfNoCase User-Agent .*flunky.* bad_bot
SetEnvIfNoCase User-Agent .*FrontPage.* bad_bot
SetEnvIfNoCase User-Agent .*Grafula.* bad_bot
SetEnvIfNoCase User-Agent .*hloader.* bad_bot
SetEnvIfNoCase User-Agent .*HMView.* bad_bot
SetEnvIfNoCase User-Agent .*humanlinks.* bad_bot
SetEnvIfNoCase User-Agent .*IlseBot.* bad_bot
SetEnvIfNoCase User-Agent ".*Indy\ Library.*" bad_bot
SetEnvIfNoCase User-Agent .*InfoNaviRobot.* bad_bot
SetEnvIfNoCase User-Agent .*InfoTekies.* bad_bot
SetEnvIfNoCase User-Agent .*Intelliseek.* bad_bot
SetEnvIfNoCase User-Agent .*InterGET.* bad_bot
SetEnvIfNoCase User-Agent ".*Internet\ Ninja.*" bad_bot
SetEnvIfNoCase User-Agent .*Iria.* bad_bot
SetEnvIfNoCase User-Agent .*Jakarta.* bad_bot
SetEnvIfNoCase User-Agent .*JennyBot.* bad_bot
SetEnvIfNoCase User-Agent .*JetCar.* bad_bot
SetEnvIfNoCase User-Agent .*JOC.* bad_bot
SetEnvIfNoCase User-Agent .*JustView.* bad_bot
SetEnvIfNoCase User-Agent .*Jyxobot.* bad_bot
SetEnvIfNoCase User-Agent .*Kenjin.Spider.* bad_bot
SetEnvIfNoCase User-Agent .*Keyword.Density.* bad_bot
SetEnvIfNoCase User-Agent .*larbin.* bad_bot
SetEnvIfNoCase User-Agent .*LexiBot.* bad_bot
SetEnvIfNoCase User-Agent .*likse.* bad_bot
SetEnvIfNoCase User-Agent .*MarkWatch.* bad_bot
SetEnvIfNoCase User-Agent .*Mata.Hari.* bad_bot
SetEnvIfNoCase User-Agent .*Memo.* bad_bot
SetEnvIfNoCase User-Agent .*Microsoft.URL.* bad_bot
SetEnvIfNoCase User-Agent ".*Microsoft\ URL\ Control.*" bad_bot
SetEnvIfNoCase User-Agent .*MIIxpc.* bad_bot
SetEnvIfNoCase User-Agent ".*Missigua\ Locator.*" bad_bot
SetEnvIfNoCase User-Agent ".*Mister\ PiX.*" bad_bot
SetEnvIfNoCase User-Agent .*NAMEPROTECT.* bad_bot
SetEnvIfNoCase User-Agent .*Navroad.* bad_bot
SetEnvIfNoCase User-Agent .*NearSite.* bad_bot
SetEnvIfNoCase User-Agent .*NetAnts.* bad_bot
SetEnvIfNoCase User-Agent .*Netcraft.* bad_bot
SetEnvIfNoCase User-Agent .*NetMechanic.* bad_bot
SetEnvIfNoCase User-Agent .*NextGenSearchBot.* bad_bot
SetEnvIfNoCase User-Agent .*NICErsPRO.* bad_bot
SetEnvIfNoCase User-Agent .*niki-bot.* bad_bot
SetEnvIfNoCase User-Agent .*NimbleCrawler.* bad_bot
SetEnvIfNoCase User-Agent .*Ninja.* bad_bot
SetEnvIfNoCase User-Agent .*NPbot.* bad_bot
SetEnvIfNoCase User-Agent .*Octopus.* bad_bot
SetEnvIfNoCase User-Agent .*Openfind.* bad_bot
SetEnvIfNoCase User-Agent .*OutfoxBot.* bad_bot
SetEnvIfNoCase User-Agent ".*Papa\ Foto.*" bad_bot
SetEnvIfNoCase User-Agent .*pavuk.* bad_bot
SetEnvIfNoCase User-Agent .*pcBrowser.* bad_bot
SetEnvIfNoCase User-Agent ".*PHP\ version\ tracker.*" bad_bot
SetEnvIfNoCase User-Agent .*Pockey.* bad_bot
SetEnvIfNoCase User-Agent ".*ProPowerBot\/2.14.*" bad_bot
SetEnvIfNoCase User-Agent .*ProWebWalker.* bad_bot
SetEnvIfNoCase User-Agent .*psbot.* bad_bot
SetEnvIfNoCase User-Agent .*Pump.* bad_bot
SetEnvIfNoCase User-Agent .*QueryN.Metasearch.* bad_bot
SetEnvIfNoCase User-Agent .*SlySearch.* bad_bot
SetEnvIfNoCase User-Agent .*Snake.* bad_bot
SetEnvIfNoCase User-Agent .*Snapbot.* bad_bot
SetEnvIfNoCase User-Agent .*Snoopy.* bad_bot
SetEnvIfNoCase User-Agent .*sogou.* bad_bot
SetEnvIfNoCase User-Agent .*SpaceBison.* bad_bot
SetEnvIfNoCase User-Agent .*SpankBot.* bad_bot
SetEnvIfNoCase User-Agent .*spanner.* bad_bot
SetEnvIfNoCase User-Agent .*Sqworm.* bad_bot
SetEnvIfNoCase User-Agent .*Stripper.* bad_bot
SetEnvIfNoCase User-Agent .*SuperBot.* bad_bot
SetEnvIfNoCase User-Agent .*Surfbot.* bad_bot
SetEnvIfNoCase User-Agent .*suzuran.* bad_bot
SetEnvIfNoCase User-Agent ".*Szukacz\/1.4.*" bad_bot
SetEnvIfNoCase User-Agent .*tAkeOut.* bad_bot
SetEnvIfNoCase User-Agent .*Telesoft.* bad_bot
SetEnvIfNoCase User-Agent ".*TurnitinBot\/1.5.*" bad_bot
SetEnvIfNoCase User-Agent .*The.Intraformant.* bad_bot
SetEnvIfNoCase User-Agent .*TheNomad.* bad_bot
SetEnvIfNoCase User-Agent .*TightTwatBot.* bad_bot
SetEnvIfNoCase User-Agent .*Titan.* bad_bot
SetEnvIfNoCase User-Agent .*True_Robot.* bad_bot
SetEnvIfNoCase User-Agent .*turingos.* bad_bot
SetEnvIfNoCase User-Agent .*TurnitinBot.* bad_bot
SetEnvIfNoCase User-Agent .*URLy.Warning.* bad_bot
SetEnvIfNoCase User-Agent .*VCI.* bad_bot
SetEnvIfNoCase User-Agent .*VoidEYE.* bad_bot
SetEnvIfNoCase User-Agent .*WebmasterWorldForumBot.* bad_bot
SetEnvIfNoCase User-Agent ".*WebGo\ IS.*" bad_bot
SetEnvIfNoCase User-Agent .*Widow.* bad_bot
SetEnvIfNoCase User-Agent .*WISENutbot.* bad_bot
SetEnvIfNoCase User-Agent .*Xaldon.* bad_bot
SetEnvIfNoCase User-Agent .*Zeus.* bad_bot
SetEnvIfNoCase User-Agent .*ZmEu.* bad_bot
SetEnvIfNoCase User-Agent .*Zyborg.* bad_bot
SetEnvIfNoCase User-Agent .*crawle.* bad_bot
SetEnvIfNoCase User-Agent .*igdeSpyder.* bad_bot
SetEnvIfNoCase User-Agent .*Robot.* bad_bot
SetEnvIfNoCase User-Agent .*Aport.* bad_bot
SetEnvIfNoCase User-Agent .*spider.* bad_bot
SetEnvIfNoCase User-Agent .*Parser.* bad_bot
SetEnvIfNoCase User-Agent .*ahref.* bad_bot
SetEnvIfNoCase User-Agent .*zoom.* bad_bot
SetEnvIfNoCase User-Agent .*Powermarks.* bad_bot
SetEnvIfNoCase User-Agent .*SafeDNS.* bad_bot
SetEnvIfNoCase User-Agent .*BLEXBot.* bad_bot
SetEnvIfNoCase User-Agent .*aria2.* bad_bot
SetEnvIfNoCase User-Agent .*wikido.* bad_bot
SetEnvIfNoCase User-Agent .*Qwantify.* bad_bot
SetEnvIfNoCase User-Agent .*DotBot.* bad_bot
SetEnvIfNoCase User-Agent .*FatBot.* bad_bot
SetEnvIfNoCase User-Agent .*grapeshot.* bad_bot
SetEnvIfNoCase User-Agent .*Nutch.* bad_bot
SetEnvIfNoCase User-Agent .*linkdexbot.* bad_bot
SetEnvIfNoCase User-Agent .*Twitterbot.* bad_bot
SetEnvIfNoCase User-Agent ".*Google\-HTTP\-Java\-Client.*" bad_bot
SetEnvIfNoCase User-Agent .*MetaCommentBot.* bad_bot
SetEnvIfNoCase User-Agent .*Veoozbot.* bad_bot
SetEnvIfNoCase User-Agent .*ScoutJet.* bad_bot
SetEnvIfNoCase User-Agent .*DomainAppender.* bad_bot

# blocking direct queries via PHP or automated scripts using PHP
SetEnvIfNoCase User-Agent .*PHP\/5.* bad_bot
SetEnvIfNoCase User-Agent .*PHP\/4.* bad_bot
SetEnvIfNoCase User-Agent .*PHP\/3.* bad_bot

# blocking image harvesters and thumbnail generators 
SetEnvIfNoCase User-Agent .*Thumbtack-Thunderdome.* bad_bot
SetEnvIfNoCase User-Agent .*Googlebot-Image.* bad_bot        # yes we block Google Images too due to impact over resources
SetEnvIfNoCase User-Agent .*Googlebot-Video.* bad_bot
SetEnvIfNoCase User-Agent .*bingpreview.* bad_bot
SetEnvIfNoCase User-Agent .*msnbot-media.* bad_bot
SetEnvIfNoCase User-Agent .*Exabot.* bad_bot
SetEnvIfNoCase User-Agent ".*Image\ Stripper.*" bad_bot
SetEnvIfNoCase User-Agent ".*Image\ Sucker.*" bad_bot
SetEnvIfNoCase User-Agent ".*Express\ WebPictures.*" bad_bot
SetEnvIfNoCase User-Agent ".*Web\ Image\ Collector.*" bad_bot
SetEnvIfNoCase User-Agent .*Web.Image.Collector.* bad_bot

# blocking malicious browsers
SetEnvIfNoCase User-Agent ".*Firefox\ mutant.*" bad_bot
SetEnvIfNoCase User-Agent ".*Ukraine\ Local.*" bad_bot
SetEnvIfNoCase User-Agent ".*Mozilla\/3.Mozilla\/2.01.*" bad_bot
SetEnvIfNoCase User-Agent ".*Mozilla.*NEWT.*" bad_bot

# link extractors
SetEnvIfNoCase User-Agent .*LinkextractorPro.* bad_bot
SetEnvIfNoCase User-Agent ".*LinkScan\/8.1a.Unix.*" bad_bot
SetEnvIfNoCase User-Agent .*LNSpiderguy.* bad_bot
SetEnvIfNoCase User-Agent .*LinkWalker.* bad_bot
SetEnvIfNoCase User-Agent .*Xenu.* bad_bot

# if we do not use the RSS feed or don't want it harvested we can add this too:
SetEnvIfNoCase User-Agent .*feed.* bad_bot
SetEnvIfNoCase User-Agent .*rss.* bad_bot

<Limit GET POST HEAD>
Order Allow,Deny
Allow from all
Deny from env=bad_bot
</Limit>

# denying some subnets that are known to propagate attacks:

# Cyveillance subnets
deny from 38.100.19.8/29
deny from 38.100.21.0/24
deny from 38.100.41.64/26
deny from 38.105.71.0/25
deny from 38.105.83.0/27
deny from 38.112.21.140/30
deny from 38.118.42.32/29
deny from 65.213.208.128/27
deny from 65.222.176.96/27
deny from 65.222.185.72/29

# Poneytelecom subnets
deny from 62.4.0.0/19
deny from 62.210.0.0/16
deny from 195.154.0.0/16
deny from 212.47.224.0/19
deny from 212.83.128.0/19
deny from 212.83.160.0/19
deny from 212.129.0.0/18

# Ecatel & Leaseweb subnets
deny from 80.82.64.0/24
deny from 80.82.65.0/24
deny from 80.82.66.0/24
deny from 80.82.67.0/24
deny from 80.82.68.0/24
deny from 80.82.69.0/24
deny from 80.82.70.0/24
deny from 80.82.76.0/24
deny from 80.82.77.0/24
deny from 80.82.78.0/24
deny from 80.82.79.0/24
deny from 89.248.160.0/21
deny from 89.248.168.0/24
deny from 89.248.169.0/24
deny from 89.248.170.0/23
deny from 89.248.172.0/23
deny from 89.248.174.0/24
deny from 93.174.88.0/21
deny from 94.102.48.0/20
deny from 188.72.106.0/24
deny from 188.72.117.0/24
deny from 185.56.80.125

# Aboundex 
Deny from 173.192.34.95

# Bluecoat
deny from 8.21.4.254
deny from 65.46.48.192/30
deny from 65.160.238.176/28
deny from 85.92.222.0/24
deny from 206.51.36.0/22
deny from 216.52.23.0/24

# Cyberpatrol
deny from 38.103.17.160/27

# Internet Identity - Anti-Phishing
deny from 66.113.96.0/20
deny from 70.35.113.192/27

# Ironport
deny from 204.15.80.0/22

# Lightspeed Systems Security
deny from 66.17.15.128/26
deny from 69.84.207.32/27
deny from 69.84.207.128/25

# Layered Technologies
deny from 72.36.128.0/17
deny from 72.232.0.0/16
deny from 72.233.0.0/17
deny from 216.32.0.0/14

# M86
deny from 67.192.231.224/29
deny from 208.90.236.0/22

# Phish-Inspector.com
deny from 209.147.127.208/28

# Prescient Software, Inc. Phishmongers
deny from 198.186.190.0/23
deny from 198.186.192.0/23
deny from 198.186.194.0/24

# urlfilterdb
deny from 207.210.99.32/29

# websense-in.car1.sandiego1.level3.net
deny from 4.53.120.22

# Websense
deny from 66.194.6.0/24
deny from 67.117.201.128/28
deny from 69.67.32.0/20
deny from 131.191.87.0/24
deny from 204.15.64.0/21
deny from 208.80.192.0/21
deny from 212.62.26.64/27
deny from 213.168.226.0/24
deny from 213.168.241.0/30
deny from 213.168.242.0/30
deny from 213.236.150.16/28
