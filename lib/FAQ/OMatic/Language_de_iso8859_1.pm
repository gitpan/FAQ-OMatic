###
### submitItem.pm
###

sub translations {
	my $tx = shift;
	my $txfile = <<'__EOF__';
### 
### submitItem.pm
###

msgid "The file"
msgstr "Die Datei"

msgid "doesn't exist."
msgstr "konnte nicht gefunden werden."

msgid "Your browser or WWW cache has truncated your POST."
msgstr "Ihr Browser oder WWW-Cache hat Ihre Post gek�rzt."

msgid "Changed the item title, was"
msgstr "Die Titel wurde ge�ndert in"

msgid "Your part order list"
msgstr "Ihre Liste mit den Abschnitten"

msgid "doesn't have the same number of parts"
msgstr "hat nicht die gleiche Anzahl von Abschnitten"

msgid "as the original item."
msgstr "wie der Original-Eintrag."

msgid "doesn't say what to do with part"
msgstr "beschreibt keine Aktion mit dem Abschnitt"

###
### submitMove.pm
###

msgid "The moving file" 
msgstr "Die zu verschiebene Datei" 

msgid "is broken or missing."
msgstr "ist defekt oder nicht vorhanden."

msgid "The newParent file" 
msgstr "Die newParant-Datei"

msgid "is broken or missing."
msgstr "ist defekt oder nicht vorhanden."

msgid "The oldParent file" 
msgstr "Die oldParant-Datei" 

msgid "is broken or missing."
msgstr "ist defekt oder nicht vorhanden."

msgid "The new parent"
msgstr "Die newParent-Datei"

msgid "is the same as the old parent."
msgstr "ist die gleiche wie die oldParent-Datei."

msgid "is the same as the item you want to move."
msgstr "ist gleich mit dem Eintrag den Sie verschieben m�chten."

msgid "The new parent"
msgstr "Die neue parent-Datei"

msgid "is a child of the item being moved"
msgstr "ist ein Kind vom Eintrag der verschoben wurde"

msgid "You can't move the top item."
msgstr "Sie k�nnen den in der Hierarchie h�chsten Eintrag nicht verschieben."

msgid "moved a sub-item to"
msgstr "hat ein Subeintrag verschoben nach"

msgid "moved a sub-item from"
msgstr "hat ein Subeintrag verschoben von"

###
### submitPass.pm
###

msgid "An email address must look like"
msgstr "Eine eMail-Adresse sollte folgenderma�en aufgebaut sein:"

msgid "If yours"
msgstr "Wenn Ihre Mailadresse"

msgid "does and I keep rejecting it, please mail"
msgstr "lautet und nicht akzeptiert wurde, schicken Sie bitte eine Mail an"

msgid "and tell him what's happening."
msgstr "mit der Fehlerbeschreibung."

msgid "Your password may not contain spaces or carriage returns."
msgstr "Ihr Passwort darf keine Leerzeichen enthalten."

msgid "Your Faq-O-Matic authentication secret"
msgstr "Ihr Faq-O-Matic Schl�ssel"

msgid "I couldn't mail the authentication secret to"
msgstr "Konnte den Schl�ssel nicht senden an"

msgid "and I'm not sure why."
msgstr "aus ungekl�rter Ursache."

msgid "The secret you entered is not correct."
msgstr "Der eingegebe Schl�ssel ist falsch."

msgid "Did you copy and paste the secret or the URL completely?"
msgstr "Haben Sie die URL komplett kopiert und wieder eingef�gt?"

msgid "I sent email to you at"
msgstr "Es wurde eine email zur folgenden Adresse geschickt:"

msgid "It should arrive soon, containing a URL. Either open the URL directly, or paste the secret into the form below and click Validate."
msgstr "Die Mail, die eine URL enth�lt, wird gleich in Ihrer Mailbox sein. Entweder �ffnen Sie die URL direkt oder f�gen den Schl�ssel in das Eingabefeld unten ein und klicken auf Absenden."

msgid "Thank you for taking the time to sign up."
msgstr "Vielen Dank das Sie sich Zeit genommen haben f�r die Registrierung."

msgid "Secret:"
msgstr "Schl�ssel:"

msgid "Validate"
msgstr "Absenden"

###
### editBag.pm
###

msgid "Replace bag"
msgstr "Ersetze Datei-Objekt"

###
### OMatic.pm
###

msgid "Warnings:"
msgstr "Warnungen:"

###
### install.pm
###

msgid "Faq-O-Matic Installer"
msgstr "Faq-O-Matic Installation"

msgid "failed:"
msgstr "schlug fehl:"

msgid "Unknown step:"
msgstr "Unbekannter Schritt:"

msgid "Updating config to reflect new meta location"
msgstr "Konfiguration wird aktualisiert f�r neues meta-Verzeichnis"

msgid "(Can't find <b>config</b> in '$meta' -- assuming this is a new installation.)"
msgstr "(Konnte <b>config</b> nicht in '$meta' finden -- vermutlich ist dies eine Neuinstallation.)"

msgid "Click here"
msgstr "Klicke hier"

msgid "to create"
msgstr "zum erzeugen von"

msgid "If you want to change the CGI stub to point to another directory, edit the script and then\n"
msgstr "Wenn Sie den CGI-Abschnitt in einem anderem Verzeichnis ablegen m�chten, editieren Sie das Skript und dann\n"

msgud "click here to use the new location"
msgstr "klicke hier, um das neue Verzeichnis zu benutzen"

msgid "FAQ-O-Matic stores files in two main directories.<p>The <b>meta/</b> directory path is encoded in your CGI stub ($0). It contains:"
msgstr "FAQ-O-Matic speichert Dateien in zwei Haupverzeichnisse.<p>Das <b>meta/</b>-Verzeichnis wird f�r CGI benutzt ($0). Es enth�lt:"

msgid "<ul><li>the <b>config</b> file that tells FAQ-O-Matic where everything else lives. That's why the CGI stub needs to know where meta/ is, so it can figure out the rest of its configuration. <li>the <b>idfile</b> file that lists user identities. Therefore, meta/ should not be accessible via the web server. <li>the <b>RCS/</b> subdirectory that tracks revisions to FAQ items. <li>various hint files that are used as FAQ-O-Matic runs. These can be regenerated automatically.</ul>"
msgstr "<ul><li>Das <b>config</b>-File, wo alle FAQ-O-Matic-Verzeichniseintr�ge abgelegt sind. Dies ist f�r den CGI-Abschnitt wichtig, damit das Verzeichnis meta/ gefunden wird. <li>Das <b>idfile</b> wo Benutzerdaten abgelegt werden. Deshalb sollte das Verzeichnis meta/ nicht via Web-Server freigegeben sein. <li>Das <b>RCS/</b> Unterverzeichnis, was auf die verschiedenen Versionen der FAQ-Eintr�ge zeigt. <li>verschiedene Dateien die zur Laufzeit von FAQ-O-Matic angelegt werden.</ul>"

msgid "<p>The <b>serve/</b> directory contains three subdirectories <b>item/</b>, <b>cache/</b>, and <b>bags/</b>. These directories are created and populated by the FAQ-O-Matic CGI, but should be directly accessible via the web server (without invoking the CGI)."
msgstr "<p>Das <b>serve/</b>-Verzeichnis enth�lt drei Unterverzeichnisse: <b>item/</b>, <b>cache/</b> und <b>bags/</b>. Diese Verzeichnisse werden erzeugt und benutzt von FAQ-O-Matic-CGI und sollten daher auf dem Webserver frei verf�gbar sein (ohne CGI einzuschalten)."

msgid "<ul><li>serve/item/ contains only FAQ-O-Matic formatted source files, which encode both user-entered text and the hierarchical structure of the answers and categories in the FAQ. These files are only accessed through the web server (rather than the CGI) when another FAQ-O-Matic is mirroring this one. <li>serve/cache/ contains a cache of automatically-generated HTML versions of FAQ answers and categories. When possible, the CGI directs users to the cache to reduce load on the server. (CGI hits are far more expensive than regular file loads.) <li>serve/bags/ contains image files and other ``bags of bits.'' Bit-bags can be linked to or inlined into FAQ items (in the case of images). </ul>"
msgstr "<ul><li>serve/item/ enth�lt ausschlie�lich FAQ-O-Matic-formatierte source-Files, welche den vom Benutzer eingegebenen Text und die hierachische Struktur der Eintr�ge und Kategorien enth�lt. Auf diese Dateien kann nur �ber den Webserver zugegriffen werden, wenn ein anderes FAQ-O-Matic diese spiegelt. <li>serve/cache/ enth�lt ein Cache von automatisch erstellten HTML-Versionen von FAQ-Eintr�gen und Kategorien. Wenn m�glich, wird der Cache benutzt, um den Server zu entlasten. (CGI-Zugriffe sind weitaus teurer als regul�re Dateizugriffe.) <li>serve/bags/ enth�lt Bild-Dateien und und andere Datei-Objekte. Datei-Objekte k�nnen in FAQ-Eintr�ge eingef�gt werden).</ul>"

msgid "I don't have write permission to <b>$meta</b>."
msgstr "Habe keine Schreib-Berechtigung f�r <b>$meta</b>."

msgid "I couldn't create"
msgstr "Fehler beim erzeugen von"

msgid "Created"
msgstr "erzeugt: "

msgid "I don't have write permission to"
msgstr "Habe keine Schreib-Berechtigung f�r"

msgid "Created new config file."
msgstr "Habe neues config-File erzeugt."

msgid "Couldn't create"
msgstr "Fehler beim erzeugen von"

msgid "The idfile exists."
msgstr "Das idfile ist vorhanden."

msgid "Configuration Main Menu (install module)"
msgstr "Konfigurationsmen� (Modulinstallation)"

msgid "Perform these tasks in order to prepare your FAQ-O-Matic version"
msgstr "F�hre diese Schritte durch, f�r FAQ-O-Matic Version"

msgid "Define configuration parameters."
msgstr "Festlegen der Konfigurationsparameter."

msgid "Set your password and turn on installer security"
msgstr "W�hlen Sie Ihr Passwort und Installations-Sicherheit"

msgid "(Need to configure"
msgstr "(Wird ben�tigt zur Konfiguration von"

msgid "(Installer security is on.)"
msgstr "(Installations-Sicherheit ist an.)"

msgid "Create item, cache, and bags directories in serve dir."
msgstr "Erzeuge Eintrags-, Cache und Datei-Objekt-Verzeichnisse."

msgid "Copy old items</a> from"
msgstr "Kopiere alte Eintr�ge</a> von"

msgid "to"
msgstr "nach"

msgid "Install any new items that come with the system."
msgstr "Installiere neue System-Eintr�ge."

msgid "Create system default items."
msgstr "Erstelle Systemdefault-Eintr�ge"

msgid "Rebuild the cache and dependency files."
msgstr "Erneuere den Cache und die davon abh�ngigen Dateien."

msgid "Install system images and icons."
msgstr "Installiere Systemgrafiken und Icons."

msgid "Update mirror from master now. (this can be slow!)"
msgstr "Updaten der Mirror-Files (kann lange dauern)"

msgid "Set up the maintenance cron job"
msgstr "Einrichten des Pflegedienstes"

msgid "Run maintenance script manually now"
msgstr "Starte Pflege-Skript jetzt manuell"

msgid "(Need to set up the maintenance cron job first)"
msgstr "(Notwendig um den Pflegedienst erstmalig einzuschalten)"

msgid "Mark the config file as upgraded to Version"
msgstr "Vermerke im Konfigurationsfile die neue Versionsnummer"

msgid "Select custom colors for your Faq-O-Matic</a> (optional)"
msgstr "Benutzerdefinierte Farben f�r Faq-O-Matic</a> (optional)"

msgid "Define groups</a> (optional)"
msgstr "Lege Gruppen fest</a> (optional)"

msgid "Upgrade to CGI.pm version 2.49 or newer."
msgstr "Upgrade auf CGI.pm Version 2.49 oder neuer."

msgid "(optional; older versions have bugs that affect bags)"
msgstr "(optional; �ltere Versionen haben Fehler beim Umgang mit Datei-Objekten)"

msgid "You are using version"
msgstr "Sie benutzen Version"

msgid "now"
msgstr "zur Zeit"

msgid "Bookmark this link to be able to return to this menu."
msgstr "Setzen Sie ein Lesezeichen auf diese URL, damit Sie wieder zum Men� zur�ckkehren k�nnen."

msgid "Go to the Faq-O-Matic"
msgstr "Gehe zur Faq-O-Matic"

msgid "(need to turn on installer security)"
msgstr "(Installations-Sicherheit geht verloren)"

msgid "Other available tasks:"
msgstr "Andere vorhandene Tasks:"

msgid "See access statistics."
msgstr "Zugriffs-Statistik anzeigen."

msgid "Examine all bags."
msgstr "Untersuche alle Datei-Objekte."

msgid "Check for unreferenced bags (not linked by any FAQ item)."
msgstr "Suche nach Datei-Objekten, die in keinem FAQ-Eintrag vorhanden sind)."

msgid "Rebuild the cache and dependency files."
msgstr "Erneuere den Cache und die davon abh�ngigen Dateien."

msgid "The Faq-O-Matic modules are version"
msgstr "Die Faq-O-Matic-Module haben die Version"

msgid "I wasn't able to change the permissions on"
msgstr "Ich darf die Zugriffsrechte nicht �ndern von"

msgid "to 755 (readable/searchable by all)."
msgstr "nach 755 (lesbar/suchbar von Allen)."

msgid "updated config file:"
msgstr "Habe config-file upgedatet:"

msgid "Redefine configuration parameters to ensure that"
msgstr "Erneuere Konfigurationsparameter um sicherzustellen das"

msgid "is valid."
msgstr "g�ltig ist."

msgid "Jon made a mistake here; key=$key, property=$property."
msgstr "Jon hat hier einen Fehler gemacht; key=$key, property=$property."

msgid "<b>Mandatory:</b> System information"
msgstr "<b>Vorschreibend:</b> System-Information"

msgid "Identity of local FAQ-O-Matic administrator (an email address)"
msgstr "Identit�t des FAQ-O-Matic Administrators (email-Adresse)"

msgid "A command FAQ-O-Matic can use to send mail. It must either be sendmail, or it must understand the -s (Subject) switch."
msgstr "Ein FAQ-O-Matic-Kommando sendet eine Mail via sendmail oder mit dem -s (Subject) Argument."

msgid "The command FAQ-O-Matic can use to install a cron job."
msgstr "Das Kommando mit dem FAQ-O-Matic ein cron-job benutzt"

msgid "RCS ci command."
msgstr "RCS ci Kommando."

msgid "<b>Mandatory:</b> Server directory configuration"
msgstr "<b>Vorschreibend:</b> Server-Verzeichnis-Konfiguration"

msgid "Filesystem directory where FAQ-O-Matic will keep item files, image and other bit-bag files, and a cache of generated HTML files. This directory must be accesible directly via the http server. It might be something like /home/faqomatic/public_html/fom-serve/"
msgstr "Dateisystem-Verzeichnis wo FAQ-O-Matic die item-Files, andere Datei-Objekte und den Cache von erzeugten HTML-Files ablegt. Auf dieses Verzeichnis wird via HTTP zugegriffen. Beispiel : /home/faqomatic/public_html/fom-serve/" 

msgid "Use the" 
msgstr "Benutze den"

msgid "links to change the color of a feature.\n"
msgstr "Link um eine bestimmte Farben zu �ndern.\n"  

msgid "An Item Title"
msgstr "Ein Titeleintrag"

msgid "A regular part is how most of your content will appear. The text colors should be most pleasantly readable on this background."
msgstr "In diesem regul�re Abschnitt wird der Inhalt erscheinen. Die Textfarben sollten gut lesbar sein auf diesem Hintergrund."

msgid "A new link"
msgstr "Ein neuer Link"

msgid "A visited link"
msgstr "Ein besuchter Link"

msgid "A search hit"
msgstr "Ein Suchergebnis"

msgid "A directory part should stand out"
msgstr "Ein Verzeichnis sollte hervortreten"

msgid "Regular text color"
msgstr "Regul�re Textfarbe"

msgid "Link color"
msgstr "Farbe eines Links"

msgid "Visited link color"
msgstr "Farbe eines besuchten Links"  

msgid "to proceed to the"
msgstr "um weitermachen bei:"

msgid "step"
msgstr "Schritt"

msgid "Select a color for"
msgstr "W�hle eine Farbe f�r"

msgid "Or enter an HTML color specification manually:"
msgstr "Oder gebe einen HTML-Farben-Code ein:"

msgid "Select"
msgstr "OK"

msgid "The URL prefix needed to access files in" 
msgstr "Der URL-Prefix ist n�tig f�r den Filezugriff in"

msgid "It should be relative to the root of the server (omit http://hostname:port, but include a leading /). It should also end with a /."
msgstr " Er sollte relativ zum root des Servers (ohne http://hostname:port, aber mit einem Slash (/) am Anfang). Am Ende der Kommandozeile sollte auch ein Slash (/) stehen."

msgid "<i>Optional:</i> Miscellaneous configurations"
msgstr "<i>Optional:</i> Verschiedene Einstellungen"

msgid "If this parameter is set, this FAQ will become a mirror of the one at the given URL. The URL should be the base name of the CGI script of the master FAQ-O-Matic."
msgstr "Wenn diese Einstellung gesetzt ist, wird FAQ-O-Matic an der angegebenen URL gespiegelt. Die URL sollte auf das FAQ-O-Matic-CGI-Script zeigen."

msgid "An HTML fragment inserted at the top of each page. You might use this to place a corporate logo."
msgstr "Auf jeder Seite wird am Anfang ein HTML-Fragment eingef�gt. Dies kann zum Plazieren eines gemeinsamen Logos verwendet werden."

msgid "The width= tag in a table. If your"
msgstr "Der width= Tag in einer Tabelle. Steht im"

msgid "has"
msgstr " " 

msgid "you will want to make this empty."
msgstr "sollte dieses Feld freigelassen werden."

msgid "An HTML fragment appended to the bottom of each page. You might use this to identify the webmaster for this site."
msgstr "Auf jedem Seiten-Ende wird ein HTML-Fragment eingef�gt und kann zur Identifikation des Webmasters benutzt werden."

msgid "Where FAQ-O-Matic should send email when it wants to alert the administrator (usually same as"
msgstr "An wen soll FAQ-O-Matic eine Mail schicken, wenn der Administrator alarmiert werden soll (normalerweise"

msgid "If true, FAQ-O-Matic will mail the log file to the administrator whenever it is truncated."
msgstr "FAQ-O-Matic schickt das Logfile als Mail zum Administrator."

msgid "User to use for RCS ci command (default is process UID)"
msgstr "Benutzer, welcher das RCS ci-Kommando einsetzt (default: UID)"

msgid "Links from cache to CGI are relative to the server root, rather than absolute URLs including hostname:"
msgstr "Links vom Cache zu CGI sind relativ zum Server-Root, nicht absolute URLs inklusive hostname:"

msgid "mailto: links can be rewritten such as"
msgstr "mailto: Links k�nnen ge�ndert werden wie beispielsweise"

msgid "or e-mail addresses suppressed entirely (hide)."
msgstr "oder die eMail-Adresse nicht anzeigen (verstecke)"

msgid "Number of seconds that authentication cookies remain valid. These cookies are stored in URLs, and so can be retrieved from a browser history file. Hence they should usually time-out fairly quickly."
msgstr "Zeit in Sekunden, in der die Authentifikationscookies g�ltig sind. Die Cookies werden in URLs gespeichert und k�nnen mit der Browser-History aufgerufen werden. Daher sollte das time-out schnell genug gew�hlt werden."

msgid "<i>Optional:</i> These options set the default [Appearance] modes."
msgstr "<i>Optional:</i> Diese Einstellungen werden als Default-Werte bei [Darstellung] verwendet."

msgid "Page rendering scheme. Do not choose"
msgstr "Seitenaufbau. Bitte nicht"

msgid "as the default."
msgstr "als Standardeinstellung w�hlen."

msgid "expert editing commands"
msgstr "Experten-Kommandos"

msgid "show"
msgstr "zeige"

msgid "hide"
msgstr "verstecke"

msgid "compact"
msgstr "kompakt"

msgid "name of moderator who organizes current category"
msgstr "Name des Moderators, welcher die aktuelle Kategorie administriert"

msgid "last modified date"
msgstr "Datum der letzten �nderung"

msgid "attributions"
msgstr "Zeige Autoren"

msgid "commands for generating text output"
msgstr "Kommandos f�r das generieren der Textausgabe"

msgid "<i>Optional:</i> These options fine-tune the appearance of editing features."
msgstr "<i>Optional:</i> Diese Einstellungen sind f�r die Feineinstellung der Texteingabe."

msgid "The old [Show Edit Commands] button appears in the navigation bar."
msgstr "Der [Zeige erweiterte Funktionen]-Button erscheint in der Navigationszeile."

msgid "Navigation links appear at top of page as well as at the bottom."
msgstr "Navigations-Links erscheinen auf oben und unten auf der Seite."

msgid "Hide [Append to This Answer] and [Add New Answer in ...] buttons."
msgstr "Verstecke [Diesen Eintrag erweitern] und [Einen neuen Eintrag hinzuf�gen in...]"

msgid "icons-and-label"
msgstr "Icons und Label"

msgid "Editing commands appear with neat-o icons rather than [In Brackets]."
msgstr "Editier-Kommandos erscheinen mit Icons nicht in [eckigen Klammern]."

msgid "<i>Optional:</i> Other configurations that you should probably ignore if present."
msgstr "<i>Optional:</i> Andere Einstellungen welche ignoriert werden k�nnen."

msgid "Draw Item titles John Nolan's way."
msgstr "Zeige den Titel nach John Nolan's Art"

msgid "Hide sibling (Previous, Next) links"
msgstr "Links nicht anzeigen (Vorherige, N�chste)"

msgid "Arguments to make ci quietly log changes (default is probably fine)"
msgstr "Argumente f�r ci um �nderungen an der log-Datei vorzunehmen (Default: fine)"

msgid "off"
msgstr "aus"

msgid "true"
msgstr "wahr"

msgid "cheesy"
msgstr "cheesy"

msgid "This is a command, so only letters, hyphens, and slashes are allowed."
msgstr "Bei diesem Kommando sind nur Buchstaben, Bindestrich (-) und Slashes (/) erlaubt."

msgid "If this is your first time installing a FAQ-O-Matic, I recommend"
msgstr "Installieren Sie zum ersten Mal FAQ-O-Matic, wird empfohlen"

msgid "only filling in the sections marked <b>Mandatory</b>."
msgstr "nur die mit <b>Vorschreibend</b> markierten Anschnitte auszuf�llen."

msgid "Define"
msgstr "�nderungen �bernehmen"

msgid "(no description)"
msgstr "(kein Eintrag)"

msgid "Unrecognized config parameter"
msgstr "Falscher Konfigurationsparameter"

msgid "Please report this problem to"
msgstr "Bitte wenden Sie sich mit diesem Problem an"

msgid "Cron job installed. The maintenance script should run hourly."
msgstr "Der Cron-Job wurde installiert. Das Script wird nun st�ndlich aufgerufen."

msgid "I thought I installed a new cron job, but it didn't"
msgstr "Der neue cron-Job wurde installiert, wird aber nicht"

msgid "appear to take."
msgstr "ausgef�hrt."

msgid "You better add"
msgstr "Durch hinzuf�gen von"

msgid "to some crontab yourself with"
msgstr "zum crontab mit"

msgid "I replaced this old crontab line, which appears to be an older one for this same FAQ:"
msgstr "Die alte crontab-Zeile wurde ersetzt"


###
### submitBag.pm
###

msgid "Bag names may only contain letters, numbers, underscores (_), hyphens (-), and periods (.), and may not end in '.desc'. Yours was"
msgstr "Objekt-Dateinamen d�rfen nur Buchstaben, Nummern, Unterstriche (_), Bindestriche (-) und Punkte (.) enthalten. Die Dateiendung '.desc' ist nicht erlaubt. Ihr Dateiname war"

###
### editBag.pm
###

msgid "Upload new bag to show in the"
msgstr "Uploaden eines Dateiobjekts in den"

msgid "part in"
msgstr "Eintrag von"

msgid "Bag name:"
msgstr "Objekt-Name"

msgid "The bag name is used as a filename, so it is restricted to only contain letters, numbers, underscores (_), hyphens (-), and periods (.). It should also carry a meaningful extension (such as .gif) so that web browsers will know what to do with the data."
msgstr "Der Objektname wird von FAQ-O-Matic als Dateiname benutzt (nur Buchstaben, Zahlen, Unterstriche, Bindestriche und Punkte sind erlaubt) und sollte eine sinnvolle Erweiterung haben (beispielsweise .gif), damit der Webbrowser die Datei korrekt darstellt."

msgid "Bag data:"
msgstr "Objekt-Datei:"

msgid "If this bag is an image, fill in its dimensions."
msgstr "Ist das Objekt eine Bild-Datei, geben Sie hier die Dimensionen ein."

msgid "Width:"
msgstr "Breite:"

msgid "Height:"
msgstr "H�he:"

msgid "(Leave blank to keep original bag data and change only the associated information below.)"
msgstr "(Braucht nicht ausgef�llt zu werden, wenn das alte Dateiobjekt erhalten werden soll.)"

###
### appearanceForm.pm
###

msgid "Appearance Options"
msgstr "Einstellungen zur Darstellung"

msgid "Show"
msgstr "Alle"

msgid "Compact"
msgstr "Kompakte"

msgid "Hide"
msgstr "Keine"

msgid "expert editing commands"
msgstr "Anzeige der Experten-Kommandos"

msgid "name of moderator who organizes current category"
msgstr "Anzeige vom Namen des Moderators"

msgid "all categories and answers below current category"
msgstr "Anzeige aller Kategorien und Antworten unter der Aktuellen Kategorie"

msgid "last modified date"
msgstr "Anzeige vom Datum der letzten �nderung"

msgid "Show All"
msgstr "Zeige alle"

msgid "Default"
msgstr "Standard"

msgid "attributions"
msgstr "Autoren"

msgid "Simple"
msgstr "Einfaches"

msgid "Fancy"
msgstr "Erweitertes"

msgid "commands for generating text output"
msgstr "Anzeige der Kommandos um die Textausgabe zu generieren"

msgid "Accept"
msgstr "�nderungen �bernehmen"

###
### addItem.pm
###

msgid "Subcategories:\n\n\nAnswers in this category:\n"
msgstr "Unterkategorien:\n\n\nAntworten in dieser Kategorie:\n"

msgid "Copy of"
msgstr "Kopie von"

###
### changePass.pm
###

msgid "Please enter your username, and select a password."
msgstr "Bitte geben Sie Ihren Usernamen und Ihr Passwort ein."

msgid "I will send a secret number to the email address you enter"
msgstr "Es wird ein Schl�ssel zu der eingegebenen email-Adresse geschickt"

msgid "to verify that it is valid."
msgstr "um zu �berpr�fen, ob Ihre Eingaben richtig sind."

msgid "If you prefer not to give your email address to this web form, please contact"
msgstr "Wenn Sie Ihre email-Adresse nicht in dieses Formular eingeben m�chten, kontaktieren Sie bitte"

msgid "Please <b>do not</b> use a password you use anywhere else, as it will not be transferred or stored securely!"
msgstr "Da das Passwort unverschl�sselt �bertragen wird, sollten Sie auf keinen Fall ein Passwort w�hlen, welches Sie schon anderweitig benutzen."

msgid "Password:"
msgstr "Passwort:"

msgid "Set Password"
msgstr "Setze Passwort"

###
### Auth.pm
###

msgid "the administrator of this Faq-O-Matic"
msgstr "der Administrator von FAQ-O-Matic"

msgid "someone who has proven their identification"
msgstr "ein Benutzer, welcher seine Identifikation bewiesen hat"

msgid "someone who has offered identification"
msgstr "ein Benutzer, welcher seine Identifikation eingereicht hat"

msgid "anybody"
msgstr "irgendjemand" 

msgid "the moderator of the item"
msgstr "dem Moderator des Eintrags"

msgid "group members"
msgstr "Gruppenmitglieder"

###
### Authenticate.pm
###

msgid "That password is invalid. If you've forgotten your old password, you can"
msgstr "Das Passwort ist falsch. Wenn Sie Ihr altes Passwort vergessen haben, k�nnen Sie"

msgid "Set a New Password"
msgstr "ein neues Passwort eingeben"

msgid "Create a New Login"
msgstr "ein neues Login erstellen"

msgid "New items can only be added by"
msgstr "Neue Eintr�ge k�nnen nur eingef�gt werden von"

msgid "New text parts can only be added by"
msgstr "Neue Texteintr�ge k�nnen nur eingef�gt werden von"

msgid "Text parts can only be removed by"
msgstr "Texteintr�ge k�nnen nur verschoben werden von"

msgid "This part contains raw HTML. To avoid pages with invalid HTML, the moderator has specified that only"
msgstr "Dieser Eintrag enth�lt HTML-Code. Um Seiten mit HTML-Code zu vermeiden wurde festgelegt das nur"

msgid "can edit HTML parts."
msgstr "HTML-Seiten erstellen kann."

msgid "If you are"
msgstr "Sind Sie"

msgid "you may authenticate yourself with this form."
msgstr "sollten Sie sich in diesem Formular authentifizieren."

msgid "Text parts can only be added by"
msgstr "Texteintr�ge k�nnen nur hinzugef�gt werden von"

msgid "Text parts can only be edited by"
msgstr "Texteintr�ge k�nnen nur ge�ndert werden von"

msgid "The title and options for this item can only be edited by"
msgstr "Der Titel und die Einstellungen f�r diesen Eintrag k�nnen nur ge�ndert werden von"

msgid "The moderator options can only be edited by"
msgstr "Die Moderator-Einstellungen k�nnen nur ge�ndert werden von"

msgid "This item can only be moved by someone who can edit both the source and destination parent items."
msgstr "Dieser Eintr�g kann nur vom rechtm�ssigem Besitzer verschoben werden."

msgid "This item can only be moved by"
msgstr "Dieser Eintrag kann nur verschoben werden von"

msgid "Only"
msgstr "Nur"

msgid "can replace existing bags."
msgstr "kann verhandene Datei-Objekte ersetzen."

msgid "can post bags."
msgstr "kann Datei-Objekte verschicken."

msgid "The FAQ-O-Matic can only be configured by"
msgstr "FAQ-O-Matic kann nur konfiguriert werden von"

msgid "The operation you attempted"
msgstr "Die von Ihnen versuchte Operation"

msgid "can only be done by"
msgstr "kann nur durchgef�hrt werden von"

msgid "If you have never established a password to use with FAQ-O-Matic, you can"
msgstr "Wenn Sie noch kein Passwort zur Benutzung von FAQ-O-Matic festgelegt haben, k�nnen Sie"

msgid "If you have forgotten your password, you can"
msgstr "Wenn Sie Ihr Passwort vergessen haben, k�nnen Sie"

msgid "If you have already logged in earlier today, it may be that the token I use to identify you has expired. Please log in again."
msgstr "Wenn Sie schon einmal eingeloggt waren, k�nnte es sein, da� Ihr Passwort nicht mehr g�ltig ist. Bitte loggen Sie sich erneut ein."

msgid "Please offer one of the following forms of identification:"
msgstr "Bitte w�hlen Sie die Art der Identifikation:"

msgid "No authentication, but my email address is:"
msgstr "Keine Authorisierung, aber meine email-Adresse lautet:"

msgid "Authenticated login:"
msgstr "Authorisiertes Login:"

###
### moveItem.pm
###

msgid "The file"
msgstr "Die Datei"

msgid "doesn't exist."
msgstr "konnte nicht gefunden werden."

msgid "Make"
msgstr "Mache"

msgid "belong to which other item?"
msgstr "zugeh�rig zu welchem Eintrag?"

msgid "No item that already has sub-items can become the parent of"
msgstr "Der Eintrag hat Subeintr�ge und kann daher nicht verwendet werden als Oberbegriff von"

msgid "No item can become the parent of"
msgstr "Der Eintrag kann nicht als Oberbegriff verwendet werden von"

msgid "Some destinations are not available (not clickable) because you do not have permission to edit them as currently autorized."
msgstr "Sie haben keine Zugriffsrechte auf einige Eintr�ge, deshalb k�nnen diese nicht angeklickt werden."

msgid "Click here</a> to provide better authentication."
msgstr "Klicken Sie hier</a>, um die Zugriffsrechte zu �ndern."

msgid "Hide answers, show only categories"
msgstr "Zeige keine Antworten, zeige nur die Kategorien"

msgid "Show both categories and answers"
msgstr "Zeige die Kategorien und die Antworten"

###
### editPart.pm
###

msgid "Enter the answer to"
msgstr "Antwort eingeben in"

msgid "Enter a description for"
msgstr "Beschreibung eingeben f�r"

msgid "Edit duplicated text for"
msgstr "�ndere duplizierten Text f�r"

msgid "Enter new text for"
msgstr "Neuen Text eingeben f�r"

msgid "Editing the"
msgstr "�nderung des"

msgid "text part in"
msgstr "Texteintrag in"

###
### Part.pm
###

msgid "Upload file:"
msgstr "Zu ladene Datei:"

msgid "Warning: file contents will <b>replace</b> previous text"
msgstr "Warnung: Die Datei wird den vorhandenen Text <b>ersetzen</b>"

msgid "Replace"
msgstr "Ersetze"

msgid "with new upload"
msgstr "mit neuer Datei"

msgid "Select bag to replace with new upload"
msgstr "W�hle ein neues Datei-Objekt" 

msgid "Hide Attributions"
msgstr "Name des Autors nicht anzeigen"

msgid "Format text as:"
msgstr "Formatiere den Text als:"

msgid "Directory"
msgstr "Verzeichnis"

msgid "Natural text"
msgstr "Normaler Text"

msgid "Monospaced text (code, tables)"
msgstr "Text mit festen Zeichenabst�nden"

msgid "Untranslated HTML"
msgstr "HTML-Code"

msgid "Submit Changes"
msgstr "�nderungen abschicken"

msgid "Revert"
msgstr "Eingabefeld zur�cksetzen"

msgid "Insert Uploaded Text Here"
msgstr "Textdatei hier einf�gen"

msgid "Insert Text Here"
msgstr "Text hier einf�gen"

msgid "Edit This Text"
msgstr "Diesen Text editieren"

msgid "Duplicate This Text"
msgstr "Diesen Text duplizieren"

msgid "Remove This Text"
msgstr "Diesen Text l�schen"

msgid "Upload New Bag Here"
msgstr "Eine neues Datei-Objekt hier einf�gen"

###
### searchForm.pm
###

msgid "Search for"
msgstr "Suche nach"

msgid "matching"
msgstr "passend auf"

msgid "all"
msgstr "alle"

msgid "any"
msgstr "jedes"

msgid "two"
msgstr "zwei"

msgid "three"
msgstr "drei"

msgid "four"
msgstr "vier"

msgid "five"
msgstr "f�nf"

msgid "words"
msgstr "der W�rter"

msgid "Show documents"
msgstr "Zeige Dokumente"

msgid "modified in the last"
msgstr "die ver�ndert wurden"

msgid "day"
msgstr "am letzten Tag"

msgid "two days"
msgstr "in den letzten beiden Tagen"

msgid "three days"
msgstr "in den letzten drei Tagen"

msgid "week"
msgstr "in der letzten Woche"

msgid "fortnight"
msgstr "in den letzten vierzehn Tagen"

msgid "month"
msgstr "im letzten Monat"

###
### search.pm
###

msgid "No items matched"
msgstr "Kein Eintrag passte zu"

msgid "of these words"
msgstr "der folgenden W�rter"

msgid "Search results for"
msgstr "Ergebnisse der Suche f�r"

msgid "at least"
msgstr "zumindest"

msgid "Results may be incomplete, because the search index has not been refreshed since the most recent change to the database."
msgstr "Die Ergebnisse k�nnen unvollst�ndig sein, da der Index nicht erneuert wurde seit der letzten �nderung an der Datenbasis."

###
### Item.pm
###

msgid "defined in"
msgstr "definiert in"

msgid "Name & Description"
msgstr "Name und Beschreibung"

msgid "Setting"
msgstr "Einstellung"

msgid "Setting if Inherited"
msgstr "Geerbter Wert"

msgid "Moderator"
msgstr "Moderator"

msgid "(will inherit if empty)"
msgstr "(geerbter Wert wenn leer)"

msgid "Send mail to the moderator when someone other than the moderator edits this item:"
msgstr "Schicke dem Moderator eine Mail, wenn jemand anders diesen Eintrag �ndert:"

msgid "Permissions"
msgstr "Zugriffsrechte"

#msgid "RelaxChildPerms"
#msgstr "RelaxChildPerms"

msgid "Blah"
msgstr "Blah"

msgid "blah"
msgstr "blah"

msgid "<p>New Order for Text Parts:"
msgstr "<p>Neue Reihenfolge f�r Textabschnitte:"

msgid "Who can add a new text part to this item:"
msgstr "Wer darf einen neuen Texteintrag in dieses Feld eintragen:" 

msgid "Who can add a new answer or category to this category:"
msgstr "Wer darf eine neue Antwort oder Kategorie in diese Katagorie eintragen:"

msgid "Who can edit or remove existing text parts from this item:"
msgstr "Wer darf vorhandenen Text editieren bzw. verschieben von diesem Feld:"

msgid "Who can move answers or subcategories from this category;"
msgstr "Wer darf Antworten oder Subkategorien verschieben von dieser Kategorie;"

msgid "or turn this category into an answer or vice versa:"
msgstr "bzw. umwandeln dieser Kategorie in eine Antwort und umgekehrt:"

msgid "Who can edit the title and options of this answer or category:"
msgstr "Wer darf den Titel und die Einstellungen dieser Antwort oder Kategorie �ndern:"

msgid "Who can use untranslated HTML when editing the text of"
msgstr "Wer darf HTML-Code benutzen beim Editieren von"

msgid "this answer or category:"
msgstr "dieser Antwort oder Kategorie:"

msgid "Who can change these moderator options and permissions:"
msgstr "Wer darf diese Moderator-Einstellungen und Zugriffsrechte �ndern:"

msgid "Who can use the group membership pages:"
msgstr "Wer darf die Gruppenmitgliedschaftsseiten benutzen:"

msgid "Who can create new bags:"
msgstr "Wer darf neue Dateiobjekte einf�gen:"

msgid "Who can replace existing bags:"
msgstr "Wer darf vorhandene Dateiobjekte ersetzen:"

msgid "Group"
msgstr "Gruppen"

msgid "The moderator"
msgstr "Moderator"

msgid "Authenticated users"
msgstr "Authorisierte Benutzer"

msgid "Users giving their names"
msgstr "Benutzer, welcher seinen Namen angegeben hat"

msgid "Whoever can for my parent,"
msgstr "Jeder �bergeordnete Benutzer"

msgid "File $subfilename seems broken."
msgstr "Datei $subfilename scheint defekt zu sein."

msgid "Permissions:"
msgstr "Zugriffsrechte:"

msgid "Moderator options for"
msgstr "Moderator-Einstellungen f�r"

msgid "Title:"
msgstr "Titel:"

msgid "Category"
msgstr "Kategorie"

msgid "Answer"
msgstr "Eintrag"

msgid "answer"
msgstr "Eintrag"

msgid "Show attributions from all parts together at bottom"
msgstr "Zeige nicht den Namen des Autors unter jedem Eintrag"

msgid "New Item"
msgstr "Neuer Eintrag"

msgid "Submit Changes"
msgstr "�nderungen abschicken"

msgid "Revert"
msgstr "Eingabefelder zur�cksetzen"
 
msgid "Convert to Answer"
msgstr "Konvertieren nach Antwort"

msgid "Convert to Category"
msgstr "Konvertieren nach Kategorie"

msgid "New Subcategory of"
msgstr "Neue Subkategorie von"

msgid "Move"
msgstr "Verschiebe"

msgid "Trash"
msgstr "L�sche"

msgid "Parts"
msgstr "Eintr�ge"

msgid "New Category"
msgstr "Neue Kategorie"

msgid "New Answer"
msgstr "Neue Antwort"

msgid "Editing"
msgstr "Bearbeite"

msgid "Insert Uploaded Text Here"
msgstr "Textdatei hier einf�gen"

msgid "Insert Text Here"
msgstr "Text hier einf�gen"

msgid "New Answer in"
msgstr "Neuer Eintrag in"

msgid "Duplicate Category as Answer"
msgstr "Dupliziere Kategorie"

msgid "Duplicate Answer"
msgstr "Dupliziere Eintrag"

msgid "Title and Options"
msgstr "Titel und Einstellungen"

msgid "Category"
msgstr "Kategorie"

msgid "Edit"
msgstr "�ndere"

msgid "Add a New Answer in"
msgstr "Ein neuen Eintrag hinzuf�gen in"

msgid "Append to This Answer"
msgstr "Diesen Eintrag erweitern"

msgid "This document is:"
msgstr "Dieses Dokument ist:"

msgid "This document is at:"
msgstr "Dieses Dokument hat die URL:"

msgid "Previous"
msgstr "Vorhergehende"

msgid "Next"
msgstr "N�chste"


###
### Appearcance.pm
###

msgid "Search"
msgstr "Suchen"

msgid "Appearance"
msgstr "Darstellung"

msgid "Show Top Category Only"
msgstr "Nur die oberste Kategorie zeigen"

msgid "Show This <em>Entire</em> Category"
msgstr "Die <em>gesamte</em> Kategorie zeigen"

msgid "Show This $whatAmI As Text</a>"
msgstr "Anzeigen von $whatAmI als Text</a>"

msgid "Show This <em>Entire</em> Category As Text</a>"
msgstr "Anzeigen der <em>gesamten</em> Kategorie als Text</a>"

msgid "Hide Expert Edit Commands"
msgstr "Erweiterte Funktionen verstecken"

msgid "Show Expert Edit Commands"
msgstr "Zeige erweiterte Funktionen"

msgid "Return to FAQ"
msgstr "Zur�ck zur FAQ"

msgid "This is a"
msgstr "Dies ist eine"

msgid "Hide Help"
msgstr "Hilfe verstecken"

msgid "Help"
msgstr "Hilfe"

msgid "Log In"
msgstr "Einloggen"

msgid "Change Password"
msgstr "�ndere Passwort"

msgid "Edit Title of %0 %1"
msgstr "�ndere Titel von %0 %1"

msgid "New %0"
msgstr "Neue %0"

msgid "Edit Part in %0 %1"
msgstr " �ndere Abschnitt in %0 %1"

msgid "Insert Part in %0 %1"
msgstr "Einf�gen eines Textteils in %0 %1"

msgid "Move %0 %1"
msgstr "Verschiebe %0 %1"

msgid "Search"
msgstr "Suche"

msgid "Access Statistics"
msgstr "Zugriffs-Statistik"

msgid "Validate"
msgstr "F�r g�ltig erkl�ren"

msgid "%0 Permissions for %1"
msgstr "%0 Zugriffsrechte f�r %1"

msgid "Upload bag for %0 %1"
msgstr "Uploaden eines Datei-Objekts f�r %0 %1"
);
__EOF__

	my @txs = grep { m/^msg/ } split(/\n/, $txfile);
	for (my $i=0; $i<@txs; $i+=2) {
		$txs[$i] =~ m/msgid \"(.*)\"$/;
		my $from = $1;
		$txs[$i+1] =~ m/msgstr \"(.*)\"$/;
		my $to = $1;
		if (not defined $from or not defined $to) {
			die "bad translation at pair $i";
		}
		$tx->{$from} = $to;
	}
};
