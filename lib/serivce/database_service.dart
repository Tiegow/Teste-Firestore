import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teste_firestore/model/tarefa_model.dart';

/// Nome da collection no Firestore
const String TAREFA_COLLECTION_REF = "tarefas";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _tarefasRef;

  DatabaseService() {
    _tarefasRef = _firestore
        .collection(TAREFA_COLLECTION_REF)
        .withConverter<Tarefa>(
          fromFirestore: (snapshots, _) => Tarefa.fromJson(snapshots.data()!),
          toFirestore: (tarefa, _) => tarefa.toJson(),
        );
  }

  Stream<QuerySnapshot> getTarefas() {
    return _tarefasRef.snapshots();
  }

  void addTarefa(Tarefa tarefa) {
    _tarefasRef.add(tarefa);
  }

  void atualizarTarefa(String id, Tarefa tarefa) {
    _tarefasRef.doc(id).update(tarefa.toJson());
  }

  void deletarTarefa(String id) {
    _tarefasRef.doc(id).delete();
  }
}
