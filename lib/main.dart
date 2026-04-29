import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 245, 165, 206),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 168, 227, 231),
        ),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 223, 164, 235),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

@override
State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp>{

//declaração variaveis vei
final TextEditingController _opcaoController = TextEditingController();
String? _erroTexto;
final List<String> _opcoes = [];

final Random _random = Random();

static const Color _roxo = Color.fromARGB(255, 219, 117, 233);
static const Color _roxoClaro = Color.fromARGB(255, 232, 135, 226);
static const Color _roxoMedio = Color.fromARGB(255, 231, 133, 236);
static const Color _cinza = Color.fromARGB(255, 208, 118, 244);
static const Color _vermelho = Color.fromARGB(255, 226, 122, 247);
static const Color _verde = Color.fromARGB(255, 226, 126, 249);

// coress declaration

//logica do sorteio 
void _sortear(){

  if(_opcoes.isEmpty || _opcoes.length < 2){
    _mostrarErro("Adicione ao menos 2 opções para sortear!");
    return;
  }

  final int indice = _random.nextInt(_opcoes.length);
  final String sorteado = _opcoes[indice];

  _mostrarResultado(sorteado);
}

void _mostrarErro(String mensagem){
  //snackbar vei coisa nova vamo la, eh uma alternativa mais leve pro alertdialogg
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(mensagem)),
        ],
      ),
      backgroundColor: _vermelho ,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 5),

    ),
  );
}

void _mostrarSucesso(String opcao){
 ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text('"$opcao" adicionada!')),
        ],
      ),
      backgroundColor: _verde ,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),

    ),
  );
}

void _adicionarOpcao(){
final texto = _opcaoController.text.trim();
if (texto.isEmpty){
  setState(() => _erroTexto = 'Digite ao menos uma opção');
  return;
}
if(_opcoes.contains(texto)){
  setState(() => _erroTexto = 'Essa opção já foi adicionada!');
  return;
}
setState(() {
  _opcoes.add(texto);
  _erroTexto = null;
  _opcaoController.clear();
});
_mostrarSucesso(texto);
}

void _removerOpcao(int index){
  setState(() => _opcoes.removeAt(index));

}

@override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: _roxoClaro,
 
     appBar: AppBar(
       title: const Text('🎲 Sorteador de Decisões'),
       actions: [
         // Botão para limpar toda a lista
         if (_opcoes.isNotEmpty)
           IconButton(
             icon: const Icon(Icons.delete_sweep),
             tooltip: 'Limpar tudo',
             onPressed: () {
               showDialog(
                 context: context,
                 builder: (ctx) => AlertDialog(
                   title: const Text('Limpar lista?'),
                   content: const Text('Todas as opções serão removidas.'),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                   actions: [
                     TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                     ElevatedButton(
                       onPressed: () {
                         setState(() => _opcoes.clear());
                         Navigator.pop(ctx);
                       },
                       style: ElevatedButton.styleFrom(backgroundColor: _vermelho, foregroundColor: Colors.white),
                       child: const Text('Limpar'),
                     ),
                   ],
                 ),
               );
             },
           ),
         Padding(
           padding: const EdgeInsets.only(right: 12),
           child: Center(
             child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
               decoration: BoxDecoration(
                 color: Colors.white.withOpacity(0.25),
                 borderRadius: BorderRadius.circular(20),
               ),
               child: Text('${_opcoes.length} opções', style: const TextStyle(color: Colors.white, fontSize: 13)),
             ),
           ),
         ),
       ],
     ),
 
     body: SingleChildScrollView(
       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
 
           ClipRRect(
             borderRadius: BorderRadius.circular(24),
             child: Image.network(
               'https://picsum.photos/seed/dice/600/300',
               height: 160,
               fit: BoxFit.cover,
               errorBuilder: (_, __, ___) => Container(
                 height: 160, color: _roxoMedio,
                 child: const Center(child: Text('🎲', style: TextStyle(fontSize: 64))),
               ),
             ),
           ),
 
           const SizedBox(height: 20),
 
           TextField(
             controller: _opcaoController,
             onChanged: (_) => setState(() => _erroTexto = null),
             onSubmitted: (_) => _adicionarOpcao(),
             style: const TextStyle(fontSize: 16),
             decoration: InputDecoration(
               hintText: 'Ex: Pizza, Sushi, Hambúrguer...',
               hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
               labelText: 'Nova opção',
               labelStyle: const TextStyle(color: _cinza),
               prefixIcon: const Icon(Icons.add_circle_outline, color: _roxo),
               suffixIcon: _opcaoController.text.isNotEmpty
                   ? IconButton(icon: const Icon(Icons.clear, color: _cinza), onPressed: () => setState(() { _opcaoController.clear(); _erroTexto = null; }))
                   : null,
               errorText: _erroTexto,
               filled: true,
               fillColor: Colors.white,
               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: _erroTexto != null ? _vermelho : const Color(0xFFDDDDDD), width: 1.5)),
               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _roxo, width: 2.0)),
               errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _vermelho, width: 1.5)),
               focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _vermelho, width: 2.0)),
             ),
           ),
 
           const SizedBox(height: 12),
 
           ElevatedButton.icon(
             onPressed: _adicionarOpcao,
             icon: const Icon(Icons.add),
             label: const Text('Adicionar opção', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
             style: ElevatedButton.styleFrom(
               backgroundColor: _verde, foregroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(vertical: 14), elevation: 2,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
             ),
           ),
 
           const SizedBox(height: 20),
 
           // Lista de opções
           if (_opcoes.isEmpty)
             Container(
               height: 90,
               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEEEEEE))),
               child: const Center(child: Text('Nenhuma opção adicionada ainda', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14))),
             )
           else
             ListView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: _opcoes.length,
               itemBuilder: (context, index) {
                 return Container(
                   margin: const EdgeInsets.only(bottom: 8),
                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEEEEEE))),
                   child: ListTile(
                     leading: CircleAvatar(
                       backgroundColor: _roxoMedio,
                       child: Text('${index + 1}', style: const TextStyle(color: _roxo, fontWeight: FontWeight.bold)),
                     ),
                     title: Text(_opcoes[index], style: const TextStyle(fontSize: 15)),
                     trailing: IconButton(
                       icon: const Icon(Icons.delete_outline, color: _vermelho),
                       onPressed: () => _removerOpcao(index),
                     ),
                   ),
                 );
               },
             ),
 
           const SizedBox(height: 24),
 
           // Botão Sortear — desabilitado se menos de 2 opções
           ElevatedButton.icon(
             // onPressed = null desabilita o botão visualmente
             onPressed: _opcoes.length >= 2 ? _sortear : null,
             icon: const Icon(Icons.shuffle, size: 22),
             label: Text(
               _opcoes.length < 2
                   ? 'Adicione ${2 - _opcoes.length} opção(ões)'
                   : 'SORTEAR',
               style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1),
             ),
             style: ElevatedButton.styleFrom(
               backgroundColor: _roxo,
               foregroundColor: Colors.white,
               disabledBackgroundColor: const Color(0xFFBBBBBB),
               disabledForegroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(vertical: 18),
               elevation: 4,
               shadowColor: _roxo.withOpacity(0.4),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
             ),
           ),
 
           const SizedBox(height: 24),
         ],
       ),
     ),
   );
 }

// ============================================================
 // ALERTDIALOG DE RESULTADO
 // showDialog = abre um popup modal sobre a tela
 // ============================================================
 void _mostrarResultado(String resultado) {
   showDialog(
     context: context,
 
     // barrierDismissible: false = usuário precisa clicar no botão para fechar
     barrierDismissible: true,
 
     builder: (BuildContext dialogContext) {
       return AlertDialog(
         // Formato arredondado do dialog
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
         backgroundColor: Colors.white,
 
         // Conteúdo do dialog
         content: Column(
           mainAxisSize: MainAxisSize.min, // ocupa só o espaço necessário
           children: [
             const SizedBox(height: 8),
 
             // Ícone de troféu
             Container(
               width: 80,
               height: 80,
               decoration: BoxDecoration(
                 color: _roxoMedio,
                 shape: BoxShape.circle,
               ),
               child: const Center(
                 child: Text('🎉', style: TextStyle(fontSize: 40)),
               ),
             ),
 
             const SizedBox(height: 16),
 
             const Text(
               'A decisão foi tomada!',
               style: TextStyle(fontSize: 14, color: _cinza),
               textAlign: TextAlign.center,
             ),
 
             const SizedBox(height: 8),
 
             // Resultado em destaque
             Text(
               resultado,
               style: const TextStyle(
                 fontSize: 28,
                 fontWeight: FontWeight.bold,
                 color: _roxo,
               ),
               textAlign: TextAlign.center,
             ),
 
             const SizedBox(height: 8),
           ],
         ),
 
         // Botões de ação do dialog
         actions: [
           // Botão secundário — sortear novamente
           TextButton(
             onPressed: () {
               // Navigator.pop = fecha o dialog atual
               Navigator.pop(dialogContext);
               // Sorteia de novo após fechar
               Future.delayed(const Duration(milliseconds: 200), _sortear);
             },
             child: const Text('Sortear novamente', style: TextStyle(color: _cinza)),
           ),
 
           // Botão primário — confirmar resultado
           ElevatedButton(
             onPressed: () => Navigator.pop(dialogContext),
             style: ElevatedButton.styleFrom(
               backgroundColor: _roxo,
               foregroundColor: Colors.white,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
             ),
             child: const Text('Ótimo!'),
           ),
         ],
       );
     },
   );
 }


}
