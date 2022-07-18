#!/bin/bash



### EXIT SCRIPT IF ANY ERROR OCCURS, WITH ERROR MESSAGE
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG # TRACKING LAST EXECUTED COMMAND
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT # ECHO ERROR MESSAGE ON EXIT



### INFORMATION BOX
echo ""
echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "###                       X X X X X X     X X X X X X X     X X X X X X X      X                          ###"
echo "###                       X                           X                 X      X                          ###"
echo "###                       X                         X                   X      X                          ###"
echo "###                       X                       X                     X      X                          ###"
echo "###                       X X X X               X             X X X X X        X                          ###"
echo "###                       X                   X                         X      X                          ###"
echo "###                       X                   X                         X      X                          ###"
echo "###                       X                   X                         X                                 ###"
echo "###                       X                   X             X X X X X X X      X                          ###"
echo "###                                                                                                       ###"
echo "#############################################################################################################"

echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "### Dieses Skript wird dein MacBook interaktiv für die Fakultät 73 einrichten. Jede Änderung am System    ###"
echo "### wird vorher abgefragt und kann gestoppt werden. Für dieses Skript sind 'PowerUser'-Rechte, sowie dein ###"
echo "### Passwort, welches du zur Anmeldung an das MacBook-System benutzt, erforderlich. Die                   ###"
echo "### 'PowerUser'-Rechte, kannst du dir in der SelfService-App selbst geben.                                ###"
echo "###                                                                                                       ###"
echo "### Für weitere Informationen, schau bitte in die Readme.md oder in das Hilfe-Skript.                     ###"
echo "###                                                                                                       ###"
echo "### Folgendes wird in dieser Reihenfolge unternommen:                                                     ###"
echo "### 1) Anpassen der .zshrc-Datei --> Eintrag des VW-Proxy                                                 ###"
echo "### 2) Installation von Homebrew-Paketmanager                                                             ###"
echo "### 3) Installation von einem oder mehreren Java Development Kits --> via Homebrew                        ###"
echo "### 4) Installation von Maven für Java --> via Homebrew                                                   ###"
echo "### 5) Installation von Eclipse für Java --> via Homebrew                                                 ###"
echo "###                                                                                                       ###"
echo "#############################################################################################################"
echo ""


PS3='Möchtest du das Skript starten?: '
options=("Start" "Abbrechen" )
select opt in "${options[@]}"; do
    case $opt in
        "Start")
            echo ">>> Das Skript wird gestartet."
            break
            ;;
        "Abbrechen")
            echo ">>> Das Skript wird beendet."
            exit 0
            ;;
        *) echo "Bitte mit 1 oder 2 anworten... $REPLY";;
    esac
done


### .zshrc
echo ""
echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "### Schritt 1: .zshrc-Datei für Proxy einrichten                                                          ###"
echo "###                                                                                                       ###"
echo "### Konfiguration der .zshrc-Datei. Hier liegen Umgebungsvariablen und Informationen für das Terminal.    ###"
echo "### Die Datei ist bei einem neuen Benutzer im Normalfall leer und kann bei Existenz einfach überschrieben ###"
echo "### werden. Im folgenden, wird hier eine Anweisung hinterlegt, die jedes Mal, wenn das Terminal           ###"
echo "### (die Bash) geöffnet wird, prüft, ob die ZScaler-App läuft oder nicht und damit entweder den VW-Proxy  ###"
echo "### benutzt oder nicht. So wird gewährleistetm, dass das Terminal jederzeit das Internet erreicht.        ###"
echo "###                                                                                                       ###"
echo "### [ACHTUNG: Hast du bereits Einstellungen getroffen, werden diese gelöscht!]                            ###"
echo "###                                                                                                       ###"
echo "#############################################################################################################"
echo ""

PS3='Proxy-Anweisung in die .zshrc-Datei schreiben?: '
options=("Ja" "Nein" )
select opt in "${options[@]}"; do
    case $opt in
        "Ja")
            echo ">>> Anweisung wird geschrieben."
            write_proxy="true"
            break
            ;;
        "Nein")
            echo ">>> Übersprungen."
            write_proxy="false"
            break
            ;;
        *) echo "Bitte mit 1 oder 2 anworten... $REPLY";;
    esac
done

if [ $write_proxy = "true" ]; then
    FILE=~/.zshrc
    if [ ! -f $FILE ]; then
        touch $FILE
    else
        read -e -p ">>> Es wurde eine .zshrc-Datei gefunden. Überschreiben? [J/n]" YN
        if [[ $YN == "j" || $YN == "J" || $YN == "" ]]; then
            rm -f $FILE && touch $FILE
            echo ">>> Datei überschrieben."
        fi
    fi
    old_content=$(<$FILE)
    cat << EOF > $FILE
$old_content
if pgrep -x "Zscaler" > /dev/null; then
    echo "Zscaler running - SET PROXY."
    export http_proxy=http://127.0.0.1:9000
    export https_proxy=http://127.0.0.1:9000
else
    echo "Zscaler not running - NO PROXY SET."
fi
EOF
fi

source ~/.zshrc
echo ">>> Refresh terminal with source ~/.zshrc"



### HOMEBREW
echo ""
echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "### Schritt 2: Homebrew installieren                                                                      ###"
echo "###                                                                                                       ###"
echo "### Homebrew ist ein Paket-Manager für Mac OS, mit dessen Hilfe Software installiert werden kann.         ###"
echo "### Homebrew wird für die nachfolgenden Schritte benötigt. Möchtest du Homebrew nicht installieren,       ###"
echo "### wird das Skript beenden.                                                                              ###"
echo "### Weitere Informationen findest du hier: https://brew.sh/index_de                                       ###"
echo "#############################################################################################################"
echo ""

PS3='Homebrew installieren?: '
options=("Installieren" "Beenden" )
select opt in "${options[@]}"; do
    case $opt in
        "Installieren")
            echo ">>> Starte installation."
            install_homebrew="true"
            break
            ;;
        "Beenden")
            echo ">>> Skript wird beendet."
            install_homebrew="false"
            exit 0
            ;;
        *) echo "Bitte mit 1 oder 2 anworten... $REPLY";;
    esac
done

if [ $install_homebrew = "true" ]; then
    if test ! $(which brew); then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
        old_content=$(<~/.zshrc)
        cat << EOF > ~/.zshrc
$old_content
eval \$(/opt/homebrew/bin/brew shellenv)
EOF
    source ~/.zshrc
    echo ">>> Refresh terminal with source ~/.zshrc"
    echo ">>> Homebrew Repositorys werden aktualisiert..."
    brew upgrade && brew update
    brew uninstall --ignore-dependencies openjdk || echo "No old java versions found..."
fi



### JDK
echo ""
echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "### Schritt 3: JDK installieren.                                                                          ###"
echo "###                                                                                                       ###"
echo "### Für Eclipse & Intellj wird ein Java Developement Kit (JDK) benötigt. Standart für die Fakultät73 ist  ###"
echo "### JDK 8 (aka 1.8). Es können bei Bedarf auch mehrere Versionen hinzugefügt werden. Mit dem Befehl       ###"
echo "### 'j<Versionsnummer>' im Terminal ist es dann möglich, zwischen den Versionen zu wechseln.              ###"
echo "###                                                                                                       ###"
echo "#############################################################################################################"
echo ""

### DEFINE JDK ALIAS FUNCTION
function add_jdk_alias_into_zshrc() {
    old_content=$(<~/.zshrc)
    cat << EOF > ~/.zshrc
$old_content
alias j$1="export JAVA_HOME=`/usr/libexec/java_home -v $2`; java -version"
EOF
}

PS3='JDK Installation. Bitte Option wählen: '
options=("Nur Java 8" "Java 8 & weitere" "Überspringen")
select opt in "${options[@]}"; do
    case $opt in
        "Nur Java 8")
            install_java="single"
            break
            ;;
        "Java 8 & weitere")
            install_java="multiple"
            break
            ;;
        "Überspringen")
            echo ">>> Übersprungen."
            install_java="false"
            break
            ;;
        *) echo "Bitte mit 1, 2 oder 3 anworten... $REPLY";;
    esac
done

if [[ $install_java = "single" || $install_java = "multiple" ]]; then
    brew tap bell-sw/liberica
    brew install --cask liberica-jdk8-full
    version_short=8
    version_with_peroid=1.8
    add_jdk_alias_into_zshrc $version_short $version_with_peroid
    export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
fi

if [ $install_java = "multiple" ]; then
    stop_loop="false"
    while [[ $stop_loop = "false" ]]; do
        while true; do
            read -p "Bitte eine weitere Version wählen (9 - 18 | Leer lassen zum abbrechen): " version
            if [ -z ${version} ]; then
                stop_loop="true"
                break
            fi
            if [[ $version =~ ^[0-9]+$ ]] ||  ((number >= 9 && number <= 18)); then
                version_string="liberica-jdk${version}-full"
                brew install --cask $version_string
                add_jdk_alias_into_zshrc $version $version
                break
            else
                echo ">>> Bitte eine Java Version zwischen 9 und 18 wählen."
            fi
        done
    done
fi

source ~/.zshrc
echo ">>> Refresh terminal with source ~/.zshrc"



### MAVEN
echo ""
echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "###  Schritt 4: Maven und Maven Proxy Settings                                                            ###"
echo "###                                                                                                       ###"
echo "### Als nächstes kommt Maven. Dies ist ein Package & Build Manager für Java und sollte installiert        ###"
echo "### werden. Maven wird immer die aktuell gesetzte 'Default' JDK benutzen. Diese kannst du später          ###"
echo "### jederzeit ändern. Zusätzlich wird der Repository Pfad auf $HOME/.m2 festgelegt, sowie der VW-Proxy    ###"
echo "### konfiguriert.                                                                                         ###"
echo "###                                                                                                       ###"
echo "#############################################################################################################"
echo ""

PS3='Maven installieren?'
options=("Installieren" "Überspringen")
select opt in "${options[@]}"; do
    case $opt in
        "Installieren")
            echo ">>> Starte Installation."
            install_maven="true"
            break
            ;;
        "Überspringen")
            echo ">>> Übersprungen."
            install_maven="false"
            break
            ;;
        *) echo "Bitte mit 1 oder 2 anworten... $REPLY";;
    esac
done

if [ $install_maven = "true" ]; then
    brew install maven

    DIR=$HOME/.m2
    if [ ! -d $DIR ]; then
        mkdir $DIR
    fi
    FILE=$HOME/.m2/settings.xml
    if [ ! -f $FILE ]; then
        touch $FILE
    fi
    cat << EOF > $HOME/.m2/settings.xml
<settings>

<!-- localRepository
| The path to the local repository maven will use to store artifacts.
| Default: ~/.m2/repository
| <localRepository>/path/to/local/repo</localRepository> -->

<localRepository>$HOME/.m2</localRepository>

<!-- offline
| Determines whether maven should attempt to connect to the
| network when executing a build.
| This will have an effect on artifact downloads, artifact
| deployment, and others.
| Default: false -->

<offline>false</offline>

<proxies>
    <proxy>
        <id>optional</id>
        <active>true</active>
        <protocol>http</protocol>
        <host>127.0.0.1</host>
        <port>9000</port>
    </proxy>
</proxies>

</settings>
EOF
fi

source ~/.zshrc
echo ">>> Refresh terminal with source ~/.zshrc"



### ECLIPSE
echo ""
echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "### Schritt 5: Eclipse - Java - IDE installieren                                                          ###"
echo "###                                                                                                       ###"
echo "### Jetzt kommt die IDE. Hier wird Eclispe installiert, da dies der Standart für die Fakultät73 ist.      ###"
echo "### Die IDE wird anschließend asl APP auf deinem Mac angezeigt und Bedarf weiterer Einrichtung.           ###"
echo "###                                                                                                       ###"
echo "#############################################################################################################"
echo ""

PS3='Eclispe installieren?'
options=("Installieren" "Überspringen")
select opt in "${options[@]}"; do
    case $opt in
        "Installieren")
            echo ">>> Starte Installation."
            install_eclipse="true"
            break
            ;;
        "Überspringen")
            echo ">>> Übersprungen."
            install_eclipse="false"
            break
            ;;
        *) echo "Bitte mit 1 oder 2 anworten... $REPLY";;
    esac
done

if [ $install_eclipse = "true" ]; then
    brew install --cask eclipse-java
fi

### FINISH
echo ""
echo "#############################################################################################################"
echo "###                                                                                                       ###"
echo "### Das Skript ist nun abgeschlossen. Wie es weiter geht, steht im Hilfe-Skript.                          ###"
echo "###                                                                                                       ###"
echo "#############################################################################################################"
echo ""
