```bash
./database/init.sh "../../db.sqlite"
docker compose down
docker compose build
docker compose up
xdg-open http://localhost:8080/login.php
```