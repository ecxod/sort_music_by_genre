import os
import shutil
import sqlite3
import subprocess

# Benutzereingaben
input_folder = r"C:\Users\Christian\MyMusic"
output_folder = r"C:\Users\Christian\MyMusicByGenre"
program_folder = r"C:\Users\Christian\SqLite"
db_file = os.path.join(program_folder, "music_metadata.db")

# SQLite-Datenbank initialisieren
conn = sqlite3.connect(db_file)
cursor = conn.cursor()
cursor.execute('''CREATE TABLE IF NOT EXISTS music (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL UNIQUE,
    artist TEXT, title TEXT, album TEXT, genre TEXT,
    asin TEXT, tsrc TEXT, streamtitle TEXT, streamname TEXT,
    number TEXT, date TEXT)''')
conn.commit()

# Musikdateien durchsuchen und Metadaten extrahieren
for root, dirs, files in os.walk(input_folder):
    for file in files:
        if file.endswith(('.mp3', '.ogg', '.aac')):
            filepath = os.path.join(root, file)
            # Metadaten mit ffprobe extrahieren
            result = subprocess.run(
                ['ffprobe', '-v', 'error', '-show_entries', 'format_tags', '-of', 'ini', filepath],
                capture_output=True, text=True
            )
            tags = {}
            for line in result.stdout.splitlines():
                if '=' in line:
                    key, value = line.split('=', 1)
                    tags[key.lower()] = value.replace("'", "''")

            # Standardwerte setzen
            artist = tags.get('artist', 'unknown_artist')
            title = tags.get('title', 'unknown_title')
            album = tags.get('album', '')
            genre = tags.get('genre', 'unknown')
            streamtitle = tags.get('streamtitle', '')
            streamname = tags.get('streamname', '')
            number = tags.get('number', '')
            date = tags.get('date', '')

            # Ausgabe-Pfad setzen
            output_folder_genre = os.path.join(output_folder, genre)
            if date:
                output_path = os.path.join(output_folder_genre, f"{artist} - {title} ({date}){os.path.splitext(file)[1]}")
            else:
                output_path = os.path.join(output_folder_genre, f"{artist} - {title}{os.path.splitext(file)[1]}")

            # Daten in SQLite speichern
            cursor.execute('''INSERT OR IGNORE INTO music (path, artist, title, album, genre, streamtitle, streamname, number, date)
                              VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)''',
                           (output_path, artist, title, album, genre, streamtitle, streamname, number, date))
            conn.commit()

            # Zielverzeichnis erstellen
            os.makedirs(output_folder_genre, exist_ok=True)

            # Datei verschieben
            shutil.move(filepath, output_path)

# Verbindung schließen
conn.close()
