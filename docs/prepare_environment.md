Vou te guiar pela instalação e configuração do Ruby on Rails no WSL Ubuntu usando o mise (anteriormente conhecido como rtx). O mise é uma excelente ferramenta moderna para gerenciar versões de Ruby e outras linguagens.

## 1. Instalar o mise

Primeiro, instale o mise no seu WSL Ubuntu:

```bash
curl https://mise.run | sh
```

Adicione o mise ao seu shell. Se você usa bash:

```bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

Se usa zsh:

```bash
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc
```

## 2. Instalar dependências do Ruby

Antes de instalar o Ruby, instale as dependências necessárias:

```bash
sudo apt update
sudo apt install -y build-essential libssl-dev libreadline-dev \
  zlib1g-dev libyaml-dev libffi-dev libgdbm-dev libncurses5-dev \
  automake libtool bison sqlite3 libsqlite3-dev
```

## 3. Instalar Ruby com mise

Instale a versão mais recente do Ruby (ou especifique uma versão):

```bash
# Listar versões disponíveis
mise ls-remote ruby

# Instalar a versão mais recente
mise use -g ruby@latest

# Ou instalar uma versão específica
mise use -g ruby@3.3.0
```

Verifique a instalação:

```bash
ruby -v
gem -v
```

## 4. Configurar o Bundler

O Bundler geralmente vem com o Ruby, mas você pode garantir que está atualizado:

```bash
gem update --system
gem install bundler
```

## 5. Instalar Node.js (necessário para Rails)

O Rails precisa de um runtime JavaScript:

```bash
mise use -g node@lts
```

## 6. Instalar Rails

Agora instale o Rails:

```bash
gem install rails
```

Verifique a instalação:

```bash
rails -v
```

## 7. Instalar o Bun

```bash
mise use -g bun@latest
bun --version
```

## 8. Baixe as dependências do projeto Bun

```bash
bun install
```

## 9. Instale o CMake e outras dependências necessárias:

```bash
sudo apt update
sudo apt install -y cmake pkg-config libgit2-dev
```

## 10. Instale as dependências do projeto Rails

```bash
bundle install
```