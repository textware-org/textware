```bash
 
/var/www/database/init.sh "/var/www/db.sqlite"
bash ./ssh-config.sh .env.researcher 

docker compose down
docker compose build
docker compose up
xdg-open http://localhost:8080/login.php
```