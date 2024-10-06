Program w języku PHP, który ma pozwalać na logowanie do edytora markdown z pliku login.php treści wyswietlanej z formatu markdown do html w pliku index.html.
pliku markdown powinien byc przechowywany w bazie danych sqlite. Hasło i login potrzebne do logowanie przez formularz na login.php to to same dane, potrzebne do logowania do bazy danych sqlite w folderze wyżej "../db.slite" 
Dane z markdown są renderowane na domyślnej stronie index.php 
W lokalnej bazie danych są edytowane metadane i edytowane w pliku meta.php. 
Skrypt update/deply do publikacji strony poprzez ssh z danymi dostepowymi i ścieżką do strony z przechowwyanymi w pliku .env 
Pliki do testowania projektu Dockerfile i dockercompose

```bash
 
/var/www/database/init.sh "/var/www/db.sqlite"
bash ./ssh-config.sh .env.researcher 

docker compose down
docker compose build
docker compose up
xdg-open http://localhost:8080/login.php
```
