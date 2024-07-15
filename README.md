# Interfaz Gráfica

Este repositorio hospeda el codigo relacionado a la interfaz gráfica del proyecto Cloud Gaming Rental Service descripto en el siguiente [informe](https://drive.google.com/file/d/1G9Y-qSAztYXd9f97DJ-oina4pQhgBauq/view?usp=sharing).

## Descripción

Este proyecto es una aplicación de escritorio Flutter que permite a los usuarios participar en un sistema descentralizado de cloud gaming. Los usuarios pueden actuar como "offerer" (prestando su computadora para generar ingresos) o "receiver" (recibiendo la transmisión del videojuego). La aplicación requiere la ejecución de un servidor y un nodo de procesamiento para funcionar correctamente.

## Requisitos del Sistema

- **Sistema Operativo**: Windows 10/11
- **Flutter**: Versión 3.3.1 o superior

## Dependencias

### Flutter

Para iniciar la aplicación se requiere requiere del framework Flutter, el mismo puede descargarse e instalarse siguiendo este [enlace](https://docs.flutter.dev/get-started/install).

Además es importante configurar un proyecto [Firebase](https://firebase.google.com/docs?authuser=1&hl=es) utilizando authentication y storage. Tener en cuenta que se requiere de un archivo .env con el token requerido para la autenticación con Google.

## Ejecución

Para iniciar la aplicación, ejecuta el siguiente comando:

```bash
flutter run
```

Luego seleccionar el sistema Windows (opción 1).
