# **Sort Music by Genre**

Dieses Skript sortiert deine Musikdateien basierend auf ihrem Genre in separate Ordner. Es kombiniert die Leistungsfähigkeit von **FFmpeg** und **SQLite3**, um die Metadaten der Dateien auszulesen und die Organisation zu automatisieren. 

## **Voraussetzungen**

### Tools:
1. **[FFmpeg](https://www.ffmpeg.org/download.html)**: Ein leistungsstarkes Werkzeug zur Verarbeitung von Multimedia-Dateien. Es wird verwendet, um die Metadaten deiner Musikdateien zu extrahieren.
2. **[SQLite3](https://www.sqlite.org/download.html)**: Eine leichtgewichtige SQL-Datenbank, in der die Metadaten der Musikdateien zwischengespeichert werden.

### Ordner-Struktur:
Bevor du das Skript ausführst, stelle sicher, dass du drei Ordner eingerichtet hast:

1. **Eingabeordner (Input Folder)**:  
   Hier befinden sich die unsortierten Musikdateien.  
   Beispiel:  
   ```dos
   set "input_folder=C:\Users\Christian\MyMusic"
   ```

2. **Ausgabeordner (Output Folder)**:  
   In diesem Ordner werden die Musikdateien nach Genre sortiert abgelegt.  
   Beispiel:  
   ```dos
   set "output_folder=C:\Users\Christian\MyMusicByGenre"
   ```

3. **Programmordner (Program Folder)**:  
   Hier wird die SQLite-Datenbank erstellt und gespeichert. Diese Datenbank enthält Informationen über die Musikdateien und deren Metadaten.  
   Beispiel:  
   ```dos
   set "program_folder=C:\Users\Christian\SqLite"
   ```

---

## **Wie funktioniert das Skript?**

1. **Extrahieren von Metadaten**:  
   Das Skript verwendet FFmpeg, um die Metadaten (z. B. Genre, Künstler, Titel) aus den Musikdateien im Eingabeordner auszulesen.

2. **Speichern in der SQLite-Datenbank**:  
   Die extrahierten Metadaten werden in einer SQLite-Datenbank gespeichert, die sich im Programmordner befindet.

3. **Sortieren der Dateien**:  
   Basierend auf den Genres werden die Musikdateien in entsprechende Unterordner im Ausgabeordner verschoben oder kopiert. Zum Beispiel:
   - `C:\Users\Christian\MyMusicByGenre\Rock`
   - `C:\Users\Christian\MyMusicByGenre\Jazz`
   - `C:\Users\Christian\MyMusicByGenre\Pop`

---

## **Vorteile**
- Automatische Sortierung von Musikdateien.
- Effiziente Nutzung von Open-Source-Tools (FFmpeg und SQLite3).
- Kein manuelles Durchsuchen oder Verschieben von Dateien erforderlich.

---

## **Anwendung**
1. **Installiere die benötigten Tools**:
   - Lade FFmpeg und SQLite3 herunter und stelle sicher, dass beide ausführbar sind (z. B. durch Hinzufügen zu den Systempfaden).

2. **Passe die Ordnerpfade an**:  
   Bearbeite die Skript-Variablen `input_folder`, `output_folder` und `program_folder` entsprechend deinen Anforderungen.

3. **Führe das Skript aus**:  
   Speichere das Batch-Skript als `sort_music_by_genre.bat` und führe es mit einem Doppelklick aus. Alternativ kannst du es in einer Eingabeaufforderung starten.

