import 'package:flutter/material.dart';
import 'package:cidadao_app/change_password_page.dart';
import 'package:cidadao_app/user_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Importar para usar File

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  List<Calling> calls = [];

  void _onDestinationSelected(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  Widget _buildBody() {
    switch (currentPageIndex) {
      case 0:
        return _buildHomePageWithBackground();
      case 1:
        return _buildNotificationsPage();
      case 2:
        return const UserProfilePage(); // Página de perfil do usuário
      case 3:
        return const ChangePasswordPage(); // Página para alterar senha
      default:
        return Container();
    }
  }

  Widget _buildHomePageWithBackground() {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/back.webp',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Início'),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Olá, bem-vindo ao Cidadão Atento!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black54,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 350),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Para registrar uma nova ocorrência, clique no botão abaixo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black54,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _showAddCallDialog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      backgroundColor: Colors.amber,
                      textStyle: const TextStyle(fontSize: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Adicionar Chamado',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chamados'),
      ),
      body: _buildCallsList(),
    );
  }

  Widget _buildCallsList() {
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(calls[index].description),
            leading: Image.file(calls[index].image),
          ),
        );
      },
    );
  }

  Future<void> _showAddCallDialog() async {
    final descriptionController = TextEditingController();
    final picker = ImagePicker();
    XFile? xFile;

    // Exibe o diálogo e aguarda o resultado
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar Chamado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  xFile = await picker.pickImage(source: ImageSource.gallery);
                },
                child: const Text('Selecionar Foto'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Fechar o diálogo com resultado
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );

    // Verifica o resultado após o fechamento do diálogo
    if (result == true && xFile != null && descriptionController.text.isNotEmpty) {
      setState(() {
        calls.add(Calling(
          description: descriptionController.text,
          image: File(xFile!.path),
        ));
      });

      _showSnackBar('Seu chamado foi aberto com sucesso!');
    } else {
      _showSnackBar('Adicione uma descrição e selecione uma imagem para abrir o chamado!');
    }
  }

  void _showSnackBar(String message) {
    // Exibe o SnackBar com o contexto garantido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onDestinationSelected,
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.important_devices),
            label: 'Chamados',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Cadastro',
          ),
          NavigationDestination(
            icon: Icon(Icons.lock_outline),
            label: 'Alterar Senha',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;

  const NotificationCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.crisis_alert_rounded),
        title: Text(title),
        subtitle: const Text('Clique para acompanhar o status'),
      ),
    );
  }
}
class Calling {
  final String description;
  final File image;

  Calling({required this.description, required this.image});
}