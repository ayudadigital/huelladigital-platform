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

## Ciclo de vida

- Preparar archivo `.env`, tomando `.env.dist` como semilla. Por defecto está configurado el entorno de desarrollo local

  ```console
  $ cat .env
  # Datasource config
  DATASOURCE_URL=jdbc:postgresql://db:5432/huelladigital
  DATASOURCE_DBNAME=huelladigital
  DATASOURCE_USERNAME=huelladigital_user
  DATASOURCE_PASSWORD=huelladigital_password
  # app version
  tag_app=beta
  # App url
  BASE_URI=https://dev.huelladigital.ayudadigital.org
  # Spring profile
  PROFILE=dev
  ```

- Preparar entorno

  ```console
  $ devcontrol assets-install
  Huelladigital (c) 2020 Ayuda Digital

  # Create data directories
  # Generating self-signed certificate
  Generating a 4096 bit RSA private key
  ....................++
  ........++
  writing new private key to '/var/folders/_y/c70k8b2168l7m3tqz9d50drc0000gn/T/tmp.dzVRSVTu/dev.huelladigital.ayudadigital.org.key'
  -----
  ```

  Si no existe certificado para el servicio en `./data/router/usr/local/etc/haproxy/certs/dev.huelladigital.ayudadigital.org.pem` y el entorno configurado es "dev", se creará un certificado auto-firmado.

- Arranque de plataforma

  ```console
  docker-compose up -d
  ```

- Acceso dede un navegador en <https://localhost>

- Parada de plataforma

  ```console
  docker-compose down -v
  ```
