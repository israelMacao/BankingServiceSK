# 🏦 Sistema Bancario - Microservicios

Este proyecto demuestra el desarrollo de microservicios con Spring Boot, Docker, PostgreSQL y comunicación entre servicios. Ver [Instrucciones de Instalación]

## 📋 Descripción del Proyecto

Sistema bancario desarrollado con arquitectura de microservicios que permite la gestión de clientes y cuentas bancarias con sus respectivas transacciones.

### 🎯 Características Principales

- ✅ **Microservicios** con Spring Boot 3.5.5
- ✅ **Java 21** con características modernas
- ✅ **PostgreSQL** con bases de datos separadas por servicio
- ✅ **Docker & Docker Compose** para despliegue
- ✅ **Comunicación entre servicios** con WebClient
- ✅ **API REST** documentada con OpenAPI/Swagger
- ✅ **Health Checks** y monitoreo
- ✅ **Validación de datos** con Bean Validation
- ✅ **Manejo de errores** robusto
- ✅ **Logging** estructurado
- ✅ **Tests unitarios** con JUnit 5 y Mockito

## 🏗️ Arquitectura

```
┌─────────────────┐    ┌─────────────────┐
│  Cliente        │    │  Cuenta         │
│  Service        │    │  Service        │
│  (Puerto 8080)  │◄──►│  (Puerto 8081)  │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────┐       ┌───────┘
                 ▼       ▼
         ┌─────────────────┐
         │   PostgreSQL    │
         │  ┌───────────┐  │
         │  │DBcliente  │  │
         │  └───────────┘  │
         │  ┌───────────┐  │
         │  │DBcuenta   │  │
         │  └───────────┘  │
         └─────────────────┘
```

## 🗃️ Bases de Datos

### DBcliente
- **Usuario**: `cliente_user`
- **Contraseña**: `cliente_pass123`
- **Tablas**: 
  - `persona` (datos personales)
  - `cliente` (información de clientes)

### DBcuenta
- **Usuario**: `cuenta_user`
- **Contraseña**: `cuenta_pass123`
- **Tablas**:
  - `cuenta` (cuentas bancarias)
  - `movimiento` (transacciones)

## 📁 Estructura del Proyecto

```
proyecto-banco/
├── cliente/                    # Servicio Cliente
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── application-docker.properties
├── cuenta/                     # Servicio Cuenta
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── application-docker.properties
├── init-databases.sql          # Script de inicialización de BD
├── docker-compose.yml          # Configuración de servicios
├── deploy.sh                   # Script de despliegue
└── README-Docker.md           # Esta documentación
```

## 📋 Prerrequisitos
✅ Docker instalado (versión 20.0 o superior)
✅ Docker Compose instalado (versión 1.29 o superior)
✅ Git instalado (para clonar el repositorio)
✅ Puertos libres: 8080, 8081, 5432, 8082

## 🚀 Despliegue

```bash
# 1. Clonar el repositorio
git clone https://github.com/israelMacao/BankingServiceSK.git
cd BankingServiceSK
# 2. Construir imágenes
docker-compose build

# 3. Iniciar servicios
docker-compose up -d

# 4. Verificar estado
docker-compose ps
```

## 🔗 URLs de Acceso

| Servicio | URL | Descripción |
|----------|-----|-------------|
| Cliente | http://localhost:8080/api | API del servicio cliente |
| Cuenta | http://localhost:8081/api | API del servicio cuenta |

## 🏥 Monitoreo

### Verificar estado de servicios
```bash
docker-compose ps
```

### Ver logs
```bash
# Todos los servicios
docker-compose logs -f

# Servicio específico
docker-compose logs -f cliente-service
docker-compose logs -f cuenta-service
docker-compose logs -f postgres
```


## 🛠️ Comandos Útiles

### Gestión de servicios
```bash
# Iniciar servicios
docker-compose up -d

# Detener servicios
docker-compose down

# Reiniciar un servicio específico
docker-compose restart cliente-service

# Escalar un servicio
docker-compose up -d --scale cliente-service=2
```

## 🧪 Pruebas Rápidas 

### 1. Probar APIs con datos de ejemplo

**Obtener cliente por identificación:**
```bash
curl http://localhost:8080/api/clientes/identificacion/1234567890
```

**Obtener cuentas de un cliente:**
```bash
curl http://localhost:8081/api/cuentas/cliente/1
```

**Crear un movimiento:**
```bash
curl -X POST http://localhost:8081/api/movimientos \
  -H "Content-Type: application/json" \
  -d '{
    "cuentaId": 1001,
    "tipoMovimiento": "DEPOSITO",
    "valor": 500.00
  }'
```

### 3. Explorar con Swagger
- **Cliente API**: http://localhost:8080/api/swagger-ui/index.html
- **Cuenta API**: http://localhost:8081/api/swagger-ui/index.html

## 📊 Datos de Prueba

El sistema incluye datos de prueba:

### Personas/Clientes
- Juan Pérez (CLI001) - Identificación: 1234567890
- María García (CLI002) - Identificación: 0987654321
- Carlos López (CLI003) - Identificación: 1122334455

### Cuentas
- Cuenta 1001: AHORROS, Cliente CLI001, Saldo: $1,500.00
- Cuenta 1002: CORRIENTE, Cliente CLI001, Saldo: $300.00
- Cuenta 1003: AHORROS, Cliente CLI002, Saldo: $3,000.00


### Persistencia de Datos
Los datos se almacenan en un volumen Docker named `postgres_data` que persiste entre reinicios.

## 🚨 Solución de Problemas

### Servicio no inicia
1. Verificar logs: `docker-compose logs [servicio]`
2.