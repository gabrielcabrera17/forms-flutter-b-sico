
import 'package:flutter/material.dart';

class PruebaFormScreen extends StatefulWidget {
  const PruebaFormScreen({super.key});

  @override
  PruebaFormScreenState createState() {
    return PruebaFormScreenState();
  }
  
}

class PruebaFormScreenState extends State<PruebaFormScreen> {

  final _formKey = GlobalKey<FormState>();

  //metodo para validar si un campo contiene número
  bool contieneNumero( String? valor){
    RegExp regExp = RegExp(r'^\d+$'); // Expresión regular para detectar dígitos
    return regExp.hasMatch(valor ??""); // Verifica si la cadena contiene números

  }

  //Lista de item
 final List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
];
  List<String> selectedItems = [];
  @override
  
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 60),// Alto del formulario
        child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Por favor ingresa un texto';
              }
              return null;
            },
          ),
           TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Campo Vacio';
              }else if(!contieneNumero(value)){
                return 'Este campo solo acepta números';
              }
              return null;
            },
          ),

          // Validación del DropdownButton
            FormField<List<String>>(
              validator: (value) {
                if (selectedItems.isEmpty) {
                  return 'Por favor selecciona al menos un ítem';
                }
                return null;
              },
              builder: (FormFieldState<List<String>> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
          
                    DropdownButtonHideUnderline(
                      
                      child: DropdownButton<String>(
                        
                        isExpanded: true,
                        hint: Text(
                          'Select Items',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            //disable default onTap to avoid closing menu when selecting an item
                            enabled: false,
                            child: StatefulBuilder(
                              builder: (context, menuSetState) {
                                final isSelected = selectedItems.contains(item);
                                return InkWell(
                                  onTap: () {
                                    isSelected ? selectedItems.remove(item) : selectedItems.add(item);
                                    //This rebuilds the StatefulWidget to update the button's text
                                    setState(() {});
                                    //This rebuilds the dropdownMenu Widget to update the check mark
                                    menuSetState(() {});
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        if (isSelected)
                                          const Icon(Icons.check_box_outlined)
                                        else
                                          const Icon(Icons.check_box_outline_blank),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                        //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                        value: selectedItems.isEmpty ? null : selectedItems.last,
                        onChanged: (value) {},
                        selectedItemBuilder: (context) {
                          return items.map(
                            (item) {
                              return Container(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  selectedItems.join(', '),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              );
                            },
                          ).toList();
                        },
                        
                      ),
                    ),
                if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          field.errorText ?? '',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed:(){
                  if (_formKey.currentState!.validate()){
                    // Si el formulario es válido, exhibe un snack bar. En el mundo real,
                    // a menudo llamarías a un servidor o guardarías la información en una base de datos.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Procesando Dato')),
                    );
                  }
                },
                child: const Text('Enviado'),
                ),
              )
          ],
        ),
        )
      );
    }
}