import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teste_firestore/model/tarefa_model.dart';
import 'package:teste_firestore/serivce/database_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _appBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirDialogInput();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text("Tarefas", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _appBody() {
    return SafeArea(child: Column(children: [_mensagensListView()]));
  }

  Widget _mensagensListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream:
            _databaseService
                .getTarefas(), // Consultando as tarefas na base de dados
        builder: (context, snapshot) {
          List tarefas =
              snapshot.data?.docs ?? []; // Resultado da busca na base de dados
          if (tarefas.isEmpty) {
            return const Center(child: Text("Adicione uma tarefa!"));
          }
          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              // Representação dos dados da tarefa
              Tarefa tarefa = tarefas[index].data();
              String tarefaID = tarefas[index].id;

              // Criação dos elementos do ListView
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListTile(
                  tileColor: Theme.of(context).primaryColor,
                  title: Text(
                    tarefa.descricao,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    DateFormat(
                      "dd/MM/yyyy h:mm a",
                    ).format(tarefa.atualizadoEm.toDate()),
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Checkbox(
                    side: BorderSide(color: Colors.white, width: 2),
                    value: tarefa.isConcluida,
                    onChanged: (value) {
                      Tarefa tarefaAtualizada = tarefa.copyWith(
                        isConcluida: !tarefa.isConcluida,
                        atualizadoEm: Timestamp.now(),
                      );
                      _databaseService.atualizarTarefa(
                        tarefaID,
                        tarefaAtualizada,
                      );
                    },
                  ),
                  onLongPress: () {
                    _databaseService.deletarTarefa(tarefaID);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _abrirDialogInput() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Tarefa"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Tarefa..."),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Tarefa novaTarefa = Tarefa(
                  descricao: _textEditingController.text,
                  isConcluida: false,
                  criadoEm: Timestamp.now(),
                  atualizadoEm: Timestamp.now(),
                );
                _databaseService.addTarefa(novaTarefa);

                _textEditingController.clear();
                Navigator.pop(context);
              },
              color: Theme.of(context).primaryColor,
              child: const Text("Feito", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
