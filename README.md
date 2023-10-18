
# Project ELEGRO Simple-Server
<br/>
Proyect: node - mongo - nginx with docker 

```bash
$~ git clone https://github.com/elegroag/elegro-node-mongo.git
$~ mv elegro-node-mongo aplication_name
$~ cd aplication_name
```

Se crean algunos directorios y archivos necesarios 
```bash
$~ mkdir data
$~ mkdir app
$~ touch .env
```


Use la coneccion mongosee con el host network de mongo, en el app.js server 
```sh
mongoose
    .connect("mongodb://mongo:27017/iberoVentas", { useNewUrlParser: true })
    .then((db) => console.log("Db is connected"))
    .catch((error) => console.error(error));
```

Edita el nginx.config 
```sh
worker_processes 1;

events { worker_connections 1024; }

http {
  server {
    listen 80;
    server_name localhost;
    location / {
      proxy_pass http://node:3001;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }
  }
}
```

+ Seleccionar el puerto de salida
```sh
    listen 80;
```

+ Seleccionar el proyecto node que se está ejecutando, usando el container_name, del docker compose definido para el servicio node
```sh
    proxy_pass http://node:3001;
```

RUN PROJECT
----
Listar los contenedores en ejecución      
```bash
$~  docker ps
# o ver aquellos detenidos
$~  docker ps -a
```
Procesamos el docker compose para desplegar los servicios       
```bash
$~  docker-compose up -d
```

Detener y borrar el contenedor desplegado       
```bash
$~  docker-compose down
# o tambien con más poderes
$~  docker-compose down --rmi all --volumes
# limpiar las network que ya no estan en uso
$~  docker network prune

```

Volver a procesar los cambios hechos en el Dockerfile, reconstruir
```bash
$~  docker-compose up -d --build
```

Ingresar a la consola interactiva del servicio node   
```bash
$~  docker exec -dit node bash
```

Identificar errors o warnings en los servicios en ejecución
```bash
$~  docker-compose logs
$~  docker-compose logs node
$~  docker-compose logs nginx
$~  docker-compose logs mongo
```

La salida del docker-compose logs node: 
```bash
node  | > simple-server@1.0.0 start
node  | > nodemon app.js
node  | 
node  | [nodemon] 1.19.4
node  | [nodemon] to restart at any time, enter `rs`
node  | [nodemon] watching dir(s): *.*
node  | [nodemon] watching extensions: js,mjs,json
node  | [nodemon] starting `node app.js`
node  | Init Coneccion OK
node  | Db is connected
node  | GET From SERVER
node  | GET From SERVER
```

Procesar la imagen e ignore la cache
```bash
docker-compose up -d --force-recreate
# OR rerecrear las imagen  
docker-compose up -d --build --force-recreate
```

