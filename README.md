# Paperhub

Paperhub é um editor de texto colaborativo onde estudantes e pesquisadores podem criar seus papers, artigos e dissertações de forma fácil e prática.

## Instalação e Dependências

Antes de começar, vale lembrar que você pode instalar as ferramentas individualmente, porém em recomendo fortemente o uso do [asdf](https://asdf-vm.com/) para gerenciar suas ferramentas. Caso opte por instalar o asdf, certifique-se de instalar os plugins para elixir, erlang, node e bun. Caso não queira usar o asdf, você pode instalar as ferramentas manualmente.

- Elixir: https://elixir-lang.org/install.html
- Erlang: https://www.erlang.org/downloads
- Node: https://nodejs.org/en/download/package-manager
- Bun: https://bun.sh/docs/installation

## Como rodar o projeto

A partir daqui, vamos supor que você já tem todas as ferramentas necessárias instaladas. Sendo assim o primeiro passo é clonar o repositório.

```bash
git clone https://github.com/queirozlc/paperhub.git
```

Será necessário também a instalação do postgres ou docker, caso opte por rodar o postgres localmente, certifique-se que as credenciais do banco de dados estão corretas no arquivo `config/dev.exs`. Caso opte por usar docker (recomendado), você pode usar o seguinte comando para iniciar o container:

```bash
docker compose up -d
```

Depois de clonar o repositório, você pode instalar as dependências com o comando `mix setup`. Isso vai instalar as dependências do projeto e configurar o banco de dados.

```bash
mix setup
```

Você pode checar se tudo está funcionando corretamente com o comando `mix test`.

```bash
mix test
```

Caso seja necessário, configure o banco de teste com o comando:

```bash
MIX_ENV=test mix ash.setup
```

Agora para iniciar o servidor, você pode usar o comando:

```bash
mix phx.server
```

E para acessar a aplicação, você pode usar o seguinte link:

```bash
http://localhost:4000
```

## Alguns links úteis

- [Phoenix Docs](https://hexdocs.pm/phoenix)
- [Elixir Docs](https://elixir-lang.org/docs.html)
- [Ash Docs](https://hexdocs.pm/ash/readme.html)
