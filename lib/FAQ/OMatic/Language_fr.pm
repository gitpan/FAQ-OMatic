### Fr : Translation Basile Chandesris - base@citeweb.net
###
### Status : Runs but Not finished (version 3)
#########################################################
### Perl warning : Subroutine translation redefined at  
### ..../OMatic/Language_de...pm line 5 [now: line 17]
### ???
#########################################################
### Perl warning : Use of unitilized value at
### .../OMatic/Item.pm line 939
###

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
# msgstr "Die Datei"
msgstr "Le fichier"

msgid "doesn't exist."
# msgstr "konnte nicht gefunden werden."
msgstr "n'a pas pu &ecirc;tre trouv&eacute;."

msgid "Your browser or WWW cache has truncated your POST."
# msgstr "Ihr Browser oder WWW-Cache hat Ihre Post gek&Cedilla;rzt."
msgtr "Votre navigateur ou cache web a tronqu&eacute; votre envoi."
 
msgid "Changed the item title, was"
# msgstr "Die Titel wurde ge ndert in"
msgstr "Le titre de l'&eacute;l&eacute;ment a chang&eacute;, il est maintenant"

msgid "Your part order list"
# msgstr "Ihre Liste mit den Abschnitten"
msgstr "Votre liste de sections"

msgid "doesn't have the same number of parts"
# msgstr "hat nicht die gleiche Anzahl von Abschnitten"
msgstr "n'a pas le m&ecirc;me nombre de sections"

msgid "as the original item."
# msgstr "wie der Original-Eintrag."
msgstr "que l'&eacute;l&eacute;ment d'origine."

msgid "doesn't say what to do with part"
# msgstr "beschreibt keine Aktion mit dem Abschnitt"
msgstr "ne d&eacute;crit pas l'action &agrave; r&eacute;aliser sur la section"

###
### submitMove.pm
###

msgid "The moving file" 
# msgstr "Die zu verschiebene Datei" 
msgstr "Le fichier &agrave; d&eacute;placer"

msgid "is broken or missing."
# msgstr "ist defekt oder nicht vorhanden."
msgstr "est d&eacute;fecteux ou manquant."

msgid "The newParent file" 
# msgstr "Die newParant-Datei"
msgstr "Le nouveau fichier parent"

msgid "is broken or missing."
# msgstr "ist defekt oder nicht vorhanden."
msgstr "est d&eacute;fecteux ou manquant."

msgid "The oldParent file" 
# msgstr "Die oldParant-Datei"
msgstr "L'ancien fichier parent"

msgid "is broken or missing."
# msgstr "ist defekt oder nicht vorhanden."
msgstr "est d&eacute;fecteux ou manquant."

msgid "The new parent"
# msgstr "Die newParent-Datei"
msgstr "Le nouveau fichier parent"

msgid "is the same as the old parent."
# msgstr "ist die gleiche wie die oldParent-Datei."
msgstr "est le m&ecirc;me que l'ancien fichier parent."

msgid "is the same as the item you want to move."
# msgstr "ist gleich mit dem Eintrag den Sie verschieben m chten."
msgstr "est le m&ecirc;me &eacute;l&eacute;ment que vous souhaitez d&eacute;placer."

msgid "The new parent"
# msgstr "Die neue parent-Datei"
msgstr "Le nouveau fichier parent."

msgid "is a child of the item being moved"
# msgstr "ist ein Kind vom Eintrag der verschoben wurde"
msgstr "est le fils de l'&eacute;l&eacute;ment que vous a &eacute;t&eacute; d&eacute;plac&eacute;."

msgid "You can't move the top item."
# msgstr "Sie k nnen den in der Hierarchie h chsten Eintrag nicht verschieben."
msgstr "Vous ne pouvez pas d&eacute;placer l'entr&eacute;e sommet de la hi&eacute;rarchie."

msgid "moved a sub-item to"
# msgstr "hat ein Subeintrag verschoben nach"
msgstr "a d&eacute;plac&eacute; un sous-entr&eacute;e vers"

msgid "moved a sub-item from"
# msgstr "hat ein Subeintrag verschoben von"
msgstr "a d&eacute;plac&eacute; un sous-entr&eacute; depuis"

###
### submitPass.pm
###

msgid "An email address must look like"
# msgstr "Eine eMail-Adresse sollte folgenderma&thorn;en aufgebaut sein:"
msgstr "L'adresse m&egrave;l doit avoir la forme : "

msgid "If yours"
# msgstr "Wenn Ihre Mailadresse"
msgstr "Si votre adresse m&egrave;l"

msgid "does and I keep rejecting it, please mail"
# msgstr "lautet und nicht akzeptiert wurde, schicken Sie bitte eine Mail an"
msgstr "sonne et n'est pas accept&eacute;, envoyez svp un m&eacute;l"

msgid "and tell him what's happening."
# msgstr "mit der Fehlerbeschreibung."
msgstr "en d&eacute;crivant l'incident."

msgid "Your password may not contain spaces or carriage returns."
#msgstr "Ihr Passwort darf keine Leerzeichen enthalten."
msgstr "Votre mot de passe ne doit contenir aucun caract&egrave;re vide (esp, rtn)."

msgid "Your Faq-O-Matic authentication secret"
#msgstr "Ihr Faq-O-Matic Schl&Cedilla;ssel"
msgid "Votre cl&eacute; d'acc&egrave;s Faq-O-Matic"

msgid "I couldn't mail the authentication secret to"
#msgstr "Konnte den Schl&Cedilla;ssel nicht senden an"
msgstr "Je ne peux pas vous envoyer la cl&eacute; d'acc&egrave;s &agrave;"

msgid "and I'm not sure why."
#msgstr "aus ungekl rter Ursache."
msgstr "et je ne sais pas pourquoi."

msgid "The secret you entered is not correct."
#msgstr "Der eingegebe Schl&Cedilla;ssel ist falsch."
msgstr "La cl&eacute; d'acc&egrave;s donn&eacute;e n'est pas correcte."

msgid "Did you copy and paste the secret or the URL completely?"
#msgstr "Haben Sie die URL komplett kopiert und wieder eingef&Cedilla;gt?"
msgstr "Avez vous copi&eacute; la cl&eacute; d'acc&egrave;s ou compl&egrave;tement coll&eacute; l'URL ?"

msgid "I sent email to you at"
#msgstr "Es wurde eine email zur folgenden Adresse geschickt:"
msgstr "Un m&egrave;l vous est envoy&eacute; &agrave;"

msgid "It should arrive soon, containing a URL. Either open the URL directly, or paste the secret into the form below and click Validate."
#msgstr "Die Mail, die eine URL enth lt, wird gleich in Ihrer Mailbox sein. Entweder  ffnen Sie die URL direkt oder f&Cedilla;gen den Schl&Cedilla;ssel in das Eingabefeld unten ein und klicken auf Absenden."
msgstr "Le m&egrave;l devrait &ecirc;tre arriv&eacute; dans votre bo&icirc;te aux lettre. Il contient un URL et une cl&eacute; d'acc&egrave;s. Soit vous activez l'URL, soit vous utilisez la cl&eacute; d'acc&egrave;s dans le formulaire ci-dessous et cliquez sur valider."

msgid "Thank you for taking the time to sign up."
#msgstr "Vielen Dank das Sie sich Zeit genommen haben f&Cedilla;r die Registrierung."
msgstr "Merci beaucoup de prendre du temps pour s'inscrire."

msgid "Secret:"
#msgstr "Schl&Cedilla;ssel:"
msgstr "Cl&eacute; d'acc&egrave;s : "

msgid "Validate"
#msgstr "Absenden"
msgstr "Valider"

###
### editBag.pm
###

msgid "Replace bag"
#msgstr "Ersetze Datei-Objekt"
msgstr "Remplacer le fichier objet"

###
### OMatic.pm
###

msgid "Warnings:"
#msgstr "Warnungen:"
msgstr "Alertes : "

###
### install.pm
###

msgid "%1"
#
msgstr "%1"

msgid "The URL prefix needed to access files in"
#
msgstr "Le préfixe de l'URL doit accéder aux fichiers dans"

msgid "Select the display language."
#
msgstr "Selectionnez la langue utilisée."

msgid "Show dates in 24-hour time or am/pm format."
#
msgstr "Montrer les dates dans le format 24 heures ou dans le format am/pm."



msgid "Faq-O-Matic Installer"
#msgstr "Faq-O-Matic Installation"
msgstr "Intallation de Faq-O-Matic"

msgid "failed:"
#msgstr "schlug fehl:"
msgstr "&eacute;chec"

msgid "Unknown step:"
#msgstr "Unbekannter Schritt:"
msgstr "Pas inconnu : "

msgid "Updating config to reflect new meta location"
#msgstr "Konfiguration wird aktualisiert f&Cedilla;r neues meta-Verzeichnis"
msgstr "La configuration sera actualis&eacute; pour une nouvelle meta localisation"

msgid "(Can't find <b>config</b> in '$meta' -- assuming this is a new installation.)"
#msgstr "(Konnte <b>config</b> nicht in '$meta' finden -- vermutlich ist dies eine Neuinstallation.)"
msgstr "(Ne trouve pas la <b>config</b> dans '$meta' -- il s'agit vraissemblablement d'une nouvelle installation)."

msgid "Click here"
#msgstr "Klicke hier"
msgstr "Cliquez ici"

msgid "to create"
#msgstr "zum erzeugen von"
msgstr "pour cr&eacute;er"

msgid "If you want to change the CGI stub to point to another directory, edit the script and then\n"
#msgstr "Wenn Sie den CGI-Abschnitt in einem anderem Verzeichnis ablegen m chten, editieren Sie das Skript und dann\n"
msgstr "Si vous souhaitez transformer le CGI d'une section pour qu'il pointe vers un autre r&eacute;pertoire, &eacute;ditez le script et ensuite\n"

msgud "click here to use the new location"
#msgstr "klicke hier, um das neue Verzeichnis zu benutzen"
msgstr "Cliquez ici, pour utiliser la nouvelle localisation"

msgid "FAQ-O-Matic stores files in two main directories.<p>The <b>meta/</b> directory path is encoded in your CGI stub ($0). It contains:"
#msgstr "FAQ-O-Matic speichert Dateien in zwei Haupverzeichnisse.<p>Das <b>meta/</b>-Verzeichnis wird f&Cedilla;r CGI benutzt ($0). Es enth lt:"
msgstr "FAQ-O-Matic enregistre les fichiers dans deux r&eacute;pertoire principaux.<p>Le r&eacute;pertoire <b>meta/</b> est contenu dans votre CGI ($0). Il contient : "

msgid "<ul><li>the <b>config</b> file that tells FAQ-O-Matic where everything else lives. That's why the CGI stub needs to know where meta/ is, so it can figure out the rest of its configuration. <li>the <b>idfile</b> file that lists user identities. Therefore, meta/ should not be accessible via the web server. <li>the <b>RCS/</b> subdirectory that tracks revisions to FAQ items. <li>various hint files that are used as FAQ-O-Matic runs. These can be regenerated automatically.</ul>"
#msgstr "<ul><li>Das <b>config</b>-File, wo alle FAQ-O-Matic-Verzeichniseintr ge abgelegt sind. Dies ist f&Cedilla;r den CGI-Abschnitt wichtig, damit das Verzeichnis meta/ gefunden wird. <li>Das <b>idfile</b> wo Benutzerdaten abgelegt werden. Deshalb sollte das Verzeichnis meta/ nicht via Web-Server freigegeben sein. <li>Das <b>RCS/</b> Unterverzeichnis, was auf die verschiedenen Versionen der FAQ-Eintr ge zeigt. <li>verschiedene Dateien die zur Laufzeit von FAQ-O-Matic angelegt werden.</ul>"
msgstr "<ul><li>Le fichier <b>config</b>, d&eacute;crit o&ugrave; tous les &eacute;l&eacute;ments de la FAQ-O-Matic sont. C'est pourquoi le CGI a besoin de conna&icirc;tre o&ugrave; le r&eacute;pertoire meta/ doit &ecirc;tre trouv&eacute;. <li>Le fichier <b>idfile</b> contient la liste des identit&eacute;s des utilisateurs. Cependant, meta/ ne doit pas &ecirc;tre accessible au travers du serveur Web. <li>Le sous-r&eacute;pertoire <b>RCS/</b>, suit les mises &agrave; jours de la FAQ. <li>diff&eacute;rents fichiers cach&eacute;s sont utilis&eacute;s lorsque la FAQ-O-Matic tourne. Ils peuvent &ecirc;tre recr&eacute;&eacute;s automatiquement.</ul>"

msgid "<p>The <b>serve/</b> directory contains three subdirectories <b>item/</b>, <b>cache/</b>, and <b>bags/</b>. These directories are created and populated by the FAQ-O-Matic CGI, but should be directly accessible via the web server (without invoking the CGI)."
#msgstr "<p>Das <b>serve/</b>-Verzeichnis enth lt drei Unterverzeichnisse: <b>item/</b>, <b>cache/</b> und <b>bags/</b>. Diese Verzeichnisse werden erzeugt und benutzt von FAQ-O-Matic-CGI und sollten daher auf dem Webserver frei verf&Cedilla;gbar sein (ohne CGI einzuschalten)."
msgstr "<p>Le r&eacute;pertoire <b>serve/</b> contient trois sous r&eacute;pertoires : <b>item/</b>, <b>cache/</b> et <b>bags/</b>. Ces r&eacute;pertoires sont cr&eacute;es et contiennent les CGI de la FAQ-O-Matic, mais ils doivent &ecirc;tre accessible du serveur web (sans appeller de CGI)."

msgid "<ul><li>serve/item/ contains only FAQ-O-Matic formatted source files, which encode both user-entered text and the hierarchical structure of the answers and categories in the FAQ. These files are only accessed through the web server (rather than the CGI) when another FAQ-O-Matic is mirroring this one. <li>serve/cache/ contains a cache of automatically-generated HTML versions of FAQ answers and categories. When possible, the CGI directs users to the cache to reduce load on the server. (CGI hits are far more expensive than regular file loads.) <li>serve/bags/ contains image files and other ``bags of bits.'' Bit-bags can be linked to or inlined into FAQ items (in the case of images). </ul>"
#msgstr "<ul><li>serve/item/ enth lt ausschlie&thorn;lich FAQ-O-Matic-formatierte source-Files, welche den vom Benutzer eingegebenen Text und die hierachische Struktur der Eintr ge und Kategorien enth lt. Auf diese Dateien kann nur &Cedilla;ber den Webserver zugegriffen werden, wenn ein anderes FAQ-O-Matic diese spiegelt. <li>serve/cache/ enth lt ein Cache von automatisch erstellten HTML-Versionen von FAQ-Eintr gen und Kategorien. Wenn m glich, wird der Cache benutzt, um den Server zu entlasten. (CGI-Zugriffe sind weitaus teurer als regul re Dateizugriffe.) <li>serve/bags/ enth lt Bild-Dateien und und andere Datei-Objekte. Datei-Objekte k nnen in FAQ-Eintr ge eingef&Cedilla;gt werden).</ul>"
msgstr "<ul><li>serve/item/ contient les fichiers sources format&eacute;s de la FAQ-O-Matic, qui codent &agrave; la fois les entr&eacute;es des utilisateurs et les structures hi&eacute;rarchiques des r&eacute;ponses et des cat&eacute;gories dans la FAQ. Ces fichiers ne sont acc&egrave;d&eacute;s qu'au travers du serveur web (plut&ocirc;t que par CGI) lorsqu'une autre FAQ-O-Matic joue le r&ocirc;le de miroir. <li>serve/cache/ contient un cache des r&eacute;ponses et cat&eacute;gories de la FAQ, automatiquement g&eacute;n&eacute;r&eacute; en HTML afin de r&eacute;duire la charge sur le serveur. (Les requ&ecirc;tes sur CGI sont beaucoup plus ch&egrave;res en ressources que le d&eacute;chargement de fichiers) <li>serve/bags/ contient les images de fichiers et autres fichiers-objets. Les fichiers-objets peuvent &ecirc;tre li&eacute;s &agrave; ou ins&eacute;r&eacute;s dans les &eacute;l&eacute;ments de la FAQ (dans le cas des images).</ul>"

msgid "I don't have write permission to <b>$meta</b>."
#msgstr "Habe keine Schreib-Berechtigung f&Cedilla;r <b>$meta</b>."
msgstr "Je n'ai pas la permission d'&eacute;criture pour <b>$meta</b>."

msgid "I couldn't create"
#msgstr "Fehler beim erzeugen von"
msgstr "Erreur &agrave; la cr&eacute;ation de"

msgid "Created"
#msgstr "erzeugt: "
msgstr "cr&eacute;e : "

msgid "I don't have write permission to"
#msgstr "Habe keine Schreib-Berechtigung f&Cedilla;r"
msgstr "Je n'ai pas la permission d'&eacute;criture pour"

msgid "Created new config file."
#msgstr "Habe neues config-File erzeugt."
msgstr "Cr&eacute;ation d'un nouveau fichier de configuration."

msgid "Couldn't create"
#msgstr "Fehler beim erzeugen von"
msgstr "Erreur &agrave; la cr&eacute;ation de"

msgid "The idfile exists."
#msgstr "Das idfile ist vorhanden."
msgstr "Le fichier idfile existe."

msgid "Configuration Main Menu (install module)"
#msgstr "Konfigurationsmen&Cedilla; (Modulinstallation)"
msgstr "Menu de configuration principal (installation du module)"

msgid "Perform these tasks in order to prepare your FAQ-O-Matic version"
#msgstr "F&Cedilla;hre diese Schritte durch, f&Cedilla;r FAQ-O-Matic Version"
msgstr "R&eacute;alisez ces t&acirc;ches afin de pr&eacute;parer votre FAQ-O-Matic version"

msgid "Define configuration parameters."
#msgstr "Festlegen der Konfigurationsparameter."
msgstr "D&eacute;finissez les param&egrave;tres de configuration."

msgid "Set your password and turn on installer security"
#msgstr "W hlen Sie Ihr Passwort und Installations-Sicherheit"
msgstr "Mettez en place votre mot de passe et mettez en route la s&eacute;curit&eacute; de l'installation"

msgid "(Need to configure"
#msgstr "(Wird ben tigt zur Konfiguration von"
msgstr "(Doit &ecirc;tre configur&eacute;"

msgid "(Installer security is on.)"
#msgstr "(Installations-Sicherheit ist an.)"
msgstr "(La s&eacute;curit&eacute; de l'installation est activ&eacute;e)."

msgid "Create item, cache, and bags directories in serve dir."
#msgstr "Erzeuge Eintrags-, Cache und Datei-Objekt-Verzeichnisse."
msgstr "Cr&eacute;ez des &eacute;l&eacute;ments, des caches et des r&eacute;pertoires de fichiers objets."

msgid "Copy old items</a> from"
#msgstr "Kopiere alte Eintr ge</a> von"
msgstr "Copie les anciens &eacute;l&eacute;ments de"

msgid "to"
#msgstr "nach"
msgstr "vers"

msgid "Install any new items that come with the system."
#msgstr "Installiere neue System-Eintr ge."
msgstr "Installe les nouveaux &eacute;l&eacute;ments du syst&egrave;me."

msgid "Create system default items."
#msgstr "Erstelle Systemdefault-Eintr ge"
msgstr "Cr&eacute;ez les &eacute;l&eacute;ments par d&eacute;faut du syst&egrave;me."

msgid "Rebuild the cache and dependency files."
#msgstr "Erneuere den Cache und die davon abh ngigen Dateien."
msgstr "Reconstruit le cache et les fichiers de d&eacute;pendance."

msgid "Install system images and icons."
#msgstr "Installiere Systemgrafiken und Icons."
msgstr "Installer les images et les ic&ocirc;nes du syst&egrave;me."

msgid "Update mirror from master now. (this can be slow!)"
#msgstr "Updaten der Mirror-Files (kann lange dauern)"
msgstr "Mettre &agrave; jour les fichiers du miroir (cela peut durer longtemps !)"

msgid "Set up the maintenance cron job"
#msgstr "Einrichten des Pflegedienstes"
msgstr "Mise en route du service de maintenance."

msgid "Run maintenance script manually now"
#msgstr "Starte Pflege-Skript jetzt manuell"
msgstr "Mettre en route la maintenance manuelle"

msgid "(Need to set up the maintenance cron job first)"
#msgstr "(Notwendig um den Pflegedienst erstmalig einzuschalten)"
msgstr "(Besoin de mettre en route tout d'abord le service de maintenance)"

msgid "Mark the config file as upgraded to Version"
#msgstr "Vermerke im Konfigurationsfile die neue Versionsnummer"
msgstr "Marquer le fichier de configuration &agrave; la nouvelle mise &agrave; jour de la version"

msgid "Select custom colors for your Faq-O-Matic</a> (optional)"
#msgstr "Benutzerdefinierte Farben f&Cedilla;r Faq-O-Matic</a> (optional)"
msgstr "Personnalisez les couleurs de votre Faq-O-Matic</a> (optionnel)"

msgid "Define groups</a> (optional)"
#msgstr "Lege Gruppen fest</a> (optional)"
msgstr "D&eacute;finissez des groupes (optionnel)"

msgid "Upgrade to CGI.pm version 2.49 or newer."
#msgstr "Upgrade auf CGI.pm Version 2.49 oder neuer."
msgstr "Mettre &agrave; jour &agrave; CGI.pm version 2.49 ou nouvelle."

msgid "(optional; older versions have bugs that affect bags)"
#msgstr "(optional;  ltere Versionen haben Fehler beim Umgang mit Datei-Objekten)"
msgstr "(optionnel; les anciennes versions ont des bogues qui affectent les fichiers objets)"

msgid "You are using version"
#msgstr "Sie benutzen Version"
msgstr "Vous utilisez maintenant la version"

msgid "now"
#msgstr "zur Zeit"
msgstr " "

msgid "Bookmark this link to be able to return to this menu."
#msgstr "Setzen Sie ein Lesezeichen auf diese URL, damit Sie wieder zum Men&Cedilla; zur&Cedilla;ckkehren k nnen."
msgstr "Cr&eacute;ez un signet pour pouvoir retrouver ce menu."

msgid "Go to the Faq-O-Matic"
#msgstr "Gehe zur Faq-O-Matic"
msgstr "Aller &agrave; la Faq-O-Matic"

msgid "(need to turn on installer security)"
#msgstr "(Installations-Sicherheit geht verloren)"
msgstr "(il faut r&eacute;activer l'installation de s&eacute;curit&eacute;)"

msgid "Other available tasks:"
#msgstr "Andere vorhandene Tasks:"
msgstr "Autres t&acirc;ches disponibles : "

msgid "See access statistics."
#msgstr "Zugriffs-Statistik anzeigen."
msgstr "Visualiser les statistiques d'acc&egrave;s."

msgid "Examine all bags."
#msgstr "Untersuche alle Datei-Objekte."
msgstr "Examiner tous les fichiers objets."

msgid "Check for unreferenced bags (not linked by any FAQ item)."
#msgstr "Suche nach Datei-Objekten, die in keinem FAQ-Eintrag vorhanden sind)."
msgstr "V&eacute;rification des fichiers objets non r&eacute;f&eacute;renc&eacute;s (qui ne sont li&eacute;s &agrave; aucun &eacute;l&eacute;ment de FAQ)." 

msgid "Rebuild the cache and dependency files."
#msgstr "Erneuere den Cache und die davon abh ngigen Dateien."
msgstr "Reconstruire le cache et les fichiers de d&eacute;pendance."

msgid "The Faq-O-Matic modules are version"
#msgstr "Die Faq-O-Matic-Module haben die Version"
msgstr "Le module Faq-O-Matic a pour version"

msgid "I wasn't able to change the permissions on"
#msgstr "Ich darf die Zugriffsrechte nicht  ndern von"
msgstr "Je ne peux pas modifier les permissions de"

msgid "to 755 (readable/searchable by all)."
#msgstr "nach 755 (lesbar/suchbar von Allen)."
msgstr "vers 755 (&agrave; lire/&agrave; rechercher par tous)."

msgid "updated config file:"
#msgstr "Habe config-file upgedatet:"
msgstr "Mise &agrave; jour de la configuration fichier : "

msgid "Redefine configuration parameters to ensure that"
#msgstr "Erneuere Konfigurationsparameter um sicherzustellen das"
msgstr "Red&eacute;finir les param&egrave;tres de configuration pour assurer que"

msgid "is valid."
#msgstr "g&Cedilla;ltig ist."
msgstr "est valide."

msgid "Jon made a mistake here; key=$key, property=$property."
#msgstr "Jon hat hier einen Fehler gemacht; key=$key, property=$property."
msgstr "Jon a fait une erreur ici; key=$key, property=$property."

msgid "<b>Mandatory:</b> System information"
#msgstr "<b>Vorschreibend:</b> System-Information"
msgstr "<b>Obligatoire : </b> Informations du syst&egrave;me"

msgid "Identity of local FAQ-O-Matic administrator (an email address)"
#msgstr "Identit t des FAQ-O-Matic Administrators (email-Adresse)"
msgstr "Identit&eacute; des administrateurs de la FAQ-O-Matic (adresse m&egrave;l)"

msgid "A command FAQ-O-Matic can use to send mail. It must either be sendmail, or it must understand the -s (Subject) switch."
#msgstr "Ein FAQ-O-Matic-Kommando sendet eine Mail via sendmail oder mit dem -s (Subject) Argument."
msgstr "Une commande de la FAQ-O-Matic peut envoyer du courrier via sendmail ou avec le -s (Sujet) Argument." 

msgid "The command FAQ-O-Matic can use to install a cron job."
#msgstr "Das Kommando mit dem FAQ-O-Matic ein cron-job benutzt"
msgstr "La commande FAQ-O-Matic peut installer un cron job."

msgid "RCS ci command."
#msgstr "RCS ci Kommando."
msgstr "RCS ci commande."

msgid "<b>Mandatory:</b> Server directory configuration"
#msgstr "<b>Vorschreibend:</b> Server-Verzeichnis-Konfiguration"
msgstr "<b>Obligatoire : </b> Configuration du r&eacute;pertoire du serveur"

msgid "Filesystem directory where FAQ-O-Matic will keep item files, image and other bit-bag files, and a cache of generated HTML files. This directory must be accesible directly via the http server. It might be something like /home/faqomatic/public_html/fom-serve/"
#msgstr "Dateisystem-Verzeichnis wo FAQ-O-Matic die item-Files, andere Datei-Objekte und den Cache von erzeugten HTML-Files ablegt. Auf dieses Verzeichnis wird via HTTP zugegriffen. Beispiel : /home/faqomatic/public_html/fom-serve/"
msgstr "R&eacute;pertoire du fichier syst&egrave;me dans lequel FAQ-O-Matic garde les &eacute;l&eacute;ments, images et fichiers objets, ainsi que le cache des fichiers HTML g&eacute;n&eacute;r&eacute;s. Ce r&eacute;pertoire doit &ecirc;tre accessible par le serveur http. Cela peut &ecirc;tre quelque chose comme : /home/faqomatic/public_html/fom-serve/" 

msgid "Use the" 
#msgstr "Benutze den"
msgstr "Utilisez le"

msgid "links to change the color of a feature.\n"
#msgstr "Link um eine bestimmte Farben zu  ndern.\n"
msgstr "liens pour modifier la couleur d'un objet.\n"

msgid "An Item Title"
#msgstr "Ein Titeleintrag"
msgstr "Un titre d'&eacute;l&eacute;ment"

msgid "A regular part is how most of your content will appear. The text colors should be most pleasantly readable on this background."
#msgstr "In diesem regul re Abschnitt wird der Inhalt erscheinen. Die Textfarben sollten gut lesbar sein auf diesem Hintergrund."
msgstr "Cette partie pr&eacute;sente comment le contenu appara&icirc;tra. Les couleurs du texte doivent &ecirc;tre agr&eacute;ables &agrave; lire sur ce fond."

msgid "A new link"
#msgstr "Ein neuer Link"
msgstr "Un nouveau lien"

msgid "A visited link"
#msgstr "Ein besuchter Link"
msgstr "Un lien visit&eacute;"

msgid "A search hit"
#msgstr "Ein Suchergebnis"
msgstr "Un r&eacute;sultat de recherche"

msgid "A directory part should stand out"
#msgstr "Ein Verzeichnis sollte hervortreten"
msgstr "Une section de r&eacute;pertoire doit appara&icirc;tre" 

msgid "Regular text color"
#msgstr "Regul re Textfarbe"
msgstr "Couleur du texte normale"

msgid "Link color"
#msgstr "Farbe eines Links"
msgstr "Couleur du lien"

msgid "Visited link color"
#msgstr "Farbe eines besuchten Links"  
msgstr "Couleur du lien visit&eacute;"

msgid "to proceed to the"
#msgstr "um weitermachen bei:"
msgstr "continuer en faisant : "

msgid "step"
#msgstr "Schritt"
msgstr " "

msgid "Select a color for"
#msgstr "W hle eine Farbe f&Cedilla;r"
msgstr "S&eacute;lectionnez la couleur pour"

msgid "Or enter an HTML color specification manually:"
#msgstr "Oder gebe einen HTML-Farben-Code ein:"
msgstr "Ou entrer une couleur en code HTML : "

msgid "Select"
#msgstr "OK"
msgstr "OK"

msgid "The URL prefix needed to access files in" 
#msgstr "Der URL-Prefix ist n tig f&Cedilla;r den Filezugriff in"
msgstr "Le pr&eacute;fixe de l'URL doit acc&eacute;der aux fichiers dans"

msgid "It should be relative to the root of the server (omit http://hostname:port, but include a leading /). It should also end with a /."
#msgstr " Er sollte relativ zum root des Servers (ohne http://hostname:port, aber mit einem Slash (/) am Anfang). Am Ende der Kommandozeile sollte auch ein Slash (/) stehen."
msgstr " Il doit &ecirc;tre relatif au root du serveur (sans http://hostname:port, mais avec un slash (/) au d&eacute;but). Cela doit aussi se finir par un slash (/) &agrave; la fin."

msgid "<i>Optional:</i> Miscellaneous configurations"
#msgstr "<i>Optional:</i> Verschiedene Einstellungen"
msgstr "<i>Optionnel : </I> Configurations diverses"

msgid "If this parameter is set, this FAQ will become a mirror of the one at the given URL. The URL should be the base name of the CGI script of the master FAQ-O-Matic."
#msgstr "Wenn diese Einstellung gesetzt ist, wird FAQ-O-Matic an der angegebenen URL gespiegelt. Die URL sollte auf das FAQ-O-Matic-CGI-Script zeigen."
msgstr "Si le param&egrave;tre est mis, cette FAQ deviendra un miroir d'une &agrave; un URL donn&eacute;. Cet URL doit pointer vers le script CGI de la FAQ-O-Matic."

msgid "An HTML fragment inserted at the top of each page. You might use this to place a corporate logo."
#msgstr "Auf jeder Seite wird am Anfang ein HTML-Fragment eingef&Cedilla;gt. Dies kann zum Plazieren eines gemeinsamen Logos verwendet werden."
msgstr "Un fragment d'HTML est un ins&eacute;r&eacute; en haut de chaque page. Profitez en pour utiliser cet emplacement pour afficher votre logo."

msgid "The width= tag in a table. If your"
#msgstr "Der width= Tag in einer Tabelle. Steht im"
msgstr "Le width= tag dans un tableau. Si vous" 

msgid "has"
#msgstr " " 
msgstr "a"

msgid "you will want to make this empty."
#msgstr "sollte dieses Feld freigelassen werden."
msgstr "vous souhaitez laisser ce champs vide."

msgid "An HTML fragment appended to the bottom of each page. You might use this to identify the webmaster for this site."
#msgstr "Auf jedem Seiten-Ende wird ein HTML-Fragment eingef&Cedilla;gt und kann zur Identifikation des Webmasters benutzt werden."
msgstr "&Agrave; la fin de chaque page, un fragment d'HTML appara&icirc;tra. Vous pouvez utilisez celui-ci pour pr&eacute;senter le webmestre du site."

msgid "Where FAQ-O-Matic should send email when it wants to alert the administrator (usually same as"
#msgstr "An wen soll FAQ-O-Matic eine Mail schicken, wenn der Administrator alarmiert werden soll (normalerweise"
msgstr "O&ugrave; FAQ-O-Matic doit envoyer un m&egrave;l lorque l'on souhaite contacter l'administrateur (habituellement comme"

msgid "If true, FAQ-O-Matic will mail the log file to the administrator whenever it is truncated."
#msgstr "FAQ-O-Matic schickt das Logfile als Mail zum Administrator."
msgstr "FAQ-O-Matic envoie le fichier log par m&egrave;l &agrave; l'administrateur."

msgid "User to use for RCS ci command (default is process UID)"
#msgstr "Benutzer, welcher das RCS ci-Kommando einsetzt (default: UID)"
msgstr "User to use for RCS ci command (par d&eacute;faut le process est UID)" 

msgid "Links from cache to CGI are relative to the server root, rather than absolute URLs including hostname:"
#msgstr "Links vom Cache zu CGI sind relativ zum Server-Root, nicht absolute URLs inklusive hostname:"
msgstr "Les liens du cache vers le CGI sont relatif &agrave; la racine principale du serveur, au lieu d'&ecirc;tre des URLs absolues utilisant le nom de la machine (hostname) : "

msgid "mailto: links can be rewritten such as"
#msgstr "mailto: Links k nnen ge ndert werden wie beispielsweise"
msgstr "mailto : Les liens peuvent &ecirc;tre r&eacute;&eacute;cris comme par exemple"

msgid "or e-mail addresses suppressed entirely (hide)."
#msgstr "oder die eMail-Adresse nicht anzeigen (verstecke)"
msgstr "ou les adresses m&egrave;l supprim&eacute;es completement (cacher)"

msgid "Number of seconds that authentication cookies remain valid. These cookies are stored in URLs, and so can be retrieved from a browser history file. Hence they should usually time-out fairly quickly."
#msgstr "Zeit in Sekunden, in der die Authentifikationscookies g&Cedilla;ltig sind. Die Cookies werden in URLs gespeichert und k nnen mit der Browser-History aufgerufen werden. Daher sollte das time-out schnell genug gew hlt werden."
msgstr "Nombre de secondes pour laquelle l'authentification par cookie reste valide. Les cookies sont stock&eacute;s en fonction des URLs, et ainsi ils peuvent &eacute;tre d&eacute;charg&eacute;s par le biais du fichier historique du navigateur. Ils doivent donc &ecirc;tre rapidement d&eacute;sactiv&eacute;s (leur time-out doit &ecirc;tre court)."

msgid "<i>Optional:</i> These options set the default [Appearance] modes."
#msgstr "<i>Optional:</i> Diese Einstellungen werden als Default-Werte bei [Darstellung] verwendet."
msgstr "<i>Optionnel : </i> Ces options d&eacute;finissent le mode [Apparence] par d&eacute;faut."

msgid "Page rendering scheme. Do not choose"
#msgstr "Seitenaufbau. Bitte nicht"
msgstr "Page en construction. Svp ne choisissez rien"

msgid "as the default."
#msgstr "als Standardeinstellung w hlen."
msgstr "comme pour le mod&egrave;le par d&eacute;faut."

msgid "expert editing commands"
#msgstr "Experten-Kommandos"
msgstr "Les commandes pour le mode d'&eacute;dition expert."

msgid "show"
#msgstr "zeige"
msgstr "montrer"

msgid "hide"
#msgstr "verstecke"
msgstr "cacher"

msgid "compact"
#msgstr "kompakt"
msgstr "compact"

msgid "name of moderator who organizes current category"
#msgstr "Name des Moderators, welcher die aktuelle Kategorie administriert"
msgstr "Nom du mod&eacute;rateur qui organise la cat&eacute;gorie courante"

msgid "last modified date"
#msgstr "Datum der letzten &fnof;nderung"
msgstr "Derni&egrave;re date de modification"

msgid "attributions"
#msgstr "Zeige Autoren"
msgstr "Montrer les auteurs"

msgid "commands for generating text output"
#msgstr "Kommandos f&Cedilla;r das generieren der Textausgabe"
msgstr "commandes pour cr&eacute;er le texte en sortie" 

msgid "<i>Optional:</i> These options fine-tune the appearance of editing features."
#msgstr "<i>Optional:</i> Diese Einstellungen sind f&Cedilla;r die Feineinstellung der Texteingabe."
msgstr "<i>Optionnel:</i> Ces options d&eacute;finissent l'apparence des outils d'&eacute;dition." 

msgid "The old [Show Edit Commands] button appears in the navigation bar."
#msgstr "Der [Zeige erweiterte Funktionen]-Button erscheint in der Navigationszeile."
msgstr "L'ancien bouton [Montrer les commandes d'&eacute;dition] appara&icirc;tra dans la barre de navigation."
 
msgid "Navigation links appear at top of page as well as at the bottom."
#msgstr "Navigations-Links erscheinen auf oben und unten auf der Seite."
msgstr "Les liens de navigation appara&icirc;tront en haut et en bas de la page."

msgid "Hide [Append to This Answer] and [Add New Answer in ...] buttons."
#msgstr "Verstecke [Diesen Eintrag erweitern] und [Einen neuen Eintrag hinzuf&Cedilla;gen in...]"
msgstr "Cacher les boutons : [Contribuer &agrave; cette r&eacute;ponse] et [Ajouter une nouvelle question dans ...]." 

msgid "icons-and-label"
#msgstr "Icons und Label"
msgstr "Ic&ocirc;nes et titres"

msgid "Editing commands appear with neat-o icons rather than [In Brackets]."
#msgstr "Editier-Kommandos erscheinen mit Icons nicht in [eckigen Klammern]."
msgstr "Les commandes d'&eacute;dition appara&icirc;trons comme des ic&ocirc;nes et non dans des [crochets]."
 
msgid "<i>Optional:</i> Other configurations that you should probably ignore if present."
#msgstr "<i>Optional:</i> Andere Einstellungen welche ignoriert werden k nnen."
msgstr "<i>Optionnel : </i> D'autres options de configuration que vous devriez ignorer &agrave; pr&eacute;sent."

msgid "Draw Item titles John Nolan's way."
#msgstr "Zeige den Titel nach John Nolan's Art"
msgstr "Dessiner les titres avec le style de John Nolan."

msgid "Hide sibling (Previous, Next) links"
#msgstr "Links nicht anzeigen (Vorherige, N chste)"
msgstr "Cacher les liens de navigation (Pr&eacute;c&eacute;dent, Suivant)"

msgid "Arguments to make ci quietly log changes (default is probably fine)"
#msgstr "Argumente f&Cedilla;r ci um &fnof;nderungen an der log-Datei vorzunehmen (Default: fine)"
msgstr "Arguments pour r&eacute;liser avec ci les modifications de log (le choix par d&eacute;faut est le mieux)" 

msgid "off"
#msgstr "aus"
msgstr "d&eacute;sactivi&eacute;"

msgid "true"
#msgstr "wahr"
msgstr "activ&eacute;" 

msgid "cheesy"
#msgstr "cheesy"
msgstr "chessy"

msgid "This is a command, so only letters, hyphens, and slashes are allowed."
#msgstr "Bei diesem Kommando sind nur Buchstaben, Bindestrich (-) und Slashes (/) erlaubt."
msgstr "Il s'agit d'une commande, ainsi seul les lettres, moins (-) et slash (/) sont autoris&eacute;."

msgid "If this is your first time installing a FAQ-O-Matic, I recommend"
#msgstr "Installieren Sie zum ersten Mal FAQ-O-Matic, wird empfohlen"
msgstr "Si il s'agit de votre premi&egrave;re installation de la FAQ-O-Matic, je vous recommande"

msgid "only filling in the sections marked <b>Mandatory</b>."
#msgstr "nur die mit <b>Vorschreibend</b> markierten Anschnitte auszuf&Cedilla;llen."
msgstr "de ne remplir que les sections marqu&eacute;es <b>important</b>."

msgid "Define"
#msgstr "&fnof;nderungen &Cedilla;bernehmen"
msgstr "D&eacute;finir"

msgid "(no description)"
#msgstr "(kein Eintrag)"
msgstr "aucune description"

msgid "Unrecognized config parameter"
#msgstr "Falscher Konfigurationsparameter"
msgstr "param&eacute;tre de configuration inconnu"

msgid "Please report this problem to"
#msgstr "Bitte wenden Sie sich mit diesem Problem an"
msgstr "S'il vous pla&icirc;t faites un rapport de votre probl&egrave;me &acute;"

msgid "Cron job installed. The maintenance script should run hourly."
#msgstr "Der Cron-Job wurde installiert. Das Script wird nun st&Cedilla;ndlich aufgerufen."
msgstr "Le cron job est install&eacute;. La maintenance s'effectue automatiquement toutes les heures." 

msgid "I thought I installed a new cron job, but it didn't"
#msgstr "Der neue cron-Job wurde installiert, wird aber nicht"
msgstr "Le nouveau cron job sera install&eacute;, mais ne sera pas" 


msgid "appear to take."
#msgstr "ausgef&Cedilla;hrt."
msgstr "appara&icirct prendre." 

msgid "You better add"
#msgstr "Durch hinzuf&Cedilla;gen von"
msgstr "Vous devriez ajouter"

msgid "to some crontab yourself with"
#msgstr "zum crontab mit"
msgstr "pour "

msgid "I replaced this old crontab line, which appears to be an older one for this same FAQ:"
#msgstr "Die alte crontab-Zeile wurde ersetzt"
msgstr "J'ai remplac&eacute; cette ancienne ligne de crontab, qui apparait comme une ancienne ligne pour cette m&ecirc;me FAQ : "

###
### submitBag.pm
###

msgid "Bag names may only contain letters, numbers, underscores (_), hyphens (-), and periods (.), and may not end in '.desc'. Yours was"
#msgstr "Objekt-Dateinamen d&Cedilla;rfen nur Buchstaben, Nummern, Unterstriche (_), Bindestriche (-) und Punkte (.) enthalten. Die Dateiendung '.desc' ist nicht erlaubt. Ihr Dateiname war"
msgstr "Un fichier objet ne contient que des lettres, des nombres, des underscores (_), des moins (-), et des points (.), et ne doit pas se terminer par '.desc'. Le votre &eacute;tait"


###
### editBag.pm
###

msgid "Upload new bag to show in the"
#msgstr "Uploaden eines Dateiobjekts in den"
msgstr "Charger un nouveau fichier objet dans"

msgid "part in"
#msgstr "Eintrag von"
msgstr "partie dans"

msgid "Bag name:"
#msgstr "Objekt-Name"
msgstr "Nom de l'objet"

msgid "The bag name is used as a filename, so it is restricted to only contain letters, numbers, underscores (_), hyphens (-), and periods (.). It should also carry a meaningful extension (such as .gif) so that web browsers will know what to do with the data."
#msgstr "Der Objektname wird von FAQ-O-Matic als Dateiname benutzt (nur Buchstaben, Zahlen, Unterstriche, Bindestriche und Punkte sind erlaubt) und sollte eine sinnvolle Erweiterung haben (beispielsweise .gif), damit der Webbrowser die Datei korrekt darstellt."
msgstr "Le nom de l'objet est utilis&eacute; comme un nom de fichier, ainsi il ne doit contenir que des lettres, des nombres, de underscores (_), des moins (-), et des points (.). Il faut aussi utiliser avec attention les extensions (comme .gif) pour que les navigateurs web puissent savoir que faire des donn&eacute;es." 

msgid "Bag data:"
#msgstr "Objekt-Datei:"
msgstr "Objet donn&eacute; : "

msgid "If this bag is an image, fill in its dimensions."
#msgstr "Ist das Objekt eine Bild-Datei, geben Sie hier die Dimensionen ein."
msgstr "Si un objet est une image, remplissez ses dimensions."

msgid "Width:"
#msgstr "Breite:"
msgstr "Largeur : "

msgid "Height:"
#msgstr "H he:"
msgstr "Hauteur : "

msgid "(Leave blank to keep original bag data and change only the associated information below.)"
#msgstr "(Braucht nicht ausgef&Cedilla;llt zu werden, wenn das alte Dateiobjekt erhalten werden soll.)"
msgstr "(Laissez en blanc  pour garder le fichier objet original et ne modifi&eacute; que l'information ci-dessous)."

###
### appearanceForm.pm
###

msgid "Appearance Options"
#msgstr "Einstellungen zur Darstellung"
msgstr "Options d'apparence"

msgid "Show"
#msgstr "Alle"
msgstr "Montrer"

msgid "Compact"
#msgstr "Kompakte"
msgstr "Compact"

msgid "Hide"
#msgstr "Keine"
msgstr "Cacher"

msgid "expert editing commands"
#msgstr "Anzeige der Experten-Kommandos"
msgstr "- Commandes d'&eacute;dition expert."

msgid "name of moderator who organizes current category"
#msgstr "Anzeige vom Namen des Moderators"
msgstr "- Le nom du mod&eacute;rateur qui organise la cat&eacute;gorie courante."

msgid "all categories and answers below current category"
#msgstr "Anzeige aller Kategorien und Antworten unter der Aktuellen Kategorie"
msgstr "toutes les cat&eacute;gories et r&eacute;ponses de la cat&eacute;gorie courante"

msgid "last modified date"
#msgstr "Anzeige vom Datum der letzten &fnof;nderung"
msgstr "- La derni&eacute;re modification de date."

msgid "Show All"
#msgstr "Zeige alle"
msgstr "Tout montrer"

msgid "Default"
#msgstr "Standard"
msgstr "Par d&eacute;faut"

msgid "attributions"
#msgstr "Autoren"
msgstr "- Montrer les auteurs."

msgid "Simple"
#msgstr "Einfaches"
msgstr "Simple"

msgid "Fancy"
#msgstr "Erweitertes"
msgstr "Standard"

msgid "commands for generating text output"
#msgstr "Anzeige der Kommandos um die Textausgabe zu generieren"
msgstr "- Commande pour g&eacute;n&eacute;rer la sortie texte."

msgid "Accept"
#msgstr "&fnof;nderungen &Cedilla;bernehmen"
msgstr "Modifier l'apparence"


###
### addItem.pm
###

msgid "Subcategories:\n\n\nAnswers in this category:\n"
#msgstr "Unterkategorien:\n\n\nAntworten in dieser Kategorie:\n"
msgstr "Sous-cat&eacute;gories :\n\nR&eacute;ponses dans cette cat&eacute;gorie : \n"

msgid "Copy of"
#msgstr "Kopie von"
msgstr "Copie de"

###
### changePass.pm
###

msgid "Please enter your username, and select a password."
#msgstr "Bitte geben Sie Ihren Usernamen und Ihr Passwort ein."
msgstr "Entrez votre nom d'utilisateur, et un mot de passe."

msgid "I will send a secret number to the email address you enter"
#msgstr "Es wird ein Schl&Cedilla;ssel zu der eingegebenen email-Adresse geschickt"
msgstr "Je vous envoi un nombre secret &agrave; l'adresse m&egrave;l que vous avez entr&eacute;e"

msgid "to verify that it is valid."
#msgstr "um zu &Cedilla;berpr&Cedilla;fen, ob Ihre Eingaben richtig sind."
msgstr "pour v&eacute;rifier la validit&eacute; de votre adresse."

msgid "If you prefer not to give your email address to this web form, please contact"
#msgstr "Wenn Sie Ihre email-Adresse nicht in dieses Formular eingeben m chten, kontaktieren Sie bitte"
msgstr "Si vous ne souhaitez pas donner votre adresse m&eacute;l dans ce formulaire web, alors contactez"

msgid "Please <b>do not</b> use a password you use anywhere else, as it will not be transferred or stored securely!"
#msgstr "Da das Passwort unverschl&Cedilla;sselt &Cedilla;bertragen wird, sollten Sie auf keinen Fall ein Passwort w hlen, welches Sie schon anderweitig benutzen."
msgstr "Svp <b>n'utilisez pas</b> un mot de passe que vous utilisez pour autre chose, car le transfert et le stockage ne sont pas s&eacute;curis&eacute; !"

msgid "Password:"
#msgstr "Passwort:"
msgstr "Mot de passe :"

msgid "Set Password"
#msgstr "Setze Passwort"
msgstr "Entrez un mot de passe"

###
### Auth.pm
###

msgid "the administrator of this Faq-O-Matic"
#msgstr "der Administrator von FAQ-O-Matic"
msgstr "l'administrateur de FAQ-O-Matic"

msgid "someone who has proven their identification"
#msgstr "ein Benutzer, welcher seine Identifikation bewiesen hat"
msgstr "quelqu'un qui a valid&eacute; son identification"

msgid "someone who has offered identification"
#msgstr "ein Benutzer, welcher seine Identifikation eingereicht hat"
msgstr "quelqu'un qui a &eacute;t&eacute; identifi&eacute;"

msgid "anybody"
#msgstr "irgendjemand" 
msgstr "n'importe qui"

msgid "the moderator of the item"
#msgstr "dem Moderator des Eintrags"
msgstr "mod&eacute;rateur de cette section"

msgid "group members"
#msgstr "Gruppenmitglieder"
msgstr "membres du groupe"

###
### Authenticate.pm
###

msgid "That password is invalid. If you've forgotten your old password, you can"
#msgstr "Das Passwort ist falsch. Wenn Sie Ihr altes Passwort vergessen haben, k nnen Sie"
msgstr "Ce mot de passe est faux. Si vous avez oubli&eacute; votre ancien mot de passe, vous pouvez"

msgid "Set a New Password"
#msgstr "ein neues Passwort eingeben"
msgstr "Configurer un nouveau mot de passe"

msgid "Create a New Login"
#msgstr "ein neues Login erstellen"
msgstr "Cr&eacute;er un nouveau login"

msgid "New items can only be added by"
#msgstr "Neue Eintr ge k nnen nur eingef&Cedilla;gt werden von"
msgstr "Les nouvelles sections ne peuvent &ecirc;tre ajout&eacute;es que par"

msgid "New text parts can only be added by"
#msgstr "Neue Texteintr ge k nnen nur eingef&Cedilla;gt werden von"
msgstr "Les nouveaux articles ne peuvent &ecirc;tre ajout&eacute;s que par"

msgid "Text parts can only be removed by"
#msgstr "Texteintr ge k nnen nur verschoben werden von"
msgstr "Les articles ne peuvent &ecirc;tre effac&eacute;s que par"

msgid "This part contains raw HTML. To avoid pages with invalid HTML, the moderator has specified that only"
#msgstr "Dieser Eintrag enth lt HTML-Code. Um Seiten mit HTML-Code zu vermeiden wurde festgelegt das nur"
msgstr "Cette section contient du pseudo-HTML. Afin d'&eacute;viter les pages avec du code HTML invalide, le mod&eacute;rateur a sp&eacute;cifi&eacute; que"

msgid "can edit HTML parts."
#msgstr "HTML-Seiten erstellen kann."
msgstr "l'on peut &eacute;diter des sections en HTML."

msgid "If you are"
#msgstr "Sind Sie"
msgstr "Si vous &ecirc;tes"

msgid "you may authenticate yourself with this form."
#msgstr "sollten Sie sich in diesem Formular authentifizieren."
msgstr "vous devez vous authentifier avec ce formulaire."

msgid "Text parts can only be added by"
#msgstr "Texteintr ge k nnen nur hinzugef&Cedilla;gt werden von"
msgstr "Les articles ne peuvent &ecirc;tre ajout&eacute;es que par"

msgid "Text parts can only be edited by"
#msgstr "Texteintr ge k nnen nur ge ndert werden von"
msgstr "Les articles ne peuvent &ecirc;tre &eacute;dit&eacute;s que par"

msgid "The title and options for this item can only be edited by"
#msgstr "Der Titel und die Einstellungen f&Cedilla;r diesen Eintrag k nnen nur ge ndert werden von"
msgstr "Le titre et les options de cette section ne peuvent &ecirc;tre &eacute;dit&eacute;s que par"

msgid "The moderator options can only be edited by"
#msgstr "Die Moderator-Einstellungen k nnen nur ge ndert werden von"
msgstr "Les options de mod&eacute;ration ne peuvent &ecirc;tre &eacute;dit&eacute; que par"

msgid "This item can only be moved by someone who can edit both the source and destination parent items."
#msgstr "Dieser Eintr g kann nur vom rechtm ssigem Besitzer verschoben werden."
msgstr "Cette section ne peut &ecirc;tre d&eacute;plac&eacute;e que par quelqu'un qui peut &agrave; la fois &eacute;diter la source et la destination parente de la section."

msgid "This item can only be moved by"
#msgstr "Dieser Eintrag kann nur verschoben werden von"
msgstr "Cet &eacute;l&eacute;ment ne peut &ecirc;tre d&eacute;plac&eacute; vers"

msgid "Only"
#msgstr "Nur"
msgstr "Seul"

msgid "can replace existing bags."
#msgstr "kann verhandene Datei-Objekte ersetzen."
msgstr "peut remplacer les fichiers objets existant."

msgid "can post bags."
#msgstr "kann Datei-Objekte verschicken."
msgstr "peut ajouter des fichiers objet."

msgid "The FAQ-O-Matic can only be configured by"
#msgstr "FAQ-O-Matic kann nur konfiguriert werden von"
msgstr "La FAQ-O-Matic ne peut &ecirc;tre configur&eacute;e que par"

msgid "The operation you attempted"
#msgstr "Die von Ihnen versuchte Operation"
msgstr "L'op&eacute;ration que vous avez tent&eacute;"

msgid "can only be done by"
#msgstr "kann nur durchgef&Cedilla;hrt werden von"
msgstr "ne peut &ecirc;tre r&eacute;alis&eacute; que par"

msgid "If you have never established a password to use with FAQ-O-Matic, you can"
#msgstr "Wenn Sie noch kein Passwort zur Benutzung von FAQ-O-Matic festgelegt haben, k nnen Sie"
msgstr "Si vous n'avez jamais configur&eacute; de mot de passe dans cette FAQ-O-Matic, vous pouvez"

msgid "If you have forgotten your password, you can"
#msgstr "Wenn Sie Ihr Passwort vergessen haben, k nnen Sie"
msgstr "Si vous avez oubli&eacute; votre mot de passe, vous pouvez"

msgid "If you have already logged in earlier today, it may be that the token I use to identify you has expired. Please log in again."
#msgstr "Wenn Sie schon einmal eingeloggt waren, k nnte es sein, da&thorn; Ihr Passwort nicht mehr g&Cedilla;ltig ist. Bitte loggen Sie sich erneut ein."
msgstr "Si vous vous &egrave;tes d&eacute;j&agrave; logu&eacute;, il se peut que l'authentification  est expir&eacute;e. Reloguez vous &agrave; nouveau."

msgid "Please offer one of the following forms of identification:"
#msgstr "Bitte w hlen Sie die Art der Identifikation:"
msgstr "Svp remplissez une de ces formes d'authentification : "

msgid "No authentication, but my email address is:"
#msgstr "Keine Authorisierung, aber meine email-Adresse lautet:"
msgstr "Pas d'authentification, mais mon adresse m&egrave;l est : "

msgid "Authenticated login:"
#msgstr "Authorisiertes Login:"
msgstr "login d'authentification : "

###
### moveItem.pm
###

msgid "The file"
#msgstr "Die Datei"
msgstr "Le fichier"

msgid "doesn't exist."
#msgstr "konnte nicht gefunden werden."
msgstr "n'a pas pu &ecirc;tre trouv&eacute;."

msgid "Make"
#msgstr "Mache"
msgstr "Faire"

msgid "belong to which other item?"
#msgstr "zugeh rig zu welchem Eintrag?"
msgstr "appartient &agrave; quel autre entr&eacute; ?"

msgid "No item that already has sub-items can become the parent of"
#msgstr "Der Eintrag hat Subeintr ge und kann daher nicht verwendet werden als Oberbegriff von"
msgstr "Aucune entr&eacute; qui poss&eacute;de d&eacute;j&agrave; des sous-entr&eacute; ne peut devenir parent de"

msgid "No item can become the parent of"
#msgstr "Der Eintrag kann nicht als Oberbegriff verwendet werden von"
msgstr "L'entr&eacute;e ne peut pas devenir le parent de"

msgid "Some destinations are not available (not clickable) because you do not have permission to edit them as currently autorized."
#msgstr "Sie haben keine Zugriffsrechte auf einige Eintr ge, deshalb k nnen diese nicht angeklickt werden."
msgstr "Certaines destinations ne sont pas accessibles car vous n'avez pas la permission d'&eacute;diter celle-ci."

msgid "Click here</a> to provide better authentication."
#msgstr "Klicken Sie hier</a>, um die Zugriffsrechte zu  ndern."
msgstr "Cliquez ici</a> pour permettre une meilleure authentification."

msgid "Hide answers, show only categories"
#msgstr "Zeige keine Antworten, zeige nur die Kategorien"
msgstr "Cacher les r&eacute;ponses, ne montrer que les cat&eacute;gories"

msgid "Show both categories and answers"
#msgstr "Zeige die Kategorien und die Antworten"
msgstr "Montrer &agrave la fois les cat&eacute;gories et les r&eacute;ponses"

###
### editPart.pm
###

msgid "Enter the answer to"
#msgstr "Antwort eingeben in"
msgstr "R&eacute;pondre &agrave;"

msgid "Enter a description for"
#msgstr "Beschreibung eingeben f&Cedilla;r"
msgstr "D&eacute;crire"

msgid "Edit duplicated text for"
#msgstr "&fnof;ndere duplizierten Text f&Cedilla;r"
msgstr "Dupliquer un texte de"

msgid "Enter new text for"
#msgstr "Neuen Text eingeben f&Cedilla;r"
msgstr "&Eacute;diter un nouveau texte dans"

msgid "Editing the"
#msgstr "&fnof;nderung des"
msgstr "&Eacute;diter la partie de texte n°"

msgid "text part in"
#msgstr "Texteintrag in"
msgstr "dans"

###
### Part.pm
###

msgid "Upload file:"
#msgstr "Zu ladene Datei:"
msgstr "Charger le fichier : "

msgid "Warning: file contents will <b>replace</b> previous text"
#msgstr "Warnung: Die Datei wird den vorhandenen Text <b>ersetzen</b>"
msgstr "Attention : Le contenu du fichier va <b>remplacer</b> le texte pr&eacute;c&eacute;dent"

msgid "Replace"
#msgstr "Ersetze"
msgstr "Remplacer"

msgid "with new upload"
#msgstr "mit neuer Datei"
msgstr "avec un nouveau chargement de fichier"

msgid "Select bag to replace with new upload"
#msgstr "W hle ein neues Datei-Objekt"
msgstr "S&eacute;lectionner le nouveau fichier objet"

msgid "Hide Attributions"
#msgstr "Name des Autors nicht anzeigen"
msgstr "Ne pas montrer le nom des auteurs"

msgid "Format text as:"
#msgstr "Formatiere den Text als:"
msgstr "Formater le texte comme : "

msgid "Directory"
#msgstr "Verzeichnis"
msgstr "un r&eacute;pertoire"

msgid "Natural text"
#msgstr "Normaler Text"
msgstr "Un texte normal"

msgid "Monospaced text (code, tables)"
#msgstr "Text mit festen Zeichenabst nden"
msgstr "Un texte monospace (code, tableau)"

msgid "Untranslated HTML"
#msgstr "HTML-Code"
msgstr "Du code HTML"

msgid "Submit Changes"
#msgstr "&fnof;nderungen abschicken"
msgstr "Valider les modifications"

msgid "Revert"
#msgstr "Eingabefeld zur&Cedilla;cksetzen"
msgstr "Annuler"

msgid "Insert Uploaded Text Here"
#msgstr "Textdatei hier einf&Cedilla;gen"
msgstr "Ins&eacute;rer un texte &agrave; charger"

msgid "Insert Text Here"
#msgstr "Text hier einf&Cedilla;gen"
msgstr "Ins&eacute;rer un texte"

msgid "Edit This Text"
#msgstr "Diesen Text editieren"
msgstr "&Eacute;diter ce texte"

msgid "Duplicate This Text"
#msgstr "Diesen Text duplizieren"
msgstr "Dupliquer ce texte"

msgid "Remove This Text"
#msgstr "Diesen Text l schen"
msgstr "Effacer ce texte"

msgid "Upload New Bag Here"
#msgstr "Eine neues Datei-Objekt hier einf&Cedilla;gen"
msgstr "Charger un nouveau fichier objet"

###
### searchForm.pm
###

msgid "Search for"
#msgstr "Suche nach"
msgstr "Rechercher"

msgid "matching"
#msgstr "passend auf"
msgstr "contient"

msgid "all"
#msgstr "alle"
msgstr "tout les"

msgid "any"
#msgstr "jedes"
msgstr "chaque"

msgid "two"
#msgstr "zwei"
msgstr "deux"

msgid "three"
#msgstr "drei"
msgstr "trois"

msgid "four"
#msgstr "vier"
msgstr "quatre"

msgid "five"
#msgstr "f&Cedilla;nf"
msgstr "cinq"

msgid "words"
#msgstr "der W rter"
msgstr "mots"

msgid "Show documents"
#msgstr "Zeige Dokumente"
msgstr "Montrer les documents"

msgid "modified in the last"
#msgstr "die ver ndert wurden"
msgstr "qui ont &eacute;t&eacute; modifi&eacute;s"

msgid "day"
#msgstr "am letzten Tag"
msgstr "il y a un jour"

msgid "two days"
#msgstr "in den letzten beiden Tagen"
msgstr "il y a deux jours"

msgid "three days"
#msgstr "in den letzten drei Tagen"
msgstr "il y a trois jours"

msgid "week"
#msgstr "in der letzten Woche"
msgstr "cette semaine"

msgid "fortnight"
#msgstr "in den letzten vierzehn Tagen"
msgstr "il y a deux semaines"

msgid "month"
#msgstr "im letzten Monat"
msgstr "depuis un mois"

###
### search.pm
###

msgid "No items matched"
#msgstr "Kein Eintrag passte zu"
msgstr "Aucun &eacute;l&eacute;m&eacute;nt trouv&eacute;"

msgid "of these words"
#msgstr "der folgenden W rter"
msgstr "contenant ces mots"

msgid "Search results for"
#msgstr "Ergebnisse der Suche f&Cedilla;r"
msgstr "Chercher les r&eacute;sultats de "

msgid "at least"
#msgstr "zumindest"
msgstr "&agrave; la fin"

msgid "Results may be incomplete, because the search index has not been refreshed since the most recent change to the database."
#msgstr "Die Ergebnisse k nnen unvollst ndig sein, da der Index nicht erneuert wurde seit der letzten &fnof;nderung an der Datenbasis."
msgstr "Les r&eacute;sultats peuvent &ecirc;tre incomplets, car l'index de recherche n'a peut &ecirc;tre pas &eacute;t&eacute; remis &agrave; jour depuis les modifications r&eacute;centes de la base de donn&eacute;es."

###
### Item.pm
###

msgid "(system default)"
#
msgstr "(système par défaut)"

msgid "Yes"
#
msgstr "Oui"

msgid "No"
#
msgstr "Non"

msgid "Inherit"
#
msgstr "Hérité"

msgid "The moderator"
#
msgstr "Le modérateur"

msgid "Group Administrators"
#
msgstr "Groupe des administrateurs"

msgid "Authenticated users"
#
msgstr "Utilisateurs authentifiés"

msgid "Users giving their names"
#
msgstr "Utilisateurs ayant donné leur nom"

msgid "Relax"
#
msgstr "Relax"

msgid "Don't Relax"
#
msgstr "Don't Relax"

msgid "defined in"
#msgstr "definiert in"
msgstr "d&eacute;finit dans"

msgid "Name & Description"
#msgstr "Name und Beschreibung"
msgstr "Nom et description"

msgid "Setting"
#msgstr "Einstellung"
msgstr "Configuration"

msgid "Setting if Inherited"
#msgstr "Geerbter Wert"
msgstr "Configuration h&eacute;rit&eacute;"

msgid "Moderator"
#msgstr "Moderator"
msgstr "Mod&eacute;rateur"

msgid "(will inherit if empty)"
#msgstr "(geerbter Wert wenn leer)"
msgstr "(h&eacute;ritera si c'est vide)"

msgid "Send mail to the moderator when someone other than the moderator edits this item:"
#msgstr "Schicke dem Moderator eine Mail, wenn jemand anders diesen Eintrag  ndert:"
msgstr "Envoyer un m&egrave;l au mod&eacute;rateur, si quelqu'un d'autre que le mod&eacute;rateur &eacute;dite la section : "

msgid "Permissions"
#msgstr "Zugriffsrechte"
msgstr ": ses permissions"

msgid "RelaxChildPerms"
#msgstr "RelaxChildPerms"
msgstr "RelaxChildPerms"

msgid "Blah"
#msgstr "Blah"
msgstr "Blah"

msgid "blah"
#msgstr "blah"
msgstr "blah"

msgid "<p>New Order for Text Parts:"
#msgstr "<p>Neue Reihenfolge f&Cedilla;r Textabschnitte:"
msgstr "<p>Nouvel ordre des articles : "

msgid "Who can add a new text part to this item:"
#msgstr "Wer darf einen neuen Texteintrag in dieses Feld eintragen:" 
msgstr "Qui peut ajouter une nouvel article dans cette section : "

msgid "Who can add a new answer or category to this category:"
#msgstr "Wer darf eine neue Antwort oder Kategorie in diese Katagorie eintragen:"
msgstr "Qui peut ajouter une nouvelle r&eacute;ponse ou cat&eacute;gorie dans cette cat&eacute;gorie : "

msgid "Who can edit or remove existing text parts from this item:"
#msgstr "Wer darf vorhandenen Text editieren bzw. verschieben von diesem Feld:"
msgstr "Qui peut &eacute;diter ou effacer un article existant dans cette section : "

msgid "Who can move answers or subcategories from this category;"
#msgstr "Wer darf Antworten oder Subkategorien verschieben von dieser Kategorie;"
msgstr "Qui peut d&eacute;placer les r&eacute;ponses ou les sous-cat&eacute;gories de cette cat&eacute;gorie : "

msgid "or turn this category into an answer or vice versa:"
#msgstr "bzw. umwandeln dieser Kategorie in eine Antwort und umgekehrt:"
msgstr "ou transformez cette cat&eacute;gorie en r&eacute;ponse ou cette r&eacute;ponse en cat&eacute;gorie : "

msgid "Who can edit the title and options of this answer or category:"
#msgstr "Wer darf den Titel und die Einstellungen dieser Antwort oder Kategorie  ndern:"
msgstr "Qui peut &eacute;diter le titre et les options de cette r&eacute;ponse ou cat&eacute;gorie : "

msgid "Who can use untranslated HTML when editing the text of"
#msgstr "Wer darf HTML-Code benutzen beim Editieren von"
msgstr "Qui peut utiliser l'HTML pour &eacute;diter un texte de"

msgid "this answer or category:"
#msgstr "dieser Antwort oder Kategorie:"
msgstr "la r&eacute;ponse ou la cat&eacute;gorie : "

msgid "Who can change these moderator options and permissions:"
#msgstr "Wer darf diese Moderator-Einstellungen und Zugriffsrechte  ndern:"
msgstr "Qui peut modifier les options et permissions du mod&eacute;rateurs : "

msgid "Who can use the group membership pages:"
#msgstr "Wer darf die Gruppenmitgliedschaftsseiten benutzen:"
msgstr "Qui peut utiliser les pages d'appartenance de groupe : " 

msgid "Who can create new bags:"
#msgstr "Wer darf neue Dateiobjekte einf&Cedilla;gen:"
msgstr "Qui peut cr&eacute;er de nouveaux fichiers objets : "

msgid "Who can replace existing bags:"
#msgstr "Wer darf vorhandene Dateiobjekte ersetzen:"
msgstr "Qui peut remplacer des fichiers objets existant : "

msgid "Group"
#msgstr "Gruppen"
msgstr "Groupe"

msgid "The moderator"
#msgstr "Moderator"
msgstr "Le modi&eacute;rateur"

msgid "Authenticated users"
#msgstr "Authorisierte Benutzer"
msgstr "utilisateurs authentifi&eacute;s"

msgid "Users giving their names"
#msgstr "Benutzer, welcher seinen Namen angegeben hat"
msgstr "Utilisateurs ayant donn&eacute;s leurs nom"

msgid "Whoever can for my parent,"
#msgstr "Jeder &ETH;bergeordnete Benutzer"
msgstr "Whoever can for my parent," 

msgid "File $subfilename seems broken."
#msgstr "Datei $subfilename scheint defekt zu sein."
msgstr "Le fichier $subfilename semble d&eacute;fecteux."

msgid "Permissions:"
#msgstr "Zugriffsrechte:"
msgstr "Permissions : "

msgid "Moderator options for"
#msgstr "Moderator-Einstellungen f&Cedilla;r"
msgstr "Les options du mod&eacute;rateur sont"

msgid "Title:"
#msgstr "Titel:"
msgstr "Titre : "

msgid "Category"
#msgstr "Kategorie"
msgstr "Cat&eacute;gorie"

msgid "Answer"
#msgstr "Eintrag"
msgstr "l'Entr&eacute;e"

msgid "answer"
#msgstr "Eintrag"
msgstr "entr&eacute;e"

msgid "Show attributions from all parts together at bottom"
#msgstr "Zeige nicht den Namen des Autors unter jedem Eintrag"
msgstr "Montrer en bas de la page, tous les auteurs de la cat&eacute;gorie."
 
msgid "New Item"
#msgstr "Neuer Eintrag"
msgstr "Nouvelle entrée"

msgid "Submit Changes"
#msgstr "&fnof;nderungen abschicken"
msgstr "Soumettre les modifications"

msgid "Revert"
#msgstr "Eingabefelder zur&Cedilla;cksetzen"
msgstr "Annuler"
 
msgid "Convert to Answer"
#msgstr "Konvertieren nach Antwort"
msgstr "Transformer en Entr&eacute;e"

msgid "Convert to Category"
#msgstr "Konvertieren nach Kategorie"
msgstr "Transformer en Cat&eacute;gorie"

msgid "New Subcategory of"
#msgstr "Neue Subkategorie von"
msgstr "Nouvelle sous-cat&eacute;gorie"

msgid "Move"
#msgstr "Verschiebe"
msgstr "D&eacute;placer"

msgid "Trash"
#msgstr "L sche"
msgstr "Supprimer"

msgid "Parts"
#msgstr "Eintr ge"
msgstr "l'entr&eacute;e"

msgid "New Category"
#msgstr "Neue Kategorie"
msgstr "Nouvelle cat&eacute;gorie"

msgid "New Answer"
#msgstr "Neue Antwort"
msgstr "Nouvelle entr&eacute;e"

msgid "Editing"
#msgstr "Bearbeite"
msgstr "&Eacute;diter"

msgid "Insert Uploaded Text Here"
#msgstr "Textdatei hier einf&Cedilla;gen"
msgstr "Ins&eacute;rer un fichier texte &agrave; charger"

msgid "Insert Text Here"
#msgstr "Text hier einf&Cedilla;gen"
msgstr "Ins&eacute;rer un texte"

msgid "New Answer in"
#msgstr "Neuer Eintrag in"
msgstr "Nouvelle entr&eacute;e dans"

msgid "Duplicate Category as Answer"
#msgstr "Dupliziere Kategorie"
msgstr "Dupliquer la Cat&eacute;gorie"

msgid "Duplicate Answer"
#msgstr "Dupliziere Eintrag"
msgstr "Dupliquer l'entr&eacute;e"

msgid "Title and Options"
#msgstr "Titel und Einstellungen"
msgstr " : Options (Titre, ordre des articles...)"

msgid "Category"
#msgstr "Kategorie"
msgstr "la Cat&eacute;gorie"

msgid "Edit"
#msgstr "&fnof;ndere"
msgstr "&Eacute;diter"

msgid "Add a New Answer in"
#msgstr "Ein neuen Eintrag hinzuf&Cedilla;gen in"
msgstr "Ajouter une nouvelle entr&eacute;e dans"

msgid "Append to This Answer"
#msgstr "Diesen Eintrag erweitern"
msgstr "R&eacute;pondre &agrave; cette Entr&eacute;e"

msgid "This document is:"
#msgstr "Dieses Dokument ist:"
msgstr "Ce document est : "

msgid "This document is at:"
#msgstr "Dieses Dokument hat die URL:"
msgstr "Ce document est &agrave; l'URL : "

msgid "Previous"
#msgstr "Vorhergehende"
msgstr "Pr&eacute;c&eacute;dent "

msgid "Next"
#msgstr "N chste"
msgstr "Suivant "

###
### Appearcance.pm
###

msgid "Search"
#msgstr "Suchen"
msgstr "Chercher"

msgid "Appearance"
#msgstr "Darstellung"
msgstr "Modifier l'apparence"

msgid "Show Top Category Only"
#msgstr "Nur die oberste Kategorie zeigen"
msgstr "Ne montrer que la cat&eacute;gorie principale"

msgid "Show This <em>Entire</em> Category"
#msgstr "Die <em>gesamte</em> Kategorie zeigen"
msgstr "Montrer <em>tout le contenu</em> de cette cat&eacute;gorie"

msgid "Show This $whatAmI As Text</a>"
#msgstr "Anzeigen von $whatAmI als Text</a>"
msgstr "Montrer ce $whatAmI comme un texte</a>"

msgid "Show This <em>Entire</em> Category As Text</a>"
#msgstr "Anzeigen der <em>gesamten</em> Kategorie als Text</a>"
msgstr "Montrer <em>tout le contenu</em> de cette cat&eacute;gorie comme un texte"

msgid "Hide Expert Edit Commands"
#msgstr "Erweiterte Funktionen verstecken"
msgstr "Cacher les commandes d'&eacute;dition expert"

msgid "Show Expert Edit Commands"
#msgstr "Zeige erweiterte Funktionen"
msgstr "Montrer les commandes d'&eacute;dition expert"

msgid "Return to FAQ"
#msgstr "Zur&Cedilla;ck zur FAQ"
msgstr "Retourner &agrave; la FAQ"

msgid "This is a"
#msgstr "Dies ist eine"
msgstr "C'est une"

msgid "Hide Help"
#msgstr "Hilfe verstecken"
msgstr "Cacher l'aide"

msgid "Help"
#msgstr "Hilfe"
msgstr "Aide"

msgid "Log In"
#msgstr "Einloggen"
msgstr "Se loguer" 

msgid "Change Password"
#msgstr "&fnof;ndere Passwort"
msgstr "Changer de mot de passe"

msgid "Edit Title of %0 %1"
#msgstr "&fnof;ndere Titel von %0 %1"
msgstr "&Eacute;diter le titre de %0 %1"

msgid "New %0"
#msgstr "Neue %0"
msgstr "Nouveau %0"

msgid "Edit Part in %0 %1"
#msgstr " &fnof;ndere Abschnitt in %0 %1"
msgstr "&Eacute;diter la section de %0 %1"

msgid "Insert Part in %0 %1"
#msgstr "Einf&Cedilla;gen eines Textteils in %0 %1"
msgstr "Ins&eacute;re une section dans %0 %1"

msgid "Move %0 %1"
#msgstr "Verschiebe %0 %1"
msgstr "D&eacute;place %0 %1"

msgid "Search"
#msgstr "Suche"
msgstr "Chercher"

msgid "Access Statistics"
#msgstr "Zugriffs-Statistik"
msgstr "Statistique d'acc&egrave;s"

msgid "Validate"
#msgstr "F&Cedilla;r g&Cedilla;ltig erkl ren"
msgstr "Valider"

msgid "%0 Permissions for %1"
#msgstr "%0 Zugriffsrechte f&Cedilla;r %1"
msgstr "%0 permissions pour %1"

msgid "Upload bag for %0 %1"
#msgstr "Uploaden eines Datei-Objekts f&Cedilla;r %0 %1"
msgstr "Charger un fichier objet pour %0 %1"

###
### Adds
###

msgid "Either someone has changed the answer or category you were editing since you received the editing form, or you submitted the same form twice."
#
msgstr "Quelqu'un a du chang&eacute; l'entr&eacute;e ou la cat&eacute;gorie pendant que vous receviez le formulaire d'&eacute;dition, ou alors vous avez soumis le formulaire une deuxi&eacute;me fois."

msgid "Please"
#
msgstr "Svp"

msgid "Return to the FAQ"
#
msgstr "Retourner &agrave; la FAQ"

msgid "and start again to make sure no changes are lost. Sorry for the inconvenience."
#
msgstr "et recommencez pour &ecirc;tre sur que les modifications n'ont pas &eacute;t&eacute; perdues. D&eacute;sol&eacute; pour l'inconveniant."

msgid "(Sequence number in form : 0; in item : 1)."
"
msgstr "(Num&eacute;ro de s&eacute;quence dans le formulaire : 0 ; dans l'Entr&eacutee : 1)."

###
### Items
###

msgid "If you later need to edit or delete this text, use the [Appearance] page to turn on the expert editing commands."
#
msgstr "Si vous souhaitez &eacute;diter ou effacer ce texte, utilisez le bouton [Modifier apparence] et mettez en route les commandes d'&eacute;dition en mode expert."

###
### [Show this   As Text]
###

msgid "Show This"
#
msgstr "Montrer"

msgid "As Text"
#
msgstr "comme un texte"

###
### Help.pm
###

msgid "Online Help"
#
msgstr "Aide en ligne"

msgid "faq"
#
msgstr "faq"

msgid "How can I contribute to this FAQ?"
#
msgstr "Comment contribuer à cette FAQ ?"

msgid "Search Tips"
#
msgstr "Conseils de recherche"

msgid "search"
#
msgstr "recherche"

msgid "Appearance Options"
#
msgstr "Options d'apparence"

msgid "Authentification"
#
msgstr "Authentification"

msgid "Editing an Item's Title and Options"
#
msgstr "&Eacute;diter un titre d'une entrée et ses options"

msgid "Moderator Options"
#
msgstr "Options du modérateur"

msgid "Editing Text Parts"
#
msgstr "&Eacute;diter un texte"

msgid "Making Links to Other Sites"
#
msgstr "Créer des liens vers d'autres sites"

msgid "Making Links To Other FAQ-O-Matic Items"
#
msgstr "Créer des liens vers d'autres entrées de FAQ-O-Matic"

msgid "Moving Answers and Categories"
#
msgstr "Déplacer les réponses et les catégories"

###
### Mail messages
###

msgid "[Faq-O-Matic] Your authentification secret"
#
msgstr "[Faq-O-Matic] Votre clé d'accès d'authentification"

msgid "[Faq-O-Matic] Moderator Mail"
#
msgstr "[Faq-O-Matic] mèl du modérateur"

msgid "[Faq-O-Matic] problem Mail"
#
msgstr "[Faq-O-Matic] problème de mèl"

msgid "To validate your Faq-O-Matic password, you may either enter this secret into the validation form:"
#
msgstr "Pour valider votre mot de passe Faq-O-Matic, vous devez entrer cette clé d'accès dans le formulaire de validation :"

msgid "Secret"
#
msgstr "Clé d'accès"

msgid "Or access the following URL. Be careful when you copy and paste the URL that the line-break doesn't cut the URL short."
#
msgstr "Ou l'(accès à cet URL. Faites attention lorsque vous copiez et collez l'URL, il ne doit pas contenir de retour à la ligne."

msgid "Thank you for using Faq-O-Matic."
#
msgstr "Merci pour votre utilisation de Faq-O-Matic"

msgid "(Note: if you did not sign up to use the Faq-O-Matic, someone else has attempted to log in using your name.\nDo not access the URL above; it will validate the password that user has supplied. Instead, send mail to."
#
msgstr "(Note : Si vous "

msgid "and I will look into the matter.)"
#
msgstr ""

###
### 'sub'-messages
###

msgid "added a sub-item"
#
msgstr "ajouter une sous-entrée"

msgid "As always, thanks for your help maintaining the FAQ."
#
msgstr "Comme toujours, merci pour votre contribution à la FAQ (Foire Aux Questions)."

msgid "edited the item configuration."
#
msgstr "édition d'une élément de la configuration."

msgid "inserted a part"
#
msgstr "insertion d'une nouvelle partie"

msgid "New text:"
#
msgstr "Nouveau texte :"

msgid "The"
#
msgstr ""

msgid "maintained by"
#
msgstr "maintenue par"

msgid "had a problem situation."
#
msgstr ""

msgid "The command was:"
#
msgstr "la commande était :"

msgid "The message is:"
#
msgstr "Le message est :"

msgid "The process number is:"
#
msgstr "Le numéro de process est :"

msgid "The user had given this ID:"
#
msgstr "L'utilisateur a donné l'ID :"

msgid "the browser was:"
#
msgstr "Le navigateur était :"

msgid "problem: Use of uninitialized value at"
#
msgstr "Problème : Utilisation d'une variable non initialisée dans"

msgid "<b>%0</b> already contains a file '%1'."
msgstr "%0 contient d&eacute;j&agrave; un fichier <b>%1</b>"


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
