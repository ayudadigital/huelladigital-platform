# Gestión de secretos

## Introducción

Utilizaremos [git-secret](https://git-secret.io/) para gestionar los secretos de la plataforma.
Los secretos están repositados en el proyecto dentro del directorio `vault`, omo archivos `.env.*.secret`

```console
$ ls -l vault/.env.*.secret
-rw-r--r--  1 pedro.rodriguez  staff  559 Jun 15 08:37 vault/.env.dev.secret
```

## Generar claves GPG

Las claves GPG necesarias para git-secret las vamos a generar con `bin/devcontrol.sh build-jenkins-gpg-key`. Con esta acción:

- Se creará una identidad GPG para el usuario "huelladigital-platform@jenkins.ayudadigital.org"
- Tendremos las claves pública y privada en `vault/public.asc` y `vault/private.asc`

## Clave pública

Importamos la clave pública en nuestro keyring con `gpg --import vault/public.asc`

```shell
$ gpg --import vault/public.asc
gpg: key CBCF349DB957A63B: public key "Ayudadigital huelladigital-platform <huelladigital-platform@jenkins.ayudadigital.org>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

Añadimos la nueva identidad a los autorizados de git-secret y re-encriptamos

```shell
$ git secret tell huelladigital-platform@jenkins.ayudadigital.org
$ git secret hide -d
git-secret: done. 1 of 1 files are hidden.
$ git secret whoknows
pedroamador.rodriguez+huelladigital@gmail.com
huelladigital-platform@jenkins.ayudadigital.org
```

Repositamos los cambios

```shell
$ git status
On branch feature/git-secret
Your branch is up to date with 'origin/feature/git-secret'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   .gitsecret/keys/pubring.kbx
	modified:   .gitsecret/keys/pubring.kbx~
	modified:   vault/.env.dev.secret
```

## Clave privada

Añadimos la clave `vault/private.asc` como una credencial de tipo "Secret text" y el ID `huelladigital-platform-vault-key`

Toda la clave debe debe estar en una sola línea, usaremos `cat vault/private.asc|tr '\n' ','` para cambiar los saltos de línea por una coma. El texto resultante lo usaremos en la credencial de Jenkins

Ejemplo

```console
$ cat vault/private.asc |tr '\n' ','
-----BEGIN PGP PRIVATE KEY BLOCK-----,,lQG7BF7vTkERBACbUdIo6ASgwc7EVkCkOgBjlwY3luWg4KzddPsn36yMhbtjrqbz,bGejSgFdmHYpRyiNViBXAeadkGfoakvS0RlQjctioDpCKGhSnJYYmqo0DexvTdXh,ymuB5cmoajqHX0GyG1nS/PamOPPsmPrRnqnJilboOxSh9ZgbkX7Cu+/yPwCg+5nS,2Q1K3bKd0VF2lzD3WSsu4wsD/0ry6JrDfoSou3rSGEy9Ns0J/Lgk7uyagQ72qav2,GmInhDjYTcPgEH+5gIUIq/Q6CUI2ogTFUn0xMMTrA6qhlxVy95s2SS0N1ex3/LCN,l3sP2DNWu0kT5XAplFv3tZYETL9I11tF+SZgIm5iR4zGyPsGtOL85RDyqUdBfevy,JatAA/9VFfAaJiTminyECBZMkMD6mMNX5e5LJMdjCv5Y9wRIuzkKlRxnINYM+2u1,eZ2H21aA3H+1zPJFiR1XVULuc4QuV1jg1lwncDG4tlRSxt6Bee8JY+Ll8eshNV1G,3I7CwHRNjU03uLTroySCAEsnxoA/ux806NE0fAZkCINSR6Br6gAAn1of4MFjGVpe,EN34Cm6Y9OYF2GKdCpi0VUF5dWRhZGlnaXRhbCBodWVsbGFkaWdpdGFsLXBsYXRm,b3JtIDxodWVsbGFkaWdpdGFsLXBsYXRmb3JtQGplbmtpbnMuYXl1ZGFkaWdpdGFs,Lm9yZz6IeAQTEQIAOBYhBPLZozFcCYcNYsEWOXb2RweZlEobBQJe705BAhsjBQsJ,CAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEHb2RweZlEobRSsAn1CDnz7yr+mYvh17,hjuMotgB1FSjAKCELx6h14O52fVJ2bwcTnHu6LZDZZ0BMgRe705BEAQA70iV2O+A,w5wQbejVlb2x5cwGv6PBcUszweTAbcZbr1m9tC5P1ICW49yPFu7nniKB6MrL1WIv,xZUlMCSk3eXsxSuD41MzDgMlcLqJT4cqyJgD0ylBrjXB9krywbaRMj35+eFNXc73,zXBlD2FoxuPoDlveJiqvTV3zRvo0X/Wfip8ABA0EAO305BHY8rvBAav/WaKkoX+V,w4k384ZDf/FMOgq3ZXjOvwnH2hSxsE4RwQwNvPsYKAFuDPSZmrV0v7OZVaEKQvve,eYIbywRNjdGQr7N8z//7Mgs4+bbv3uk3198ipb/s9/DR4F8NChFUGeH56oKXNwSH,BEILA2/PsYfgZNz2Onr7AAD6AwuSwt621BPhhOzfo7MycaB/kxYV11wG78KBB14n,3JwRTIhgBBgRAgAgFiEE8tmjMVwJhw1iwRY5dvZHB5mUShsFAl7vTkECGwwACgkQ,dvZHB5mUShtdxwCfeOZnzhAYPJp87t//z0RXFkuWmyoAn162mrRAu9TjD1qzmC1+,eR6GjLL4,=wz3B,-----END PGP PRIVATE KEY BLOCK-----,
```
