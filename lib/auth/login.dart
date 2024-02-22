import 'package:definitivo_app_tcc/auth/auth_service/auth.dart';
import 'package:definitivo_app_tcc/auth/auth_service/user.dart';
import 'package:definitivo_app_tcc/auth/cadastro.dart';
import 'package:definitivo_app_tcc/auth/common/custom_form.dart';
import 'package:definitivo_app_tcc/global/saldo_global.dart';
import 'package:definitivo_app_tcc/input_saldo.dart';
import 'package:flutter/material.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Nome do app
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 40,
                        ),
                        children: [
                          TextSpan(
                            text: 'G',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Fácil',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 224, 221, 221),
                            ),
                          )
                        ],
                      ),
                    ),
                    //Categorias
                    SizedBox(
                      height: 30,
                      child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          child: Text('Login')),
                    ),
                  ],
                ),
              ),
              // Formulario
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Email
                    CustomAuthField(
                      controller: _emailController,
                      icon: Icons.email,
                      label: 'Email',
                    ),
                    //Senha
                    CustomAuthField(
                      controller: _senhaController,
                      icon: Icons.lock,
                      label: 'Senha',
                      isSecret: true,
                    ),
                    //Botão Entrar
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            )),
                        onPressed: () async {
                          
                          dynamic result = await _auth.signIn(
                            _emailController.text,
                            _senhaController.text,
                          );

                          if (result != null) {
                            WalletManager walletManager = WalletManager(result);
                            await walletManager.getBalance();
                            print('Usuário logado com ID: $result');
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (c) {
                              return InputSaldo(result);
                            }));
                          } else {
                            print('Erro no login');
                          }
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    //Esqueceu a senha
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    //Divisor
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Text('Ou'),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Botão de novo usuário
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          side: const BorderSide(
                            width: 2,
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (c) {
                              return SignUpScreen();
                            }),
                          );
                        },
                        child: const Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
