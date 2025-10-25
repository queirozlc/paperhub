![Paperhub Logo Favicon](https://github.com/user-attachments/assets/3261346b-44f4-4ceb-a376-a9ebcbd66c91)

# Paperhub

Paperhub é um editor de texto colaborativo em tempo real com integração com Inteligência Artificial e Git 📝 🚀✨

## Tecnologias Utilizadas

- Ruby on Rails
- Tailwind CSS
- PostgreSQL
- Svelte
- Inertia JS

### Passos para instalação

1. Clone o repositório
2. Instale as ferramentas necessárias
3. Configure o banco de dados
4. Inicie o servidor

Para clonar o repositorio, use o seguinte comando:

```bash
git clone https://github.com/queirozlc/paperhub.git
```

### Instalação das ferramentas necessárias

Você irá precisar do Ruby, mais precisamente na versão 3.4.2 (checar arquivo .ruby-version) e também precisará do bun, acredito que Node.js também seja necessário então instale o Node.js também.

Todas as ferramentas podem ser instaladas a partir do site oficial, ou usando gerenciadores de pacote (método recomendado).

No caso do Node por exemplo, você pode baixar do [site oficial](https://nodejs.org/) ou utilizar algo como NVM. Não vou por aqui todos os sites oficiais então certifique-se de que instalou corretamente as ferramentas caso opte por esse caminho.

Para usar o gerenciador de pacotes eu recomendo duas ferramentas:

- [asdf](https://asdf-vm.com/): Gerenciador de versões de múltiplas linguagens, você pode instalar o Ruby, o bun e o Node.js por ele via plugins.

- [mise-en-place](https://mise.jdx.dev/getting-started.html): Mais simples e mais rápido que o asdf, e ainda tem suporte aos arquivos `.tool-versions` que o asdf utiliza, esse seria o gerenciador de pacotes recomendado.

### Subindo o projeto

Para subir o projeto você irá precisar de um banco de dados [PostgreSQL](https://www.postgresql.org/) rodando. É fortemente recomendado que você utilize o Docker para isso, já que o projeto foi desenvolvido com o Docker em mente. Caso queira utilizar um banco local instalado na máquina você terá que configurar as credenciais para usar:

- POSTGRES_USER: postgres
- POSTGRES_PASSWORD: postgres

> [!IMPORTANT]
> É muito importante prestar atenção nessa parte, caso contrário a aplicação não irá funcionar pois não irá conseguir conectar ao banco de dados.

Para subir o banco de dados, você pode usar o seguinte comando:

```bash
docker-compose up -d
```

Após isso, você pode usar o script na pasta `bin` para instalar as dependências do projeto, preparar o banco e subir a aplicação (esse passo pode ser pulado usando a option `--skip-server`)

```bash
bin/setup
```

Exemplo pulando o servidor:

```bash
bin/setup --skip-server
```

Após isso, você pode subir o servidor com o seguinte comando:

```bash
bin/dev
```

Pronto! Agora você pode acessar a aplicação em `http://localhost:3100`.

### Configurar serviço de IA

Para utilizar as funcionalidades de Inteligência Artificial (IA), apelidadas de Turing AI, são necessários alguns passos.

1. Inicializar serviço

   1.1. Clone o repositório [paperhub-ai](https://github.com/bruno-remeikis/paperhub-ai)

   1.2. Execute-o com `docker-compose up --build`

2. Configurar variável de ambiente

   2.1. Adicione a variável de ambiente `VITE_AI_SERVICE_URL=http://localhost:8000`. Você pode criar o arquivo de nome "**.env**" ou adicionar às variáveis de ambiente da própria máquina
