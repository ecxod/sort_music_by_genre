@echo off
setlocal enabledelayedexpansion

:: Benutzereingaben
set "input_folder=C:\Users\Christian\MyMusic"
set "output_folder=C:\Users\Christian\MyMusicByGenre"
set "program_folder=C:\Users\Christian\MyMusicSoft"
set "pattern=%%genre%%\%%artist%% - %%title%% (%%date%%)"

:: Erlaubte Muster
set "allowed_patterns=%%artist%% %%title%% %%album%% %%genre%% %%streamtitle%% %%streamname%% %%number%% %%date%%"

:: SQLite-Datenbank initialisieren
set "db_file=%program_folder%\music_metadata.db"
sqlite3 "%db_file%" "CREATE TABLE IF NOT EXISTS `music` (`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,`path` TEXT NOT NULL UNIQUE,`artist` TEXT, `title` TEXT, `album` TEXT, `genre` TEXT, `asin` TEXT, `tsrc` TEXT, `streamtitle` TEXT, `streamname` TEXT, `number` TEXT, `date` TEXT)" >nul 2>&1

:: Musikdateien durchsuchen und Metadaten extrahieren
for /r "%input_folder%" %%f in (*.mp3 *.ogg *.aac) do (

    :: Dateierweiterung ermitteln
    set "extension=%%~xf"

    :: Metadaten mit ffprobe extrahieren
    for /f "tokens=1,* delims==" %%a in ('ffprobe -v error -show_entries format_tags -of ini "%%~f"') do (
        set "tag_name=%%a"
        set "tag_value=%%b"
        set "!tag_name!=!tag_value!"
    )

    if defined artist (
        set "escaped_artist=!artist:'=''!"
    ) else (
       set "escaped_artist='unknown_artist'" 
    )
    if defined title (
        set "escaped_title=!title:'=''!"
    ) else (
       set "escaped_title='unknown_title'" 
    )
    if defined album (
        set "escaped_album=!album:'=''!"
    ) else (
       set "escaped_album=''" 
    )
    if defined genre (
        set "escaped_genre=!genre:'=''!"
    ) else (
       set "escaped_genre='unknown'" 
    )
    if defined streamtitle (
        set "escaped_streamtitle=!streamtitle:'=''!"
    ) else (
        set "escaped_streamtitle=''" 
    )
    if defined streamname (
        set "escaped_streamname=!streamname:'=''!"
    ) else (
        set "escaped_streamname=''" 
    )
    if defined number (
        set "escaped_number=!number:'=''!"
    ) else (
        set "escaped_number=''" 
    )

    :: Ausgabe-Pfad setzen
    set "output_folder_genre=!output_folder!\!escaped_genre!"
    if defined date (
        set "escaped_date=!date:'=''!"
        set "output_path=!output_folder_genre!\!escaped_artist! - !escaped_title! (!escaped_date!)!extension!"
    ) else (
        set "escaped_date=''"
        set "output_path=!output_folder_genre!\!escaped_artist! - !escaped_title!!extension!"
    )

    :: Daten in SQLite speichern
    sqlite3 "%db_file%" "INSERT OR IGNORE INTO music (path, artist, title, album, genre, streamtitle, streamname, number, date) VALUES ( '!output_path!', '!escaped_artist!', '!escaped_title!', '!escaped_album!', '!escaped_genre!', '!escaped_streamtitle!', '!escaped_streamname!', '!escaped_number!', '!escaped_date!' );" >nul 2>&1

    :: Zielverzeichnis erstellen
    if defined genre (
        if not exist "!output_folder_genre!" (
            mkdir "!output_folder_genre!" >nul 2>&1
        )
    )

    :: Datei kopieren
    move "%%~f" "!output_path!" >nul 2>&1

)

