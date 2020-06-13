# Huella Digital - Plataforma

Plataforma para provisionar la aplicación [Huella Digital](https://github.com/ayudadigital/huelladigital)

Está basada en docker y docker-compose

## Configuración del servidor

Usaremos Ubuntu 18.04 como sistema base

- Instalamos [Docker](https://docs.docker.com/engine/install/ubuntu/)
- Instalamos [docker-compose](https://docs.docker.com/compose/install/)
- Preparamos el firewall del sistema y abrimos puertos

    ```shell
    $ sudo ufw default deny incoming
    $ sudo ufw default allow outgoing
    $ sudo ufw allow 22
    $ sudo ufw allow 80
    $ sudo ufw allow 443
    $ sudo ufw allow 8080
    $ sudo ufw enable
    ```

[...]
