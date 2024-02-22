import 'package:definitivo_app_tcc/models/despesa_model.dart';
import 'package:definitivo_app_tcc/models/entrada_model.dart';

EntradaModel salario = EntradaModel(
  title: 'Salario',
  value: 500,
  description: 'Recebi meu salário da empresa',
  type: 'Trabalho',
);

EntradaModel emprestimo = EntradaModel(
  title: 'Empréstimo',
  value: 1500,
  description: 'Peguei um empréstimo porque estava precisando',
  type: 'Outro',
);

List<EntradaModel> entradas = [
  salario,
  emprestimo,
];

List<String> entrada_types = [
  'Salario',
  'Presente',
  'Juros',
  'Outro',
];

//Despesas

DespesaModel aluguel = DespesaModel(
  title: 'Aluguel',
  value: 500,
  description: 'Tive que pagar o aluguel',
  type: 'Casa',
);

DespesaModel parcela_emprestimo = DespesaModel(
  title: 'Parcela do empréstimo',
  value: 250,
  description: 'Tive que pegar empréstimo para pagar aluguel. 10 parcelas de 250.',
  type: 'Outro',
);

List<DespesaModel> despesas = [
  aluguel,
  parcela_emprestimo, 
];

List<String> despesas_types = [
  'Casa',
  'Lazer',
  'Transporte',
  
];