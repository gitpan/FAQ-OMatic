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

msgid "The file (%0) doesn't exist."
msgstr "Le fichier (%0) n'existe pas."

msgid "To name your FAQ-O-Matic, use the [Appearance] page to show the expert editing commands, then click [Edit Category Title and Options]."
msgstr "Pour donner un nom a votre FAQ-O-Matic, utilisez la page [Apparence] � montrer des commandes d'�dition experte, puis cliquez [Edit Category Title and Options]."

msgid "Your browser or WWW cache has truncated your POST."
msgtr "Votre navigateur ou cache web a tronqu� votre envoi."
 
msgid "Changed the item title, was "%0""
msgstr "Le titre de l'�l�ment a chang�, il a et�: <i>%0</i>."

msgid "Your part order list (%0) "
msgstr "Votre liste de sections (%0) "

msgid "doesn't have the same number of parts (%0) as the original item."
msgstr "n'a pas le m�me nombre de sections (%0) que l'�l�ment d'origine."

msgid "doesn't say what to do with part %0."
msgstr "ne d�crit pas l'action � r�aliser sur la section %0."

###
### submitMove.pm
###

msgid "The moving file (%0) is broken or missing."
msgstr "Le fichier � d�placer (%0) est d�fecteux ou manquant."

msgid "The newParent file (%0) is broken or missing."
msgstr "Le nouveau fichier parent (%0) est d�fecteux ou manquant."

msgid "The oldParent file (%0) is broken or missing."
msgstr "L'ancien fichier parent (%0) est d�fecteux ou manquant."

msgid "The new parent (%0) is the same as the old parent."
msgstr "Le nouveau fichier parent (%0) est le m�me que l'ancien fichier parent."

msgid "The new parent (%0) is the same as the item you want to move."
msgstr "Le nouveau fichier parent (%0) est le m�me �l�ment que vous souhaitez d�placer."

msgid "The new parent (%0) is a child of the item being moved (%1)."
msgstr "Le nouveau fichier parent (%0) est un fils de l'�l�ment (%1) que vous a �t� d�plac�."

msgid "You can't move the top item."
msgstr "Vous ne pouvez pas d�placer l'entr�e au sommet de la hi�rarchie."

msgid "moved a sub-item to %0"
msgstr "a d�plac� un sous-entr�e vers %0"

msgid "moved a sub-item from %0"
msgstr "a d�plac� un sous-entr� de %0"

###
### submitPass.pm
###

msgid "An email address must look like 'name@some.domain'."
msgstr "L'adresse m�l doit avoir la forme 'nome@quelque.domain'."

msgid "If yours (%0) does and I keep rejecting it, please mail %1 and tell him what's happening."
msgstr "Si votre adresse m�l (%0) sonne et n'est pas accept�, envoyez svp un m�l � %1 en d�crivant l'incident."

msgid "Your password may not contain spaces or carriage returns."
msgstr "Votre mot de passe ne doit contenir aucun caract�re vide (esp, rtn)."

msgid "Your Faq-O-Matic authentication secret"
msgstr "Votre cl� d'acc�s Faq-O-Matic"

msgid "I couldn't mail the authentication secret to "%0" and I'm not sure why."
msgstr "Je ne peux pas vous envoyer la cl� d'acc�s � <i>%0</i> et je ne sais pas pourquoi."

msgid "The secret you entered is not correct."
msgstr "La cl� d'acc�s donn�e n'est pas correcte."

msgid "Did you copy and paste the secret or the URL completely?"
msgstr "Avez vous copi� la cl� d'acc�s ou compl�tement coll� l'URL ?"

msgid "I sent email to you at "%0". It should arrive soon, containing a URL."
msgstr "Un m�l vous est envoy� � <i>%0</i>. Le m�l devrait �tre arriv� dans votre bo�te aux lettre."

msgid "Either open the URL directly, or paste the secret into the form below and click Validate."
msgstr "Il contient un URL et une cl� d'acc�s. Soit vous activez l'URL, soit vous utilisez la cl� d'acc�s dans le formulaire ci-dessous et cliquez sur valider."

msgid "Thank you for taking the time to sign up."
msgstr "Merci beaucoup de prendre du temps pour s'inscrire."

msgid "Secret:"
msgstr "Cl� d'acc�s : "

msgid "Validate"
msgstr "Valider"

###
### editBag.pm
###

msgid "Replace bag"
msgstr "Remplacer le fichier objet"

msgid "Replace which bag?"
msgstr "Remplacer quel fichier objet?"

###
### OMatic.pm
###

msgid "Warnings:"
msgstr "Alertes:"

###
### install.pm
###

msgid "Untitled Faq-O-Matic"
msgstr "Faq-O-Matic sans nom"

msgid "Faq-O-Matic Installer"
msgstr "Installation de Faq-O-Matic"

msgid "%0 failed: "
msgstr "%0 est �chou�: "

msgid "Unknown step: "%0"."
msgstr "Pas inconnu: "%0"."

msgid "Updating config to reflect new meta location <b>%0</b>."
msgstr "La configuration sera actualis� pour une nouvelle meta localisation <b>%0</b>."

msgid "(Can't find <b>config</b> in '%0' -- assuming this is a new installation.)"
msgstr "(Ne trouve pas la <b>config</b> dans '%0' -- il s'agit vraissemblablement d'une nouvelle installation)."

msgid "Click here</a> to create %0."
msgstr "Cliquez ici</a> pour cr�er %0."

msgid "If you want to change the CGI stub to point to another directory, edit the script and then"
msgstr "Si vous souhaitez transformer le CGI d'une section pour qu'il pointe vers un autre r�pertoire, �ditez le script et ensuite"

msgid "click here to use the new location"
msgstr "Cliquez ici, pour utiliser la nouvelle localisation"

msgid "FAQ-O-Matic stores files in two main directories.<p>The <b>meta/</b> directory path is encoded in your CGI stub ($0). It contains:"
msgstr "FAQ-O-Matic enregistre les fichiers dans deux r�pertoires principaux.<p>Le r�pertoire <b>meta/</b> est enregistr� dans votre CGI ($0). Il contient : "

msgid "<ul><li>the <b>config</b> file that tells FAQ-O-Matic where everything else lives. That's why the CGI stub needs to know where meta/ is, so it can figure out the rest of its configuration. <li>the <b>idfile</b> file that lists user identities. Therefore, meta/ should not be accessible via the web server. <li>the <b>RCS/</b> subdirectory that tracks revisions to FAQ items. <li>various hint files that are used as FAQ-O-Matic runs. These can be regenerated automatically.</ul>"
msgstr "<ul><li>Le fichier <b>config</b>, d�crit o� tous les �l�ments de la FAQ-O-Matic sont. C'est pourquoi le CGI a besoin de conna�tre o� le r�pertoire meta/ doit �tre trouv�. <li>Le fichier <b>idfile</b> contient la liste des identit�s des utilisateurs. Cependant, meta/ ne doit pas �tre accessible au travers du serveur Web. <li>Le sous-r�pertoire <b>RCS/</b>, suit les mises � jours de la FAQ. <li>diff�rents fichiers cach�s sont utilis�s lorsque la FAQ-O-Matic tourne. Ils peuvent �tre recr��s automatiquement.</ul>"

msgid "<p>The <b>serve/</b> directory contains three subdirectories <b>item/</b>, <b>cache/</b>, and <b>bags/</b>. These directories are created and populated by the FAQ-O-Matic CGI, but should be directly accessible via the web server (without invoking the CGI)."
msgstr "<p>Le r�pertoire <b>serve/</b> contient trois sous r�pertoires : <b>item/</b>, <b>cache/</b> et <b>bags/</b>. Ces r�pertoires sont cr�es et contiennent les CGI de la FAQ-O-Matic, mais ils doivent �tre accessible du serveur web (sans appeller de CGI)."

msgid "<ul><li>serve/item/ contains only FAQ-O-Matic formatted source files, which encode both user-entered text and the hierarchical structure of the answers and categories in the FAQ. These files are only accessed through the web server (rather than the CGI) when another FAQ-O-Matic is mirroring this one. <li>serve/cache/ contains a cache of automatically-generated HTML versions of FAQ answers and categories. When possible, the CGI directs users to the cache to reduce load on the server. (CGI hits are far more expensive than regular file loads.) <li>serve/bags/ contains image files and other ``bags of bits.'' Bit-bags can be linked to or inlined into FAQ items (in the case of images). </ul>"
msgstr "<ul><li>serve/item/ contient les fichiers sources format�s de la FAQ-O-Matic, qui codent � la fois les entr�es des utilisateurs et les structures hi�rarchiques des r�ponses et des cat�gories dans la FAQ. Ces fichiers ne sont acc�d�s qu'au travers du serveur web (plut�t que par CGI) lorsqu'une autre FAQ-O-Matic joue le r�le de miroir. <li>serve/cache/ contient un cache des r�ponses et cat�gories de la FAQ, automatiquement g�n�r� en HTML afin de r�duire la charge sur le serveur. (Les requ�tes sur CGI sont beaucoup plus ch�res en ressources que le d�chargement de fichiers) <li>serve/bags/ contient les images de fichiers et autres fichiers-objets. Les fichiers-objets peuvent �tre li�s � ou ins�r�s dans les �l�ments de la FAQ (dans le cas des images).</ul>"

msgid "I don't have write permission to <b>%0</b>."
msgstr "Je n'ai pas la permission d'�criture pour <b>%0</b>."

msgid "I couldn't create <b>%0</b>: %1"
msgstr "Erreur � la cr�ation de <b>%0</b>: %1"

msgid "<b>%0</b> already contains a file '%1'."
msgstr "%0 d�j� contient un fichier <b>%1</b>"

msgid "Created <b>%0</b>."
msgstr "Cr�e <b>%0</b>."

msgid "Created new config file."
msgstr "Cr�ation d'un nouveau fichier de configuration."

msgid "The idfile exists."
msgstr "Le fichier idfile existe."

msgid "Configuration Main Menu (install module)"
msgstr "Menu de configuration principal (installation du module)"

msgid "Go To Install/Configuration Page"
msgstr "Retour au menu de configuration pincipal"

msgid "Perform these tasks in order to prepare your FAQ-O-Matic version %0:"
msgstr "R�alisez ces t�ches afin de pr�parer votre FAQ-O-Matic version %0:"

msgid "Define configuration parameters"
msgstr "D�finissez les param�tres de configuration"

msgid "Set your password and turn on installer security"
msgstr "Mettez en place votre mot de passe et mettez en route la s�curit� de l'installation"

msgid "(Need to configure $mailCommand and $adminAuth)"
msgstr "($mailCommand et $adminAuth doivent �tre configur�)"

msgid "(Installer security is on)"
msgstr "(La s�curit� de l'installation est activ�e)"

msgid "Create item, cache, and bags directories in serve dir"
msgstr "Cr�ez des �l�ments, des caches et des r�pertoires de fichiers objets"

msgid "Copy old items</a> from <tt>%0</tt> to <tt>%1</tt>."
msgstr "Copiez les anciens �l�ments</a> de <tt>%0</tt> vers <tt>%1</tt>."

msgid "Install any new items that come with the system"
msgstr "Installez les nouveaux �l�ments du syst�me"

msgid "Create system default items"
msgstr "Cr�ez les �l�ments par d�faut du syst�me"

msgid "Created category "%0"."
msgstr "Cr�e categorie <b>%0</b>."

msgid "Rebuild the cache and dependency files"
msgstr "Reconstruisez le cache et les fichiers de d�pendance"

msgid "Install system images and icons"
msgstr "Installez les images et les ic�nes du syst�me"

msgid "Update mirror from master now. (this can be slow!)"
msgstr "Mettre � jour les fichiers du miroir (cela peut durer longtemps !)"

msgid "Set up the maintenance cron job"
msgstr "Mettez en route le service de maintenance."

msgid "Run maintenance script manually now"
msgstr "Mettez en route la maintenance manuellement"

msgid "(Need to set up the maintenance cron job first)"
msgstr "(Besoin de mettre en route tout d'abord le service de maintenance)"

msgid "Maintenance last run at:"
msgstr "Derni�re mise en route du service de maintenance:"

msgid "Mark the config file as upgraded to Version %0"
msgstr "Marquez le fichier de configuration � la nouvelle mise � jour de la version %0"

msgid "Select custom colors for your Faq-O-Matic</a> (optional)"
msgstr "Personnalisez les couleurs de votre Faq-O-Matic</a> (optionnel)"

msgid "Define groups</a> (optional)"
msgstr "D�finissez des groupes</a> (optionnel)"

msgid "Upgrade to CGI.pm version 2.49 or newer."
msgstr "Mettre � jour � CGI.pm version 2.49 ou plus nouvelle."

msgid "(optional; older versions have bugs that affect bags)"
msgstr "(optionnel; les anciennes versions ont des bogues qui affectent les fichiers objets)"

msgid "You are using version %0 now."
msgstr "Actuellement vous utilisez la version %0."

msgid "Bookmark this link to be able to return to this menu."
msgstr "Cr�ez un signet pour pouvoir retrouver ce menu."

msgid "Go to the Faq-O-Matic"
msgstr "Allez � la Faq-O-Matic"

msgid "(need to turn on installer security)"
msgstr "(il faut r�activer l'installation de s�curit�)"

msgid "Other available tasks:"
msgstr "Autres t�ches disponibles:"

msgid "See access statistics"
msgstr "Visualiser les statistiques d'acc�s"

msgid "Examine all bags"
msgstr "Examiner tous les fichiers objets"

msgid "Check for unreferenced bags (not linked by any FAQ item)"
msgstr "V�rification des fichiers objets non r�f�renc�s (qui ne sont li�s � aucun �l�ment de FAQ)"

msgid "Rebuild the cache and dependency files"
msgstr "Reconstruire le cache et les fichiers de d�pendance"

msgid "The Faq-O-Matic modules are version %0."
msgstr "Les modules Faq-O-Matic sont de version %0."

msgid "I wasn't able to change the permissions on <b>%0</b> to 755 (readable/searchable by all)."
msgstr "Je ne peux pas modifier les permissions de <b>%0</b> vers 755 (� lire/� rechercher par tous)."

msgid "Rewrote configuration file."
msgstr "Le fichier de configuration a �t� re-�crit."

msgid "%0 (%1) has an internal apostrophe, which will certainly make Perl choke on the config file."
msgstr "%0 (%1) contient un apostrophe �'int�rieur, qui fail Perl �chouer en lisant le fichier de configuration."

msgid "%0 (%1) doesn't look like a fully-qualified email address."
msgstr "%0 (%1) n'a pas l'air d'une adresse m�l."

msgid "%0 (%1) isn't executable."
msgstr "%0 (%1) n'est pas ex�cutable."

msgid "%0 has funny characters."
msgstr "%0 contient des charact�res dr�les."

msgid "You should <a href="%0">go back</a> and fix these configurations."
msgstr "<a href="%0">Retournez</a> et correctez ces configurations."

msgid "updated config file:"
msgstr "Mise � jour le ficier de configuration:"

msgid "Redefine configuration parameters to ensure that <b>%0</b> is valid."
msgstr "Red�finir les param�tres de configuration pour assurer que <b>%0</b> est valide."

msgid "Jon made a mistake here; key=%0, property=%1."
msgstr "Jon a fait une erreur ici; key=%0, property=%1."

msgid "<b>Mandatory:</b> System information"
msgstr "<b>Obligatoire: </b> Informations du syst�me"

msgid "Identity of local FAQ-O-Matic administrator (an email address)"
msgstr "Identit� de l'administrateur de la FAQ-O-Matic (adresse m�l)"

msgid "A command FAQ-O-Matic can use to send mail. It must either be sendmail, or it must understand the -s (Subject) switch."
msgstr "Une commande que FAQ-O-Matic peut utiliser pour envoyer du m�l. Il doit �tre sendmail ou soutenir l'option -s (Sujet)."

msgid "The command FAQ-O-Matic can use to install a cron job."
msgstr "La commande que FAQ-O-Matic peut iutiliser pour installer un cron job."

msgid "Path to the <b>ci</b> command from the RCS package."
msgstr "La commande <b>ci</b> du paquet RCS."

msgid "<b>Mandatory:</b> Server directory configuration"
msgstr "<b>Obligatoire:</b> Configuration du r�pertoire du serveur"

msgid "Protocol, host, and port parts of the URL to your site. This will be used to construct link URLs. Omit the trailing '/'; for example: <tt>http://www.dartmouth.edu</tt>"
msgstr "Protocol, ordinateur et port de l'URL de votre site. Cela est utilits� pour construire des liens URL. Ommettez le '/' a la fin. Exemple: <tt>http://www.dartmouth.edu</tt>"

msgid "The path part of the URL used to access this CGI script, beginning with '/' and omitting any parameters after the '?'. For example: <tt>/cgi-bin/cgiwrap/jonh/faq.pl</tt>"
msgstr "Le part des r�pertoires de l'URL pour atteindre � votre script CGI, commen�ant avec '/', mais sans '?' et des arguments derri�res. Exemple: <tt>/cgi-bin/cgiwrap/jonh/faq.pl</tt>"

msgid "Filesystem directory where FAQ-O-Matic will keep item files, image and other bit-bag files, and a cache of generated HTML files. This directory must be accessible directly via the http server. It might be something like /home/faqomatic/public_html/fom-serve/"
msgstr "R�pertoire du fichier syst�me dans lequel FAQ-O-Matic garde les �l�ments, images et fichiers objets, ainsi que le cache des fichiers HTML g�n�r�s. Ce r�pertoire doit �tre accessible par le serveur http. Cela peut �tre quelque chose comme : /home/faqomatic/public_html/fom-serve/"

msgid "The path prefix of the URL needed to access files in <b>$serveDir</b>. It should be relative to the root of the server (omit http://hostname:port, but include a leading '/'). It should also end with a '/'."
msgstr "Le pr�fixe de l'URL necessaire pour acc�der des fichiers dans <b>$serveDir</b>. Il doit �tre relatif a la racine principale du serveur (sans http://hostname:port, mais avec '/' au d�but et a la fin)."

msgid "Use the <u>%0</u> links to change the color of a feature."
msgstr "Utilisez les liens <u>%0</u> pour modifier la couleur d'un objet."

msgid "An Item Title"
msgstr "Un titre d'�l�ment"

msgid "A regular part is how most of your content will appear. The text colors should be most pleasantly readable on this background."
msgstr "Cette partie pr�sente comment le contenu appara�tra. Les couleurs du texte doivent �tre agr�ables � lire sur ce fond."

msgid "A new link"
msgstr "Un nouveau lien"

msgid "A visited link"
msgstr "Un lien visit�"

msgid "A search hit"
msgstr "Un r�sultat de recherche"

msgid "A directory part should stand out"
msgstr "Une section de r�pertoire doit appara�tre"

msgid "Regular text"
msgstr "Texte normal"

msgid "Proceed to step '%0'"
msgstr "Continuer en faisant: %0"

msgid "Select a color for %0:"
msgstr "S�lectionnez la couleur pour %0:"

msgid "Or enter an HTML color specification manually:"
msgstr "Ou entrez une couleur en code HTML:"

msgid "Select"
msgstr "OK"

msgid "<i>Optional:</i> Miscellaneous configurations"
msgstr "<i>Optionnel:</i> Configurations diverses"

msgid "Select the display language."
msgstr "Selectionnez la langue utilis�e."

msgid "Show dates in 24-hour time or am/pm format."
msgstr "Montrer les dates dans le format 24 heures ou dans le format am/pm."

msgid "If this parameter is set, this FAQ will become a mirror of the one at the given URL. The URL should be the base name of the CGI script of the master FAQ-O-Matic."
msgstr "Si ce param�tre est mis, cette FAQ deviendra un miroir d'une � l'URL donn�. Cet URL doit pointer vers le script CGI de la FAQ-O-Matic."

msgid "An HTML fragment inserted at the top of each page. You might use this to place a corporate logo."
msgstr "Un fragment d'HTML ins�r� en haut de chaque page. Profitez en pour utiliser cet emplacement pour afficher votre logo."

msgid "If this field begins with <tt>file=</tt>, the text will come from the named file in the meta directory; otherwise, this field is included verbatim."
msgstr "Si ce param�tre commence avec <tt>file=</tt>, le texte est lit du fichier nomm� dans le rep�rtoire meta; en d'autres temps, le texte es pris verbatim."

msgid "The <tt>width=</tt> tag in a table. If your <b>$pageHeader</b> has <tt>align=left</tt>, you will want to make this empty."
msgstr "Le <tt>width=</tt> tag dans un tableau. Si votre <b>$pageHeader</b> contient <tt>align=left</tt>, ce champs doit �tre vide."

msgid "An HTML fragment appended to the bottom of each page. You might use this to identify the webmaster for this site."
msgstr "Un fragment d'HTML ins�r� en bas de chaque page. Vous pouvez utilisez celui-ci pour pr�senter le webmestre du site."

msgid "Where FAQ-O-Matic should send email when it wants to alert the administrator (usually same as $adminAuth)"
msgstr "O� FAQ-O-Matic doit envoyer un m�l lorque l'on souhaite contacter l'administrateur (habituellement le m�eme q'$adminAuth)"

msgid "If true, FAQ-O-Matic will mail the log file to the administrator whenever it is truncated."
msgstr "Si mis, FAQ-O-Matic envoie le fichier log par m�l � l'administrateur."

msgid "User to use for RCS ci command (default is process UID)"
msgstr "Utilisateur qui ex�cute la commande ci (par d�faut l'UID du process)"

msgid "Links from cache to CGI are relative to the server root, rather than absolute URLs including hostname:"
msgstr "Des liens du cache vers le CGI sont relatif � la racine principale du serveur, au lieu d'�tre des URLs absolues utilisant le nom de la machine (hostname):"

msgid "mailto: links can be rewritten such as jonhATdartmouthDOTedu (cheesy), jonh (nameonly), or e-mail addresses suppressed entirely (hide)."
msgstr "Des liens <i>mailto:</i> peuvent �tre r��cris comme par exemple jonhATdartmouthDOTedu (cheesy), jonh (nameonly), ou des adresses de m�l supprim�es completement (hide)."

msgid "Number of seconds that authentication cookies remain valid. These cookies are stored in URLs, and so can be retrieved from a browser history file. Hence they should usually time-out fairly quickly."
msgstr "Nombre de secondes pour laquelle l'authentification par cookie reste valide. Les cookies sont stock�s en fonction des URLs, et ainsi ils peuvent �tre d�charg�s par le biais du fichier historique du navigateur. Ils doivent donc �tre rapidement d�sactiv�s (leur time-out doit �tre court)."

msgid "<i>Optional:</i> These options set the default [Appearance] modes."
msgstr "<i>Optionnel:</i> Ces options d�finissent le mode [Apparence] par d�faut."

msgid "Page rendering scheme. Do not choose 'text' as the default."
msgstr "Sch�ma de la repr�sentation d'une page. Svp ne choisissez pas 'text' comme pour le mod�le par d�faut."

msgid "expert editing commands"
msgstr"Commandes d'�dition expert"

msgid "name of moderator who organizes current category"
msgstr "Nom du mod�rateur qui organise la cat�gorie courante"

msgid "last modified date"
msgstr "Derni�re date de modification"

msgid "attributions"
msgstr "Montrer les auteurs"

msgid "commands for generating text output"
msgstr "commandes pour cr�er le texte en sortie"

msgid "<i>Optional:</i> These options fine-tune the appearance of editing features."
msgstr "<i>Optionnel:</i> Ces options d�finissent l'apparence des outils d'�dition."

msgid "The old [Show Edit Commands] button appears in the navigation bar."
msgstr "L'ancien bouton [Montrer les commandes d'�dition] appara�tra dans la barre de navigation."
 
msgid "Navigation links appear at top of page as well as at the bottom."
msgstr "Les liens de navigation appara�tront en haut et en bas de la page."

msgid "Hide [Append to This Answer] and [New Answer in ...] buttons."
msgstr "Cacher les boutons [Contribuer � cette Entr�e] et [Nouvelle Entr�e dans ...]."

msgid "icons-and-label"
msgstr "Ic�nes et titres"

msgid "Editing commands appear with neat-o icons rather than [In Brackets]."
msgstr "Les commandes d'�dition appara�trons comme des ic�nes et non dans des [crochets]."
 
msgid "<i>Optional:</i> Other configurations that you should probably ignore if present."
msgstr "<i>Optionnel:</i> D'autres options de configuration que vous devriez ignorer � pr�sent."

msgid "Draw Item titles John Nolan's way."
msgstr "Dessiner les titres au style de John Nolan."

msgid "Hide sibling (Previous, Next) links"
msgstr "Cacher les liens de navigation (Pr�c�dent, Suivant)"

msgid "Arguments to make ci quietly log changes (default is probably fine)"
msgstr "Arguments pour r�liser avec ci les modifications de log (le choix par d�faut est le mieux)"

msgid "off"
msgstr "d�sactivi�"

msgid "true"
msgstr "activ�"

msgid "cheesy"
msgstr "chessy"

msgid "This is a command, so only letters, hyphens, and slashes are allowed."
msgstr "Il s'agit d'une commande, ainsi seul les lettres, moins (-) et slash (/) sont autoris�."

msgid "If this is your first time installing a FAQ-O-Matic, I recommend only filling in the sections marked <b>Mandatory</b>."
msgstr "Si il s'agit de votre premi�re installation de la FAQ-O-Matic, je vous recommande de ne remplir que les sections marqu�es <b>important</b>."

msgid "Define"
msgstr "D�finir"

msgid "(no description)"
msgstr "(aucune description)"

msgid "Unrecognized config parameter"
msgstr "Param�tre de configuration inconnu"

msgid "Please report this problem to"
msgstr "S'il vous pla�t faites un rapport de votre probl�me �"

msgid "Attempting to install cron job:"
msgstr "Essayant d' installer le cron job:"

msgid "Cron job installed. The maintenance script should run hourly."
msgstr "Le cron job est install�. La maintenance s'effectue automatiquement toutes les heures."

msgid "I thought I installed a new cron job, but it didn't appear to take."
msgstr "Le nouveau cron job sera install�, mais ne sera pas appara�t prendre."

msgid "You better add %0 to some crontab yourself with <b><tt>crontab -e</tt></b>."
msgstr "Vous devriez ajouter %0 pour une crontab avec <b><tt>crontab -e</tt></b>."

msgid "I replaced this old crontab line, which appears to be an older one for this same FAQ:"
msgstr "J'ai remplac� cette ancienne ligne de crontab, qui apparait comme une ancienne ligne pour cette m�me FAQ : "


###
### submitBag.pm
###

msgid "Bag names may only contain letters, numbers, underscores (_), hyphens (-), and periods (.), and may not end in '.desc'. Yours was"
msgstr "Un fichier objet ne doit contenir que des lettres, des nombres, des underscores (_), des moins (-), et des points (.), et ne doit pas se terminer par '.desc'. Le votre �tait"


###
### editBag.pm
###

msgid "Upload new bag to show in the %0 part in <b>%1</b>."
msgstr "Charger un nouveau fichier objet dans la %0 partie dans <b>%1</b>"

msgid "Bag name:"
msgstr "Nom de l'objet"

msgid "The bag name is used as a filename, so it is restricted to only contain letters, numbers, underscores (_), hyphens (-), and periods (.). It should also carry a meaningful extension (such as .gif) so that web browsers will know what to do with the data."
msgstr "Le nom de l'objet est utilis� comme un nom de fichier, ainsi il ne doit contenir que des lettres, des nombres, des underscores (_), des moins (-), et des points (.). Il faut aussi utiliser avec attention les extensions (comme .gif) pour que les navigateurs web puissent savoir que faire des donn�es."

msgid "Bag data:"
msgstr "Objet donn� : "

msgid "If this bag is an image, fill in its dimensions."
msgstr "Si un objet est une image, remplissez ses dimensions."

msgid "Width:"
msgstr "Largeur:"

msgid "Height:"
msgstr "Hauteur:"

msgid "(Leave blank to keep original bag data and change only the associated information below.)"
msgstr "(Laissez en blanc pour garder le fichier objet original et ne modifi� que l'information ci-dessous)."


###
### appearanceForm.pm
###

msgid "Appearance Options"
msgstr "Options d'apparence"

msgid "Show"
msgstr "Montrer"

msgid "Compact"
msgstr "Compact"

msgid "Hide"
msgstr "Cacher"

msgid "all categories and answers below current category"
msgstr "toutes les cat�gories et r�ponses de la cat�gorie courante"

msgid "Default"
msgstr "Standard"

msgid "Simple"
msgstr "Simple"

msgid "Fancy"
msgstr "D�cor�"

msgid "Accept"
msgstr "Modifier l'apparence"


###
### addItem.pm
###

msgid "Subcategories:"
msgstr "Sous-cat�gories :"

msgid "Answers in this category:"
msgstr "R�ponses dans cette cat�gorie : "

msgid "Copy of"
msgstr "Copie de"


###
### changePass.pm
###

msgid "Please enter your username, and select a password."
msgstr "Entrez votre nom d'utilisateur, et un mot de passe."

msgid "I will send a secret number to the email address you enter to verify that it is valid."
msgstr "Je vous envoi un nombre secret � l'adresse m�l que vous avez entr�e pour v�rifier la validit� de votre adresse."

msgid "If you prefer not to give your email address to this web form, please contact"
msgstr "Si vous ne souhaitez pas donner votre adresse m�l dans ce formulaire web, alors contactez"

msgid "Please <b>do not</b> use a password you use anywhere else, as it will not be transferred or stored securely!"
msgstr "Svp <b>n'utilisez pas</b> un mot de passe que vous utilisez pour autre chose, car le transfert et le stockage ne sont pas s�curis� !"

msgid "Password:"
msgstr "Mot de passe :"

msgid "Set Password"
msgstr "Entrez un mot de passe"


###
### Auth.pm
###

msgid "the administrator of this Faq-O-Matic"
msgstr "l'administrateur de FAQ-O-Matic"

msgid "someone who has proven their identification"
msgstr "quelqu'un qui a valid� son identification"

msgid "someone who has offered identification"
msgstr "quelqu'un qui a �t� identifi�"

msgid "anybody"
msgstr "n'importe qui"

msgid "the moderator of the item"
msgstr "mod�rateur de cette section"

msgid "%0 group members"
msgstr "membres du groupe %0"

msgid "I don't know who"
msgstr "Je ne sais qui"

msgid "Email:"
msgstr "Adresse m�l:"

###
### Authenticate.pm
###

msgid "That password is invalid. If you've forgotten your old password, you can"
msgstr "Ce mot de passe est faux. Si vous avez oubli� votre ancien mot de passe, vous pouvez"

msgid "Set a New Password"
msgstr "Configurer un nouveau mot de passe"

msgid "Create a New Login"
msgstr "Cr�er un nouveau login"

msgid "New items can only be added by %0."
msgstr "Les nouvelles sections ne peuvent �tre ajout�es que par %0."

msgid "New text parts can only be added by %0."
msgstr "Les nouveaux articles ne peuvent �tre ajout�s que par %0."

msgid "Text parts can only be removed by %0."
msgstr "Les articles ne peuvent �tre effac�s que par %0."

msgid "This part contains raw HTML. To avoid pages with invalid HTML, the moderator has specified that only %0 can edit HTML parts. If you are %0 you may authenticate yourself with this form."
msgstr "Cette section contient du HTML pur. Afin d'�viter les pages avec du code HTML invalide, le mod�rateur a sp�cifi� que personne que %0 peut �diter des sections en HTML. Si vous �tes %0, vous devez vous authentifier avec ce formulaire."

msgid "Text parts can only be added by %0."
msgstr "Les articles ne peuvent �tre ajout�es que par %0."

msgid "Text parts can only be edited by %0."
msgstr "Les articles ne peuvent �tre �dit�s que par %0."

msgid "The title and options for this item can only be edited by %0."
msgstr "Le titre et les options de cette section ne peuvent �tre �dit�s que par %0."

msgid "The moderator options can only be edited by %0."
msgstr "Les options de mod�ration ne peuvent �tre �dit� que par %0."

msgid "This item can only be moved by someone who can edit both the source and destination parent items."
msgstr "Cette section ne peut �tre d�plac�e que par quelqu'un qui peut � la fois �diter la source et la destination parente de la section."

msgid "This item can only be moved by %0."
msgstr "Cet �l�ment ne peut �tre d�plac� que par %0."

msgid "Existing bags can only be replaced by %0."
msgstr "Personne que %0 peut remplacer les fichiers objets existants."

msgid "Bags can only be posted by %0."
msgstr "Personne que %0 peut ajouter des fichiers objet."

msgid "The FAQ-O-Matic can only be configured by %0."
msgstr "La FAQ-O-Matic ne peut �tre configur�e que par %0."

msgid "The operation you attempted (%0) can only be done by %1."
msgstr "L'op�ration que vous avez tent� (%0) ne peut �tre r�alis� que par %1."

msgid "If you have never established a password to use with FAQ-O-Matic, you can"
msgstr "Si vous n'avez jamais configur� de mot de passe dans cette FAQ-O-Matic, vous pouvez"

msgid "If you have forgotten your password, you can"
msgstr "Si vous avez oubli� votre mot de passe, vous pouvez"

msgid "If you have already logged in earlier today, it may be that the token I use to identify you has expired. Please log in again."
msgstr "Si vous vous �tes d�j� logu�, il se peut que l'authentification  est expir�e. Reloguez vous � nouveau."

msgid "Please offer one of the following forms of identification:"
msgstr "Svp remplissez une de ces formes d'authentification : "

msgid "No authentication, but my email address is:"
msgstr "Pas d'authentification, mais mon adresse m�l est : "

msgid "Authenticated login:"
msgstr "Login d'authentification : "


###
### moveItem.pm
###

msgid "Make <b>%0</b> belong to which other item?"
msgstr "Faire <b>%0</b> appartient � quel autre entr� ?"

msgid "No item that already has sub-items can become the parent of"
msgstr "Aucune entr� qui poss�de d�j� des sous-entr� ne peut devenir parent de"

msgid "No item can become the parent of"
msgstr "L'entr�e ne peut pas devenir le parent de"

msgid "Some destinations are not available (not clickable) because you do not have permission to edit them as currently autorized."
msgstr "Certaines destinations ne sont pas accessibles car vous n'avez pas la permission d'�diter celle-ci."

msgid "Click here</a> to provide better authentication."
msgstr "Cliquez ici</a> pour permettre une meilleure authentification."

msgid "Hide answers, show only categories"
msgstr "Cacher les r�ponses, ne montrer que les cat�gories"

msgid "Show both categories and answers"
msgstr "Montrer � la fois les cat�gories et les r�ponses"


###
### editPart.pm
###

msgid "Enter the answer to <b>%0</b>"
msgstr "R�pondre � <b>%0</b>"

msgid "Enter a description for <b>%0</b>"
msgstr "D�crire <b>%0</b>"

msgid "Edit duplicated text for <b>%0</b>"
msgstr "Dupliquer un texte de <b>%0</b>"

msgid "Enter new text for <b>%0</b>"
msgstr "�diter un nouveau texte dans <b>%0</b>"

msgid "Editing the %0 text part in <b>%1</b>."
msgstr "�diter la partie de texte n�%0 dans <b>%1</b>."

msgid "If you later need to edit or delete this text, use the [Appearance] page to turn on the expert editing commands."
msgstr "Si vous voulez �diter ou effacer ce texte plus tard, utilisez la page [Apparence] pour les commandes d'�dition expert."


###
### Part.pm
###

msgid "Upload file:"
msgstr "Charger le fichier:"

msgid "Warning: file contents will <b>replace</b> previous text"
msgstr "Attention: Le contenu du fichier va <b>remplacer</b> le texte pr�c�dent"

msgid "Replace %0 with new upload"
msgstr "Remplacer %0 avec un nouveau chargement de fichier"

msgid "Select bag to replace with new upload"
msgstr "S�lectionner le nouveau fichier objet"

msgid "Hide Attributions"
msgstr "Ne pas montrer le nom des auteurs"

msgid "Format text as:"
msgstr "Formater le texte comme : "

msgid "Directory"
msgstr "un r�pertoire"

msgid "Natural text"
msgstr "un texte normal"

msgid "Monospaced text (code, tables)"
msgstr "un texte monospace (code, tableau)"

msgid "Untranslated HTML"
msgstr "du code HTML"

msgid "Submit Changes"
msgstr "Soumettre les modifications"

msgid "Revert"
msgstr "Annuler"

msgid "Insert Uploaded Text Here"
msgstr "Ins�rer un texte � charger"

msgid "Insert Text Here"
msgstr "Ins�rer un texte"

msgid "Edit This Text"
msgstr "�diter ce texte"

msgid "Duplicate This Text"
msgstr "Dupliquer ce texte"

msgid "Remove This Text"
msgstr "Effacer ce texte"

msgid "Upload New Bag Here"
msgstr "Charger un nouveau fichier objet"


###
### searchForm.pm
###

msgid "Search for"
msgstr "Rechercher"

msgid "matching"
msgstr "contenant"

msgid "all"
msgstr "tout les"

msgid "any"
msgstr "un des"

msgid "two"
msgstr "deux"

msgid "three"
msgstr "trois"

msgid "four"
msgstr "quatre"

msgid "five"
msgstr "cinq"

msgid "words"
msgstr "mots"

msgid "Show documents"
msgstr "Montrer les documents"

msgid "modified in the last"
msgstr "qui ont �t� modifi�s"

msgid "day"
msgstr "il y a un jour"

msgid "two days"
msgstr "il y a deux jours"

msgid "three days"
msgstr "il y a trois jours"

msgid "week"
msgstr "cette semaine"

msgid "fortnight"
msgstr "il y a deux semaines"

msgid "month"
msgstr "depuis un mois"


###
### search.pm
###

msgid "No items matched"
msgstr "Aucun �l�m�nt trouv�"

msgid "of these words"
msgstr "contenant ces mots"

msgid "Search results for"
msgstr "R�sultat de la recherche de"

msgid "at least"
msgstr "� la fin"

msgid "Results may be incomplete, because the search index has not been refreshed since the most recent change to the database."
msgstr "Les r�sultats peuvent �tre incomplets, car l'index de recherche n'a peut �tre pas �t� remis � jour depuis les modifications r�centes de la base de donn�es."


###
### Item.pm
###

msgid "defined in"
msgstr "d�finit dans"

msgid "Name & Description"
msgstr "Nom et description"

msgid "Setting"
msgstr "Configuration"

msgid "Setting if Inherited"
msgstr "Configuration h�rit�"

msgid "Group %0"
msgstr "Groupe %0"

msgid "Moderator"
msgstr "Mod�rateur"

msgid "nobody"
msgstr "personne"

msgid "(system default)"
msgstr "(syst�me par d�faut)"

msgid "(inherited from parent)"
msgstr "(herit� du parent)"

msgid "(will inherit if empty)"
msgstr "(h�ritera si c'est vide)"

msgid "Send mail to the moderator when someone other than the moderator edits this item:"
msgstr "Envoyer un m�l au mod�rateur, si quelqu'un d'autre que le mod�rateur �dite la section : "

msgid "Permissions"
msgstr "Permissions"

msgid "Blah blah"
msgstr "Blah blah"

msgid "Yes"
msgstr "Oui"

msgid "No"
msgstr "Non"

msgid "Relax"
msgstr "Relax"

msgid "Don't Relax"
msgstr "Don't Relax"

msgid "undefined"
msgstr "pas defin�"

msgid "<p>New Order for Text Parts:"
msgstr "<p>Nouvel ordre des articles:"

msgid "Who can access the installation/configuration page (use caution!):"
msgstr "Qui peut avoir acc�s � la page de configuration (attention!):"

msgid "Who can add a new text part to this item:"
msgstr "Qui peut ajouter un nouvel article dans cette section:"

msgid "Who can add a new answer or category to this category:"
msgstr "Qui peut ajouter une nouvelle r�ponse ou cat�gorie dans cette cat�gorie:"

msgid "Who can edit or remove existing text parts from this item:"
msgstr "Qui peut �diter ou effacer un article existant dans cette section:"

msgid "Who can move answers or subcategories from this category; or turn this category into an answer or vice versa:"
msgstr "Qui peut d�placer les r�ponses ou les sous-cat�gories de cette cat�gorie;  ou transformer cette cat�gorie en r�ponse ou cette r�ponse en cat�gorie:"

msgid "Who can edit the title and options of this answer or category:"
msgstr "Qui peut �diter le titre et les options de cette r�ponse ou cat�gorie:"

msgid "Who can use untranslated HTML when editing the text of this answer or category:"
msgstr "Qui peut utiliser l'HTML pour �diter un texte de la r�ponse ou la cat�gorie:"

msgid "Who can change these moderator options and permissions:"
msgstr "Qui peut modifier les options et permissions du mod�rateurs:"

msgid "Who can use the group membership pages:"
msgstr "Qui peut utiliser les pages d'appartenance des groupes:"

msgid "Who can create new bags:"
msgstr "Qui peut cr�er de nouveaux fichiers objets:"

msgid "Who can replace existing bags:"
msgstr "Qui peut remplacer des fichiers objets existant:"

msgid "Group"
msgstr "Groupe"

msgid "Authenticated users"
msgstr "utilisateurs authentifi�s"

msgid "Users giving their names"
msgstr "Utilisateurs ayant donn� leurs noms"

msgid "Inherit"
msgstr "H�rit�"

msgid "File %0 seems broken."
msgstr "Le fichier %0 a l'air d'�tre d�fecteux."

msgid "Permissions:"
msgstr "Permissions:"

msgid "Moderator options for"
msgstr "Les options du mod�rateur sont"

msgid "Title:"
msgstr "Titre:"

msgid "Category"
msgstr "Cat�gorie"

msgid "Answer"
msgstr "l'Entr�e"

msgid "Show attributions from all parts together at bottom"
msgstr "Montrer en bas de la page, tous les auteurs de la cat�gorie."
 
msgid "New Item"
msgstr "Nouvelle Entr�e"

msgid "Convert to Answer"
msgstr "Transformer en Entr�e"

msgid "Convert to Category"
msgstr "Transformer en Cat�gorie"

msgid "New Subcategory of "%0""
msgstr "Nouvelle Sous-Cat�gorie de <i>%0</i>"

msgid "Move %0"
msgstr "D�placer %0"

msgid "Trash %0"
msgstr "Supprimer %0"

msgid "Parts"
msgstr "Des Entr�es"

msgid "New Category"
msgstr "Nouvelle Cat�gorie"

msgid "New Answer"
msgstr "Nouvelle Entr�e"

msgid "Editing %0 <b>%1</b>"
msgstr "�diter %0 <b>%1</b>"

msgid "New Answer in "%0""
msgstr "Nouvelle Entr�e dans <i>%0</i>"

msgid "Duplicate Category as Answer"
msgstr "Dupliquer la Cat�gorie"

msgid "Duplicate Answer"
msgstr "Dupliquer l'Entr�e"

msgid "%0 Title and Options"
msgstr "%0: Options (Titre, ordre des articles...)"

msgid "Edit %0 Permissions"
msgstr "�diter des permissions pour %0"

msgid "Append to This Answer"
msgstr "Contribuer � cette Entr�e"

msgid "This document is:"
msgstr "Ce document est:"

msgid "This document is at:"
msgstr "Ce document est � l'URL:"

msgid "Previous"
msgstr "Pr�c�dent"

msgid "Next"
msgstr "Suivant"


###
### Appearance.pm
###

msgid "Search"
msgstr "Chercher"

msgid "Appearance"
msgstr "Apparence"

msgid "Show Top Category Only"
msgstr "Ne montrer que la cat�gorie principale"

msgid "Show This <em>Entire</em> Category"
msgstr "Montrer <em>toute</em> la Cat�gorie"

msgid "Show This %0 As Text"
msgstr "Montrer ce %0 comme un texte"

msgid "Show This <em>Entire</em> Category As Text"
msgstr "Montrer <em>toute</em> la Cat�gorie comme un texte"

msgid "Hide Expert Edit Commands"
msgstr "Cacher les commandes d'�dition expert"

msgid "Show Expert Edit Commands"
msgstr "Montrer les commandes d'�dition expert"

msgid "This is a"
msgstr "C'est une"

msgid "Hide Help"
msgstr "Cacher l'aide"

msgid "Help"
msgstr "Aide"

msgid "Log In"
msgstr "Se loguer"

msgid "Change Password"
msgstr "Changer de mot de passe"

msgid "Edit Title of %0 %1"
msgstr "�diter le Titre de %0 %1"

msgid "New %0"
msgstr "Nouveau %0"

msgid "Edit Part in %0 %1"
msgstr "�diter la section de %0 %1"

msgid "Insert Part in %0 %1"
msgstr "Ins�rer une section dans %0 %1"

msgid "Move %0 %1"
msgstr "D�place %0 %1"

msgid "Access Statistics"
msgstr "Statistique d'acc�s"

msgid "%0 Permissions for %1"
msgstr "%0 permissions pour %1"

msgid "Upload bag for %0 %1"
msgstr "Charger un fichier objet pour %0 %1"

###
### Adds
###

msgid "Either someone has changed the answer or category you were editing since you received the editing form, or you submitted the same form twice."
msgstr "Quelqu'un a du chang� l'entr�e ou la cat�gorie pendant que vous receviez le formulaire d'�dition, ou alors vous avez soumis le formulaire une deuxi�me fois."

msgid "Return to the FAQ"
msgstr "Retourner � la FAQ"

msgid "Please %0 and start again to make sure no changes are lost. Sorry for the inconvenience."
msgstr "Svp cliquez %0 et recommencez pour �tre sur que les modifications n'ont pas �t� perdues. D�sol� pour l'inconveniant."

msgid "(Sequence number in form: %0; in item: %1)"
msgstr "(Num�ro de s�quence dans le formulaire %0; dans l'entr�e: %1)."

msgid "This page will reload every %0 seconds, showing the last %1 lines of the process output."
msgstr "Cette page se red�signera toute les %0 secondes, et montre les %1 derni�res lignes du process."

msgid "Show the entire process log"
msgstr "Montrer tout le log du proc�s"


###
### 'sub'-messages
###

msgid "Select a group to edit:"
msgstr "S�lectionnez une groupe:"

msgid "Add Group"
msgstr "Ajouter une groupe nouvelle"

msgid "(Members of this group are allowed to access these group definition pages.)"
msgstr "(Des mebres de cette groupe on acc�s aux pages qui definissent les membres des groupes.)"

msgid "Up To List Of Groups"
msgstr "Retourner � la liste des groupes"

msgid "Add Member"
msgstr "Ajouter un membre nouveau"

msgid "Remove Member"
msgstr "Supprimer un membre"


###
### END
###

);
__EOF__

	my @txs = grep { m/^msg/ } split(/\n/, $txfile);
	for (my $i=0; $i<@txs; $i+=2) {
		$txs[$i] =~ m/msgid \"(.*)\"$/;
		my $from = $1;
		$txs[$i+1] =~ m/msgstr \"(.*)\"$/;
		my $to = $1;
		if (not defined $from or not defined $to) {
			die "bad translation for ".$txs[$i]." at pair $i";
		}
		$tx->{$from} = $to;
	}
};

