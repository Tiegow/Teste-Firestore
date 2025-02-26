import 'package:cloud_firestore/cloud_firestore.dart';

class Tarefa {
  String descricao;
  bool isConcluida;
  Timestamp criadoEm;
  Timestamp atualizadoEm;

  Tarefa({
    required this.descricao,
    required this.isConcluida,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  /// Factory method
  Tarefa.fromJson(Map<String, Object?> json)
    : this(
        descricao: json['descricao']! as String,
        isConcluida: json['isConcluida']! as bool,
        criadoEm: json['criadoEm']! as Timestamp,
        atualizadoEm: json['atualizadoEm']! as Timestamp,
      );

  /// Permite criar uma nova instância (cópia) de uma tarefa com valores modificados
  Tarefa copyWith({
    String? descricao,
    bool? isConcluida,
    Timestamp? criadoEm,
    Timestamp? atualizadoEm,
  }) {
    return Tarefa(
      descricao: descricao ?? this.descricao,
      isConcluida: isConcluida ?? this.isConcluida,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  /// Gera o Json referente a instância da Tarefa
  Map<String, Object?> toJson() {
    return {
      'descricao': descricao,
      'isConcluida': isConcluida,
      'criadoEm': criadoEm,
      'atualizadoEm': atualizadoEm,
    };
  }
}
