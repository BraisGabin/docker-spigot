# Docker Spigot

A Spigot Docker image with the `spigot.jar` file inside of it.

## How to use it

You first need to build this image:

```bash
docker build -t braisgabin/spigot https://github.com/BraisGabin/docker-spigot.git
```

You must accept the [Mojang eula license][eula] by adding an environment variable `EULA` with the value `true`.
You probably want to open the port `25565` and save the configuration inside `/var/lib/spigot/` in a volume.
To do all of this and run spigot you can use this command:

```bash
docker run -itd -p "25565:25565" -e "EULA=true" -v "server_name:/var/lib/spigot/"
```

### How to configure the server

To configure the server you need to modify the files inside the image. There are a lot of ways to do that.
I explain here one of them:

```bash
docker run --rm -it -v "server_name:/server" -w "/server" debian:jessie bash
```

or directly:

```bash
docker run --rm -it -v "server_name:/server" -w "/server" debian:jessie vim server.properties
```

You must remember to restart the server.

### How to use it in production

I recommend you to use Docker Compose for a production server. An example of `docker-compose.yml`:

```yml
version: '2'

services:
  spigot:
    image: braisgabin/spigot
    volumes:
      - server_1:/var/lib/spigot/
    environment:
      EULA: "true"
    ports:
      - 25565:25565
```

This is just an example. You can copy&paste it and edit as you want.

Now you can update your server with very short down times:

```bash
docker build --no-cache -t braisgabin/spigot https://github.com/BraisGabin/docker-spigot.git
docker-compose -d
```

## Why yet another Spigot Docker image?
You can't redistribute the complied jar of Spigot, for this reason all the spigot docker images
needs to build it inside the entrypoint. I don't want to do that so I build my own image.

## Why isn't it in the Docker Hub?
I can't upload this image to the Docker Hub because, as I said, it's not allowed to distribute the compiled jar.


 [eula]: https://account.mojang.com/documents/minecraft_eula
