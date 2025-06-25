

# Dice Summon - Backend

Este é o backend do projeto Dice Summon, escrito em Elixir. Ele fornece uma API de autenticação e suporte para comunicação em tempo real entre usuários usando WebSockets via Cowboy.

## Requisitos

- Elixir >= 1.14
- Erlang/OTP >= 25
- Docker e Docker Compose (opcional para rodar o MongoDB)

## Tecnologias

- Elixir
- Plug + Cowboy (servidor HTTP e WebSocket)
- MongoDB
- Cachex (cache em memória)

## Executando o projeto

### 1. Clonar o repositório

```bash
git clone https://github.com/FueledByRage/dice-summon-backend
````

### 2. Instalar as dependências

```bash
mix deps.get
```

### 3. Rodar o MongoDB com Docker

```bash
docker compose up -d mongo
```

> Isso sobe um container com MongoDB na porta 27017.

### 4. Executar a aplicação

```bash
mix run --no-halt
```

A aplicação estará disponível em `http://localhost:4000`.

## Endpoints

* `POST /login` - Login de usuário com JSON `{ "username": "...", "password": "..." }`

## WebSocket

* Endpoint: `ws://localhost:4000/ws?username=USERNAME`
* Eventos suportados:

  * `invite`: envia um convite para outro usuário
  * `invite_response`: responde a um convite (`true` ou `false`)

## Organização

* `lib/dice_summon/` contém os módulos principais:

  * `Cache` para controle de conexões via PID
  * `Invite` para lógica de convite
  * `SocketHandler` para tratamento de mensagens WebSocket
  * `Router` para endpoints HTTP

## Ambiente de desenvolvimento

Use a flag `MONGO_URI` para configurar a conexão com o banco:

```bash
MONGO_URI=mongodb://localhost:27017/dice_summon
```

Se estiver usando Docker Compose, o serviço `app` já define essa variável automaticamente.

## Licença

Este projeto é de uso interno e não possui licença pública por enquanto.
