# To Do List

Este projeto é um aplicativo em Flutter que permite ao usuário adicionar, visualizar, editar e deletar tarefas, persistindo os dados mantidos localmente.

O aplicativo foi implementado buscando ao máximo utilizar apenas recursos nativo do Flutter, portanto, foram utilizados apenas os packages:
- **Shared_preferences**: para persistência de dados;
- **Flutter_localizations**: para internacionalização de data.

#### Instalação: [Baixe o APK]()

<br>

<img width="357" alt="ToDoList1" src="https://github.com/AlexFlorenco/to-do-list-ldc/assets/92060682/e83c27e0-491c-4997-b212-6a4ef12104a9">
___________________
<img width="357" alt="ToDoList2" src="https://github.com/AlexFlorenco/to-do-list-ldc/assets/92060682/80e3a7db-7b85-4f13-be08-92d71b7199be">

<br>

## 📲 Instalação e execução
> Além da instalação, este projeto não requer configurações adicionais.

### Instalação no seu dispositivo
Para executar este aplicativo no seu dispositivo é necessário que você possua um smartphone com Android.
Com um smartphone Android em mãos, você pode executar o app seguindo estas etapas:
1. Acesse o link do download clicando [aqui](). 
2. Você irá baixar o arquivo `To-Do-List.apk`
3. Abra o arquivo e permita quais quer avisos de segurança do Android
4. Clique em Instalar
5. Clique em Abrir

### Execução no simulador
Para executar este aplicativo será necessário possuir o Flutter instalado em seu sistema e algum simulador, Android ou iOS.
Com o Flutter instalado, você pode executar o app seguindo estas etapas:

1. Abra seu terminal e execute os comandos
```
$ git clone https://github.com/AlexFlorenco/to-do-list-ldc.git
$ cd to-do-list-ldc  
$ flutter run
```
2. Aguarde que seja feita a construção do app no seu simulador

<br>

## 📚 Como usar
O aplicativo é divido em 3 principais áreas de interação:
- Barra de inserção/edição
- Tarefa
- Lista de tarefas

**Barra de inserção**
- No campo de texto você pode inserir o título da tarefa criar ou editar (este campo é obrigatório);
- No ícone de calendário você pode inserir a data do prazo de conclusão da sua tarefa (este campo é opcional);
- No botão de adição ➕ você cria uma nova tarefa;
- Durante uma edição, o botão altera seu ícone para ↩️.

**Tarefa**
- No checkbox ☑️ você altera o estado da tarefa para concluído e ela é levada pra o final da To Do List;
- Ao tocar em uma tarefa, você ativa o modo edição, e a barra de inserção se torna barra de edição, permitindo que você alterar o título ou a data;
- Ao clicar no status da tarefa você pode alterar entre `Criada`, `Iniciada` ou `Concluída`;
- Tarefas com o prazo de conclusão atrasado ficam com o status `Atrasada`;
- Tarefas com o prazo de conclusão atrasado não pode ter o status alterado, ao não ser que sejam concluidas;
- Ao tocar e segurar em uma tarefa, abrirá um pop-up que permitirá você excluir esta tarefa.

**Lista de tarefas**
- A lista de tarefas é ordenada da seguinte forma:
  - 1º tarefas com prazo definido, do mais próximo para o mais distante;
  - 2º tarefas sem prazo definido;
  - 3º tarefas concluídas.
- Quando não houver tarefas para exibir, você verá uma ilustração com uma mensagem auto-explicativa.

<br>


## 🔧 Estrutura do Projeto

>Este projeto utiliza o padrão arquitetural MVC para separar a lógica de negócios da interface do usuário, seguindo os princípios SOLID para garantir uma arquitetura mais robusta e de fácil manutenção.
>Singletons são utilizado para garantir a única instância de certas classes, como as cores do aplicativo e a gestão de preferências compartilhadas.
>A persistência de dados local é realizada através do pacote SharedPreferences.
<br>

### Descrição das Pastas e Arquivos
O projeto é estruturado em várias partes principais:

📂 **Controllers**
- `i_to_do_controller.dart`: Interface para o controlador de tarefas;
- `to_do_controller.dart`: Implementação do controlador de tarefas utilizando o padrão MVC.
<br>

📂 **Core**
- **Singletons**: Contém classes que são instanciadas apenas uma vez durante a execução do aplicativo;
  - `app_colors.dart`: Define as cores utilizadas na aplicação;
  - `shared_prefs.dart`: Gerencia a persistência de dados localmente utilizando o SharedPreferences.
<br>

📂 **Models**
- `task.dart`: Define a classe de modelo para as tarefas a serem realizadas.
<br>

📂 **Pages**
- `todo_page.dart`: Página principal do aplicativo que exibe a lista de tarefas e permite a interação com elas.
<br>

📂 **Services** (repositories)
- `i_todo_service.dart`: Interface para o serviço de tarefas;
- `todo_service.dart`: Implementação do serviço de tarefas que gerencia a lógica de negócio relacionada às persistência de dados.
<br>

📂 **Widgets**
- `custom_icon_button.dart`: Widget personalizado para botão de criar e alterar uma tarefa;
- `custom_text_form.dart`: Widget personalizado para campo de texto;
- `empty_widget.dart`: Widget para exibir quando não há tarefas para exibir;
- `snackbar_widget.dart`: Widget para notificar o usuário quando uma tarefa for criada, alterada ou deletada;
- `task_widget.dart`: Widget para exibir uma tarefa na lista de tarefas.
<br>

